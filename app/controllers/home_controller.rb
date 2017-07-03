class HomeController < ApplicationController
  def index

  end

  def calculate_units

  end

  def calculate_investment_value
    end_date = Date.today - 1.days
    end_date = end_date - 2.days if end_date.sunday?
    end_date = end_date - 1.days if end_date.saturday?
    investment_hash = params[:investment_hash]
    mf = MutualFund.find(params[:fund_id])
    cumulative_value = mf.calculate_investment_value(investment_hash)
    respond_to do |format|
      format.json { render json: {total_investment_value: cumulative_value} }
    end
  end
end
