require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:loan)    { FactoryGirl.create(:loan) }
  let(:payment) { FactoryGirl.create(:payment, loan_id: loan.id) }
  describe '.loan' do
    it 'returns loan' do
      expect(payment.loan).to eq(loan)
    end
  end
 
  describe '.amount' do
    it 'returns decimal' do
      expect(payment.amount.class).to eq(BigDecimal)
    end
  end

  describe '.payment_date' do
    it 'returns date' do
      expect(payment.payment_date.class).to eq(Date)
    end
  end
end
