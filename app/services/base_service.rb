class BaseService
  attr_accessor :current_user, :params

  def initialize(user, params = {})
    @current_user, @params = user, params.dup
  end

  def abilities
    @abilities ||= begin
                     abilities = Six.new
                     abilities << Ability
                     abilities
                   end
  end

  def can?(object, action, subject)
    abilities.allowed?(object, action, subject)
  end

  def receive_delayed_notifications
    notifications = Event::Subscription::Notification.delayed
    notifications.each do |notification|
      Sidekiq::Client.enqueue_to(:mail_notifications, MailNotificationWorker, notification.id)
    end
  end

  def multiple_action(action_name, action_source, source, items = nil, &block)
    RequestStore.store[:borders] ||= []

    if [items].flatten.many? || items.nil?
      RequestStore.store[:borders].push("gitlab.#{action_name}.#{action_source}")
      Gitlab::Event::Action.trigger :"#{action_name}", source
    end

    yield

    if [items].flatten.many? || items.nil?
      RequestStore.store[:borders].pop
    end

    receive_delayed_notifications
  end
end
