Gitlab::Seeder.quiet do
  (1..300).each  do |i|
    # Random Project
    project = Project.all.sample

    # Random user
    user = project.team.users.sample

    next unless user

    user_id = user.id

    begin
      RequestStore.store[:current_user] = user
      Gitlab::Seeder.by_user(user) do
        Issue.seed(:id, [{
          id: i,
          project_id: project.id,
          author_id: user_id,
          assignee_id: user_id,
          state: ['opened', 'closed'].sample,
          milestone: project.milestones.sample,
          title: Faker::Lorem.sentence(6),
          description: Faker::Lorem.sentence
        }])
        print('.')
      end
    ensure
      RequestStore.store[:current_user] = nil
    end
  end

  Issue.all.map do |issue|
    issue.set_iid
    issue.save
  end
end
