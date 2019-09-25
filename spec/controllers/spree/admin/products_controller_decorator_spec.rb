require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe Spree::Admin::ProductsController do
  stub_authorization!
  render_views

  it 'should enqueue an UploadWorker job' do
    ActiveJob::Base.queue_adapter = :test

    file = fixture_file_upload("files/sample.csv", 'text/csv')

    expect do
      post :upload, params: { file: file.tempfile.path }
    end.to have_enqueued_job(UploadWorker)

    response.should redirect_to '/admin/products'
  end
end
