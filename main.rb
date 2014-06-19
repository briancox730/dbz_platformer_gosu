require 'gosu'
require 'rubygems'
require 'pry'
require_relative 'player'
require_relative 'map'
require_relative 'collectiblegem'
include Gosu

module Tiles
  Grass = 0
  Earth = 1
end

class Main < Window
  attr_reader :map

  def initialize
    super(1200, 500, false)
    self.caption = "DBZ"
    @sky = Image.new(self, "media/clouds.jpg", true)
    @map = Map.new(self, "media/map.txt")
    @cptn = CptnRuby.new(self, 500, 100)
    @camera_x = @camera_y = 0
    @sky_x = @sky_y = 0
  end

  def update
    move_x = 0
    move_x -= 5 if button_down? KbA
    move_x += 5 if button_down? KbD
    @cptn.update(move_x)
    @cptn.collect_gems(@map.gems)
    @camera_x = [[@cptn.x - 600, 0].max, @map.width * 50 - 1200].min
    @camera_y = [[@cptn.y - 250, 0].max, @map.height * 50 - 500].min
  end

  def draw
    @sky_x = 0 - (@cptn.x / 20)
    @sky_y = 0
    @sky.draw(@sky_x, @sky_y, 0)
    translate(-@camera_x, -@camera_y) do
      @map.draw
      @cptn.draw
    end
  end

  def button_down(id)
    if id == KbSpace then @cptn.try_to_jump end
    if id == KbJ then @cptn.try_to_slide end
    if id == KbEscape then close end
  end
end

Main.new.show
