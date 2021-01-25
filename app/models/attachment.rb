class Attachment < ApplicationRecord

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end
end
