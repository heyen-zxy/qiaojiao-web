module ApplicationHelper
  def uptoken

    put_policy = Qiniu::Auth::PutPolicy.new(
        "qiaojiangyoujia",                    # 存储空间
        nil,                           # 最终资源名，可省略，即缺省为“创建”语义
        1800,                          # 相对有效期，可省略，缺省为3600秒后 uptoken 过期
        (Time.now + 30.minutes).to_i  # 绝对有效期，可省略，指明 uptoken 过期期限（绝对值），通常用于调试，这里表示半小时
    )

    uptoken = Qiniu::Auth.generate_uptoken(put_policy) #生成凭证

  end

  def active_class controller, action=nil
    if action.present?
      controller_name == controller.to_s && action_name == action.to_s ? 'active' : ''
    else
      controller_name == controller.to_s ? 'active' : ''
    end
  end

  def controller_name_view
    controllers = {
        products: '商品、服务',
        orders: '订单',
        in_payments: '用户支付记录',
        out_payments: '佣金汇款记录',
        users: '用户',
        attachments: '文件库'
    }
    controllers[controller_name.to_sym]
  end

  def action_name_view
    actions = {
        index: '列表',
        new: '新增',
        create: '新增',
        edit: '编辑',
        update: '编辑'
    }
    actions[action_name.to_sym]
  end
end
