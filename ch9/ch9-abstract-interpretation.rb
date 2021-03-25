

class Sign < Struct.new(:name)
  NEGATIVE, ZERO, POSITIVE = [:negative, :zero, :positive].map { |name| new(name) }
  UNKNOWN = new(:unknown)
  def inspect
    "#<Sign #{name}>"
  end
  def *(other_sign)
    if [self, other_sign].include?(ZERO)
      ZERO
    elsif [self, other_sign].include?(UNKNOWN)
      UNKNOWN
    elsif self == other_sign
      POSITIVE
    else
      NEGATIVE
    end
  end
  def +(other_sign)
    if self == other_sign || other_sign == ZERO
      self
    elsif self == ZERO
      other_sign
    else
      UNKNOWN
    end
  end
  def <=(other_sign)
    self == other_sign || other_sign == UNKNOWN
  end
end

class Numeric
  def sign
    if self < 0
      Sign::NEGATIVE
    elsif zero?
      Sign::ZERO
    else
      Sign::POSITIVE
    end
  end
end

def calculate (x,y,z)
  (x * y) * (x * z)
end

def sum_of_squares(x, y)
  (x * x) + (y * y)
end

class Type < Struct.new(:name)
  NUMBER, BOOLEAN = [:number, :boolean].map { |name| new(name) }
  def inspect
    "#<Type #{name}>"
  end
end

class Number < Struct.new(:value)
  def to_s
    value.to_s
  end
  def inspect
    "<<#{self}>>"
  end
  def evaluate(environment)
    self
  end
  def type
    Type::NUMBER
  end
end

class Boolean < Struct.new(:value)
  def to_s
    value.to_s
  end
  def inspect
    "<<#{self}>>"
  end
  def evaluate(environment)
    self
  end
  def type
    Type::BOOLEAN
  end
end

class Add < Struct.new(:left, :right)
  def to_s
    "#{left} + #{right}"
  end
  def inspect
    "<<#{self}>>"
  end
  def evaluate(environment)
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
  def type
    if left.type == Type::NUMBER && right.type == Type.NUMBER
      Type::NUMBER
    end
  end
end

class Multiply < Struct.new(:left, :right)
  def to_s
    "#{left} * #{right}"
  end
  def inspect
    "<<#{self}>>"
  end
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end

class LessThan < Struct.new(:left, :right)
  def to_s
    "#{left} < #{right}"
  end
  def inspect
    "<<#{self}>>"
  end
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
  if left.type == Type::NUMBER && right.type == Type.NUMBER
    Type::BOOLEAN
  end
end

#---------------------------------
# Debug
#---------------------------------


p Sign::POSITIVE * Sign::POSITIVE;
p 5.sign * -9.sign

p calculate(Sign::POSITIVE, Sign::NEGATIVE, Sign::ZERO)
