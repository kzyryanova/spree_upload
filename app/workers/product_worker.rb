class ProductWorker < ActiveJob::Base
  queue_as :default

  DEFAULT_SHIPPING_CATEGORY_ID = 1

  def perform(row)
    name, description, price, available_on, slug, stock_total, category, shipping_category_id = row
    shipping_category_id = shipping_category_id || DEFAULT_SHIPPING_CATEGORY_ID

    taxonomy_id = ::Spree::Taxonomy.find_by_name(category).try(:id)

    return if Spree::Product.find_by_slug(slug)

    product = ::Spree::Product.create(
      name: name,
      description: description,
      available_on: available_on,
      slug: slug,
      price: price.gsub(',', '.'),
      shipping_category_id: shipping_category_id,
      taxon_ids: [taxonomy_id]
    )

    stock_item = product.master.stock_items.first_or_initialize
    stock_item.count_on_hand = stock_total
    stock_item.save!
  end
end
