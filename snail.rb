def snail(fib)
  s,l,r = 0,1,[]
  (1..fib.to_i).map do |x|
    s += l
    l = s - l
    if (t = x%4) > 2
      s.times do
        r << [s]*s
      end
    else
      if t > 1
        s.times do |q|
          r.map! do |w|
            w.unshift s
          end
        end
      else
        if t > 0
          s.times do
            r.unshift [s]*s
          end
        else
          r.map! do |w|
            w += [s]*s
          end
        end
      end
    end
  end
  r.map do |w|
    puts w.map { |c| "%#{r.flatten.max.to_s.size}s" % c } * ' '
  end
end

snail(7)


# s,l,r=0,1,[]
# (1..gets.to_i).map{|x|s+=l
# l=s-l
# (t=x%4)>2?s.times{r<<[s]*s}:t>1?s.times{r.map!{|w|w.unshift s}}:t>0?s.times{r.unshift [s]*s}:r.map!{|w|w+=[s]*s}}
# r.map{|w|puts w.map{|c|"%#{r.flatten.max.to_s.size}s"%c}*' '}
