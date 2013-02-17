class ActivityObserver < ActiveRecord::Observer
  observe :issue,           # +
          :key,             # +
          :merge_request,   # +
          :milestone,       # +
          :group,           # +
          :note,            # +
          :project,         # +
          :protected_branch,# +
          :service,         # +
          :snippet,         # +
          :user,            # +
          :user_team,       # +
          :user_team_project_relationship,
          :user_team_user_relationship,
          :users_project,   # +
          :project_hook,    # +
          :system_hook,     # +
          :wiki             # +

  def after_create(model)
    Gitlab::Event::Notifications.trigger :created, model
  end

  def after_update(model)
    Gitlab::Event::Notifications.trigger :updated, model
  end

  def after_destroy(model)
    Gitlab::Event::Notifications.trigger :deleted, model
  end
end
