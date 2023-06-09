module Spree
  module WishlistDecorator
    def self.prepended(base)
      base.belongs_to :store, class_name: 'Spree::Store', optional: true
    end
    def include?(variant_id)
      wished_items.map(&:variant_id).include? variant_id.to_i
    end
  end
end

::Spree::Wishlist.prepend Spree::WishlistDecorator