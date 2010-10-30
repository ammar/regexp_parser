module CType
  Digit   = ('0'..'9').to_a.freeze
  Lower   = ('a'..'z').to_a.freeze
  Upper   = ('A'..'Z').to_a.freeze

  Alpha   = [Lower, Upper].flatten.freeze
  Alnum   = [Alpha, Digit].flatten.freeze
  Word    = [Alnum, '_'].flatten.freeze

  Blank   = [' ', "\t"].freeze
  Space   = [" ", "\t", "\r", "\n", "\v", "\f"].freeze

  Cntrl   = ( 0..31 ).to_a.map {|c| c.chr}.freeze
  Graph   = (33..126).to_a.map {|c| c.chr}.freeze
  Print   = (32..126).to_a.map {|c| c.chr}.freeze
  ASCII   = ( 0..127).to_a.map {|c| c.chr}.freeze

  Punct   = [
    ('!'..'/').to_a,
    (':'..'@').to_a,
    ('['..'`').to_a,
    ('{'..'~').to_a
  ].flatten.freeze

  XDigit  = [
    ('a'..'f').to_a,
    ('A'..'F').to_a,
    ('0'..'9').to_a
  ].flatten.freeze

  def self.alnum?(c);   c =~ /[[:alnum:]]/  ? true : false end 
  def self.alpha?(c);   c =~ /[[:alpha:]]/  ? true : false end 
  def self.blank?(c);   c =~ /[[:blank:]]/  ? true : false end 
  def self.cntrl?(c);   c =~ /[[:cntrl:]]/  ? true : false end 
  def self.digit?(c);   c =~ /[[:digit:]]/  ? true : false end 
  def self.graph?(c);   c =~ /[[:graph:]]/  ? true : false end 
  def self.lower?(c);   c =~ /[[:lower:]]/  ? true : false end 
  def self.print?(c);   c =~ /[[:print:]]/  ? true : false end 
  def self.punct?(c);   c =~ /[[:punct:]]/  ? true : false end 
  def self.space?(c);   c =~ /[[:space:]]/  ? true : false end 
  def self.upper?(c);   c =~ /[[:upper:]]/  ? true : false end 
  def self.xdigit?(c);  c =~ /[[:xdigit:]]/ ? true : false end 
  def self.word?(c);    c =~ /[[:alnum:]_]/ ? true : false end 
  def self.ascii?(c);   c =~ /[\x00-\x7F]/  ? true : false end 
end
