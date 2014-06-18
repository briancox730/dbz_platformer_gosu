class CollectibleGem
  attr_reader :x, :y

  def initialize(image, x, y)
    @image = image
    @x, @y = x, y
  end

  def draw
    @image.draw_rot(@x, @y, 0, 25 * Math.sin(milliseconds / 133.7))
  end
end
