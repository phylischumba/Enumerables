require 'enumerable.rb'
require 'spec_helper'

describe Enumerable do
  let(:num_arr) { [1, 2, 3, 4, 5] }
  let(:num_range) { (1..5).to_a }
  let(:nil_arr) { [false, nil, false] }
  let(:str_arr) { %w[mangoes oranges apples] }
  let(:mixed_arr) { [1, 'two', 3, 4] }
  let(:multiply) do
    proc do |x|
      x * 3
    end
  end
  describe '#my_each' do
    it 'iterates through each element in array if block is given' do
      expect(num_arr.my_each { |x| puts x }).to eql(num_arr.each { |x| puts x })
    end
    it 'iterates through each element in a range if block is given' do
      expect(num_range.my_each { |x| puts x }).to eql(num_range.each { |x| puts x })
    end
    it 'returns to enum if block is not given' do
      expect(num_arr.my_each).to be_a(Enumerator)
    end
    it 'returns an error if an argument is given' do
      expect { num_arr.my_each(1) }.to raise_error(ArgumentError)
    end
    it 'raise nomethoderror if invoked on subject rather than enumerable' do
      expect { 5.my_each }.to raise_error(NoMethodError)
    end
  end

  describe '#my_each_with_index' do
    it 'iterates each element of an array, item and its index,  if block is given' do
      ans = []
      num_arr.my_each_with_index { |number, i| ans << "#{number} : #{i}" }
      expect(ans).to eql(['1 : 0', '2 : 1', '3 : 2', '4 : 3', '5 : 4'])
    end
    it 'iterates each element of a range, item and its index,  if block is given' do
      ans = []
      num_range.my_each_with_index { |number, i| ans << "#{number} : #{i}" }
      expect(ans).to eql(['1 : 0', '2 : 1', '3 : 2', '4 : 3', '5 : 4'])
    end
    it 'returns to_enum if no block is given' do
      expect(num_arr.my_each_with_index).to be_a(Enumerator)
    end
    it 'returns an error if an argument is given' do
      expect { num_arr.my_each_with_index(1) }.to raise_error(ArgumentError)
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_each_with_index }.to raise_error(NoMethodError)
    end
  end

  describe '#my_select' do
    it 'returns an array of items which satisfies condition' do
      expect(num_arr.my_select(&:even?)).to eql(num_arr.select(&:even?))
    end
    it 'returns to_enum if no block is given' do
      expect(num_arr.my_select).to be_a(Enumerator)
    end
    it 'returns an error if an argument is given' do
      expect { num_arr.my_select(1) }.to raise_error(ArgumentError)
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_select }.to raise_error(NoMethodError)
    end
  end
  describe '#my_all?' do
    it 'returns true if all elements of an array satisfy given condition' do
      expect(num_arr.my_all? { |x| x < 1 }).to eql(num_arr.all? { |x| x < 1 })
    end
    it 'returns true if all elements of a range satisfy given condition' do
      expect(num_range.my_all? { |x| x <= 5 }).to be true
    end
    it 'returns true if array has all elements same as argument' do
      expect(str_arr.my_all?(/a/)).to be true
    end
    it 'returns true if we dont pass block or argument and all the elements are true' do
      expect(num_arr.my_all?).to be true
    end
    it 'returns true if all elements match Class passed as argument' do
      expect(str_arr.my_all?(String)).to be true
    end
    it 'returns true if an empty array is given' do
      expect([].my_all?).to be true
    end
    it 'returns false if all the items of array does not meet given condition' do
      expect(num_range.my_all? { |x| x % 4 == 0 }).to be false
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_all? }.to raise_error(NoMethodError)
    end
  end

  describe '#my_none?' do
    it 'returns true if none of elements of array satisfy given condition' do
      expect(num_arr.my_none? { |x| x >= 1 }).to eql(num_arr.none? { |x| x >= 1 })
    end
    it 'returns true if none of the elements of range satisfy given condition' do
      expect(num_range.my_none? { |x| x < 0 }).to be true
    end
    it 'returns true if none of the elements match expression passed as argument' do
      expect(num_arr.my_none?(/a/)).to be true
    end
    it 'returns true if none of the elements match the Class passed as argument' do
      expect(str_arr.my_none?(Numeric)).to be true
    end
    it 'returns true if none of the elements are true if we dont pass block and argument' do
      expect(nil_arr.my_none?).to be true
    end
    it 'returns true if an empty array is given' do
      expect([].my_none?).to be true
    end
    it 'returns flase if any of the elements of array meet the condition' do
      expect(num_arr.my_none? { |x| x < 4 }).to be false
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_none? }.to raise_error(NoMethodError)
    end
  end

  describe '#my_any?' do
    it 'returns true if any of elements of array meet a given condition' do
      expect(num_arr.my_any? { |x| x % 3 == 0 }).to eql(num_arr.any? { |x| x % 3 == 0 })
    end
    it 'returns true if any of elements of range meet a given condition' do
      expect(num_range.my_any? { |x| x < 2 }).to be true
    end
    it 'returns true if any of the elements matches expression passed as argument' do
      expect(str_arr.my_any?(/a/)).to be true
    end
    it 'returns true if any of the elements match Class passed as argument' do
      expect(str_arr.my_any?(String)).to be true
    end
    it 'returns true if we dont pass block and argument' do
      expect(num_arr.my_any?).to be true
    end
    it 'returns false if none of elements in a range meet given condition' do
      expect(num_range.my_any? { |x| x > 9 }).to be false
    end
    it 'returns false if an empty array is given' do
      expect([].my_any?).to be false
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_any? }.to raise_error(NoMethodError)
    end
  end

  describe '#my_count' do
    it 'returns number of elements in an array if no block is passed' do
      expect(num_arr.my_count).to eql(num_arr.count)
    end
    it 'returns number of array elements that meet a given condition if block is passed' do
      expect(num_arr.my_count(&:even?)).to eql(2)
    end
    it 'returns number of elements in a range if no block is given' do
      expect(num_range.my_count).to eql(5)
    end
    it 'returns the number of times an element is in an array if an argument is passed' do
      expect(num_arr.my_count(4)).to eql(1)
    end
    it 'counts number of times a condition is met by each element of an array' do
      expect(num_arr.my_count(&:even?)).to be 2
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_count? }.to raise_error(NoMethodError)
    end
  end

  describe '#my_map' do
    it 'performs operation on each element of array if block is given with no proc and returns the array' do
      expect(num_arr.my_map { |x| x * 2 }).to eql(num_arr.map { |x| x * 2 })
    end
    it 'performs operation on each element of range if block is given and returns the array' do
      expect(num_range.my_map { |x| x * 2 }).to eql([2, 4, 6, 8, 10])
    end
    it 'returns to_enum if no block is given' do
      expect(num_arr.my_map).to be_a(Enumerator)
    end
    it 'performs the proc operation if block and proc are given' do
      expect(num_arr.my_map(multiply) { |x| x * 2 }).to eql([3, 6, 9, 12, 15])
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_map }.to raise_error(NoMethodError)
    end
  end

  describe '#my_inject' do
    it 'performs operation on each element of array if block is given with no proc and returns the result' do
      expect(num_arr.my_inject { |x| x * 2 }).to eql(num_arr.inject { |x| x * 2 })
    end
    it 'performs operation on each element of range if block is given and returns the result' do
      expect(num_range.my_inject { |x| x + 2 }).to eql(9)
    end
    it 'performs the operation on all elements of array if a symbol given as a argument' do
      expect(num_arr.my_inject(:+)).to eql(15)
    end
    it 'if an initial value is given, the operation starts with it' do
      expect(num_arr.my_inject(10, :+)).to eql(25)
    end
    it 'returns an error if invoked on object other than enumerable' do
      expect { 1.my_inject }.to raise_error(NoMethodError)
    end
  end

  describe '#multiply_els' do
    it 'it takes an array and returns the multiplication of all the items' do
      expect(multiply_els(num_arr)).to eql(120)
    end
    it 'if no argument is passed, it gives an error' do
      expect { multiply_els }.to raise_error(ArgumentError)
    end
  end
end
