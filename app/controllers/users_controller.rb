class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :show, :update, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:show]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規登録に成功しました。"
      # redirect_to @user
    else
      render :new
    end
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to edit_user_path
    else
      render :edit
    end
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to edit_basic_info_user_path
    else
      render :edit_basic_info
    end
  end
    
  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:work_time, :basic_time)
    end
end
