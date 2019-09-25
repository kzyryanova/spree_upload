FactoryBot.define do
  factory :stock_location, class: 'Spree::StockLocation' do
    name { FFaker::Lorem.word }
  end
end
