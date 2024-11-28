class Transaction < ApplicationRecord
  belongs_to :given_by, class_name: 'User', foreign_key: :given_by_id
  belongs_to :given_to, class_name: 'User', foreign_key: :given_to_id

  validates :points, numericality: { greater_than: 0 }
end
