# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
require File.expand_path('../../db_helper', __FILE__)

describe 'IronHeel::Spoof' do
  Recording, Spoof = IronHeel::Recording, IronHeel::Spoof
  @defaults = {:src=>"2145551117", :dst=>"8828307700", :direction=>"IN", :timestamp=> "2009-09-09 10:37:58 -0500", :server=>"test", :path=>"2009/09/09", :filename=>"20090909-103758-8828307700-2467-OUT.wav", :level=>nil, :created_at=>nil, :updated_at=>nil, :lost=>false}
  

  before do
    @recording = Recording.create(@defaults)
  end

  after do
    Recording.delete
  end

  it 'should spoof the extension when we add a spoof that matches dst in Inbound' do
    Spoof.create(:extension => "2100", :matcher => "8828307700")
    @recording.extension.should == "2100"
  end

  it 'should spoof the extension when we add a spoof that matches src in Outbound' do
    Spoof.create(:extension => "2100", :matcher => "8828307700")
    @recording.update(:src => "8828307700", :dst => "1234567890")
    @recording.extension.should == "2100"
  end

  it 'should add a number to matcher' do
    Spoof.create(:extension => "2100", :matcher => "8828307700")
    @recording.update(:src => "8828307700", :dst => "1234567890")
    @recording.extension.should == "2100"
    @recording.update(:src => "9728307700", :dst => "1234567890")
    @recording.extension.should == "9728307700"
    spoof = Spoof[:extension => '2100']
    spoof.add!('9728307700') 
    p spoof
    @recording.extension.should == "2100"
  end


end
