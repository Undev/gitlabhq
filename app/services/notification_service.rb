class NotificationService
  class << self

    def create_notifications(event)
      Gitlab::Event::Subscription.create_adjacent_subscriptions(event)
      Gitlab::Event::Notification::Factory.create_notifications(event)
    end

    def process_notification(notification)
      Gitlab::Event::Notifications.process_notification(notification)
    end
  end

  def mailer
    Notify.delay
  end
end
