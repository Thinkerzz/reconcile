class ProcessReconcileTransactionData < ApplicationJob
  queue_as :default

  def perform(rec_tran_id)
    reconcile_transaction = ReconcileTransaction.includes(:source_files, :destination_files).find_by(id: rec_tran_id)

    ImportSourceFilesData.perform_now(reconcile_transaction.source_files.ids, reconcile_transaction.id)
    ImportDestinationFilesData.perform_now(reconcile_transaction.destination_files.ids, reconcile_transaction.id)
  end
end
