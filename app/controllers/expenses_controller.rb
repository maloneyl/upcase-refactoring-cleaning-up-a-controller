class ExpensesController < ApplicationController
  def index
    @user = find_user
    @expenses = ExpenseFilterQuery.new(
      scope: @user.expenses.active,
      filters: index_filter_params
    ).to_relation
  end

  def new
    @user = find_user
  end

  def create
    user = find_user

    @expense = user.expenses.new(expense_params)

    if @expense.save
      email_body = "#{@expense.name} by #{user.full_name} needs to be approved"
      mailer = ExpenseMailer.new(address: 'admin@expensr.com', body: email_body)
      mailer.deliver

      redirect_to user_expenses_path(user)
    else
      render :new, status: :bad_request
    end
  end

  def update
    user = find_user

    @expense = user.expenses.find(params[:id])

    if !@expense.approved
      @expense.update_attributes!(expense_params)
      flash[:notice] = 'Your expense has been successfully updated'
      redirect_to user_expenses_path(user_id: user.id)
    else
      flash[:error] = 'You cannot update an approved expense'
      render :edit
    end
  end

  def destroy
    expense = Expense.find(params[:id])
    user = find_user
    expense.mark_as_deleted!

    redirect_to user_expenses_path(user_id: user.id)
  end

  private

  def find_user
    @_user ||= User.find(params[:user_id])
  end

  def index_filter_params
    params.slice(:approved, :min_amount, :max_amount)
  end

  def expense_params
    params.require(:expense).permit(:name, :amount, :approved)
  end
end
