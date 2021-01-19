module ApplicationHelper
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
