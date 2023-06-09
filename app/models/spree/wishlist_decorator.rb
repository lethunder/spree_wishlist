module Spree
  module WishlistDecorator
    def include?(variant_id)
      wished_items.map(&:variant_id).include? variant_id.to_i
    end
  end
end

::Spree::Wishlist.prepend Spree::WishlistDecorator if ::Spree::Wishlist.included_modules.exclude?(Spree::WishlistDecorator)