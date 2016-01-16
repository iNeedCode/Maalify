require 'rails_helper'
require 'awesome_print'

RSpec.describe Member, :type => :model do

  describe 'validation rules that are used for the member' do

    before(:each) do
      @member = FactoryGirl.create(:member)
    end

    it "should display the right full_name" do
      expect(@member.full_name).to eql("#{@member.last_name}, #{@member.first_name}")
    end

    it "should fail if certain fields #{%w[ first_name last_name date_of_birth aims_id gender ]} are left blank" do
      expect(@member.valid?).to eq(true)
      @member.first_name = nil
      expect(@member.valid?).to eq(false)
      @member.last_name = nil
      @member.date_of_birth = nil
      @member.aims_id = nil
      @member.gender = nil
      expect(@member.valid?).to eq(false)

      %w[ first_name last_name date_of_birth aims_id ].each do |field|
        expect(@member.errors[field]).to eq(["can't be blank"])
      end
    end

    it 'should select the most current income by date' do
      inc1 = Income.create(amount: 1000, starting_date: '2014-01-03', member: @member)
      inc2 = Income.create(amount: 1200, starting_date: '2014-05-05', member: @member)

      expect(@member.current_income).to eql(inc2)
    end

    it 'should select the oldest income by date' do
      inc1 = Income.create(amount: 1000, starting_date: '2014-01-03', member: @member)
      inc2 = Income.create(amount: 1200, starting_date: '2014-04-01', member: @member)
      inc3 = Income.create(amount: 1500, starting_date: '2015-04-01', member: @member)

      expect(@member.oldest_income).to eql(inc1)
    end

    it 'should pass if gender is valid' do
      @member.gender = "male"
      expect(@member.valid?).to eql(true)
      @member.gender = "female"
      expect(@member.valid?).to eql(true)
    end

    it 'should fail if gender is not valid' do
      @member.gender = "malee"
      expect(@member.valid?).to eql(false)
      @member.gender = nil
      expect(@member.valid?).to eql(false)
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

    it "should return list_currrent_budgets ------------------" do
      Timecop.freeze(Date.parse("01-05-2015")) # freeze Date to 01.05.2015

      expect(@member.list_available_budgets.size).to eql(1)
      expect(@member.list_currrent_budgets.first[:budget].member_id).to eql(12345)
      expect(@member.list_currrent_budgets.first[:budget].class).to eql(Budget)
      expect(@member.list_currrent_budgets.first[:paid_amout]).to eql(0)
      expect(@member.list_currrent_budgets[1][:budget].title).to eql('MKAD-14-15 majlis')
      expect(@member.list_currrent_budgets[1][:budget].rest_promise_from_past_budget).to eql(0)

      budget1 = Budget.find(1)
      budget1.promise = 200
      budget1.rest_promise_from_past_budget = 20
      budget1.save
      budget1.reload

      expect(@member.list_currrent_budgets[1][:budget].promise).to eql(200)
      expect(@member.list_currrent_budgets[1][:budget].rest_promise_from_past_budget).to eql(20)

    end
  end

  describe 'Tanzeem Method' do

    before(:each) do
      @member = FactoryGirl.create(:member)
      @female = FactoryGirl.create(:member, aims_id: 123, gender: 'female')
      Timecop.freeze(Date.parse("01-05-2015"))
    end

    context "General" do
      it "should have a valid factory and a valid tanzeem method" do
        expect(@member).to be_valid
        expect(@member).to respond_to(:tanzeem)
      end
    end

    context "Nasirat" do
      it "should return 'Nasirat' if member >= 7 and gender is 'female'" do
        Timecop.freeze(Date.parse("01-01-2017"))
        @female.date_of_birth = "2010-01-02"
        expect(@female.tanzeem).to_not eq('Nasirat')

        @female.date_of_birth = "2010-01-01"
        expect(@female.tanzeem).to eq('Nasirat')

        @female.date_of_birth = "2009-12-31"
        expect(@female.tanzeem).to eq('Nasirat')
      end

      it "should return 'Nasirat' if member >= 7 and day after lajna year begins get 15 and gender is 'female'" do
        Timecop.freeze(Date.parse("01-11-2010"))
        @female.date_of_birth = "2003-11-01"
        expect(@female.tanzeem).to eq('Nasirat')

        @female.date_of_birth = "1995-11-01"
        expect(@female.tanzeem).to eq('Nasirat')

        @female.date_of_birth = "1995-10-31"
        expect(@female.tanzeem).to_not eq('Nasirat')
      end
    end

    context "Lajna" do

      it "should return 'Lajna' if female member get >= 15 day before lajna year begins and gender is 'female'" do
        Timecop.freeze(Date.parse("01-11-2010"))
        @female.date_of_birth = "1995-10-31"
        expect(@female.tanzeem).to eq('Lajna')

        @female.date_of_birth = "1995-11-01"
        expect(@female.tanzeem).to_not eq('Lajna')

      end

    end

    context "Kind" do
      it "should return 'Kind' for age < 7" do
        @member.date_of_birth = "2008-05-02"
        expect(@member.tanzeem).to eq('Kind')

        @female.date_of_birth = "2008-05-02"
        expect(@female.tanzeem).to eq('Kind')
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

      it "should not return 'Ansar' if member turn 40 on 01-01-2016" do
        Timecop.freeze(Date.parse("31-12-2015"))
        @member.date_of_birth = Date.parse("1976-01-01")
        expect(@member.tanzeem).not_to eq('Ansar')
        expect(@member.tanzeem).to eq('Khuddam')
      end
    end

  end
end
