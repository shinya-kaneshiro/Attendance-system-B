class UsersController < ApplicationController
  before_action :set_user, only: [
                                  :edit, :show, :update, :destroy,
                                  :edit_basic_info, :update_basic_info
                                 ]
  before_action :logged_in_user, only: [
                                        :index, :edit, :show, :update,
                                        :edit_basic_info, :update_basic_info
                                       ]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: :show
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page], per_page: 15)
    @search_users = User.all.page(params[:page]).search(params[:search])
    if params[:search] && @search_users.count == 0
      flash.now[:info] = "検索ワード「#{params[:search]}」に一致するユーザーは存在しません。"
    elsif params[:search].nil?
      @search_users = User.none
    elsif params[:search].blank?
      @search_users = User.none
      flash.now[:info] = "検索ワードを入力してください。"
    end
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規登録に成功しました。"
      redirect_to user_path @user
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
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_path
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if params[:user][:all_user] == "1"
      users = User.all
      users.each do |user|
        user.update_attributes(basic_info_params)
      end
      flash[:success] = "全ユーザーの基本情報を更新しました。"
      redirect_to edit_basic_info_user_path
    else
      if @user.update_attributes(basic_info_params)
        flash[:success] = "基本情報を更新しました。"
        redirect_to edit_basic_info_user_path
      else
        render :edit_basic_info
      end
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
