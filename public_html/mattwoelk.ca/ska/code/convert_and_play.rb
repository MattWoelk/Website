#this program will convert concert-pitch tabs to Bb-instrument tabs

require 'midi_sounds.rb'


@notes = {'Ab' => 'Bb','A' => 'B','Bb' => 'C','B' => 'Db','C' => 'D','Db' => 'Eb',
          'D' => 'E','Eb' => 'F','E' => 'Gb','F' => 'G','Gb' => 'Ab','G' => 'A',
          'G#' => 'Bb','A#' => 'C','C#' => 'Eb','D#' => 'F','F#' => 'Ab'}
@pitches = ['C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B']

#@acceptable = [' ','.','-',',','_','/','\\','#','b','A','B','C','D','E','F','G',"\t"]
#Each of the 16 MIDI channels belongs to an instrument. The velocity represents how 
#hard a note has been pressed or released and is expressed between 0 and 127. 
#The note number identifies a specific note and is also expressed between 0 and 127.

def play_line(astring, eighth_length)
  if(!astring.nil?)
  midi = LiveMIDI.new 
  #doesn't do sharps
  arr = astring.scan(/[A-G][#b]{0,}[\._\/]{0,}/)
  arr1 = astring.scan(/^[\.]{0,}/) if !astring.scan(/^[\.]{0,}/).nil?
  #nil thing error is right here when no ..'s at beginning
  previous_pitch = 60   #SET THIS BACK TO 60!!!
  
  #puts arr1[0]
  n_time = 0
  r_time = 0
  pitch = 0
  
  n_times = 0
  r_times = 0
  
  #puts astring
  print"\n"
  #do the beginning rest (this isn't the best way to do this, but it works
  if !arr1.nil?
    arr1[0][/\.{0,}/].length.times do 
      sleep(eighth_length)
      puts "."
    end
  end
  #sleep(arr1[0][/\.+/].length * eighth_length) if !arr1[0].nil?
  
  arr.length.times do |note|
    #puts "LOOK HERE: #{}"
    #pitch = 60 + @pitches.index(arr[note][/[A-G][b#]{0,}/])
    difference = (@pitches.index(arr[note][/[A-G][b#]{0,}/]) - (previous_pitch % 12))
    
    if difference >= 8
      pitch = previous_pitch - (12 - difference)
    elsif difference > 0
      pitch = previous_pitch + difference
    elsif difference <= -8
      pitch = previous_pitch + (12 + difference)
    else
      pitch = previous_pitch + difference
    end
    previous_pitch = pitch
    #puts "pitch #{pitch}"
    if /_/.match(arr[note]) 
      #n_time = (arr[note][/[_\/\\]+/].length + 1) * eighth_length 
      n_times = (arr[note][/[_\/\\]+/].length + 1)
    elsif /[A-G]/.match(arr[note])
      #n_time = eighth_length
      n_times = 1
    else
      #n_time = 0
      n_times = 0
    end
    #puts "n_time #{n_time}"
    #r_time = /\./.match(arr[note]) ? arr[note][/\.+/].length * eighth_length : 0
    r_times = /\./.match(arr[note]) ? arr[note][/\.+/].length : 0
    
    #midi.note_on(0, pitch, 100)
    #sleep(n_time)
    #midi.note_off(0, pitch, 100)
    #sleep(r_time)
    
    midi.note_on(6, pitch - 2, 100)     #CHANGE THIS BACK
    n_times.times do
      puts arr[note][/[A-G][b#]{0,}/]
      sleep(eighth_length)
    end
    midi.note_off(6, pitch - 2, 100)    #CHANGE THIS BACK
    r_times.times do
      puts "_"
      sleep(eighth_length)
    end
    
  end
end
end

def convert_line astring
  #find the part of the string that is usable (if any) and convert it
  #print everything
  line_re = /([^a-zH-Z][A-G.#b_\\\/-]+[A-G]+[A-G.#b_\\\/-]+)?(.{0,})/
  m = line_re.match(astring)
  play_line(m[1],0.12)
  #print "#{convert_digits(m[1])}#{m[2]}"
end

def convert_digits astring
  note_re = /[A-G][#b]{0,1}/ #could also be /[A-G][#b]?/
  astring.gsub!(note_re) {|note| @notes[note]} if !astring.nil?
end

def convert_file filename
  file = File.new(filename, "r")
  while (line = file.gets)
    convert_line line.chomp
    #play_line(line.chomp, 0.1)
    print "\n"
  end
  file.close
end

if __FILE__ == $0
  #convert_line 'ECBbG <-- text!'
  convert_file "Kamikaze_trumpet.txt"
  #play_line("..GbGbBD.Db...E...D...Gb...EGb.E.Db.D....BD.Db...A...B...............", 0.12)
end



# regexp to find notes /([^a-zH-Z][A-G.#b_\\\/-]+[A-G]+[A-G.#b_\\\/-]+)/

# /([^a-zH-Z][A-G.#b_\\\/-]+[A-G]+[A-G.#b_\\\/-]+)?(.{0,})/
#        to match the whole line and separate it out

# [A-G][#b]{0,} <-- selects notes out of a string (greedy)