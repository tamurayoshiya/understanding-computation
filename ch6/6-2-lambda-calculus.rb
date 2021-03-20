
class LCVariable < Struct.new(:name)
  def to_s
    name.to_s
  end
  def inspect
    to_s
  end
  def replace(name, replacement) 
    if self.name == name
      replacement
    else
      self
    end
  end 
  def callable?
    false
  end
  def reducible?
    false
  end
end

class LCFunction < Struct.new(:parameter, :body)
  def to_s
    "-> #{parameter} { #{body} }"
  end
  def inspect
    to_s
  end
  def replace(name, replacement) 
    if parameter == name
      self
    else
      LCFunction.new(parameter, body.replace(name, replacement))
    end
  end
  def call(argument)
    body.replace(parameter, argument)
  end
  def callable?
    true
  end
  def reducible?
    false
  end
end

class LCCall < Struct.new(:left, :right)
  def to_s
    "#{left}[#{right}]"
  end
  def inspect
    to_s
  end
  def replace(name, replacement) 
    LCCall.new(left.replace(name, replacement), right.replace(name, replacement))
  end
  def callable?
    false
  end
  def reducible?
    left.reducible? || right.reducible? || left.callable?
  end
  def reduce
    if left.reducible?
      LCCall.new(left.reduce, right)
    elsif right.reducible?
      LCCall.new(left, right.reduce)
    else
      left.call(right)
    end
  end
end
#---------------------------------
# Debug
#---------------------------------


one = 
  LCFunction.new(:p,
    LCFunction.new(:x,
      LCCall.new(LCVariable.new(:p), LCVariable.new(:x))))

increment = 
  LCFunction.new(:n,
    LCFunction.new(:p,
      LCFunction.new(:x,
        LCCall.new(
          LCVariable.new(:p),
          LCCall.new(
            LCCall.new(LCVariable.new(:n), LCVariable.new(:p)),
            LCVariable.new(:x)
          )
        )
      )
    )
  )

add =
  LCFunction.new(:m,
    LCFunction.new(:n,
      LCCall.new(
        LCCall.new(LCVariable.new(:n), increment),
        LCVariable.new(:m)
      )
    )
  )

two = add.call(one).call(one)
three = add.call(two).call(one)

function = LCFunction.new(
  :x,
  LCFunction.new(
    :y,
    LCCall.new(LCVariable.new(:x), LCVariable.new(:y))
  )
)
argument = LCFunction.new(:z, LCVariable.new(:z))

exp = LCCall.new(LCCall.new(add, one), one)
inc, zero = LCVariable.new(:inc), LCVariable.new(:zero)
exp = LCCall.new(LCCall.new(exp, inc), zero)

while exp.reducible?
  puts exp
  exp = exp.reduce
end
puts exp

