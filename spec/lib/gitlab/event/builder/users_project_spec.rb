require 'spec_helper'

describe Gitlab::Event::Builder::UsersProject do
  before do
    @users_project = create :users_project
    @user = create :user
    @data = {target: @users_project, user: @user, data: @users_project}
    @action = "gitlab.created.users_project"
  end

  it "should respond that can build this data into action" do
    Gitlab::Event::Builder::UsersProject.can_build?(@action, @data[:target]).should be_true
  end

  it "should build events from hash" do
    @events = Gitlab::Event::Builder::UsersProject.build(@action, @data[:target], @data[:user], @data[:data])
  end
end
