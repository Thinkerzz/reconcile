class CreateFileImport < ActiveRecord::Migration[6.0]
  def change
    create_table :file_imports do |t|
      t.integer    :import_type
      t.references :reconcile_transaction, index: true, foreign_key: true

      t.timestamps
    end
  end
end
