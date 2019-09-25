require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe ProductWorker, type: :job do
  include ActiveJob::TestHelper

  let!(:stock_location) { FactoryBot.create(:stock_location) }

  let(:data_row) do
    [
      "Ruby on Rails Bag4",
      "Animi officia aut amet molestiae atque excepturi.",
      "22,99",
      "2017-12-04T14:55:22.913Z",
      "ruby-on-rails-bag4",
      "15",
      "Bags"
    ]
  end

  it 'should create Product' do
    ActiveJob::Base.queue_adapter = :test

    Spree::Product.delete_all

    expect do
      subject.perform(data_row)
    end.to change { Spree::Product.count }.by(1)
  end
end
