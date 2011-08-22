# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
require File.expand_path('../../db_helper', __FILE__)

describe 'IronHeel::Recording' do
  User, Recording, Exclusion, Extension = IronHeel::User, IronHeel::Recording, IronHeel::Exclusion, IronHeel::Extension
  @defaults = {:username => "iron_heel", :password => "a+b3t4r;pvs6"}
  

  before do
    @user = User.create(@defaults)
    @user.add_exclusion(Exclusion.new(:extension => '3150'))
    @user.add_extension(Extension.new(:extension => '21'))
    @user.add_extension(Extension.new(:extension => '31'))
  end

  after do
    Exclusion.delete 
    Extension.delete
    User.delete
  end

  it 'should allow user to view calls it has an Extension entry for' do
    allowed_recording = Recording.create(:src=>"2117", :dst=>"8828307700", :direction=>"OUT", :timestamp=> "2009-09-09 10:37:58 -0500", :server=>"test", :path=>"2009/09/09", :filename=>"20090909-103758-8828307700-2467-OUT.wav", :level=>nil, :created_at=>nil, :updated_at=>nil, :lost=>false)
    allowed_recording2 = Recording.create(:src=>"3117", :dst=>"8828307700", :direction=>"OUT", :timestamp=> "2009-09-09 10:37:58 -0500", :server=>"test", :path=>"2009/09/09", :filename=>"20090909-103758-8828307700-2467-OUT.wav", :level=>nil, :created_at=>nil, :updated_at=>nil, :lost=>false)
    allowed_recording.authorized_listener?(@user).should.be.true
    allowed_recording2.authorized_listener?(@user).should.be.true
  end

  it 'should not allow user to view calls which it does not have Extension entries for' do
    unauthed_recording = Recording.create(:src=>"1117", :dst=>"8828307700", :direction=>"OUT", :timestamp=> "2009-09-09 10:37:58 -0500", :server=>"test", :path=>"2009/09/09", :filename=>"20090909-103758-8828307700-2467-OUT.wav", :level=>nil, :created_at=>nil, :updated_at=>nil, :lost=>false)
    unauthed_recording.authorized_listener?(@user).should.be.false
  end

  it 'should not allow user to view calls which it has Extension entries for, but has an Exclusion entry for' do
    excluded_recording = Recording.create(:src=>"3150", :dst=>"8828307700", :direction=>"OUT", :timestamp=> "2009-09-09 10:37:58 -0500", :server=>"test", :path=>"2009/09/09", :filename=>"20090909-103758-8828307700-2467-OUT.wav", :level=>nil, :created_at=>nil, :updated_at=>nil, :lost=>false)
    excluded_recording.authorized_listener?(@user).should.be.false
  end

end
