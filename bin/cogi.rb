# Encoding: UTF-8

$:<<'lib'

require 'cogi'

class Welcome < Cogi::GameWindow
  def initialize
    super(
      width: 1024,
      height: 768,
      world: {
        width: 50,
        height: 50
      }
    )
  end
end

Welcome.new.show if __FILE__ == $0
