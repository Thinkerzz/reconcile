class CreateSummary < ActiveRecord::Migration[6.0]
  def change
    create_table :summaries do |t|
      t.jsonb :detail_data
      t.jsonb :source_columns
      t.jsonb :destination_columns
      t.jsonb :result_columns

      t.integer :summary_type

      t.references :reconcile_transaction, index: true, foreign_key: true

      t.timestamps
    end
  end
end
