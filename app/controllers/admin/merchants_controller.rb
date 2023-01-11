class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    @top_merchants = Merchant.top_five_by_revenue
  end

  def show
    @merchant = Merchant.find(params[:id])
  end
  
  def new
    @merchant = Merchant.new
  end
  
  def create
    merchant = Merchant.new(merchant_params)
    
    if merchant.save
      redirect_to "/admin/merchants"
    end
  end
  
  def edit
    @merchant = Merchant.find(params[:id])
  end
  
  def update
    merchant = Merchant.find(params[:id])
    if params[:status]
      merchant.update(status: params[:status])
      redirect_to admin_merchants_path
      
    elsif merchant.update!(merchant_params)
      redirect_to admin_merchant_path
      flash[:notice] = "#{merchant.name} Has Been Updated!"
      
    else
      redirect_to admin_merchant_path
    end
  end
  
  private
  
  def merchant_params
    params.require(:merchant).permit(:id, :name)
  end
end