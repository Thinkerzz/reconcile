class CreateSummaryDetails < ApplicationJob
  queue_as :default

  def perform(summary_id, reconsile_transaction_id, summary_type)
    @summary               = Summary.find(summary_id)
    @reconsile_transaction = ReconcileTransaction.includes(:file_imports).find(reconsile_transaction_id)

    @source_data, @destination_data, @stats = [], [], {}

    @reconsile_transaction.file_imports.each do |file_import|
      @file_import = file_import

      @row_data = DataRow.row.where(file_import_id: @file_import.id).pluck(:values)

      set_processing_data
    end

    ###########################Calculating Reconcile Stats############################
    set_reconcile_stats

    ###########################Save Stats In System############################
    @summary.update(detail_data: @stats, summary_type: summary_type)
  end

  private

  def set_processing_data
    if @file_import.source?
      required_keys = (@summary.source_columns + @summary.result_columns)
      @row_data     = filter_row_data_with_required_key(@row_data, required_keys).flatten

      @source_data << @row_data.flatten
      @source_data = @source_data.flatten
    elsif @file_import.destination?
      required_keys = (@summary.destination_columns + @summary.result_columns)
      @row_data     = filter_row_data_with_required_key(@row_data, required_keys).flatten

      @destination_data << @row_data.flatten
      @destination_data = @destination_data.flatten
    end
  end

  def set_reconcile_stats
    ############################Init Stats############################
    @stats['source']      = {}
    @stats['destination'] = {}
    @stats['general']     = {}

    ############################Set Source Stats############################
    @stats['source']['total-count']  = @source_data.count
    @stats['source']['total-amount'] = 0

    @source_data.each do |sd|
      @stats['source']['total-amount'] = @stats['source']['total-amount'] + sd['amount']
    end

    ############################Set Destination Stats############################
    @stats['destination']['total-count']  = @destination_data.count
    @stats['destination']['total-amount'] = 0

    @destination_data.each do |dd|
      @stats['destination']['total-amount'] = @stats['destination']['total-amount'] + dd['amount']
    end

    ############################Set General Stats############################
    @stats['general']['total-source-files']             = @reconsile_transaction.file_imports.source.count
    @stats['general']['total-destination-files']        = @reconsile_transaction.file_imports.destination.count
    @stats['general']['reconcile-amount-discrepancies'] = (@stats['source']['total-amount'] == @stats['destination']['total-amount']) ? 'No' : 'Yes'

    @stats['general']['reconcile-discrepancies'] = []
    @stats['general']['reconcile-discrepancies'] << (@source_data - @destination_data)
    @stats['general']['reconcile-discrepancies'] = @stats['general']['reconcile-discrepancies'].flatten
  end

  def filter_row_data_with_required_key(row_data, required_keys)
    filtered_new_data = []
    row_data.each do |rd|
      filtered_new_data <<  {}.tap do |hsh|
                              required_keys.each { |rk| hsh[rk] = rd[rk] }
                            end
    end
    return filtered_new_data.flatten
  end
end
