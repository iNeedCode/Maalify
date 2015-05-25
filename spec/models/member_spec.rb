require 'rails_helper'
require 'awesome_print'

RSpec.describe Member, :type => :model do

  describe 'Tanzeem Method' do

    before(:each) do
      @member = FactoryGirl.create(:member)
      Timecop.freeze(Date.parse("01-05-2015")) # freeze Date to 01.05.2015
    end

    context "General" do
      it "should have a valid factory and a valid tanzeem method" do
        expect(@member).to be_valid
        expect(@member).to respond_to(:tanzeem)
      end
    end

    context "Kind" do
      it "should return 'Kind' for age < 7" do
        @member.date_of_birth = "2008-05-02"
        expect(@member.tanzeem).to eq('Kind')
      end
    end

    context "Atfal" do
      it "should return 'Tifl' for age >= 7" do
        @member.date_of_birth = Date.parse("2008-05-01")
        expect(@member.tanzeem).to eq('Tifl')
      end

      it "should return 'Tifl' if member turn 15 on the 01-11-2015" do
        Timecop.freeze(Date.parse("01-11-2015"))
        @member.date_of_birth = "2000-11-01"
        expect(@member.tanzeem).to eq('Tifl')
        expect(@member.tanzeem).not_to eq('Khadim')
      end
    end

    context "Khuddam" do
      it "should return 'Khadim' for age > 16 and < 40" do
        @member.date_of_birth = Date.parse("1998-01-01")
        expect(@member.tanzeem).to eq('Khadim')
      end

      it "should return 'Khadim' if member turn 15 on the 31-10-2015" do
        Timecop.freeze(Date.parse("01-11-2015"))
        @member.date_of_birth = Date.parse("2000-10-31")
        expect(@member.tanzeem).to eq('Khadim')
      end

      it "should return 'Khadim' if member turn 40 on 01-01-2016" do
        Timecop.freeze(Date.parse("31-12-2015"))
        @member.date_of_birth = Date.parse("1976-01-01")
        expect(@member.tanzeem).to eq('Khadim')
      end

    end

    context "Ansar" do

      it "should return 'Nasir' if member turn 40 on 31-12-1975" do
        Timecop.freeze(Date.parse("01-01-2016"))
        @member.date_of_birth = Date.parse("1975-12-31")
        expect(@member.tanzeem).to eq('Nasir')
      end

      it "not should return 'Nasir' if member turn 40 on 01-01-2016" do
        Timecop.freeze(Date.parse("31-12-2015"))
        @member.date_of_birth = Date.parse("1976-01-01")
        expect(@member.tanzeem).not_to eq('Nasir')
      end
    end

  end
end
