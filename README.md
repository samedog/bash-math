# bash-math
why use bc, python or perl to calculate floats when you cna write your own hacky and horrible bash functinos? ask no more for i just made a set of hacky, horrible and unoptimized math functions for bash.

THIS IS A WORK IN PROGRESS

Just include the math.sh in to your bashcript with: 

```bashscript
. path/to/bash.sh
```

and enjoy.

Current functions:

addsubs: can sum any given int (x) list (whitespace sepparated), supports -- +- and ++ 

pow: does a simple x^y ($1^$2) doesn't supports negative exponents yet

sum_float: can sum any given float (x,y) list (whitespace sepparated), supports -- +- and ++ [WOAH!!]
