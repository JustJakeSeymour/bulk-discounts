class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
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
  
  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end
  
  def update
    bulk_discount = BulkDiscount.find(params[:id])

    if bulk_discount.update!(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(bulk_discount.merchant_id, bulk_discount.id)
      flash[:alert] = "Bulk discount created."
    else
      flash[:alert] = "Fields cannot be blank"
      render :edit
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
