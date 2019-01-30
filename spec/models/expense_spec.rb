require 'spec_helper'

describe Expense do
  it 'does not allow an approved expense to be updated' do
    expense = create(:expense, :approved)

    expect{
      expense.update_attributes!(amount: 10)
    }.to raise_error(ActiveRecord::RecordNotSaved)
    expect(expense.errors.full_messages).to eq(
      ["You cannot update an approved expense"]
    )
  end
end
