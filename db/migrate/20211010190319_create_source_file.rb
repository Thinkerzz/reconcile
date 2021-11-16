class CreateSourceFile < ActiveRecord::Migration[6.0]
  def change
    create_table :source_files do |t|
      t.references :reconcile_transaction, index: true, foreign_key: true

      t.timestamps
    end
  end
end
