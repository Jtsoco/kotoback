require 'natto'

class NattoService
  def wordify(text)
    nm = Natto::MeCab.new
    nm.parse(text)
  end

natto = NattoService.new
natto.wordify('')
end
