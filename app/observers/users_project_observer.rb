class UsersProjectObserver < BaseObserver
  def after_commit(users_project)
    return if users_project.destroyed?
  end

  def after_create(users_project)
    OldEvent.create(
      project_id: users_project.project.id,
      action: OldEvent::JOINED,
      author_id: users_project.user.id
    )

    notification.new_team_member(users_project)
  end

  def after_update(users_project)
    notification.update_team_member(users_project)
  end

  def after_destroy(users_project)
    OldEvent.create(
      project_id: users_project.project.id,
      action: OldEvent::LEFT,
      author_id: users_project.user.id
    )
  end
end
