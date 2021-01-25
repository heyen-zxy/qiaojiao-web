class Admin::AttachmentsController < Admin::BaseController
  include ApplicationHelper
  before_action :set_uptoken, only: [:index, :upload_file]
  skip_before_action :verify_authenticity_token, :only => [:upload]
  def index
    @product_attachments = ProductAttachment.order('created_at  desc')
    render layout: false
  end

  def upload
    @attachment = ProductAttachment.create file_name: params[:file_name], file_path: params[:file_path]
  end

  def upload_file
    file_name = params[:file].original_filename
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
        @uptoken,
        params[:file],
        SecureRandom.uuid  + '.' + file_name.split('.').last,
        nil,
        bucket: 'qiaojiangyoujia'
    )
    file_path = result['key']
    @attachment = ProductAttachment.create file_name: params[:file].original_filename, file_path: file_path
    render json: {url: @attachment.preview_url}
  end

  private

  def set_uptoken
    @uptoken = uptoken
    p uptoken, 2222
  end
end
