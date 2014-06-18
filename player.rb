class CptnRuby
  attr_reader :x, :y

  def initialize(window, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = 0
    @map = window.map
    @standing, @walk1, @walk2, @jump =
      *Image.load_tiles(window, "media/CptnRuby.png", 50, 50, false)
    @cur_image = @standing
  end

  def draw
    if @dir == :left then
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, 0, factor, 1.0)
  end

  def would_fit(offs_x, offs_y)
    not @map.solid?(@x + offs_x, y + offs_y) and
      not @map.solid(@x + offs_x, @y + offs_y - 45)
  end

  def update(move_x)
    if move_x == 0
      @cur_image = @standing
    else
      @cur_image = (milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    end
    if @vy < 0
      @cur_image = @jump
    end

    if move_x > 0 then
      @dir = :right
      move_x.times { if would_fit(1,0) then @x += 1 end }
    end
    if move_x < 0 then
      @dir = :left
      (-move_x).times { if would_fit(-1, 0) then @x -= 1 end }
    end
    @vy += 1
    if @vy > 0 then
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0 then
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
  end

  def try_to_jump
    if @map.solid?(@x, @y + 1) then
      @vy = -20
    end
  end

  def collect_gems(gems)
    gems.reject! do |c|
      (c.x - @x).abs < 50 and (c.y - @y).abs < 50
    end
  end
end
