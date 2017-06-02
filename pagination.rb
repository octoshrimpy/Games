class Array
  def page(pg, options={})
    per = options[:per] || 5
    offset = options[:offset] || 0
    first_idx = offset + ((pg-1) * per)
    last_idx =  offset + ((pg * per)-1)
    self[first_idx..last_idx]
  end
end
