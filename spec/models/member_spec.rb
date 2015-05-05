require 'rails_helper'
require 'awesome_print'

RSpec.describe Member, :type => :model do

  describe 'tanzeem' do

    before(:each) do
      @member = FactoryGirl.create(:member)
      Timecop.freeze(Date.parse("01-05-2015")) # freeze Date to 01.05.2015
    end

    after(:each) do
      #ap "age of member: #{@member.age} (#{@member.date_of_birth} - #{Date.today})"
    end

    it "should have a valid factory a valid tanzeem method" do
      expect(@member).to be_valid
      expect(@member).to respond_to(:tanzeem)
    end

    it "should return 'Kind' for age < 7" do
      @member.date_of_birth = "2008-05-02"
      expect(@member.tanzeem).to eq('Kind')
    end

    it "should return 'Tifl' for age >= 7" do
      @member.date_of_birth = "2008-05-01"
      expect(@member.tanzeem).to eq('Tifl')
    end

    it "should return 'Khadim' for age > 16 and < 40" do
      @member.date_of_birth = "1998-01-01"
      expect(@member.tanzeem).to eq('Khadim')
    end

    it "should return 'Nasir' for age > 41" do
      @member.date_of_birth = "1974-05-01"
      expect(@member.tanzeem).to eq('Nasir')
    end

    it "should return 'Tifl' if member turn 15 on the 01-11-2015" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member.date_of_birth = "2000-11-01"
      expect(@member.tanzeem).to eq('Tifl')
    end

    it "should return 'Khadim' if member turn 15 on the 31-10-2015" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member.date_of_birth = "2000-10-31"
      expect(@member.tanzeem).to eq('Khadim')
    end

  end

end
