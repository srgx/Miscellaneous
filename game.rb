#!/usr/bin/env ruby

require 'ruby2d'

set background: 'white'
set fullscreen: true

set width: 1920
set height: 1080
set viewport_width: 1920
set viewport_height: 1080

class Cell
  attr_reader :state

  def initialize(state,posX,posY)
    @image = Square.new(
      x: posX, y: posY,
      size:10,
      color: 'black',
      z: 10
    )
    @state = state
    @future_state = state
  end

  def reset
    @state = 0
    @future_state = 0
  end

  def live
    @future_state = 1
  end

  def die
    @future_state = 0
  end

  def is_dead
    return @state.zero?
  end

  def is_alive
    return @state==1
  end

  def update
    @state = @future_state
    @image.color = @state.zero? ? 'black' : 'red'
  end

  def show
    print @state
  end

end

SPACE = 10


class Cells
  def initialize(size)
    @arr, @size = [], size
    y = 200
    @size.times do
      row = []
      x = 600
      @size.times do
        row << Cell.new(rand(2),x,y)
        x += SPACE
      end
      @arr << row
      y += SPACE
    end
  end

  def live(x,y)
    @arr[x][y].live
  end

  def reset
    @arr.each do |row|
      row.each do |cell|
        cell.reset
      end
    end
  end

  def show
    @arr.each do |row|
      row.each do |cell|
        cell.show
        print ' '
      end
      puts
    end
  end

  def neighbours(y,x)
    sum = 0

    sum += @arr.dig(y-1,x-1)&.state.to_i
    sum += @arr.dig(y-1,x)&.state.to_i
    sum += @arr.dig(y-1,x+1)&.state.to_i

    sum += @arr.dig(y,x-1)&.state.to_i
    sum += @arr.dig(y,x+1)&.state.to_i

    sum += @arr.dig(y+1,x-1)&.state.to_i
    sum += @arr.dig(y+1,x)&.state.to_i
    sum += @arr.dig(y+1,x+1)&.state.to_i

    return sum
  end

  # set future states
  def prepare
    for y in 0...@size
      for x in 0...@size

        if(@arr[y][x].is_dead&&neighbours(y,x)==3)
          @arr[y][x].live
        elsif(@arr[y][x].is_alive&&(![2,3].include?(neighbours(y,x))))
          @arr[y][x].die
        end

      end
    end
  end

  # update cells using future states
  def update
    @arr.each do |row|
      row.each { |cell| cell.update }
    end
  end

end


cells = Cells.new(50)

tick=1
update do
  if tick % 3 == 0
    cells.prepare
    cells.update
  end
  tick += 1
  if(tick>5000)
    raise "END"
  end
end

show
