class Emails::User::TeamUserRelationship < Emails::User::Base
  def joined_email(notification)
    @notification = notification
    @event        = @notification.event
    @user         = @event.author
    @utur         = @event.source
    @member       = @utur.user
    @team         = @utur.team
    @projects     = @team.projects

    headers 'X-Gitlab-Entity' => 'user',
            'X-Gitlab-Action' => 'joined',
            'X-Gitlab-Source' => 'team-user-relationship',
            'In-Reply-To'     => "team-#{@team.path}-user-#{@member.username}"

    mail(from: "#{@user.name} <#{@user.email}>", bcc: @notification.subscriber.email, subject: "'#{@member.username}' membership in '#{@team.name}' team")
  end

  def updated_email(notification)
    @notification = notification
    @event        = @notification.event
    @user         = @event.author
    @source       = @event.source
    @member       = @source.user
    @team         = @source.team
    @changes      = @event.data["previous_changes"]

    headers 'X-Gitlab-Entity' => 'team',
            'X-Gitlab-Action' => 'updated',
            'X-Gitlab-Source' => 'team-user-relationship',
            'In-Reply-To'     => "team-#{@team.path}-user-#{@member.username}"

    mail(from: "#{@user.name} <#{@user.email}>", bcc: @notification.subscriber.email, subject: "'#{@member.username}' membership in '#{@team.name}' team")
  end

  def left_email(notification)
    @notification = notification
    @event        = @notification.event
    @user         = @event.author
    @up           = @event.data
    @member       = @event.target
    @team         = Team.find_by_id(@up["team_id"])
    @member       = User.find_by_id(@up["user_id"]) if @member.nil? || @member.is_a?(TeamUserRelationship)

    if @team && @member
      headers 'X-Gitlab-Entity' => 'user',
              'X-Gitlab-Action' => 'left',
              'X-Gitlab-Source' => 'team-user-relationship',
              'In-Reply-To'     => "team-#{@team.path}-user-#{@member.username}"

      mail(from: "#{@user.name} <#{@user.email}>", bcc: @notification.subscriber.email, subject: "'#{@member.username}' membership in '#{@team.name}' team")
    end
  end
end