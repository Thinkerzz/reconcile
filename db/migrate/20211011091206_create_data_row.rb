class CreateDataRow < ActiveRecord::Migration[6.0]
  def change
    create_table :data_rows do |t|
      t.jsonb      :values
      t.integer    :row_type
      t.references :file_import, index: true, foreign_key: true

      t.timestamps
    end
  end
end
