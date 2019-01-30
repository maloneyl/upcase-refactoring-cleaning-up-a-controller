class Expense < ActiveRecord::Base
  belongs_to :user

  before_update :check_if_updatable?

  validates :amount, presence: true

  scope :active, -> { where(deleted: false) }

  def mark_as_deleted!
    update_attributes!(deleted: true)
  end

  def check_if_updatable?
    if approved_was == false
      true
    else
      errors.add :base, "You cannot update an approved expense"
      false
    end
  end
end
