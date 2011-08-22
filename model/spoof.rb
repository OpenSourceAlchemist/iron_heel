require "iron_heel"
module IronHeel
  class Spoof < Sequel::Model
    set_dataset IronHeel.db[:spoofs]
    def self.match(number)
      if spoof = filter("'#{number}' ~ matcher").first
        return spoof.extension
      end
    end

    def add!(match)
      update :matcher => matcher + "|#{match}"
    end

    def self.add(extension, matcher)
      create(:extension => extension.to_s, :matcher => matcher.to_s)
    end
  end
end
