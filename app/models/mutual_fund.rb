class MutualFund < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :nav_histories

  def calculate_investment_value(investments, end_date)
    total_investment_value = 0
    investments.each do |key, investment_obj|
      nav_history = NavHistory.where(scheme_code: investment_obj["scheme_code"], date: end_date).first
      total_investment_value += nav_history.net_asset_value.to_f * investment_obj["units"].to_f if nav_history.present?
      raise "Could not find latest data" if nav_history.blank?
    end
    total_investment_value
  end

  def get_unique_schemes
    self.nav_histories.select(:scheme_code, :scheme_name).distinct
  end

  def calculate_units(scheme_code, invested_amount, date)
    nav_histories = self.nav_histories.where(scheme_code: scheme_code, date: Date.parse(date))
    return invested_amount.to_f / nav_histories.first.net_asset_value.to_f if nav_histories.present?
    raise "no data for this date, please select a valid date" if nav_histories.blank?
  end
end
