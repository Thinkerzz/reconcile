class DestinationFile < ApplicationRecord
  has_paper_trail
  has_one_attached :destination

  # has_many :file_imports

  belongs_to :reconcile_transaction
end
