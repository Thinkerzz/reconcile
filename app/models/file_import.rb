class FileImport < ApplicationRecord
  has_many :data_rows, dependent: :destroy

  belongs_to :reconcile_transaction

  enum import_type: [:source, :destination]
end
