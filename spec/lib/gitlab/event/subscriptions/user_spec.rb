require 'spec_helper'

describe Gitlab::Event::Subscriptions::User do
  it "should respond to :subscribe method" do
    Gitlab::Event::Subscriptions::User.should respond_to :subscribe
  end

  describe "User subscribe" do
    before do
      @user = create :user
    end

    it "should subscribe user on exist user changes" do
      source = create :user
      target = source
      action = :updated

      Gitlab::Event::Subscriptions::User.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on all users changes by subscribe with symbol" do
      source = :user
      target = User
      action = :created

      Gitlab::Event::Subscriptions::User.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on all users changes by subscribe with Class name" do
      source = User
      target = User
      action = :created

      Gitlab::Event::Subscriptions::User.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on exist user :key adds" do
      target = create :user
      source = :key
      action = :created

      Gitlab::Event::Subscriptions::User.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

  end
end