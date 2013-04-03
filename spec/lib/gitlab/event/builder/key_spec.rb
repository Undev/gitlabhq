require 'spec_helper'

describe Gitlab::Event::Builder::Key do
  before do
    ActiveRecord::Base.observers.disable :all

    @user = create :user
    @key = create :key, user: @user
    @data = {source: @key, user: @user, data: @key}
    @action = "gitlab.created.key"
  end

  it "should respond that can build this data into action" do
    Gitlab::Event::Builder::Key.can_build?(@action, @data[:source]).should be_true
  end

  it "should build events from hash" do
    @events = Gitlab::Event::Builder::Key.build(@action, @data[:source], @data[:user], @data[:data])
  end
end