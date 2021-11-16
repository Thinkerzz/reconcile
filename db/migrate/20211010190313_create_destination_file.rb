class CreateDestinationFile < ActiveRecord::Migration[6.0]
  def change
    create_table :destination_files do |t|
      t.references :reconcile_transaction, index: true, foreign_key: true

      t.timestamps
    end
  end
end
