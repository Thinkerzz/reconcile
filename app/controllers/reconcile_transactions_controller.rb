class ReconcileTransactionsController < ApplicationController
  before_action :set_reconcile_transaction, only: [:show, :imported_data]
  before_action :invalid_file_type, only: [:imported_data]

  def index
    @reconcile_transactions = ReconcileTransaction.all.order(created_at: :desc)
  end

  def new
    @reconcile_transaction = ReconcileTransaction.new
    @reconcile_transaction.source_files.build
    @reconcile_transaction.destination_files.build
  end

  def create
    @reconcile_transaction = ReconcileTransaction.new(reconcile_transaction_params)

    if @reconcile_transaction.save!
      ProcessReconcileTransactionData.perform_now(@reconcile_transaction.id)
      redirect_to reconcile_transaction_summaries_path(@reconcile_transaction)
    else
      render :new
    end
  end

  def show
    @source_files      = @reconcile_transaction.source_files
    @destination_files = @reconcile_transaction.destination_files
  end

  def imported_data
    @file_type    = params[:file_type]
    @file_imports = @reconcile_transaction.file_imports.includes(:data_rows)
  end

  private

  def set_reconcile_transaction
    @reconcile_transaction = ReconcileTransaction.find_by(id: params[:id])
  end

  def invalid_file_type
    redirect_to root_path if params[:file_type].blank?
  end

  def reconcile_transaction_params
    params.require(:reconcile_transaction).permit(
      source_files_attributes: [:source, :_destroy], destination_files_attributes: [:destination, :_destroy])
  end
end
