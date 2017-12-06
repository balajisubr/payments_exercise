require 'spec_helper'
require 'rails_helper'
describe Loan do
  let(:loan) { FactoryGirl.create(:loan) }
  describe '#funded_amount' do
    it 'returns a decimal value' do
      expect(loan.funded_amount.class).to eq(BigDecimal)
    end
  end

  describe '#outstanding_balance' do
    context 'remaining when payment is appropriate' do
      let!(:payment) { FactoryGirl.create(:payment, loan_id: loan.id) }
      it 'deducts payment' do
        expect(loan.outstanding_balance).to eq(0.9e2)
      end
    end
    
    context 'remaining when payment is too high' do
      let!(:payment) { FactoryGirl.create(:payment, amount: 1000.0, loan_id: loan.id) }
      it 'returns 0' do
        expect(loan.outstanding_balance).to eq(0)
      end
    end
  end

  describe '#as_json' do
    let(:loan_json) { loan.as_json }
    describe 'renders loan fields in JSON' do
      it 'outstanding_balance' do
        expect(loan_json['outstanding_balance']).to eq(0.1e3)
      end
      it 'funded_amount' do
        expect(loan_json['funded_amount']).to eq(0.1e3)
      end
    end
  end
end
