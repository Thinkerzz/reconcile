class Summary < ApplicationRecord
  has_paper_trail

  belongs_to :reconcile_transaction

  enum summary_type: [:general, :custom]

  def discrepancies_to_csv
    discrepancies_data = self.detail_data['general']['reconcile-discrepancies']
    attributes = discrepancies_data.map(&:keys).flatten.uniq

    CSV.generate(headers: true) do |csv|
      csv << attributes

      discrepancies_data.present? && discrepancies_data.each do |discrepancy|
        csv << attributes.map{ |attr| discrepancy[attr] }
      end
    end
  end
end
