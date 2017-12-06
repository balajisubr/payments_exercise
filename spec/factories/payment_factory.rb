FactoryGirl.define do
  factory :payment, class: Payment do
    amount 10.0
    payment_date { Date.today }
    loan_id 1
  end
end
