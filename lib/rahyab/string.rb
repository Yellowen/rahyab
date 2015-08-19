# coding: utf-8

class String
  # Return String in HEX
  def to_h
    codepoints = self.codepoints
    codepoints = codepoints.map {  |n| format('%04x', n) }
    return codepoints.join
  end
end
