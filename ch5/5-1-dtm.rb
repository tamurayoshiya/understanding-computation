class Tape < Struct.new(:left, :middle, :right, :blank)
  def inspect
    "#<Tape #{left.join}(#{middle})#{right.join}>"
  end
  def write(character)
    Tape.new(left, character, right, blank)
  end
  def move_head_left
    Tape.new(left[0..-2], left.last || blank, [middle] + right, blank)
  end
  def move_head_right
    Tape.new(left + [middle], right.first || blank, right.drop(1), blank)
  end
end

class TMConfiguration < Struct.new(:state, :tape)
end

class TMRule < Struct.new(:state, :character, :next_state,
                         :write_character, :direction)
  def applies_to?(configuration)
    state == configuration.state && character == configuration.tape.middle
  end
  def follow(configuration)
    TMConfiguration.new(next_state, next_tape(configuration))
  end
  def next_tape(configuration)
    written_tape = configuration.tape.write(write_character)
    case direction
    when :left
      written_tape.move_head_left
    when :right
      written_tape.move_head_right
    end
  end
end

class DTMRulebook < Struct.new(:rules)
  def next_configuration(configuration)
    rule_for(configuration).follow(configuration)
  end
  def rule_for(configuration)
    rules.detect { |rule| rule.applies_to?(configuration) }
  end
  def applies_to?(configuration)
    !rule_for(configuration).nil?
  end
end

class DTM < Struct.new(:current_configuration, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_configuration.state)
  end
  def step
    self.current_configuration = rulebook.next_configuration(current_configuration)
  end
  def stuck?
    !accepting? && !rulebook.applies_to?(current_configuration)
  end
  def run
    step until accepting? || stuck?
  end
end

#---------------------------------
# Debug
#---------------------------------

rulebook = DTMRulebook.new([
  TMRule.new(1, '0', 2, '1', :right),
  TMRule.new(1, '1', 1, '0', :left),
  TMRule.new(1, '_', 2, '1', :right),
  TMRule.new(2, '0', 2, '0', :right),
  TMRule.new(2, '1', 2, '1', :right),
  TMRule.new(2, '_', 3, '_', :left),
])
tape = Tape.new(['1', '0', '1'], '1', [], '_')
config = TMConfiguration.new(1, tape)

dtm = DTM.new(config, [3], rulebook)
p dtm.current_configuration
dtm.step
p dtm.current_configuration
p dtm.accepting?
p dtm.run
p dtm.current_configuration
p dtm.accepting?

p "-----------------------------"

rulebook = DTMRulebook.new([
  TMRule.new(1, 'x', 1, 'x', :right),
  TMRule.new(1, 'a', 2, 'x', :right),
  TMRule.new(1, '_', 6, '_', :left),
  TMRule.new(2, 'a', 2, 'a', :right),
  TMRule.new(2, 'x', 2, 'x', :right),
  TMRule.new(2, 'b', 3, 'x', :right),
  TMRule.new(3, 'b', 3, 'b', :right),
  TMRule.new(3, 'x', 3, 'x', :right),
  TMRule.new(3, 'c', 4, 'x', :right),
  TMRule.new(4, 'c', 4, 'c', :right),
  TMRule.new(4, '_', 5, '_', :left),
  TMRule.new(5, 'a', 5, 'a', :left),
  TMRule.new(5, 'b', 5, 'b', :left),
  TMRule.new(5, 'c', 5, 'c', :left),
  TMRule.new(5, 'x', 5, 'x', :left),
  TMRule.new(5, '_', 1, '_', :right),
])
tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
config = TMConfiguration.new(1, tape)

dtm = DTM.new(config, [6], rulebook)
p dtm.current_configuration
10.times { dtm.step };
p dtm.current_configuration
25.times { dtm.step };
p dtm.current_configuration
dtm.run
p dtm.current_configuration
