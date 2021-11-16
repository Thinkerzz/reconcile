class ReconcileTransaction < ApplicationRecord
  has_paper_trail

  has_many :summaries, dependent: :destroy
  has_many :file_imports, dependent: :destroy

  has_many :source_files, dependent: :destroy
  accepts_nested_attributes_for :source_files, reject_if: :all_blank, allow_destroy: true

  has_many :destination_files, dependent: :destroy
  accepts_nested_attributes_for :destination_files, reject_if: :all_blank, allow_destroy: true
end
