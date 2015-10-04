require 'rails_helper'
require 'awesome_print'

RSpec.describe Member, :type => :model do

  before(:suite) do
    Donation.create name: "Majlis Khuddam", budget: true, organization: "Khadim", formula: '0,01*12'
    Donation.create name: "ijtema Khuddam", budget: true, organization: "Khadim", formula: '0,025'
    Donation.create name: "Ishaat Khuddam", budget: false, organization: "Khadim", formula: '3'
    Donation.create name: "Majlis Atfal", budget: false, organization: "Tifl", formula: '13'
    Donation.create name: "Ijtema Atfal", budget: false, organization: "Tifl", formula: '6'
    Donation.create name: "Ijtema Nasir", budget: false, organization: "Nasir", formula: '6'
  end

  describe 'Test validation rules' do

    before(:each) do
      @member = FactoryGirl.create(:member)
    end

    it "should fail if certain fields #{%w[ first_name last_name date_of_birth aims_id ]} are left" do
      expect(@member.valid?).to eq(true)
      @member.first_name = nil
      @member.last_name = nil
      @member.date_of_birth = nil
      @member.aims_id = nil
      expect(@member.valid?).to eq(false)

      %w[ first_name last_name date_of_birth aims_id ].each do |field|
        expect(@member.errors[field]).to eq(["can't be blank"])
      end
    end

  end

  describe 'List of possible Donation Types Method' do

    before(:each) do
      @member = FactoryGirl.create(:member)
    end

    it "should return only 'Khadim' Donation types" do
      Timecop.freeze(Date.parse("01-05-2015")) # freeze Date to 01.05.2015
      @member.date_of_birth = Date.parse("1998-01-01")
      d = Donation.where(organization: 'Khadim')
      expect(@member.list_of_possible_donation_types).to eq(d)
    end

    it "should return only 'Tifl' Donation types" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member.date_of_birth = "2000-11-01"
      d = Donation.where(organization: 'Tifl')
      expect(@member.list_of_possible_donation_types).to eq(d)
    end

    it "should return only 'Nasir' Donation types" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member.date_of_birth = "1948-11-01"
      d = Donation.where(organization: 'Nasir')
      expect(@member.list_of_possible_donation_types).to eq(d)
    end

  end

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
