# Intends to overload the WAD class.
class WAD
  # A music track.
  class Music
    property name = ""
    property identifier = ""
    property score_len = 0_u16
    property score_start = 0_u16
    # Count of primary channels.
    property channels = 0_u16
    # Count of secondary channels.
    property sec_channels = 0_u16
    property instr_cnt = 0_u16
    property dummy = 0_u16
    property instruments = [] of UInt16

    def self.parse(io, name = "")
      music = Music.new
      music.name = name
      # Reads the data.
      music.identifier = io.gets(4).to_s.gsub("\u0000", "")
      music.score_len = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.score_start = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.channels = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.sec_channels = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.instr_cnt = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      # Skips dummy bytes.
      io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      # Reads in the instruments.
      music.instr_cnt.times do
        music.instruments << io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      end

      music
    end

    # Checks to see if *name* is music with name format 'D_x..x'.
    def self.is_music?(name)
      !!(name =~ /^D_/)
    end
  end

  # "Instrument data for the DMX sound library to use for OPL synthesis".
  class Genmidi
    property header = ""
    property instr_datas = [] of InstrumentData

    # "The header is followed by 175 36-byte records of instrument data".
    struct InstrumentData
      property header = [] of Int8 | Int16
      property voice1_data = [] of Int8 | Int16
      property voice2_data = [] of Int8 | Int16
    end

    def self.parse(io)
      genmidi = Genmidi.new
      # Reads the file header
      genmidi.header = io.gets(8).to_s.gsub("\u0000", "")

      instrument_data_records_count = 175

      instrument_data_records_count.times do
        instr_data = InstrumentData.new

        # Reads instrument data's header
        instr_data.header << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        instr_data.header << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        instr_data.header << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        # Reads instrument data's first voice's data
        # First 14 bytes are all 1 byte in size
        14.times do
          instr_data.voice1_data << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        end
        instr_data.voice1_data << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # reads instrument data's second voice's data
        # First 14 bytes are all 1 byte in size
        14.times do
          instr_data.voice2_data << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        end
        instr_data.voice2_data << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        genmidi.instr_datas << instr_data
      end
      genmidi
    end

    def self.is_genmidi?(name)
      !!(name =~ /^GENMIDI/)
    end
  end

  # "Instrument data for the DMX sound library to use for Gravis Ultrasound soundcards".
  class Dmxgus
    def self.is_dmxgus?(name)
      !!(name =~ /^DMXGUS/)
    end
  end
end
