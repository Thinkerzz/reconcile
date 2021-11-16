class DataRow < ApplicationRecord
  belongs_to :file_import

  enum row_type: [:header, :row]
end
