require 'spec_helper'

describe ExpenseApprovalsController do
  before do
    @user = create(:user)
  end

  describe 'create' do
    it 'approves an unapproved expense' do
      expense = create(:expense, :unapproved, user: @user)

      post :create, id: expense.id, user_id: @user.id

      expect(response).to redirect_to(user_expenses_path(@user))
      expect(Expense.find(expense.id).approved?).to be_true
    end
  end
end
