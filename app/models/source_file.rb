class SourceFile < ApplicationRecord
  has_paper_trail
  has_one_attached :source

  # has_many :file_imports

  belongs_to :reconcile_transaction
end
