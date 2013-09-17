class TeamsController < ApplicationController
  # Authorize
  #before_filter :authorize_create_team!, only: [:new, :create]
  #before_filter :authorize_manage_team!, only: [:edit, :update]
  #before_filter :authorize_admin_team!, only: [:destroy]

  before_filter :team, except: [:index, :new, :create]

  layout :determine_layout

  before_filter :set_title, only: [:new, :create]

  def index
    redirect_to teams_dashboard_path
  end

  def show
    projects
    groups
    members
    @events = OldEvent.in_projects(team.project_ids).limit(20).offset(params[:offset] || 0)
  end

  def edit
    render 'edit', layout: "team_settings"
  end

  def update
    if team.update_attributes(params[:team])
      redirect_to team_path(team)
    else
      render action: :edit
    end
  end

  def destroy
    ::Teams::RemoveContext.new(current_user, team).execute

    redirect_to dashboard_path
  end

  def new
    @team = Team.new
  end

  def create
    @team = ::Teams::CreateContext.new(current_user, params[:team]).execute
    if @team.persisted?
      redirect_to team_path(@team)
    else
      render action: :new
    end
  end

  protected

  def projects
    @projects ||= team.projects.sorted_by_push_date
  end

  def groups
    @groups ||= team.groups
  end

  def members
    @members ||= team.members
  end

  def teams
    @teams ||= current_user.authorized_teams
  end

  def team
    @team ||= teams.find_by_path(params[:id])
    raise ActiveRecord::RecordNotFound if @team.nil?
    @team
  end

  def set_title
    @title = 'New Team'
  end

  def determine_layout
    if [:index, :new, :create].include?(action_name.to_sym)
      'navless'
    else
      'team'
    end
  end
end
