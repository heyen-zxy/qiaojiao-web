class NotificationJob < ApplicationJob
  queue_as :default

  def perform(order_id, notification_method)
    # Do something later
    p order_id, notification_method
    Order.find_by(order_id)&.send notification_method
  end
end
