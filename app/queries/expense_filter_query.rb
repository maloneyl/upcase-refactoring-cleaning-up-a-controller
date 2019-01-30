class ExpenseFilterQuery
  def initialize(scope: Expense.all, filters: {})
    @scope = scope
    @filters = filters
  end

  def to_relation
    if filters[:approved].nil?
      expenses = scope.active
    else
      expenses = scope.active.where(approved: filters[:approved])
    end

    if !filters[:min_amount].nil?
      expenses = expenses.where('amount > ?', filters[:min_amount])
    end

    if !filters[:max_amount].nil?
      expenses = expenses.where('amount < ?', filters[:max_amount])
    end

    expenses
  end

  private

  attr_reader :scope, :filters
end
