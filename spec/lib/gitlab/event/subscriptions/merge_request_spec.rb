require 'spec_helper'

describe Gitlab::Event::Subscriptions::MergeRequest do
  it "should respond to :subscribe method" do
    Gitlab::Event::Subscriptions::MergeRequest.should respond_to :subscribe
  end

  describe "MergeRequest subscribe" do
    before do
      @user = create :user
    end

    it "should subscribe user on exist merge_request changes" do
      source = create :merge_request
      target = source
      action = :updated

      Gitlab::Event::Subscriptions::MergeRequest.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on all merge_requests changes by subscribe with symbol" do
      source = :merge_request
      target = MergeRequest
      action = :created

      Gitlab::Event::Subscriptions::MergeRequest.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on all merge_requests changes by subscribe with Class name" do
      source = MergeRequest
      target = MergeRequest
      action = :created

      Gitlab::Event::Subscriptions::MergeRequest.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

    it "should subscribe user on exist merge_request :note adds" do
      target = create :merge_request
      source = :note
      action = :created

      Gitlab::Event::Subscriptions::MergeRequest.subscribe(@user, action, source, target)

      subscription = ::Event::Subscription.last
      subscription.should_not be_nil
      subscription.should be_persisted
    end

  end
end