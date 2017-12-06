# Payments Exercise

Add in the ability to create payments for a given loan using a JSON API call. You should store the payment date and amount. Expose the outstanding balance for a given loan in the JSON vended for `LoansController#show` and `LoansController#index`. The outstanding balance should be calculated as the `funded_amount` minus all of the payment amounts.

A payment should not be able to be created that exceeds the outstanding balance of a loan. You should return validation errors if a payment can not be created. Expose endpoints for seeing all payments for a given loan as well as seeing an individual payment.

#Info on implementation
* To display loan payments info
  GET /payments/loan/:loan_id
* To display individual payment info
  GET /payments/:payment_id
* To create payment
  POST /payments/create 
    example params: {loan_id: 1, amount: 10.0, payment_date: '2017-04-01'}
* Payments Model
  Has fields for payment_date, amount, loan_id
