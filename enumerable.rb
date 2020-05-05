module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    array = is_a?(Range) ? to_a : self
    i = 0
    while i < array.length
      yield(array[i])
      i += 1
    end
    array
  end

  def my_each_with_index
    return to_enum :my_each unless block_given?

    i = 0
    while i < size
      if is_a? Array
        yield self[i], i
      elsif is_a? Hash
        yield keys[i], self[keys[i]]
      elsif is_a? Range
        yield to_a[i], i
      end
      i += 1
    end
  end

  def my_select
    return to_enum :my_select unless block_given?
    
    if is_a? Array
    results = []
    my_each { |x| results << x if yield x }
    else
    results = {}
    my_each { |y, z| results[y] = z if yield y, z }
    end
    results
  end

  def my_all?(args = nil)
    condition = true
    my_each do |i|
      if condition
        if args.is_a?(Class)
          condition = i.is_a?(args) unless args.is_a?(Regexp)
        elsif args.is_a?(Regexp)
          condition = !i.match(args).nil? if args.is_a?(Regexp)
        elsif args
          condition = i == args
        elsif block_given?
          condition = false unless yield(i)
        else
          condition = false unless i
        end
      end
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

  def my_none?(args = nil, &block)
    !my_any?(args, &block)
  end

  def my_count(args = nil)
    total = 0
    if args
      my_each { |i| total += 1 if i == args }
    elsif !block_given?
      total = size
    elsif !args
      my_each { |i| total += 1 if yield i }
    end
    total
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc.class == Proc

    my_arr = []
    if proc.class == Proc
      my_each { |i| my_arr << proc.call(i) }
    elsif block_given?
      my_each { |i| my_arr << yield(i) }
    elsif self.Class == Range
      range_arr = to_a
      my_arr = range_arr.size - 1
      range_arr.length.times do |i|
        my_arr << proc.call(range_arr[i])
      end
    elsif self.Class == Array
      my_each do |i|
        my_arr << proc.call(self[i])
      end
    elsif self.Class == Hash
      my_each do |key, value|
        my_arr << proc.call(key, value)
      end
    end
    my_arr
  end

  def my_inject(*args)
    array = is_a?(Range) ? to_a : self

    argument = args[0] if args[0].is_a?(Integer)
    operator = args[0].is_a?(Symbol) ? args[0] : args[1]

    if operator
      array.my_each { |i| argument = argument ? argument.send(operator, i) : i }
      return argument
    end
    array.my_each { |i| argument = argument ? yield(argument, i) : i }
    argument
  end
end

def multiply_els(arr)
  arr.my_inject { |product, i| product * i }
end
