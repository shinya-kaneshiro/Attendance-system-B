class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update]
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
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to edit_user_path
    else
      render :edit
    end
  end
    
  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
end
