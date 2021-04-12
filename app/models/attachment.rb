class Attachment < ApplicationRecord

  def preview_url
    Rails.application.config.qiniu_domain + '/' + file_path if file_path.present?
  end

  def self.get_model_name type='product'
    case type
    when 'product'
      ProductAttachment
    when 'user'
      UserAttachment
    when 'banner'
      BannerAttachment
    when 'server_user'
      ServerUserAttachment
    when 'public_message'
      MessageAttachment
    end
  end
end
