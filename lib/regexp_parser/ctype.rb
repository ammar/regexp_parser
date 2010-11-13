# defines character type constants (as arrays) and methods that test
# whether a given character belongs in one of them.
module CType
  Digit   = ('0'..'9').to_a.freeze
  Lower   = ('a'..'z').to_a.freeze
  Upper   = ('A'..'Z').to_a.freeze

  Alpha   = [Lower, Upper].flatten.freeze
  Alnum   = [Alpha, Digit].flatten.freeze
  Word    = [Alnum, '_'].flatten.freeze

  Blank   = [' ', "\t"].freeze
  Space   = [" ", "\t", "\r", "\n", "\v", "\f"].freeze

  Cntrl   = ( 0..31 ).map {|c| c.chr}.freeze
  Graph   = (33..126).map {|c| c.chr}.freeze
  Print   = (32..126).map {|c| c.chr}.freeze
  ASCII   = ( 0..127).map {|c| c.chr}.freeze

  Punct   = [
    ('!'..'/').to_a,
    (':'..'@').to_a,
    ('['..'`').to_a,
    ('{'..'~').to_a
  ].flatten.freeze

  XDigit  = [
    Digit,
    ('a'..'f').to_a,
    ('A'..'F').to_a
  ].flatten.freeze

  def self.alnum?(c);  Alnum.include?(c)  end 
  def self.alpha?(c);  Alpha.include?(c)  end 
  def self.blank?(c);  Blank.include?(c)  end 
  def self.cntrl?(c);  Cntrl.include?(c)  end 
  def self.digit?(c);  Digit.include?(c)  end 
  def self.graph?(c);  Graph.include?(c)  end 
  def self.lower?(c);  Lower.include?(c)  end 
  def self.print?(c);  Print.include?(c)  end 
  def self.punct?(c);  Punct.include?(c)  end 
  def self.space?(c);  Space.include?(c)  end 
  def self.upper?(c);  Upper.include?(c)  end 
  def self.xdigit?(c); XDigit.include?(c) end 

  def self.word?(c);   Word.include?(c)   end 
  def self.ascii?(c);  ASCII.include?(c)  end 
end
