require 'ffi'

module TagLib
  extend FFI::Library
  ffi_lib :tag_c

  attach_function :taglib_file_new, [:string], :pointer
  attach_function :taglib_audioproperties_length, [:pointer], :int
  attach_function :taglib_file_audioproperties, [:pointer], :pointer
  attach_function :taglib_file_free, [:pointer], :void

  class File
    def self.open(path)
      file = new(path)
      result = yield(file)
      file.close
      result
    end

    def initialize(path)
      @path = path
      @file = TagLib.taglib_file_new(@path)
      @audio = TagLib.taglib_file_audioproperties(@file)
    end

    def length
      TagLib.taglib_audioproperties_length(@audio)
    end

    def close
      TagLib.taglib_file_free(@file) if @file
      @path = @file = @audio = nil
    end
  end
end
