require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe UploadWorker, type: :job do
  include ActiveJob::TestHelper

  it 'should enqueue ProductWorker job' do
    ActiveJob::Base.queue_adapter = :test
    file = fixture_file_upload("files/sample.csv", 'text/csv')

    expect do
      subject.perform(file.tempfile.path)
    end.to have_enqueued_job(ProductWorker).at_least(3).times
  end
end
