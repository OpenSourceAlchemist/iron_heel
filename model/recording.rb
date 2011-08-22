# what is IHACL?
require "iron_heel"

require 'sequel/extensions/pagination'

module IronHeel
  class Recording < Sequel::Model
    set_dataset IronHeel.db[:recordings]
    #validates_presence_of :timestamp
    # this should be on the db.
    #validates_uniqueness_of :filename
      public
    def full_path
      File.join(path, filename)
    end

    def authorized_listener?(user)
      if user.kind_of?(String)
        user = User[:username => user]
      end
      extensions = user.extensions.map { |e| e.extension }
      if extensions.detect { |e| extension.to_s.match %r{^#{e}\d*$} }
        return !excluded?(user)
      end
      false
    end

    def excluded?(user)
      exclusions = user.exclusions.map { |e| e.extension }
      exclusions.include?(extension)
    end

    def wavfile
      @wavfile ||= IronHeel::ROOT.join("recording_archive",self.path,self.filename)
    end

    def speexfile
      Pathname(wavfile.to_s + ".spx")
    end

    def to_wav
      return wavfile if File.exists?(wavfile)
      new_path = File.join("/tmp", File.basename(wavfile))
      cmd = "speexdec #{speexfile} #{new_path}"
      %x{#{cmd}}
      new_path
    end

    def current_file
      if File.exists?(wavfile)
        wavfile
      elsif File.exists?(speexfile)
        speexfile
      else
        nil
      end
    end

    def filetype
      @ext ||= current_file.extname
    end

    def length
      return "Archived" unless file = current_file

      case filetype
      when '.wav'
        require "yaml"
        cmd = "shninfo -q #{file}"
        wavinfo = YAML.load(%x{#{cmd}})
        duration = to_minutes(wavinfo["Length"].to_i)
      when ".spx"
        require "iron_heel/tag_lib"
        duration = to_minutes(TagLib::File.open(file.to_s){|f| f.length })
      end

      duration
    rescue => e
      $stderr.puts e
      duration = "Archived"
    end

    def to_minutes(seconds)
      "%02d:%02d" % seconds.divmod(60)
    end

    def extension
      if self.src.length == 4 or self.dst.length == 4
        station = (self.src.length == 4 ? self.src : self.dst)
        return (station.length == 4 ? station : "")
      else
        if exten = Spoof.match(self.src)
          return exten
        elsif exten = Spoof.match(self.dst)
          return exten
        end
        self.src
        #spoof list
        #exten = 2222 if self.src.match(/4695210365/)
        #exten = 2606 if self.src == "5"
        #exten = 2483 if self.src == "9039452870"
        #exten = 2310 if self.src.match(/9032663955/)
        #exten = 2403 if self.src.match(/8667976802/)
        #exten = 3499 if self.src.match(/8887961510|8888301512|8888414566|8888414569|8888414570|8665105415|9038824869/)
        #exten = 2250 if self.src.match(/8667976792|8666460046|8666460030|8667976797|8002205226|8667976802/)
        #exten = 2401 if self.src.match(/8003867876|8003874533|8003873534|8667976803|8667976802/)# or self.dst.match(/8003877876|8003874533|8003873534|8667976803/)
        #exten = 3310 if self.src.match(/9726330564/) or self.dst.match(/9726330564/)
        #exten = 2250 if self.src == "8668759677"
        #exten = self.src unless exten
      end
    end

    def to_mono
      mono_file = File.join("/tmp", "mono-" + self.filename)
      stereo_file = to_wav
      cmd = "sox #{stereo_file} -c1 #{mono_file}"
      puts %x{#{cmd}}
      mono_file
   end

   protected
   def validate
     if self[:timestamp].nil?
       errors.add(:timestamp, "Cannot be empty")
     end
   end

  end
end
