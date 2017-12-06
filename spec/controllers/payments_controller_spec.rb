require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:loan) { FactoryGirl.create(:loan) }
    let(:payment) { FactoryGirl.create(:payment, loan_id: loan.id) }

    context 'valid id' do
      it 'responds with a 200' do
        get :show, params: { id: payment.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#show_loan_payments' do
    context 'loan_id is invalid' do
      before do 
        get :show_loan_payments, params: {loan_id: 'a'}
      end
      it 'raises 400' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'loan_id is valid' do
      let(:loan) { FactoryGirl.create(:loan) }
      let(:loan_id) { loan.id }
      let(:num_payments) { 2 }
      before do 
        num_payments.times do
          FactoryGirl.create(:payment, loan_id: loan_id)
        end
        get :show_loan_payments, params: {loan_id: loan_id}
      end
      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns correct no of payments in response' do
        expect(JSON.parse(response.body).size).to eq(num_payments)
      end
    end
  end

  describe '#create' do
    let(:loan) { FactoryGirl.create(:loan) }
    let(:base_payment_params) { {payment_date: '2017-12-04'} }
    before do 
      post :create, params: payment_params
    end
    context 'invalid loan id' do
      let(:payment_params) { base_payment_params.merge(loan_id: 'a', amount: '10' ) }
      it 'raises 400' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises correct error' do
        expect(response.body).to eq('incorrect_loan_id')
      end
    end

    context 'invalid payment amount' do
      let(:payment_params) { base_payment_params.merge(loan_id: loan.id, amount: '1000' ) }
      it 'raises 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'raises correct error' do
        expect(response.body).to eq('amount_too_high')
      end
    end

    context 'invalid date' do
      let(:payment_params) { base_payment_params.merge(loan_id: loan.id, amount: '10', payment_date:'xx' ) }
      it 'raises 400' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises correct error' do
        expect(response.body).to eq('invalid_date')
      end
    end

    context 'valid payment' do
      let(:payment_params) { base_payment_params.merge(loan_id: loan.id, amount: '10' ) }
      it 'raises 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'creates payment with correct amount' do
        expect(JSON.parse(response.body)["amount"]).to eq("10.0")
      end

      it 'loan outstanding balance reflects correctly' do
        expect(loan.outstanding_balance).to eq(0.9e2)
      end
    end
  end
end
