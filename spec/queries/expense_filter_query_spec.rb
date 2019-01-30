require 'spec_helper'

describe ExpenseFilterQuery, '#to_relation' do
  subject do
    described_class.new(scope: scope, filters: filters).to_relation
  end

  context 'when there are no filters' do
    let(:scope) { Expense.all }
    let(:filters) { {} }

    it 'returns the scope as is' do
      all_expenses = create_list(:expense, 2)

      expect(subject).to eq(all_expenses)
    end
  end

  context 'when the filters include :approved' do
    let(:scope) { Expense.all }
    let(:filters) { {approved: false} }

    it 'returns the scope filtered with the given approved status' do
      approved_expense = create(:expense, :approved)
      unapproved_expense = create(:expense, :unapproved)

      expect(subject).to eq([unapproved_expense])
    end
  end

  context 'when the filters include :min_amount' do
    let(:scope) { Expense.all }
    let(:filters) { {min_amount: 10} }

    it 'returns the scope filtered with the given min_amount' do
      matching_expense = create(:expense, amount: 14.00)
      other_matching_expense = create(:expense, amount: 15.21)
      not_matching_expense = create(:expense, amount: 6.00)

      expect(subject).to eq([matching_expense, other_matching_expense])
    end
  end

  context 'when the filters include :max_amount' do
    let(:scope) { Expense.all }
    let(:filters) { {max_amount: 15} }

    it 'returns the scope filtered with the given max_amount' do
      matching_expense = create(:expense, amount: 14.00)
      other_matching_expense = create(:expense, amount: 14.21)
      not_matching_expense = create(:expense, amount: 16.00)

      expect(subject).to eq([matching_expense, other_matching_expense])
    end
  end

  context 'when there are multiple filters' do
    let(:scope) { Expense.all }
    let(:filters) { {approved: false, max_amount: 15} }

    it 'returns the scope filtered with those conditions' do
      matching_expense = create(:expense, :unapproved, amount: 14.00)
      not_matching_expense = create(:expense, :approved, amount: 14.00)
      other_not_matching_expense = create(:expense, :unapproved, amount: 16.00)

      expect(subject).to eq([matching_expense])
    end
  end

  context 'when initialized with no arguments' do
    it 'returns all expenses' do
      all_expenses = create_list(:expense, 2)

      expect(described_class.new.to_relation).to eq(all_expenses)
    end
  end
end
