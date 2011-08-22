require 'yaml'

class IHACL

  def self.read_list
    @config_file = File.join(RAILS_ROOT, "config", "users.yml")
    begin
      settings = YAML.load_file(@config_file)
    rescue
      settings = {}
    end
  end

  def self.config_file
    @config_file = File.join(RAILS_ROOT, "config", "users.yml")
  end

  def self.get_reg(user)
    perms = self.read_list[user]
    extens = perms["extens"].split(",")
    tmp_string = ""
    extens.each_with_index do |e, i| 
      if i>0
        if e.size == 2
          tmp_string << "|^#{e}+\\d+\\d$"
        else
          tmp_string << "|^#{e}$"
        end
      else
        if e.size == 2
          tmp_string << "^#{e}+\\d+\\d$"
        else
          tmp_string << "^#{e}$"
        end
      end
    end 
    regex = Regexp.new(tmp_string)
  end

  def self.get_exclude(user)
    perms = self.read_list[user]
    extens = perms["exclude"].split(",")
    tmp_string = ""
    extens.each_with_index { |e, i| (i>0?tmp_string << "|^#{e}$":tmp_string << "^#{e}$")} 
    regex = Regexp.new(tmp_string)
  end


end
