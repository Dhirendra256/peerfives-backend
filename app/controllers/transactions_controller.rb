class TransactionsController < ApplicationController

  def index
    transactions = []

    # Fetch transactions based on the type
    if params[:type] == 'p5'
      transactions = Transaction.where(given_by_id: params[:user_id]).includes(:given_by, :given_to)
    elsif params[:type] == 'rewards'
      transactions = Transaction.where(given_to_id: params[:user_id]).includes(:given_by, :given_to)
    end

    # Map transactions to include user names
    transactions = transactions.map do |transaction|
      {
        id: transaction.id,
        points: transaction.points,
        given_by_name: transaction.given_by.name,
        given_to_name: transaction.given_to.name,
        created_at: transaction.created_at
      }
    end

    # Return the transactions with user names
    render json: transactions
  end

  def create
    giver = User.find(params[:user_id])
    receiver = User.find(transaction_params[:given_to_id])
    points = transaction_params[:points].to_i

    if giver.p5_balance >= points
      Transaction.create!(given_by: giver, given_to: receiver, points: points)
      giver.update!(p5_balance: giver.p5_balance - points)
      receiver.update!(reward_balance: receiver.reward_balance + points)
      render json: { message: 'Transaction completed' }, status: :created
    else
      render json: { error: 'Insufficient P5 balance' }, status: :unprocessable_entity
    end
  end

  def destroy
    transaction = Transaction.find(params[:id])
    giver = transaction.given_by
    receiver = transaction.given_to

    giver.update!(p5_balance: giver.p5_balance + transaction.points)
    receiver.update!(reward_balance: receiver.reward_balance - transaction.points)
    transaction.destroy
    render json: { message: 'Transaction deleted' }
  end

  private

  def transaction_params
    params.require(:transaction).permit(:points, :given_to_id)
  end
end
