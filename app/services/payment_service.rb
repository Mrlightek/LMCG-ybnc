class PaymentService

  def self.call(type:, payment_method:, amount:, user:)
    new(
      type: type,
      payment_method: payment_method,
      amount: amount,
      user: user
    ).call
  end


  def initialize(type:, payment_method:, amount:, user:)
    @type = type
    @payment_method = payment_method
    @amount = amount
    @user = user
  end


  def call
    case payment_method.to_sym

    when :paypal
      paypal

    when :bank
      bank

    when :check
      check

    when :cashapp
      cashapp

    end
  end


  private

  attr_reader :type, :payment_method, :amount, :user


  def paypal
    puts "Process PayPal payment"
  end


  def bank
    puts "Process ACH payment"
  end


  def check
    puts "Record check payment"
  end


  def cashapp
    puts "Process CashApp payment"
  end

end