require "iron_heel"
module IronHeel
  class User < Sequel::Model
    set_dataset IronHeel.db[:users]
    many_to_many :extensions, :join_table => :users_extensions
    many_to_many :exclusions, :join_table => :users_exclusions

    def exclude(*extensions)
      extensions.map do |e|
        add_exclusion(Exclusion.new(:extension => e.to_s))
      end
    end

    def include(*extensions)
      extensions.map do |e|
        add_extension(Extension.new(:extension => e.to_s))
      end
    end
  end
end
