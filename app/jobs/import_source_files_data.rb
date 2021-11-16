require 'roo'

class ImportSourceFilesData < ApplicationJob
  queue_as :default

  def perform(source_file_ids, recon_id)
    source_files = SourceFile.includes(source_attachment: :blob).where(id: source_file_ids)

    source_files.find_each(batch_size: 10000) do |source_file|
      file_import = FileImport.create(reconcile_transaction_id: recon_id, import_type: FileImport.import_types['source'])

      sf_path = ActiveStorage::Blob.service.send(:path_for, source_file.source.key)
      sf_file = Roo::Spreadsheet.open(sf_path, extension: :xlsx)

      count = 0
      data_to_import = []

      @header = []
      sf_file.each_row_streaming do |row|
        row_values = row.map(&:value)

        if count == 0
          h_values = row_values.map { |scv| scv.parameterize(separator: '_') }
          @header << h_values
          data_to_import << set_header(h_values, 'header', file_import.id)
        else
          data_to_import << set_row(@header.flatten.zip(row_values).to_h, 'row', file_import.id)
        end

        count += 1
      end

      DataRow.import data_to_import, recursive: true
    end
  end

  private

    def set_header(header_data, type, file_import_id)
      {values: header_data, row_type: DataRow.row_types['header'], file_import_id: file_import_id}
    end

    def set_row(row_data, type, file_import_id)
      {values: row_data, row_type: DataRow.row_types['row'], file_import_id: file_import_id}
    end
end
