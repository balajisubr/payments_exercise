FactoryGirl.define do
  factory :payment, class: Payment do
    amount 0.10e2
    payment_date { Date.today }
    loan_id 1
  end
end
