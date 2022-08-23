#!/usr/bin/rexx

/* Rexx Graphics */

/* ------------------------------------------------------------------- */

rectangleWidth = 70
rectangleHeight = 40
rectangleX = 180
rectangleY = 30
rectangleDistance = 80

/* ------------------------------------------------------------------- */

circleX = 100
circleY = 50
radius = 20
circleDistance = 50

/* ------------------------------------------------------------------- */

lineX = 48
lineDistance = 25

/* ------------------------------------------------------------------- */

/* Red line */
call setColor red
call draw 'line', lineX, circleY - radius,
                  lineX + lineDistance, circleY + radius

/* Circle */
call setColor black
call draw 'circle', circleX, circleY, radius

/* Blue circle */
call setColor blue
call draw 'ccircle', circleX + circleDistance, circleY, radius

/* Rectangle */
call setColor black
call draw 'rectangle', rectangleX, rectangleY,
                       rectangleWidth, rectangleHeight

/* Rectangle */
call setColor purple
call draw 'crectangle', rectangleX + rectangleDistance, rectangleY,
                        rectangleWidth, rectangleHeight

exit 0

/* ------------------------------------------------------------------- */

setColor: procedure
  parse arg c
  say 'c' c
  return

draw: procedure
  parse arg type, arg1, arg2, arg3, arg4

  select
    when type = 'line' then
      t = 'l'
    when type = 'rectangle' then
      t = 'r'
    when type = 'crectangle' then
      t = 'f'
    when type = 'circle' then
      t = 'd'
    when type = 'ccircle' then
      t = 'g'
    otherwise
      t = ''
  end

  say t arg1 arg2 arg3 arg4

  return

/* ------------------------------------------------------------------- */
  

