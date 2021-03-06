#this is the game of programming!
#objectives of the game:
# => do random tasks (lawmowing?!) by making and coding algorithms.

require 'ruby-processing'
load 'lawn.rb'
load 'text.rb'
load 'iointerface.rb'

class Animator < Processing::App

def setup
  smooth
  puts "\n\nSTART_OF_PROGRUM\n--------------------"
  @size = 15
  @offset = 30
  @lawn = Lawn.new @size, @offset
  @text = TextIn.new 10, 220, self
  @io = IoInterface.new @lawn
  @io.clearfiles
  ellipse_mode CORNER
  background 200
  
  @font = $app.create_font("Univers45.vlw", 66)
  text_font(@font, 14)
  
  @lawn.filllawn(10,12) ############################
  fill(120,120,120)
  @lawn.textlawn
  #@io.output! @lawn.text
  
  @io.output! @lawn.text
  #@io.input!
  #puts @io.read_data
  @lawn.cut
end

def draw
  background 120
  #text("Tools:\n@lawn.lawn is an array of:\n'W' <--grass\n'O' <--rocks\n'w' <--cut-grass\n\nHave Fun!",190,20,160,200)
  text("\"to_script.txt\" is what you should read.\n\"to_game.txt\" is what you should write to.\n\nn,s,e,w: commands to move lawnmower.",190,20,160,200) if !@lawn.victory
  text("VICTORY! YES!",190,20,160,200) if @lawn.victory
  fill 200
  #@lawn.cut
  @lawn.printlawn
  @text.drawtext
  
  @io.input! if !@lawn.victory 
  #puts @io.read_data
  @lawn.text_input @io.read_data
end

def key_pressed
  @lawn.key_pressed key
  @text.key_pressed key
  #puts @text.buff
  #@lawn.lawn.each {|a| a = 'w '}
end

def mouse_pressed
  @lawn.mouse_pressed(mouse_x, mouse_y)
end

def mouse_released
  @lawn.mouse_released(mouse_x, mouse_y)
end

def run te
  eval te
  rescue SyntaxError
    puts "SyntaxError *shrug*"
  rescue NameError
    puts "NameError *shrug*"
  rescue NoMethodError
    puts "NoMethodError *shrug*"
  rescue Exception
    puts "you made an error"
end

end

Animator.new :title => "Animator", :width => 350, :height => 350