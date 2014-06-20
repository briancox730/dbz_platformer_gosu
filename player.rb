class CptnRuby
  attr_reader :x, :y

  def initialize(window, x, y)
    @x, @y = x, y
    @dir = :left
    @vy = @vx = 0
    @map = window.map
    @bowser_slide = Image.load_tiles(window, "media/bowserSlide.png", 70, 70, false)
    @bowser_run = Image.load_tiles(window, "media/bowserRun.png", 70, 70, false)
    @bowser_jump = Image.load_tiles(window, "media/bowserJump.png", 72, 70, false)
    @standing = Image.new(window, "media/bowserStand.png", false)
    # @standing, @walk1, @walk2, @jump =
      # *Image.load_tiles(window, "media/CptnRuby.png", 50, 50, false)
    @cur_image = @standing
  end

  def draw
    if @dir == :left then
      offs_x = -35
      factor = 1.0
    else
      offs_x = 35
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 69, 0, factor, 1.0)
  end

  def would_fit(offs_x, offs_y)
    not @map.solid?(@x + offs_x, y + offs_y) and
      not @map.solid?(@x + offs_x, @y + offs_y - 69)
  end

  def update(move_x)
    if move_x == 0
      @cur_image = @standing
    else
      @cur_image = @bowser_run[((milliseconds / 100) % @bowser_run.size)]
    end
    if @vy < 0
      @cur_image = @bowser_jump[((milliseconds / 200) % @bowser_jump.size)]
    end
    if @vx < 0
      @cur_image = @bowser_slide[((milliseconds / 200) % @bowser_slide.size)]
    end

    if move_x > 0 then
      @dir = :right
      move_x.times { if would_fit(35,0) then @x += 1 end }
    end
    if move_x < 0 then
      @dir = :left
      (-move_x).times { if would_fit(-35, 0) then @x -= 1 end }
    end
    @vy += 1
    if @vy > 0 then
      @vy.times { if would_fit(0, 1) then @y += 1 else @vy = 0 end }
    end
    if @vy < 0 then
      (-@vy).times { if would_fit(0, -1) then @y -= 1 else @vy = 0 end }
    end
    @vx += 1
    if @vx < 0 && @dir == :right then
      (-@vx).times { if would_fit(1, 0) then @x += 1 else @vx = 0 end }
    end
    if @vx < 0 && @dir == :left then
      (-@vx).times { if would_fit(-1, 0) then @x -= 1 else @vx = 0 end }
    end
  end

  def try_to_jump
    if @map.solid?(@x, @y + 1) then
      @vy = -20
    end
  end

  def try_to_slide
    if @dir == :left && would_fit(-1, 0) || @dir == :right && would_fit(1, 0)
      if @map.solid?(@x, @y + 1)
        @vx = -20
      end
    end
  end

  def collect_gems(gems)
    gems.reject! do |c|
      (c.x - @x).abs < 50 and (c.y - @y).abs < 50
    end
  end
end
