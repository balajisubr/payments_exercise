class PaymentsController < ActionController::API
  before_action :validate_loan_id, only: [:create, :show_loan_payments]

  class IncorrectPaymentAmountException < Exception
  end

  class IncorrectLoanParamException < Exception 
  end

  rescue_from IncorrectLoanParamException do |exception|
    render json: 'incorrect_loan_id', status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  rescue_from IncorrectPaymentAmountException do |exception|
    render json: 'amount_too_high', status: :unprocessable_entity
  end

  def index
    render json: Payment.all
  end

  def show_loan_payments
    render json: Payment.where(loan_id: params[:loan_id])
  end

  def show
    render json: Payment.find(params[:id])
  end

  def create
    loan = Loan.find(params[:loan_id])
    payment_amount = BigDecimal(params[:amount])
    if payment_amount > loan.outstanding_balance
      raise IncorrectPaymentAmountException
    else
      params.permit!
      p = Payment.create(payment_params)
      render json: p, status: :ok
    end
  end

  def validate_loan_id
    raise IncorrectLoanParamException unless params[:loan_id] =~ /(\d)/
  end

  def payment_params
    params.to_hash.slice(*Payment.attribute_names)
  end
end
