require "pathname"
$LOAD_PATH.unshift(File.expand_path("../", __FILE__))

# Allows for pathnames to be easily added to
class Pathname
  def /(other)
    join(other.to_s)
  end
end

# The Iron Heel library, by www-data
module IronHeel
  autoload :VERSION, "iron_heel/version"
  ROOT = Pathname($LOAD_PATH.first).join("..") unless IronHeel.const_defined?("ROOT")
  LIBROOT = ROOT/:lib unless IronHeel.const_defined?("LIBROOT")
  MIGRATION_ROOT = ROOT/:migrations
  MODEL_ROOT = ROOT/:model
  SPEC_HELPER_PATH = ROOT/:spec
end

