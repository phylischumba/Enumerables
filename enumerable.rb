module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      yield(size[i])
      i += 1
    end
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

  def my_all?
    return to_enum(:my_all?) unless block_given?

    state = true
    my_each { |i| state = false unless yield(i) }
    state
  end

  def my_any?
    return to_enum(:my_any?) unless block_given?

    state = false
    my_each do |i|
      state = true if yield(i)
      break
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
    my_each do |x|
      total += 1 if yield(self[x])
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

  def my_inject
    return to_enum(:my_inject) unless block_given?

    result = self[0]
    shift
    my_each do |elem|
      result = yield(result, elem)
    end
    result
  end

  def multiply_els
    return to_enum(:multiply_els) unless block_given?

    my_inject { |total, k| return total * k }
  end
end
