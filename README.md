# bash-math
why use bc, python or perl to calculate floats in your bashscript when you can use hacky and horrible bash functiorinos? ask no more for i just made a set of hacky, horrible and un-optimized math functions for bash.

THIS IS A WORK IN PROGRESS

Just include the math.sh in to your bashcript with: 

```Shell
. path/to/math.sh
```

and enjoy.

Current functions:

* addsubs(): can sum any given int (x) list (whitespace separated), supports -- +- and ++ 

* pow(): does a simple x^y ($1^$2) doesn't supports negative exponents yet

* sum_float(): can sum any given float (x,y) and/or int (x) list (whitespace separated) and will return a float [WOAH!!]
  * If a single number is passed it will return a float for that number, not handy at all but it's an unintended feature.
* mult_float(): can multiply ints and floats and will return a float.

Test code:
```Shell
#!/bin/bash
. /path/to/math.sh

sum_float 2,1 3

```

TODO:

* change some if with case because why not
* natural log and log
* nroot
* float division
* ask myself why the hell i'm doing this
