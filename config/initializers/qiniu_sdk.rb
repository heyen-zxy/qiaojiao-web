require 'qiniu'
# 构建鉴权对象
Qiniu.establish_connection! access_key: 'M5zN_IUlbAWlcHNRr1q7Cni8R9vuqTeY16Y0_fgW',
                            secret_key: 'IBjaVCD2zRPlPNtNhDrFI-TpUwNUvFpn8ZQCJCZV'
Rails.application.config.qiniu_domain = 'https://file.jxjiajiang.com'