class Spree::WishlistsController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  helper 'spree/products'

  before_action :find_wishlist, only: [:destroy, :show, :update, :edit, :add_item, :remove_item]

  respond_to :html
  respond_to :js, only: :update

  def index
    @wishlists = spree_current_user.wishlists
    respond_with(@wishlist)
  end

  def edit
    respond_with(@wishlist)
  end

  def update
    @wishlist.update wishlist_attributes
    respond_with(@wishlist)
  end

  def show
    respond_with(@wishlist)
  end

  def default
    @wishlist = spree_current_user.wishlist
    respond_with(@wishlist) do |format|
      format.html { render :show }
    end
  end


  def add_item
    authorize! :create, Spree::WishedItem

    if @wishlist.wished_items.present? && @wishlist.wished_items.detect { |wv| wv.variant_id.to_s == params[:variant_id].to_s }.present?
      @wished_item = @wishlist.wished_items.detect { |wi| wi.variant_id.to_s == params[:variant_id].to_s }
      @wished_item.quantity = params[:quantity]
    else
      @wished_item = Spree::WishedItem.new(params.permit(:quantity, :variant_id))
      @wished_item.wishlist = @wishlist
      @wished_item.save
    end
    render partial: "spree/products/wishlist_form", locals: {product: @wished_item.product}, layout: false, status: 200
  end

  def remove_item
    wished_item = @wishlist.wished_items.find_by(variant_id: params[:variant_id])
    authorize! :destroy, wished_item

    wished_item.destroy
    if params["view"]
      render partial: "spree/orders/wishlists", layout: false, status: 200
    else
      render partial: "spree/products/wishlist_form", locals: {product: wished_item.product}, layout: false, status: 200
    end
  end

  private
  # Isolate this method so it can be overwritten
  def find_wishlist
    @wishlist = spree_current_user.wishlist
  end
end
