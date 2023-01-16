class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)

    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
      flash[:alert] = "Bulk discount created."
    else
      flash[:alert] = "Fields cannot be blank"
      render :new
    end
  end
  
  def destroy
    BulkDiscount.delete(params[:id])

    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percent_discount, :quantity_threshold)
  end
end
