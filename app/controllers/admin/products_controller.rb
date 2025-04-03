class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[ show edit update destroy ]

  # GET /admin/products or /admin/products.json
  def index
    @admin_products = Product.all
  end

  # GET /admin/products/1 or /admin/products/1.json
  def show
    @admin_product = Product.find(params[:id])
  end


  # GET /admin/products/new
  def new
    @admin_product = Product.new
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products or /admin/products.json
  def create
    @admin_product = Product.new(admin_product_params)

    respond_to do |format|
      if @admin_product.save
        format.html { redirect_to admin_product_path(@admin_product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @admin_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /admin/products/1 or /admin/products/1.json
  # def update
  #   respond_to do |format|
  #     if @admin_product.update(admin_product_params)
  #       format.html { redirect_to admin_product_path(@admin_product), notice: "Product was successfully updated." }
  #       format.json { render :show, status: :ok, location: @admin_product }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @admin_product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  def update
    @admin_product = Product.find(params[:id])

    # Reject the 'images' key from the parameters and update the product
    if @admin_product.update(admin_product_params.reject { |k| k == "images" })
      # If there are images, attach them to the product
      if admin_product_params["images"]
        admin_product_params["images"].each do |image|
          @admin_product.images.attach(image)
        end
      end

      redirect_to admin_product_path(@admin_product), notice: "Product updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def update
  #   if params[:admin_product] && params[:admin_product][:images].present? && params[:admin_product][:images].any?
  #     # Purge old images if new images are uploaded
  #     @admin_product.images.purge # This removes the existing images

  #     # Attach the new images
  #     params[:admin_product][:images].each do |image|
  #       @admin_product.images.attach(image)
  #     end
  #   end

  #   if @admin_product.update(admin_product_params)
  #     redirect_to admin_product_path(@admin_product), notice: "Product was successfully updated."
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /admin/products/1 or /admin/products/1.json
  def destroy
    @admin_product.destroy!

    respond_to do |format|
      format.html { redirect_to admin_products_path, status: :see_other, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_product
      @admin_product = Product.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def admin_product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :active, images: [])
    end
end
