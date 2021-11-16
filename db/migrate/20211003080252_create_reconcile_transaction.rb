class CreateReconcileTransaction < ActiveRecord::Migration[6.0]
  def change
    create_table :reconcile_transactions do |t|
      t.timestamps
    end
  end
end
