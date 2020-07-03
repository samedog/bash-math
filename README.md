# bash-math
why use bc, python or perl to calculate floats in your bashscript when you can use hacky and horrible bash functinos? ask no more for i just made a set of hacky, horrible and unoptimized math functions for bash.

THIS IS A WORK IN PROGRESS

Just include the math.sh in to your bashcript with: 

```bashscript
. path/to/bash.sh
```

and enjoy.

Current functions:

* addsubs(): can sum any given int (x) list (whitespace sepparated), supports -- +- and ++ 

* pow(): does a simple x^y ($1^$2) doesn't supports negative exponents yet

* sum_float(): can sum any given float (x,y) and/or int (x) list (whitespace sepparated) and will return a float [WOAH!!]
  * If a single number is passed it will return a float for that number, not handy at all but it's an unintended feature.
