class User < ApplicationRecord
  has_many :given_transactions, class_name: 'Transaction', foreign_key: :given_by_id
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :given_to_id

  validates :name, presence: true
  validates :p5_balance, :reward_balance, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_create :set_default_balances

  private

  def set_default_balances
    self.p5_balance = 100
    self.reward_balance = 0
  end
end
