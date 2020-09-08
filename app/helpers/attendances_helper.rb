module AttendancesHelper
    
  # 出社・退社ボタンの表示/非表示の判定材料を返す。
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  # 出社時間と退社時間を受け取り、在社時間を計算して返す。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  # 総合勤務時間を返す。
  def total_bacic_times(time)
    format("%.2f", (((time.hour * 60) + time.min) * @worked_sum) / 60.0)
  end
end
