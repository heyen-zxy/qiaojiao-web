class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  enum status: {
      success: 1,
      failed: 0
  }
end
