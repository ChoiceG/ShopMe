class ProductsController < ApplicationController
  # products_controller.rb
  def show
    @product = Product.find(params[:id])

    # Adding images URLs to product data
    @product_json = {
      id: @product.id,
      name: @product.name,
      price: @product.price,
      description: @product.description,
      images: @product.images.map { |img| url_for(img) }  # Get the image URL for each image
    }.to_json
  end
end
