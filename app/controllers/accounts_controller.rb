class AccountsController < ApplicationController
  respond_to :html

  def new
    @account = Account.new
    respond_with @account
  end

  def create
    @account = Account.new(params[:account])

    begin
      @account.checkin!
      flash[:notice] = "Thank you (confirmation code: #{@account.id})"
    rescue
      flash[:error] = "Hum... The login information seems incorrect :("
    end

    respond_with @account, :location => :new_accounts
  end
end
