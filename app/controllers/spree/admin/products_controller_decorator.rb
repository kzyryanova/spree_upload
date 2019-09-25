module ProductsControllerDecorator
  def upload
    UploadWorker.perform_later(upload_params[:file])
    redirect_to admin_products_path, notice: I18n.t(:products_upload, scope: :products_upload)
  end

  private

  def upload_params
    params.permit(:file)
  end
end

Spree::Admin::ProductsController.prepend ProductsControllerDecorator
