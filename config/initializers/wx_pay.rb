WxPay.mch_id = Settings.mchid # 商户mchid
WxPay.key = Settings.mch_key #微信支付秘钥

WxPay.appid = Settings.appid #appid

# 下面这句没有用. TODO .删掉它.
#WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pass)

WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}
if Rails.env.production?
  WxPay.set_apiclient_by_pkcs12(File.read("apiclient_cert.p12"), WxPay.mch_id)
end