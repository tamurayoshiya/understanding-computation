ZERO  = -> p { -> x { x } }
ONE   = -> p { -> x { p[x] } }
TWO   = -> p { -> x { p[p[x]] } }
THREE = -> p { -> x { p[p[p[x]]] } }
FIVE = -> p { -> x { p[p[p[p[p[x]]]]] } }
FIFTEEN = -> p { -> x {  p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] } }
HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] } }
TRUE = -> x { -> y { x } }
FALSE = -> x { -> y { y } }
IF = -> b { b }
IS_ZERO = -> n { n[-> x { FALSE }][TRUE] }
PAIR  = -> x { -> y { -> f { f[x][y] } } }
LEFT  = -> p { p[-> x { -> y { x } } ] }
RIGHT = -> p { p[-> x { -> y { y } } ] }
INCREMENT = -> n { -> p { -> x { p[n[p][x]] } } }
SLIDE     = -> p { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]] }
DECREMENT = -> n { LEFT[n[SLIDE][PAIR[ZERO][ZERO]]] } 
ADD       = -> m { -> n { n[INCREMENT][m] } }
SUBTRACT  = -> m { -> n { n[DECREMENT][m] } }
MULTIPLY  = -> m { -> n { n[ADD[m]][ZERO] } }
POWER     = -> m { -> n { n[MULTIPLY[m]][ONE] } }
IS_LESS_OR_EQUAL =
  -> m { -> n {
    IS_ZERO[SUBTRACT[m][n]]
  }}
Y = -> f { 
  -> x { f[x[x]] }[-> x { f[x[x]] }] 
}
Z = -> f { -> x { f[-> y { x[x][y] }] }[-> x { f[-> y { x[x][y] }] }] }

#MOD =
#  -> m { -> n {
#    IF[IS_LESS_OR_EQUAL[n][m]][
#      -> x {
#        MOD[SUBTRACT[m][n]][n][x]
#      }
#    ][
#      m
#    ]
#  } }

MOD =
  Z[-> f { -> m { -> n {
    IF[IS_LESS_OR_EQUAL[n][m]][
      -> x {
        f[SUBTRACT[m][n]][n][x]
      }
    ][
      m
    ]
}}}]

def to_integer(proc)
  proc[-> n { n + 1}][0]
end

def to_boolean(proc)
  IF[proc][true][false]
end

#---------------------------------
# Debug
#---------------------------------

#(ONE..HUNDRED).map do |n|
#  IF[IS_ZERO[MOD[n][FIFTEEN]]['FizzBuzz'][
#    IF[IS_ZERO[MOD[n][THREE]]]['Fizz'][
#      IF[IS_ZERO[MOD[n][FIVE]]]['Buzz'][
#        n.to_s]]]
#end

p to_integer(MOD[
  POWER[THREE][THREE]
][
  ADD[THREE][TWO]
])
