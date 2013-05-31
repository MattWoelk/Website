#current problem:
# wWO
# WOW
# OWW  <--it considers it able to reach the
#         beginning when the center one is placed
#         because some of the stuff around it can.
#         this is a problem.

#Idea to fix it:
#check only nsew directions, 
#and check only if they are grass
# WWWW
# WOxW  :place 0
# WO0x  :check x spots recursively
# WWxW  :ALL need to lead to the origin!

class Lawn
  attr_accessor :lawn, :dudex, :dudey, :victory
  def initialize size, offset
    @lawn = [] #'W ','O ',or 'w '
    @size = size
    @offset = offset
    @dudex = 0
    @dudey = 0
    @victory = false
    @vic_button = [@offset + 30, @offset + 30, 35] #x,y,r
    @fill = [50, 50, 10]
    @recur_check = [] #true if it's been checked over
    #$app.ellipse_mode CORNER
  end
  
  def filllawn(x,y)
    x.times do |a|
      @lawn[a] = []
      y.times do |b|
        @lawn[a] << 'W'
      end
    end
    deploy_rock_herd 50 ####MAKE SURE IT IS NOT AN INFINITE LOOP
  end
  
  def deploy_rock_herd num
    num_left = num
    pickable = true
    #pick a random position in the array and check to see if you can put a rock there
    while num_left > 0
      puts "Time To Rock!"
      x = (rand*@lawn.length).floor
      y = (rand*@lawn[0].length).floor
      puts "rnd: #{x}, #{y}."
      @lawn[x][y] = 'O'
      
      #set a rock, and see if every grass around it can still get to the start
      #not in that order..
      if x - 1 >= 0 
        #000
        #xO0 <-- check at x
        #000
        set_recur
        pickable = false if !path_to_start? x-1, y
        puts "  pickable for x-1,y is #{pickable}."
      end
      if y - 1 >= 0
        #0x0
        #0O0 <--check at x
        #000
        set_recur
        pickable = false if !path_to_start? x, y-1
        puts "  pickable for x,y-1 is #{pickable}."
      end
      if x - 1 >= 0 && y - 1 >= 0
        #x00
        #0O0 <--check at x
        #000
        set_recur
        pickable = false if !path_to_start? x-1, y-1
        puts "  pickable for x-1,y-1 is #{pickable}."
      end
      if x + 1 < @lawn.length 
        #000
        #0Ox <-- check at x
        #000
        set_recur
        pickable = false if !path_to_start? x+1, y
        puts "  pickable for x+1,y is #{pickable}."
      end
      if y + 1 < @lawn[0].length
        #000
        #0O0 <--check at x
        #0x0
        set_recur
        pickable = false if !path_to_start? x, y+1
        puts "  pickable for x,y+1 is #{pickable}."
      end
      if x + 1 < @lawn.length && y + 1 < @lawn[0].length
        #000
        #0O0 <--check at x
        #00x
        set_recur
        pickable = false if !path_to_start? x+1, y+1
        puts "  pickable for x+1,y+1 is #{pickable}."
      end
      if x + 1 < @lawn.length && y - 1 >= 0
        #00x
        #0O0 <--check at x
        #000
        set_recur
        pickable = false if !path_to_start? x+1, y-1
        puts "  pickable for x+1,y-1 is #{pickable}."
      end
      if x - 1 >= 0 && y + 1 < @lawn[0].length
        #000
        #0O0 <--check at x
        #x00
        set_recur
        pickable = false if !path_to_start? x-1, y+1
        puts "  pickable for x-1,y+1 is #{pickable}."
      end
      ##############################################
      if pickable
        #do nothing, it's already a rock
      else
        @lawn[x][y] = 'W'
      end
      num_left -= 1
    end #end while
  end
  
  def set_recur
    @recur_check = []
    @lawn.length.times {|i| @recur_check << []}
    @recur_check.each {|a| @lawn[0].length.times{|b| a << false}}
    #we have just made a 2-dim array of falses
  end
  
  def path_to_start? x, y
    #this is a recursive method used to find out if @lawn[x][y] has a direct lawn route to the starting point (0,0)
    #Base Case:
    @recur_check[x][y] = true
    puts "checking: #{x}, #{y}."
    
    good = true
    if x == 0 && y == 0
      puts "AT ORIGIN"
      textlawn
      if (@lawn[x][y] <=> 'O') != 0
        return true
      else
        return false
      end
    end
    
    if x - 1 >= 0
      a = path_to_start? x-1, y-1 if !@recur_check[x-1][y-1] && y - 1 >= 0 && (@lawn[x-1][y-1] <=> 'O') != 0
      b = path_to_start? x-1, y+1 if !@recur_check[x-1][y+1] && y + 1 < @lawn[0].length && (@lawn[x-1][y+1] <=> 'O') != 0
      c = path_to_start? x-1, y   if !@recur_check[x-1][y] && (@lawn[x-1][y] <=> 'O') != 0
    end
    if x + 1 < @lawn.length
      d = path_to_start? x+1, y-1 if !@recur_check[x+1][y-1] && y - 1 >= 0 && (@lawn[x+1][y-1] <=> 'O') != 0
      e = path_to_start? x+1, y+1 if !@recur_check[x+1][y+1] && y + 1 < @lawn[0].length && (@lawn[x+1][y+1] <=> 'O') != 0
      f = path_to_start? x+1, y   if !@recur_check[x+1][y] && (@lawn[x+1][y] <=> 'O') != 0
    end
    g = path_to_start? x, y-1 if !@recur_check[x][y-1] && y - 1 >= 0 && (@lawn[x][y-1] <=> 'O') != 0
    h = path_to_start? x, y+1 if !@recur_check[x][y+1] && y + 1 < @lawn[0].length && (@lawn[x][y+1] <=> 'O') != 0
    
    good = false if a.nil? && b.nil? && c.nil? && d.nil? && e.nil? && f.nil? && g.nil? && h.nil?
    good = true if a || b || c || d || e || f || g || h
    puts "STUCK\nSTUCK\nSTUCK" if a.nil? && b.nil? && c.nil? && d.nil? && e.nil? && f.nil? && g.nil? && h.nil?
    
    #return true or false
    return good
  end
  
  def textlawn
    ps = ""
    @lawn[0].length.times do |x|
      ps << "row #{x}: "
      @lawn.length.times do |y|
        ps << @lawn[y][x] + " "
      end
      puts ps + ""
      ps = ""
    end
    puts "--lawn was just printed--"
  end
  
  def text
    total = ""
     ps = ""
     @lawn[0].length.times do |x|
       #ps << "row #{x}: "
       @lawn.length.times do |y|
         ps << @lawn[y][x]
       end
       total << ps + "\n"
       ps = ""
     end
     total
  end
  
  def printlawn
    #ps = ""
    if @victory
      $app.fill(@fill[0],@fill[1],@fill[2])
      $app.stroke 204, 102, 0
      $app.ellipse(@vic_button[0], @vic_button[1], @vic_button[2]*2, @vic_button[2]*2)
    else
      @lawn.length.times do |x|
        #ps << "row #{x}: "
        @lawn[0].length.times do |y|
          #ps << @lawn[x][y]
          drawelement x, y, @lawn[x][y]
        end
        #puts ps + ""
        #ps = ""
      end
      #puts "--lawn was just printed--"
      drawdude(@dudex*@size + @offset,@dudey*@size + @offset,@size,@size)
    end
  end
  
  def drawelement x, y, input
    drawgrass(x*@size + @offset,y*@size + @offset,@size,@size) if (input <=> 'W') == 0
    drawrock(x*@size + @offset,y*@size + @offset,@size,@size) if (input <=> 'O') == 0
    drawcut(x*@size + @offset,y*@size + @offset,@size,@size) if (input <=> 'w') == 0
  end
  
  def grassorrock
    rndchoice ? 'W' : 'O'
  end
  
  def rndchoice
    x = (rand*5).round
    return true if x>=1
    return false if x==0
  end
  
  def cut
    @lawn[@dudex][@dudey] = 'w' if (@lawn[@dudex][@dudey] <=> 'W') == 0
  end
  
  def key_pressed key
    case key
    when 5000..800000
      #this is to catch shift and arrows
    when 119
      duden
    when 115
      dudes
    when 97
      dudew
    when 100
      dudee
    when 101
      @victory = true
    else
    end
    #puts key
  end
  
  def duden
    @dudey -= 1 if @dudey > 0
    cut
    success?
  end
  
  def dudes
    @dudey += 1 if @dudey < @lawn[0].length - 1
    cut
    success?
  end
  
  def dudee
    @dudex += 1 if @dudex < @lawn.length - 1
    cut
    success?
  end
  
  def dudew
    @dudex -= 1 if @dudex > 0
    cut
    success?
  end
  
  def drawgrass(x,y,w,h)
    $app.line(x,y,x+(w/4),y+h)
    $app.line(x+(w/4),y+h,x+(w/2),y)
    $app.line(x+(w/2),y,x+(w/2)+(w/4),y+h)
    $app.line(x+(w/2)+(w/4),y+h,x+w,y)
  end
  
  def drawcut(x,y,w,h)
    drawgrass x+w/4,y+h/2,w-w/2,h/2
  end
  
  def drawdude(x,y,w,h)
    $app.no_fill
    $app.stroke 204, 102, 0
    $app.rect(x, y, w, h)
  end
  
  def drawrock(x,y,w,h)
    $app.ellipse(x,y,w,h)
  end
  
  def success?
    @lawn.each do |x|
      x.each do |y|
        return false if (y <=> 'W') == 0
      end
    end
    puts "success"
    @victory = true
    return true
  end
  
  def text_input inputted
    #deal with the text that is recieved from the iointerface!~!
    dudes if !inputted.nil? && (inputted <=> "s") == 0
    duden if !inputted.nil? && (inputted <=> "n") == 0
    dudee if !inputted.nil? && (inputted <=> "e") == 0
    dudew if !inputted.nil? && (inputted <=> "w") == 0
  end
  
  def mouse_pressed x, y
    if @victory && $app.dist(x,y,@vic_button[0] + @vic_button[2],@vic_button[0] + @vic_button[2]) < @vic_button[2]
      @fill = [204, 110, 10]
      #puts "#{x}#{y}"
    end
  end
  
  def mouse_released x, y
    if @victory && $app.dist(x,y,@vic_button[0] + @vic_button[2],@vic_button[0] + @vic_button[2]) < @vic_button[2]
      #reset everything!!
      reset
    end
    @fill = [50,50,10]
  end
  
  def reset
    x = @lawn.length
    y = @lawn[0].length
    @lawn = []
    @dudex = 0
    @dudey = 0
    @victory = false
    filllawn x, y
    textlawn
    cut
  end
end





