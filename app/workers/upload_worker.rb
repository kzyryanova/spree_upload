require 'csv'

class UploadWorker < ActiveJob::Base
  queue_as :default

  def perform(uploaded_file)
    CSV.foreach(uploaded_file, headers: true, skip_blanks: true, col_sep: ";" ) do |row|
      unless row.fields.compact.blank?
        ProductWorker.perform_later(row.fields.compact)
      end
    end
  end
end
