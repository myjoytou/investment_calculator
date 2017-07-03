class MutualFund < ApplicationRecord
  validates :name, presence: true
  has_many :nav_histories

  def calculate_investment_value(investment_hash, end_date)
    total_investment_value = 0
    investment_hash.each do |scheme_code, units|
      nav_history = NavHistory.where(scheme_code: scheme_code, date: end_date).first
      total_investment_value += nav_history.net_asset_value if nav_history.present?
      raise "Could not find latest data" if nav_history.blank?
    end
    total_investment_value
  end
end
