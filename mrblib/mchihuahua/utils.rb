class String
  def oreno_unicode_decode
    self.gsub!(/\\u([0-9a-fA-F]{4})/) { [$1.hex].pack("U") }
  end
end
