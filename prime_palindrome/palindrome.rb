require 'prime'

10000.downto(0).each do |num|
  next unless Prime.prime?(num)
  if num == num.to_s.reverse.to_i
    print num
    return
  end
end
