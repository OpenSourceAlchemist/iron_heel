# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software

desc "migrate to latest version of db"
task :migrate, :version do |_, args|
  args.with_defaults(:version => nil)
  require File.expand_path("../../lib/iron_heel", __FILE__)
  require IronHeel::LIBROOT/:iron_heel/:db
  require 'sequel/extensions/migration'

  raise "No DB found" unless IronHeel.db

  require IronHeel::ROOT/:model/:init

  if args.version.nil?
    Sequel::Migrator.apply(IronHeel.db, IronHeel::MIGRATION_ROOT)
  else
    Sequel::Migrator.run(IronHeel.db, IronHeel::MIGRATION_ROOT, :target => args.version.to_i)
  end

end
