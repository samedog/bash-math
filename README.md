# bash-math
why use bc, python or perl to calculate floats in your bashscript when you can use hacky and horrible bash functiorinos? ask no more for i just made a set of hacky, horrible and un-optimized math functions for bash.

THIS IS A WORK IN PROGRESS

Just include the math.sh in to your bashcript with: 

```Shell
. path/to/math.sh
```

and enjoy.

Current functions:

* fpow(): does a simple x^y ($1^$2)
  * Supports negative exponent and base (fpow -+x -+y assumes (-+x)^(+-y) and not -+(x^(-y))
  * doesn't support floats.
  * Doesn't supports (x/y) exponents.

* sum_float(): can sum any given numbers
  * If a single number is passed it will return a float for that number
  * Supports multiple inputs
  * Supports float (x,y) and int (x) numbers
  * Supports + and - numbers 
  
* mult_float(): can multiply ints and floats and will return a float (supports multiple numbers)
  * Supports float (x,y) and int (x) numbers
  * Supports multiple inputs
  * Supports + and - numbers 
  
* div_float(): divides ( $1 / $2 )
  * Supports float (x,y) and int (x) numbers
  * Supports + and - numbers
  
Test code:

. /path/to/math.sh
sum_float 2,1 -3

```

TODO:

* natural log and log
* nroot
* ask myself why the hell i'm doing this
