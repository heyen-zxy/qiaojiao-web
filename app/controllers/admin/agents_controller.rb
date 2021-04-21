class Admin::AgentsController < Admin::BaseController
  before_action :set_agent, only: [:edit, :update, :destroy]
  def index
    @agents = Agent.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end

  def new
    params[:agent] ||= {}
    @agent = Agent.new
  end

  def create
    @agent = Agent.new
    if @agent.update agent_permit
      redirect_to admin_agents_path, notice: '添加成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @agent.update agent_permit
      redirect_to admin_agents_path, notice: '变更成功'
    else
      render :edit
    end
  end


  def destroy
    if @agent.destroy
      redirect_to admin_agents_path, notice: '删除成功'
    end
  end

  private
  def set_agent
    @agent = Agent.find_by id: params[:id]
    redirect_to admin_agents_path, alert: '找不到数据' if @agent.blank?
  end

  def agent_permit
    params.require(:agent).permit(:company_name, :name, :phone, :admin_id, :province, :city, :county)
  end

end
