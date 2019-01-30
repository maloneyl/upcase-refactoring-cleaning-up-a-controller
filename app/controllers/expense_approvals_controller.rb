class ExpenseApprovalsController < ApplicationController
  def create
    expense = Expense.find(params[:id])
    expense.update_attributes!(approved: true)

    redirect_to user_expenses_path(params[:user_id])
  end
end
