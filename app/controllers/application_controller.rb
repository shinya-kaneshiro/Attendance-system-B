class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
    #beforeフィルター
    
    # paramsハッシュからユーザーを取得する。
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認する。
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認する。
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "アクセス権限がありません。"
        redirect_to(root_url)
      end
    end
    
    # 管理権限保有者、またはログインユーザー本人であるか確認する。
    def admin_or_correct_user
      active_controller = controller_name
      if active_controller == "users"
        @user = User.find(params[:id]) if @user.blank?
      elsif active_controller == "attendances"
        @user = User.find(params[:user_id]) if @user.blank?
      end
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end  
    end
    
    # 管理者権限を保有しているか確認する。
    def admin_user
      unless current_user.admin?
        flash[:danger] = "アクセス権限がありません。"
        redirect_to root_url
      end
    end

  # ページ出力前に1ヶ月分のデータの存在を確認・セットする。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
  
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
