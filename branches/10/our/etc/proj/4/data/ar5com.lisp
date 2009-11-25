#|
@relation ar5

@attribute total_loc numeric
@attribute blank_loc numeric
@attribute comment_loc numeric
@attribute code_and_comment_loc numeric
@attribute executable_loc numeric
@attribute unique_operands numeric
@attribute unique_operators numeric
@attribute total_operands numeric
@attribute total_operators numeric
@attribute halstead_vocabulary numeric
@attribute halstead_length numeric
@attribute halstead_volume numeric
@attribute halstead_level numeric
@attribute halstead_difficulty numeric
@attribute halstead_effort numeric
@attribute halstead_error numeric
@attribute halstead_time numeric
@attribute branch_count numeric
@attribute decision_count numeric
@attribute call_pairs numeric
@attribute condition_count numeric
@attribute multiple_condition_count numeric
@attribute cyclomatic_complexity numeric
@attribute cyclomatic_density numeric
@attribute decision_density numeric
@attribute design_complexity numeric
@attribute design_density numeric
@attribute normalized_cyclomatic_complexity numeric
@attribute formal_parameters numeric
@attribute defects {false true}
|#

(defun ar5com () 
  (table-deep-copy (data
   :name 'ar5com 
   :columns '($loc $vg $ivg $v $l $d $e $b $t $lOCode $lOCcomment $locCodeAndComment $uniq_Op $uniq_Opnd $total_Op $total_Opnd $branchCount defects)
   :egs
   '(
(82 10 20 937 0.10073 9.9273 9301.8545 0.31233 516.7697 47 9 0 12 55 132 91 20 false)
(16 2 1 111 0.24074 4.1538 461.0769 0.037 25.6154 8 2 1 6 13 20 18 2 false)
(31 6 1 240 0.12903 7.75 1860 0.08 103.3333 16 3 2 9 18 42 31 10 false)
(477 93 4 6126 0.021462 46.5933 285430.76 2.042 15857.2644 284 89 2 29 150 699 482 236 true)
(11 1 2 84 0.33333 3 252 0.028 14 9 0 0 4 10 17 15 0 false)
(9 1 1 57 0.31818 3.1429 179.1429 0.019 9.9524 7 0 0 4 7 13 11 0 false)
(10 1 2 67 0.26923 3.7143 248.8571 0.022333 13.8254 8 0 0 4 7 15 13 0 false)
(5 1 3 29 0.66667 1.5 43.5 0.0096667 2.4167 5 0 0 3 5 9 5 0 false)
(28 4 2 346 0.061224 16.3333 5651.3333 0.11533 313.963 22 1 0 12 18 53 49 8 false)
(26 3 2 280 0.070953 14.0938 3946.25 0.093333 219.2361 20 0 0 11 16 44 41 4 false)
(15 1 7 113 0.23158 4.3182 487.9545 0.037667 27.1086 11 0 0 5 11 22 19 0 false)
(22 3 7 198 0.15111 6.6176 1310.2941 0.066 72.7941 17 1 0 9 17 36 25 4 false)
(10 1 3 127 0.125 8 1016 0.042333 56.4444 6 0 0 6 9 23 24 0 false)
(23 5 4 325 0.069767 14.3333 4658.3333 0.10833 258.7963 17 1 0 10 15 58 43 16 false)
(86 9 3 706 0.074163 13.4839 9519.6129 0.23533 528.8674 56 8 3 11 31 113 76 24 false)
(115 21 2 1407 0.028409 35.2 49526.4 0.469 2751.4667 97 1 1 16 35 204 154 52 false)
(150 18 13 1880 0.053668 18.6329 35029.8734 0.62667 1946.1041 102 5 1 16 79 229 184 48 true)
(47 1 0 399 0.36 2.7778 1108.3333 0.133 61.5741 16 17 0 5 45 52 50 0 false)
(35 1 0 204 0.44828 2.2308 455.0769 0.068 25.2821 7 15 0 4 26 31 29 0 false)
(65 11 14 801 0.093478 10.6977 8568.8372 0.267 476.0465 38 9 0 10 43 110 92 20 false)
(29 1 10 388 0.19636 5.0926 1975.9259 0.12933 109.7737 24 1 0 5 27 57 55 0 false)
(42 8 0 557 0.059341 16.8519 9386.4815 0.18567 521.4712 29 0 0 14 27 85 65 18 false)
(14 8 1 234 0.11765 8.5 1989 0.078 110.5 11 0 0 7 14 43 34 26 false)
(29 4 2 267 0.125 8 2136 0.089 118.6667 21 0 0 8 18 46 36 8 false)
(151 29 0 2143 0.024187 41.3438 88599.6562 0.71433 4922.2031 100 13 4 28 64 285 189 64 false)
(42 5 0 333 0.081818 12.2222 4070 0.111 226.1111 31 3 0 11 18 59 40 16 false)
(208 41 17 2813 0.031797 31.45 88468.85 0.93767 4914.9361 142 28 4 17 70 371 259 104 true)
(48 12 6 538 0.071429 14 7532 0.17933 418.4444 31 8 4 14 28 88 56 32 false)
(135 26 4 2166 0.037267 26.8333 58121 0.722 3228.9444 71 20 2 23 87 258 203 70 true)
(125 29 9 1714 0.030017 33.3145 57101.0807 0.57133 3172.2823 88 12 4 27 62 229 153 70 true)
(14 5 1 149 0.13131 7.6154 1134.6923 0.049667 63.0385 12 0 0 11 13 29 18 8 false)
(147 38 0 1706 0.032799 30.4891 52014.4565 0.56867 2889.692 105 10 4 17 46 247 165 92 false)
(214 37 4 2407 0.027936 35.7958 86160.4296 0.80233 4786.6905 121 38 8 23 71 309 221 108 true)
(112 30 1 2156 0.013467 74.2571 160098.4 0.71867 8894.3556 82 7 3 23 35 305 226 90 false)
(110 21 1 1351 0.030918 32.3438 43696.4062 0.45033 2427.5781 70 11 3 23 48 182 135 54 true)
(49 9 0 465 0.054245 18.4348 8572.1739 0.155 476.2319 28 7 3 16 23 74 53 22 true)
     ))))
