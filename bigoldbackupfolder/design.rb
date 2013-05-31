@ve2 = 9 - 3
@vc1 = 1
@ve1 = 1

@vt = 25e-3

@rb1 = 1
@rb2 = 1
@re1 = 1
@re2 = 1
@re3 = 1
@rc1 = 1

@ie2 = 1
@ic1 = 1
@iri = 1

@bet = 100

#parameters:
@av1 = 1
@rin = 1
@rout = 1
@vout = 1
@pdiss = 1

def print_values
  puts "----------------------------"
  puts "rb1 = #{@rb1}\nrb2 = #{@rb2}\nre1 = #{@re1}\nre2 = #{@re2}\nre3 = #{@re3}\nrc1 = #{@rc1}\n\n"
  puts "ve2=#{@ve2}\nve1=#{@ve1}\nvc1=#{@vc1}\nie2=#{@ie2}\nic1=#{@ic1}\niri=#{@iri}"
  puts
  puts "av1=#{@av1}\nrin=#{@rin}\nrout=#{@rout}\nvout=#{@vout}\npdiss=#{@pdiss}"
  puts
end

def calculate_values
  @vc1 = @ve2 - 0.7
  @ic1 = (9-@vc1)/@rc1
  @ve1 = (@re2 + @re1)*(@ic1)
  @ie2 = (9 - @ve2)/@re3
  @iri = 9/(@rb1 + @rb2)

  @av1 = -@ic1*@rc1/(@vt + (@ic1*@re1))
  @rin = 1/(1/(((@vt/@ic1)+@re1)*(@bet+1)) + 1/(@rb1) + 1/(@rb2))
  @rout = 1/(1/(@re3) + 1/((@vt/@ie2)+(@rc1/(@bet+1))))
end

while true
  input = gets 
  case input[0..2]
  when 'rb1'
    @rb1 = input[6..-1].to_f
  when 'rb2'
    @rb2 = input[6..-1].to_f
  when 're1'
    @re1 = input[6..-1].to_f
  when 're2'
    @re2 = input[6..-1].to_f
  when 're3'
    @re3 = input[6..-1].to_f
  when 'rc1'
    @rc1 = input[6..-1].to_f
  when 've2'
    @ve2 = input[6..-1].to_f
  when 'bet'
    @bet = input[6..-1].to_f
  end
  calculate_values
  print_values
  puts @vt
end
