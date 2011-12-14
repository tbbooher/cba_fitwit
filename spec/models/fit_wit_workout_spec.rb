require 'spec_helper'

describe FitWitWorkout do
  before(:all) do
    cleanup_database
    create_default_userset
    create_15_users_and_workouts
  end

  it "should correctly compute the common value for all different score methods" do
    u = User.first
    [
    ["sum-slashes", "10/20/30/40"],
    ["sum-commas", "10,20,30,40"],
    ["simple-rounds", "100"],
    ["simple-time", "10:00"],
    ["parse-time", Time.parse("0:10")],
    ["slash-separated-time", "20:00/20:00"],
    ].each do |method, score|
      wo = FactoryGirl.create(:fit_wit_workout, score_method: method, name: "#{method}_workout")
      w = FactoryGirl.create(:workout, user: u, fit_wit_workout: wo, score: score)
      puts "For method #{method} and score #{score}, it computes #{w.common_value}."
      w.common_value.should eq(100.0)
    end
  end

  it "should show the pr for a user (based on a scope)" do
    w = FactoryGirl.create(:workout)
    w.fit_wit_workout.pr_for(w.user).score.should eq(w.score)
  end

  it "should present the top 10 leaders for this workout" do
    @fww.top_10_all_fit_wit.size.should eq(10)
    @fww.top_10_all_fit_wit.first.score.should eq("50")
    #puts @fww.top_10_all_fit_wit_by_gender(:female).first.score
    top_male_score = @fww.prs.where(sex: :male).desc(:common_value).first.score
    top_female_score = @fww.prs.where(sex: :female).desc(:common_value).first.score
    @fww.top_10_all_fit_wit_by_gender(:male).first.score.should eq(top_male_score)
    @fww.top_10_all_fit_wit_by_gender(:female).first.score.should eq(top_female_score)

    # make sure the users collection is unique, not Tim, 15, Tim, 14, Tim, 13 . . .
    @fww.top_10_all_fit_wit.map{|pr| pr.user.name}.uniq.size.should eq(10)
  end

  it "should be able to find an average of common values" do
    males = @fww.prs.where(sex: :male).map(&:common_value)
    females = @fww.prs.where(sex: :female).map(&:common_value)
    @fww.find_average(:male).should eq(males.sum/males.size)
    @fww.find_average(:female).should eq(females.sum/females.size)
  end

  it "should be able to find the max workout" do
    top_male_cv = @fww.prs.where(sex: :male).desc(:common_value).first.common_value
    @fww.find_best(:male).should eq(top_male_cv)
    # make a girl, give her a great score
    @fww.find_best(:female).should eq(50.0)
  end

  it "should be able to find peers" do
    u = @fww.workouts[7].user
    pr = @fww.pr_for(u)
    #puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Debug"
    #puts "#{u.name} score is #{@fww.pr_for(u).score}"
    #puts "--------------- above --------------- "
    #puts @fww.find_competition(u)[:above].map{|pr| [pr.user.name, pr.score]}
    #puts "--------------- and below --------------- "
    #puts @fww.find_competition(u)[:below].map{|pr| [pr.user.name, pr.score]}
    @fww.find_competition(u)[:above].
        map(&:common_value).min.should be >= pr.common_value
    @fww.find_competition(u)[:below].
        map(&:common_value).max.should be < pr.common_value
  end

end
