require 'gosu'
require_relative 'player'

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 1024

class Main < Gosu::Window
  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "DBZ"

    @player = Player.new(self)
  end

  def update

  end

  def draw

  end
end

Main.new.show
