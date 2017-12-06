class Loan < ActiveRecord::Base
  has_many :payments

  def outstanding_balance
    [self.funded_amount - payments.pluck(:amount).reduce(0,:+), 0].max
  end

  def as_json(*)
    ActiveSupport::HashWithIndifferentAccess.new(super.merge('outstanding_balance': outstanding_balance))
  end
end
