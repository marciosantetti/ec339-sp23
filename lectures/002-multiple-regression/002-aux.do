* import mroz:

import delimited "/Users/marciosantetti/Documents/Skidmore College/teaching/applied-metrics/fall-22/lectures/002-multiple-regression/mroz.csv"


* some plots:

twoway (scatter faminc hours)

twoway (scatter faminc heduc)

twoway (scatter faminc exper)


* exclude obs with 0 experience

drop if (exper == 0 & hours == 0)

twoway (scatter faminc hours)
