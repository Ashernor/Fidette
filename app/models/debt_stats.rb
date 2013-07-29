class DebtStats
  class DateRange < Struct.new(:start_date, :end_date)
  end

  def initialize params = {}
    user_id = params[:user_id]
    @debts        = Debt.where("debtor_id = #{user_id} OR creditor_id = #{user_id}")
    @debt_debts   = Debt.where("debtor_id = #{user_id}")
    @credits      = Debt.where("creditor_id = #{user_id}")
    start_date    = params[:start].present? ? params[:start].to_date : guess_start_date
    end_date      = params[:end].present? ? params[:end].to_date : guess_end_date
    @date_range   = DateRange.new(start_date, end_date)
  end

  def start_date
    @date_range.start_date
  end

  def end_date
    @date_range.end_date
  end


  # Debts by week

  def debts_by_week
    @debts_by_week ||= @debt_debts.includes(:id).group("date_trunc('week', debts.date)::DATE").count
  end

  def debts_value_by_week
    keys = @debt_debts.map{|d| d.date.strftime("%Y-%m-%d")}
    values = @debt_debts.map{|d| d.value.to_i }
    @debts_value_by_week ||= Hash[keys.zip(values)]
  end

  # Credits

  def credits_by_week
    @credits_by_week ||= @credits.includes(:id).group("date_trunc('week', debts.date)::DATE").count
  end

  def credits_value_by_week
    keys = @credits.map{|d| d.date.strftime("%Y-%m-%d")}
    values = @credits.map{|d| d.value.to_i }
    @credits_value_by_week ||= Hash[keys.zip(values)]
  end

  private

  def last_week_values hash
    values = hash.to_a
    return Hash[values.sort_by { |e| e[0] }.from(-3)] if values.size >= 3
    Hash[values.sort_by { |e| e[0] }]
  end

  def sum_hash hash
    hash.inject(0) { |memo, hash| memo += hash.to_a[1] }
  end

  def guess_start_date
    Date.today - 30
  end

  def guess_end_date
    Date.today
  end
end