class HomeController < ApplicationController
  def index
    @funds = MutualFund.all
  end

  def mutual_funds
    respond_to do |format|
      format.json { render json: {funds: MutualFund.all } }
    end
  end

  def get_schemes
    raise "fund id not present" if params[:fund_id].blank?
    fund = MutualFund.find(params[:fund_id])
    schemes = fund.get_unique_schemes
    respond_to do |format|
      format.json { render json: {schemes: schemes } }
    end
  end

  def calculate_units
    raise "scheme_code not present" if params[:scheme_code].blank?
    raise "invested amount is not present" if params[:invested_amount].blank?
    raise "date not present" if params[:date].blank?
    raise "fund id not present" if params[:fund_id].blank?
    fund = MutualFund.find(params[:fund_id])
    units = fund.calculate_units(params[:scheme_code], params[:invested_amount], params[:date])
    respond_to do |format|
      format.json { render json: {units: units } }
    end

  end

  def calculate_investment
    end_date = Date.today - 1.days
    end_date = end_date - 2.days if end_date.sunday?
    end_date = end_date - 1.days if end_date.saturday?
    end_date = Date.parse("2017-06-29")
    mf = MutualFund.find(params[:fund_id])
    cumulative_value = mf.calculate_investment_value(params[:investments], end_date)
    respond_to do |format|
      format.json { render json: {total_investment_value: cumulative_value} }
    end
  end
end
