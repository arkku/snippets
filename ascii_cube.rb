#!/usr/bin/env ruby
# Draws ASCII cubes of almost arbitrary size, in two alternative orientations,
# with an optional grid. This is believed to be quite useless.
#   - Kimmo Kulovesi, January 2010
#
$KCODE = 'utf-8'

def make_box_raw (size,
                  top_fill = '_/', top_edge = '_/', top_side = '\\/',
                  bot_fill = '_\\', bot_edge = '_\\', bot_side = '/\\',
                  space = ' ', slash = '/', backslash = '\\', line = '__')
  # Line
  str = space * size + line * size + "\n"
  # Top side
  box_line = slash + top_fill * (size - 1) + top_fill[/^./] + slash
  1.upto(size) do |row|
    amount_of_space = size - row
    str << space * amount_of_space + ((amount_of_space != 0) ? box_line :
              slash + top_edge * (size - 1) + top_edge[/^./] + slash) +
           top_side * (row - 1) + backslash + "\n"
  end
  # Bottom side
  box_line = backslash + bot_fill * (size - 1) + bot_fill[/^./] + backslash
  size.downto(1) do |row|
    str << space * (size - row) + ((row != 1) ? box_line :
              backslash + bot_edge * (size - 1) + bot_edge[/^./] + backslash) +
           bot_side * (row - 1) + slash + "\n"
  end
  str
end

def make_box_reversed_raw (size,
                  top_fill = '_\\', top_edge = '_\\', top_side = '\\/',
                  bot_fill = '_/', bot_edge = '_/', bot_side = '/\\',
                  space = ' ', slash = '/', backslash = '\\', line = '__')
  # Line
  str = space * size + line * size + "\n"
  # Top side
  box_line = backslash + top_fill * (size - 1) + top_fill[/^./] + backslash
  1.upto(size) do |row|
    amount_of_space = size - row
    str << space * amount_of_space + slash + top_side * (row - 1) +
           ((amount_of_space != 0) ? box_line :
              backslash + top_edge * (size - 1) + top_edge[/^./] + backslash) + "\n"
  end
  # Bottom side
  box_line = slash + bot_fill * (size - 1) + bot_fill[/^./] + slash
  size.downto(1) do |row|
    str << space * (size - row) + backslash + bot_side * (row - 1) + 
           ((row != 1) ? box_line :
              slash + bot_edge * (size - 1) + bot_edge[/^./] + slash) + "\n"
  end
  str
end


def make_box (size, reversed = false, grid = false)
  box = method(reversed ? :make_box_reversed_raw : :make_box_raw)
  if grid
    box.call(size)
  else
    box.call(size, '  ', '__', '  ', '  ', '__', '  ')
  end
end

MAX_SIZE = 10000
size = 2
reversed = false
grid = false
ARGV.each do |arg|
  case arg
  when /^[-]+r/
    reversed = true
  when /^[-]+g/
    grid = true
  when /^[0-9]+/
    size = arg.to_i
    if size < 1 or size > MAX_SIZE
      $stderr.puts "Error: Size must be between 1 and #{MAX_SIZE}, inclusive!"
      exit 1
    end
  else
    $stderr.puts "Warning: Invalid argument \"#{arg}\"."
  end
end
puts make_box(size, reversed, grid)
