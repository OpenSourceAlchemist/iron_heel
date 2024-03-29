# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
task :test_db do
  require_relative "../lib/iron_heel"
  require IronHeel::ROOT/:spec/:db_helper
end

desc "Dump the test schema"
task :schema, :format, :needs => [:test_db] do |t,args|
  args.with_defaults(:format => "html")
  descs = IronHeel.db.tables.inject([]) do |arr, table|
    arr << "\\dd #{table};\\d+ #{table}"
  end
  commands = descs.join(";")
  if args.format.to_s == "html"
    f = File.open("doc/schema.html","w+") 
    command = %Q{echo '\\H #{commands}'|PGDATA=#{ENV['PGDATA']} PGHOST=#{ENV['PGHOST']} PGPORT=#{ENV['PGPORT']} psql #{ENV["APP_DB"]}|tail -n +2}
  else
    command = %Q{echo '#{commands}'|PGDATA=#{ENV['PGDATA']} PGHOST=#{ENV['PGHOST']} PGPORT=#{ENV['PGPORT']} psql #{ENV["APP_DB"]}}
    f = $stdout
  end
  f.puts %x{#{command}}
  unless f == $stdout
    f.close
    puts "Saved doc/schema.html"
  end

end
