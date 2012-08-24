class String
  def possessive
    self + (self[self.length-1] == 's' ? "'" : "'s")
  end
end
