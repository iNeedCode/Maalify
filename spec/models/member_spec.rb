require 'rails_helper'
require 'awesome_print'

RSpec.describe Member, :type => :model do

  describe 'validation rules that are used for the member' do

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

    it 'should fail if no communication possiblity has been added to the member' do
      @member.mobile_no = nil
      expect(@member.valid?).to eq(true)
      @member.email = nil
      expect(@member.valid?).to eq(true)
      @member.landline = nil
      expect(@member.valid?).to eq(false)
    end

  end

  describe "Tests for the Method 'list_of_possible_donation_types' and 'list_available_budgets'" do

    before(:each) do
      @d1 = Donation.create name: "Majlis Khuddam", budget: true, organization: "Khuddam", formula: '0.01*12'
      @d2 = Donation.create name: "ijtema Khuddam", budget: true, organization: "Khuddam", formula: '0.025'
      @d3 = Donation.create name: "Ishaat Khuddam", budget: false, organization: "Khuddam", formula: '3'
      @d4 = Donation.create name: "Majlis Atfal", budget: false, organization: "Atfal", formula: '13'
      @d5 = Donation.create name: "Ijtema Atfal", budget: false, organization: "Atfal", formula: '6'
      @d6 = Donation.create name: "Ijtema Ansar", budget: false, organization: "Ansar", formula: '6'
      @member = FactoryGirl.create(:member)
      @member1 = FactoryGirl.create(:member, aims_id: 999)
      @member_atfal = FactoryGirl.create(:member, aims_id: 232323)
      @member_ansar = FactoryGirl.create(:member, aims_id: 123123)
      Income.create(amount: 1000, starting_date: "2014-01-03", member: @member)
      Income.create(amount: 1000, starting_date: "2014-01-03", member: @member1)
      Income.create(amount: 1000, starting_date: "2014-01-03", member: @member_atfal)
      Income.create(amount: 1000, starting_date: "2014-01-03", member: @member_ansar)
      Budget.create(title: "MKAD-14-15 majlis", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d1)
      Budget.create(title: "MKAD-14-15 ijtema", start_date: "2014-11-01", end_date: "2015-10-30", member: @member, donation: @d2)
      Budget.create(title: "MKAD-14-15 majlis", start_date: "2014-11-01", end_date: "2015-10-30", member: @member1, donation: @d1)
      Budget.create(title: "MKAD-14-15 Ishaat", start_date: "2014-11-01", end_date: "2015-10-30", member: @member1, donation: @d3)
      Budget.create(title: "MKAD-14-15 ansar ijtema", start_date: "2014-11-01", end_date: "2015-10-30", member: @member_ansar, donation: @d6)
      Budget.create(title: "MKAD-14-15 atfal ijtema", start_date: "2014-11-01", end_date: "2015-10-30", member: @member_atfal, donation: @d5)
    end

    it "should return only 'Khuddam' Donation types" do
      Timecop.freeze(Date.parse("01-05-2015")) # freeze Date to 01.05.2015
      @member.date_of_birth = Date.parse("1998-01-01")
      expect(@member.list_of_possible_donation_types.size).to eql(2)
    end

    it "should return only 'Atfal' Donation types" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member_atfal.date_of_birth = "2000-11-01"
      expect(@member_atfal.list_of_possible_donation_types.size).to eql(1)
    end

    it "should return only 'Atfal' Donation types and only ones if the donation type is just used for another budget period" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member_atfal.date_of_birth = "2000-11-01"
      Budget.create(title: "MAAD-15-16 atfal ijtema", start_date: "2015-11-01", end_date: "2016-10-30", member: @member_atfal, donation: @d5)
      expect(@member_atfal.list_of_possible_donation_types.size).to eql(1)
    end

    it "should return only 'Ansar' Donation types" do
      Timecop.freeze(Date.parse("01-11-2015"))
      @member_ansar.date_of_birth = "1948-11-01"
      expect(@member_ansar.list_of_possible_donation_types.size).to eql(1)
    end

    it "should return only DISTINCT title Budgets" do
      expect(@member.list_available_budgets.size).to eql(1)
      Budget.create(title: "MKAD-15-16 majlis", start_date: "2015-11-01", end_date: "2016-10-30", member: @member1, donation: @d1)
      expect(@member.list_available_budgets.size).to eql(2)
    end

    it "should return only DISTINCT Budgets and from the same organization" do
      Budget.create(title: "MKAD-14-15 majlis", start_date: "2014-11-01", end_date: "2015-10-30", member: @member1, donation: @d2) # same title, but other donation type
      expect(@member.list_available_budgets.length).to eql(1)
    end

    it "should return only DISTINCT Budgets and from the same organization without were the member is already participating" do
      expect(@member.list_available_budgets.length).to eql(1)
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
      it "should return 'Atfal' for age >= 7" do
        @member.date_of_birth = Date.parse("2008-05-01")
        expect(@member.tanzeem).to eq('Atfal')
      end

      it "should return 'Atfal' if member turn 15 on the 01-11-2015" do
        Timecop.freeze(Date.parse("01-11-2015"))
        @member.date_of_birth = "2000-11-01"
        expect(@member.tanzeem).to eq('Atfal')
        expect(@member.tanzeem).not_to eq('Khuddam')
      end
    end

    context "Khuddam" do
      it "should return 'Khuddam' for age > 16 and < 40" do
        @member.date_of_birth = Date.parse("1998-01-01")
        expect(@member.tanzeem).to eq('Khuddam')
      end

      it "should return 'Khuddam' if member turn 15 on the 31-10-2015" do
        Timecop.freeze(Date.parse("01-11-2015"))
        @member.date_of_birth = Date.parse("2000-10-31")
        expect(@member.tanzeem).to eq('Khuddam')
      end

      it "should return 'Khuddam' if member turn 40 on 01-01-2016" do
        Timecop.freeze(Date.parse("31-12-2015"))
        @member.date_of_birth = Date.parse("1976-01-01")
        expect(@member.tanzeem).to eq('Khuddam')
      end

    end

    context "Ansar" do

      it "should return 'Ansar' if member turn 40 on 31-12-1975" do
        Timecop.freeze(Date.parse("01-01-2016"))
        @member.date_of_birth = Date.parse("1975-12-31")
        expect(@member.tanzeem).to eq('Ansar')
      end

      it "not should return 'Ansar' if member turn 40 on 01-01-2016" do
        Timecop.freeze(Date.parse("31-12-2015"))
        @member.date_of_birth = Date.parse("1976-01-01")
        expect(@member.tanzeem).not_to eq('Ansar')
      end
    end

  end
end
