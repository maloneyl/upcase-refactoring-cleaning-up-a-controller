class ExpenseFilterQuery
  def initialize(scope: Expense.all, filters: {})
    @scope = scope
    @filters = filters
  end

  def to_relation
    return scope if filters.empty?

    filtered_scope = scope

    if filters.has_key?(:approved)
      filtered_scope = filtered_scope.where(approved: filters[:approved])
    end

    if filters.has_key?(:min_amount)
      filtered_scope = filtered_scope.where('amount > ?', filters[:min_amount])
    end

    if filters.has_key?(:max_amount)
      filtered_scope = filtered_scope.where('amount < ?', filters[:max_amount])
    end

    filtered_scope
  end

  private

  attr_reader :scope, :filters
end
