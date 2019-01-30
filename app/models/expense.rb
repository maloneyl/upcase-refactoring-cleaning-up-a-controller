class Expense < ActiveRecord::Base
  belongs_to :user

  validates :amount, presence: true

  scope :active, -> { where(deleted: false) }

  def mark_as_deleted!
    update_attributes!(deleted: true)
  end
end
