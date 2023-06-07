Spree::Wishlist.class_eval do
  def include?(variant_id)
    wished_items.map(&:variant_id).include? variant_id.to_i
  end
end
