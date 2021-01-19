RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  config.authenticate_with do
    # authenticate_admin_user!
    # warden.authenticate! scope: :user
    redirect_to main_app.root_path, alert: '无权限' unless current_admin.present? && current_admin.role?('super_admin')
  end

  config.forgery_protection_settings = {with: :null_session}

  config.main_app_name = ["巧匠", "优家"]
  config.included_models = ["Resource", 'Role', 'Category', 'Admin']

  config.model 'Admin' do
    label_plural "公司人员"
    field :phone do
      label '手机号'
    end
    field :password do
      label '密码'
    end
    field :name do
      label '姓名'
    end
    field :role do
        # REQUIRED if you want to SORT the list as below
      label '角色职务'
    end
  end

  config.model 'Category' do
    label_plural "分类"
    field :name do
      label '分类名'
    end
    nestable_tree({
                      live_update: :only
                  })

  end

  config.model 'Role' do
    label_plural "角色职务"
    field :name do
      label '职务名'
    end
    field :tag do
      label '标签'
    end
    field :resources do
      # REQUIRED if you want to SORT the list as below
      label '权限资源'
      associated_collection_cache_all true
    end

  end

  config.model 'Resource' do
    label_plural "权限资源"
    field :name do
      label '资源名'
    end
    field :target do
      label '模块'
    end
    field :action do
      label '操作'
    end
    field :desc do
      label '简介'
    end
  end


  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    nestable

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
