# -*- encoding: utf-8 -*-
# vim: sw=2 ts=2

require 'stringio'

module Qiniu
  module Storage
    class << self
      def upload_with_token_2(uptoken,
                              local_file,
                              key = nil,
                              x_vars = nil,
                              opts = {})
        ### 构造URL
        url = Config.up_host(opts[:bucket])
        url[/\/*$/] = ''
        url += '/'
        ### 构造HTTP Body
        file = local_file

        post_data = {
            :file      => file,
            :multipart => true,
        }
        if not uptoken.nil?
          post_data[:token] = uptoken
        end
        if not key.nil?
          post_data[:key] = key
        end
        if x_vars.is_a?(Hash)
          post_data.merge!(x_vars)
        end

        ### 发送请求
        HTTP.api_post(url, post_data)
      rescue BucketIsMissing
        raise 'upload_with_token_2 requires :bucket option when multi_region is enabled'
      end # upload_with_token_2
    end
  end # module Storage
end # module Qiniu
