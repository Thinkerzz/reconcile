require 'will_paginate/array'

class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :create_general_summary, :export_discrepancies]
  before_action :set_reconcile_transaction

  def index
    @summaries = Summary.all
  end

  def new
    @summary             = Summary.new
    @source_options      = DataRow.header.where(file_import_id: @reconcile_transaction.file_imports.source.ids).pluck(:values).compact.flatten.uniq
    @destination_options = DataRow.header.where(file_import_id: @reconcile_transaction.file_imports.destination.ids).pluck(:values).compact.flatten.uniq
  end

  def create
    @summary                          = Summary.new(summary_params)
    @summary.reconcile_transaction_id = @reconcile_transaction.id

    if @summary.save!
      CreateSummaryDetails.perform_now(@summary.id, @reconcile_transaction.id, 'custom')
      redirect_to reconcile_transaction_summary_path(@reconcile_transaction, @summary)
    else
      render :new
    end
  end

  def general_summary
    source_options      = DataRow.header.where(file_import_id: @reconcile_transaction.file_imports.source.ids).pluck(:values).compact.flatten.uniq
    destination_options = DataRow.header.where(file_import_id: @reconcile_transaction.file_imports.destination.ids).pluck(:values).compact.flatten.uniq

    @summary                          = Summary.new
    @summary.source_columns           = source_options
    @summary.destination_columns      = destination_options
    @summary.reconcile_transaction_id = @reconcile_transaction.id

    if @summary.save!
      CreateSummaryDetails.perform_now(@summary.id, @reconcile_transaction.id, 'general')
      redirect_to reconcile_transaction_summary_path(@reconcile_transaction, @summary)
    else
      redirect_to reconcile_transaction_summaries_path(@reconcile_transaction)
    end
  end

  def show
  end

  def export_discrepancies
    respond_to do |format|
      format.html
      format.csv { send_data @summary.discrepancies_to_csv, filename: "discrepancy-summary-#{DateTime.current.strftime("%F-%T")}.csv" }
    end
  end

  private

  def set_summary
    @summary = Summary.find_by(id: params[:id])
  end

  def set_reconcile_transaction
    @reconcile_transaction = ReconcileTransaction.find_by(id: params[:reconcile_transaction_id])
  end

  def summary_params
    params["summary"]["source_columns"]      = params["summary"]["source_columns"].reject(&:blank?)
    params["summary"]["result_columns"]      = params["summary"]["result_columns"].reject(&:blank?)
    params["summary"]["destination_columns"] = params["summary"]["destination_columns"].reject(&:blank?)
    params.require(:summary).permit(source_columns: [], destination_columns: [], result_columns: [])
  end
end
