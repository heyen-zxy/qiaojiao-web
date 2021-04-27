class NotificationJob < ApplicationJob
  queue_as :default

  def perform(order_id, notification_method)
    # Do something later
    Order.find_by(id: order_id)&.send notification_method
  end
end
