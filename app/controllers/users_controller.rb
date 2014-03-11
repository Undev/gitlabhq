class UsersController < ApplicationController

  skip_before_filter :authenticate_user!, only: [:show]
  layout :determine_layout

  def show
    @user = User.find_by_username!(params[:username])

    if !current_user
      # && @projects.empty?
      return authenticate_user!
    end

    @projects       = current_user.known_projects.where(id: @user.authorized_projects.pluck(:id)).includes(:namespace)
    @groups         = current_user.authorized_groups.where(id: @user.personal_groups)
    @teams          = current_user.authorized_teams.where(id: @user.personal_teams)

    @event_projects = current_user.known_projects
    @events         = @user.recent_events.where(project_id: @event_projects).reorder('created_at DESC').offset(params[:offset]).limit(params[:limit])

    @title          = @user.name
  end

  def determine_layout
    if current_user
      'navless'
    else
      'public_users'
    end
  end
end
