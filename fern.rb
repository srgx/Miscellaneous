#!/usr/bin/env ruby

require 'ruby2d'

set background: 'white'
set fullscreen: true

set width: 1920
set height: 1080
set viewport_width: 1920
set viewport_height: 1080

class Point
  attr_accessor :x, :y
  def initialize(x,y)
    @x=x
    @y=y
  end
end

def tr1(p)
  x=-0.15*p.x+0.28*p.y
  y=0.26*p.x+0.24*p.y+0.44
  return Point.new(x,y)
end

def tr2(p)
  x=0.2*p.x-0.26*p.y
  y=0.23*p.x+0.22*p.y+1.6
  return Point.new(x,y)
end

def tr3(p)
  x=0.85*p.x+0.04*p.y
  y=-0.04*p.x+0.85*p.y+1.6
  return Point.new(x,y)
end

def tr4(p)
  x=0
  y=0.16*p.y
  return Point.new(x,y)
end


last = Point.new(0,0)

0.upto(20000) do |i|
  if(i>10000)
    c="red"
  else
    c="blue"
  end
  Square.new(
    x: last.x*90+600, y: last.y*95+20,
    size: 2,
    color: c,
    z: 10
  )
  type=rand
  if(type<0.1)
    last = tr4(last)
  elsif(type<0.86)
    last = tr3(last)
  elsif(type<0.93)
    last = tr2(last)
  else
    last = tr1(last)
  end
end


show
