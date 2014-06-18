require 'gosu'
require_relative 'player'
require_relative 'map'

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 1024

class Main < Gosu::Window
  attr_reader :map

  def initialize
    super(640, 480, false)
    self.caption = "DBZ"
    @sky = Image.new(self, "media/Space.png", true)
    @map = Map.new(self, "media/map.txt")
    @cptn = CptnRuby.new(self, 400, 400)
    @camera_x = @camera_y = 0
  end

  def update
    move_x = 0
    move_x -= 5 if button_down? KbLeft
    move_x += 5 if button_down? KbRight
    @cptn.update(move_x)
    @cptn.collect_gems(@map.gems)
    @camera_x = [[@cptn.x - 320, 0].max, @map.width * 50 - 640].min
    @camera_y = [[@cptn.y - 240, 0].max, @map.height * 50 - 480].min
  end

  def draw
    @sky.draw 0, 0, 0
    translate(-@camera_x, -@camera_y) do
      @map.draw
      @cptn.draw
    end
  end

  def button_down(id)
    if id == KbUp then @cptn.try_to_jump end
    if id == KBEscape then close end
end

Main.new.show
