module Enumerable
  def my_each
    # return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    my_arr = []
    my_each { |i| my_arr.push(i) if yield(i) }
    my_arr
  end

  def my_all?(*args)
    condition = true
    if !args[0].nil?
      my_each { |_i| condition = false }
    elsif !block_given?
      my_each { |_i| condition = false }
    else
      my_each { |i| condition = false unless yield(i) }
    end
    condition
  end

  def my_any?(*args)
    state = false
    if !args[0].nil?
      my_each { |i| state = true if args[0] === i }
    elsif !block_given?
      my_each { |i| state = true if i }
    else
      my_each { |i| state = true if yield(i) }
    end
    state
  end

  def my_none?
    return to_enum(:my_none?) unless block_given?

    state = true
    my_each { |i| state = false if yield(i) }
    state
  end

  def my_count
    return to_enum(:my_count) unless block_given?

    total = 0
    my_each do |i|
      total += 1 if block_given? && yield(i)
      total = size unless block_given?
    end
    total
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc.class == Proc

    mapped = []
    if proc.class == Proc
      my_each { |i| mapped << proc.call(i) }
    elsif block_given?
      my_each { |i| mapped << yield(i) }
    end
    mapped
  end

  def my_inject(*args)
    arr = to_a
    if !args.empty? && args[0].class != Symbol
      acc = args[0]
      arr.my_each { |item| acc = yield(acc, item) }
    elsif args.empty?
      acc = to_a[0]
      arr[1..-1].my_each { |item| acc = yield(acc, item) }
    elsif args[0].class == Symbol
      acc = to_a[0]
      # operation = args[0]
      arr[1..-1].my_each { |item| acc = acc.yield(total, item) }
    end
    acc
  end
end
def multiply_els
  return to_enum(:multiply_els) unless block_given?

  my_inject(:*)
end

# p [].my_each { |i| puts i }

# p ['burner'].my_none? { |word| word.length >= 3 }
# p [].my_count(&:even?)
# p (1..7).my_inject { |product, n| product * n }
# longest = %w[cat sheep bear].my_inject do |memo, word|
#   memo.length > word.length ? memo : word
# end
# p longest
# p (5..10).inject { |sum, n| sum + n }
