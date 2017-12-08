//: Advent of Code 2017 - Day 8 - I Heard You Like Registers (Part 2)
// https://adventofcode.com/2017/day/8

import Foundation
import XCTest

struct Instruction {
  let register: String
  let increment: Bool
  let amount: Int
  let condition: Condition

  // input is the entire line e.g.
  // b inc 5 if a > 1
  init(input: String) {
    let components = input.components(separatedBy: CharacterSet.whitespaces)
    register = components[0]
    increment = (components[1] == "inc")
    amount = Int(components[2]) ?? 0
    let conditionStrings = Array(components[3...])
    condition = Condition(input: conditionStrings)
  }
}

struct Condition {
  let register: String
  let opr: String
  let value: Int

  init(input: [String]) {
    register = input[1]
    opr = input[2]
    value = Int(input[3]) ?? 0
  }

  func evaluate(registers: [String : Int]) -> Bool {
    let lhs = registers[register] ?? 0
    let evaluation: Bool
    switch opr {
    case "<":
      evaluation = (lhs < value)
    case ">":
      evaluation = (lhs > value)
    case "==":
      evaluation = (lhs == value)
    case "<=":
      evaluation = (lhs <= value)
    case ">=":
      evaluation = (lhs >= value)
    case "!=":
      evaluation = (lhs != value)
    default:
      evaluation = false
    }

    return evaluation
  }
}

func processInstructions(input: String) -> Int {
  var registers = [String : Int]()
  var largestValue = 0
  let lines = input.components(separatedBy: CharacterSet.newlines)
  let instructions = lines.map {
    Instruction(input: $0)
  }

  for instruction in instructions {
    if instruction.condition.evaluate(registers: registers) {
      var value = registers[instruction.register] ?? 0
      if instruction.increment {
        value += instruction.amount
      } else {
        value -= instruction.amount
      }
      registers[instruction.register] = value
    }
    let currentLargestValue = largestRegisterValue(registers: registers)
    largestValue = max(largestValue, currentLargestValue)
  }

  return largestValue
}

func largestRegisterValue(registers: [String : Int]) -> Int {
  var largestValue = 0
  for register in registers {
    largestValue = max(largestValue, register.value)
  }

  return largestValue
}

class Tests : XCTestCase {

  func testInput1() {
    let input = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

    let largestValue = processInstructions(input: input)
    XCTAssertEqual(largestValue, 10)
  }

  func test() {
    let input = """
uz inc 134 if hx > -10
qin dec -300 if h <= 1
ubi inc 720 if qin <= 306
si inc -108 if he <= 1
hx inc 278 if hx <= -10
nfi inc 955 if f <= 5
h dec 786 if a == 0
qin dec -965 if f >= -6
hx dec -463 if hx != -6
t dec -631 if ty <= 3
yf dec -365 if ke >= -1
z inc 270 if ke == 0
z inc -391 if nfi < 964
nfi inc -424 if sy >= 10
uz inc 152 if yu > -9
yu dec 137 if wg < 6
ke dec -562 if hx == 463
ke dec 944 if h != -794
ty dec -993 if qin < 1261
a inc 456 if wg <= 8
zwx inc 585 if ty != 2
z dec 744 if zwq <= 5
zwq inc -316 if he > -8
xf inc -614 if hx != 462
hx dec -589 if ke >= -391
xp inc 551 if f != 0
yu inc 640 if a < 464
uz inc -299 if t != 636
t dec -93 if a != 461
yu inc -202 if qin <= 1270
hx dec 552 if zwq < -312
ubi dec -562 if jke <= 4
nfi inc -531 if sy == 0
xf inc -620 if h < -791
ubi dec 164 if jke <= 2
xf inc 715 if xf == -614
si inc 832 if w < 4
xp inc 37 if t >= 721
yu inc -49 if u != 3
wg inc -500 if o > -3
he dec -740 if xp <= 46
ubi dec -946 if u != 0
fkh dec 973 if nfi < 434
zwx inc 796 if si >= 719
hx inc 443 if ty < -2
w inc -515 if wg != -490
xf inc -394 if xf != 109
u inc 176 if sy <= 7
sy inc 170 if w < -513
si dec -699 if fkh == -973
nfi dec 321 if w != -519
yu inc -846 if wg < -496
hx inc 953 if qin < 1270
w dec -394 if u < 183
xf dec -601 if he == 731
zwx inc 267 if h >= -777
zwq inc 781 if f > -3
jke inc 278 if jke >= -3
u inc -7 if u <= 184
zwq inc 449 if wg >= -503
si dec 368 if hx != 1446
h dec -24 if jke >= 282
ke dec -284 if yu < -587
si dec 17 if a > 458
o dec 177 if yu != -594
he inc -925 if ubi >= 1116
ubi inc 544 if zwq <= 915
hx dec -56 if yf < 373
wg dec -613 if z > -866
wg inc -580 if z >= -868
xp dec -445 if ty > 3
yu dec -419 if h < -776
ty dec -75 if xp <= 35
u dec 30 if xf < -283
o inc 69 if uz != -13
f dec 910 if t >= 716
he inc 100 if xf < -296
jke dec 125 if nfi >= 98
yu dec 526 if xp <= 45
fkh dec 708 if zwq >= 918
u dec -397 if w > -131
si dec 417 if u != 533
wg dec 247 if wg == -467
t inc 45 if yu < -700
ty dec 805 if o <= 8
he dec 734 if f < -909
z inc 812 if f > -907
w dec -508 if xf > -300
a inc -375 if uz == -13
zwx inc 160 if w >= 378
o inc -905 if qin < 1264
jke dec -594 if fkh != -971
fkh dec -392 if xp >= 32
t dec 512 if jke != 754
a dec -949 if ke == -98
f inc -70 if a > 1022
f dec -844 if qin > 1261
u dec 212 if sy <= 176
xf dec -779 if w == 396
uz inc -455 if zwx >= 1548
o dec 502 if wg > -723
sy inc 77 if u > 326
uz inc -996 if xp >= 32
nfi dec -355 if hx >= 1502
hx dec 855 if hx <= 1503
qin inc 376 if xf > -296
sy dec -519 if zwq != 916
a dec 459 if a > 1023
ty inc -289 if zwq > 905
he dec -722 if zwx >= 1532
jke inc 656 if sy < 691
u dec -989 if nfi < 466
a inc -377 if zwx >= 1545
sy dec -256 if yf == 365
ubi dec 597 if fkh > -591
xf inc 403 if ty == -1094
z dec 335 if o <= -498
yf dec -707 if zwq < 907
zwq inc 420 if h == -780
h dec -612 if uz >= -1010
hx dec 941 if w != 390
xp dec 345 if u != 1306
xp dec -409 if si <= 641
uz dec 877 if hx <= 574
t dec 615 if f > -142
wg dec 505 if hx >= 566
ubi inc 413 if o >= -506
uz dec -263 if h < -167
f dec 537 if xf != 110
wg dec -762 if sy > 935
o inc 458 if fkh == -591
ubi dec -914 if ubi != 1488
wg inc 203 if sy >= 952
zwq dec -879 if ty == -1094
h inc -676 if xp <= 103
he inc 544 if zwq <= 1795
jke inc 178 if si < 648
xf dec 262 if xp >= 96
sy dec -214 if w >= 383
u inc 88 if uz != -1633
yu dec 375 if t <= -358
wg dec 526 if hx == 568
yf dec 731 if si > 631
he inc -980 if zwq == 1793
ty dec 94 if t > -368
yf dec -849 if yu > -1077
ty dec 889 if f != -139
w dec 37 if f > -137
wg inc 552 if si > 631
he inc -989 if nfi > 457
f dec -500 if zwq > 1785
ubi inc -394 if jke >= 1578
yu dec -370 if o == -498
nfi dec 879 if hx >= 559
nfi inc -280 if h > -853
a inc -746 if wg != -431
h inc -362 if a >= 569
jke dec 740 if si > 631
zwx inc -152 if yf < 489
z inc -442 if wg == -431
t inc -404 if xp != 101
t inc 668 if ty != -2081
f dec 846 if yu >= -1084
xf inc -342 if z < -1638
xf inc 692 if ubi > 2003
qin inc 874 if sy == 1159
t inc -792 if jke < 850
jke dec 263 if ubi < 1997
xf dec -645 if w != 343
u inc -291 if yf < 485
wg inc 948 if fkh != -574
u inc 773 if zwx <= 1392
fkh dec -56 if jke != 836
w dec 436 if qin <= 2521
o inc 769 if ty >= -2079
o dec 457 if zwx < 1392
a dec -422 if fkh != -531
z dec -170 if qin <= 2518
qin inc -569 if ty >= -2077
uz inc -789 if zwq >= 1803
f dec 322 if xp < 103
xf inc -752 if xp <= 108
xp dec -46 if z == -1472
hx dec 378 if zwx <= 1390
ubi dec -746 if ubi < 2008
xf dec -22 if si > 635
h dec -274 if zwq <= 1794
u dec -980 if yf < 485
ty dec -41 if ty <= -2071
t dec -818 if ty != -2043
u dec -764 if nfi < -704
uz inc 233 if sy >= 1152
t dec 552 if xp > 145
h dec 689 if zwq >= 1789
h dec -219 if yf <= 485
uz inc 890 if uz == -1390
zwx dec -399 if z == -1472
jke inc 792 if w <= -85
si dec -991 if nfi == -701
f inc -355 if ke <= -91
ke dec -575 if wg > 516
hx dec -38 if ke <= 482
si inc 478 if he > -1623
ubi dec 18 if o < -185
fkh dec 394 if wg > 521
wg inc 988 if zwx != 1790
hx inc -777 if qin >= 1949
ubi inc 680 if he >= -1618
fkh inc -479 if qin > 1945
zwx dec 704 if jke != 1640
fkh dec -167 if t == -216
yu dec 881 if ubi >= 2724
wg dec -93 if qin >= 1940
nfi dec -763 if o <= -182
t dec -937 if t != -215
u inc 114 if t != 721
ubi dec 547 if uz < -507
qin dec 827 if sy == 1159
w inc -588 if t >= 721
zwx dec 548 if a > 997
a inc 929 if f < -1164
zwq inc -260 if zwx == 1084
ty dec -814 if si > 2100
yf dec 745 if w >= -665
t inc -257 if ke <= 486
u dec 522 if t < 471
hx inc 376 if z == -1472
t dec 996 if si != 2098
uz dec 375 if u >= 2337
fkh dec 823 if xp >= 149
z dec 497 if ty != -1212
t dec 0 if sy >= 1156
xp inc 742 if a != 993
xp dec -160 if f < -1149
zwx dec -988 if z < -1972
he dec -586 if w < -677
yu inc 646 if wg > 1594
jke dec -686 if he < -1616
a dec 375 if jke <= 2323
h dec -719 if ty < -1223
xp dec -169 if uz < -868
o inc 961 if f < -1155
si inc 462 if yu == -1321
hx inc 647 if ke != 487
jke inc 372 if xf == -579
xf inc 188 if f == -1159
a dec 78 if xp < 479
wg inc -818 if f >= -1166
yf inc 994 if h > -1418
fkh inc -812 if xf > -396
qin dec -321 if si == 2116
f inc 830 if nfi >= 58
u inc 24 if h >= -1399
uz inc 881 if jke != 2693
w dec 719 if ke != 479
jke inc 694 if nfi > 61
hx dec 84 if ty > -1224
ty dec -221 if zwq <= 1536
yu dec 236 if zwq == 1540
yu dec -763 if f != -339
a dec 892 if w <= -1391
jke dec -275 if ubi < 2733
nfi inc -121 if zwx < 1086
a inc 809 if t < -526
si inc -997 if jke != 3664
xf dec 787 if hx <= 1158
ty dec -599 if z > -1975
yu inc -534 if a <= 456
ty inc 573 if nfi < -49
sy dec -53 if sy < 1162
wg inc -751 if w == -1393
xf inc 704 if ubi > 2723
si inc 314 if wg != 27
wg inc 607 if h == -1408
zwx dec -263 if a >= 450
qin inc -390 if ke <= 482
ke inc 866 if f <= -330
f inc 79 if uz <= 9
hx dec 683 if z > -1975
si dec 678 if wg > 634
si inc -853 if zwx != 1338
z inc -586 if jke == 3665
he inc 810 if jke != 3656
uz inc -248 if o != 762
fkh dec 334 if xp != 474
w dec 368 if zwq == 1533
t dec -502 if f <= -259
yf inc -523 if u > 2344
yu inc -10 if ke != 477
u dec -918 if u < 2345
uz inc 580 if fkh <= -1979
t inc 144 if ke >= 485
xp dec -366 if zwx == 1338
ubi inc -26 if t < -524
xp inc -776 if he != -813
ubi inc 136 if a != 450
qin inc 13 if xf >= 306
yf dec 536 if uz != 333
hx dec -213 if z > -1978
f inc -224 if zwq >= 1542
wg dec -507 if f <= -246
yu inc -668 if w != -1761
ke inc -680 if t != -533
jke dec -283 if wg == 1143
f dec 870 if o >= 767
jke inc -124 if fkh <= -1976
u dec -567 if w < -1763
o dec 457 if xf <= 312
ty dec 576 if zwx > 1345
qin inc 142 if yu <= -555
ke dec 749 if hx != 702
wg dec 851 if w == -1763
a dec 686 if yf == 933
wg dec -701 if z > -1964
ty inc -877 if zwq < 1541
xf dec -990 if fkh == -1983
ubi inc 0 if ty == -1282
h inc -21 if h != -1400
sy dec -519 if xf != 1303
jke inc 603 if he > -818
ty dec -4 if hx > 699
xp inc 21 if wg > 1138
xp dec 745 if t <= -527
yu dec -614 if hx > 691
a inc -490 if xp != -1018
h dec -723 if jke != 4428
sy inc -594 if yf != 947
hx dec 851 if o <= 761
a dec -345 if t >= -532
ubi inc -359 if f < -1122
jke dec 738 if wg == 1143
ty dec 340 if xp != -1024
nfi inc -786 if w >= -1767
zwq dec 428 if qin == 740
zwq inc 503 if t < -527
zwq dec -98 if si != -113
sy dec 297 if he > -815
u inc -886 if xf < 1313
z dec 105 if h <= -704
yf dec -260 if f != -1127
w dec 920 if w != -1756
a inc 744 if hx == 697
sy inc 262 if t <= -528
si inc 347 if uz <= 347
si inc -188 if o <= 779
h dec 191 if he != -812
xp inc 1000 if sy >= 578
yf inc -563 if ke < -942
xf inc 547 if h > -710
f inc -783 if yu < 73
z dec 394 if h < -705
hx dec 765 if xf != 1856
t inc -817 if wg >= 1140
yu dec -8 if t != -1343
w dec 152 if zwx >= 1338
ubi dec -134 if fkh <= -1978
f dec 841 if jke >= 3679
uz dec -245 if t <= -1349
o dec 151 if a >= 1066
qin inc -219 if w <= -2840
yu inc -323 if yf != 637
sy dec -490 if xp == -24
xp dec -649 if qin != 735
xf inc 39 if nfi != -855
wg inc 581 if sy < 1074
f inc -42 if uz == 583
z inc 506 if he < -808
he dec 568 if he < -804
wg dec 60 if he >= -1381
hx dec -835 if qin < 748
ty inc -593 if qin > 739
wg dec 613 if wg == 1664
h dec 107 if h <= -706
yf dec -40 if a > 1058
fkh inc 511 if ke >= -949
wg dec -812 if yf == 638
xf dec -349 if zwx <= 1356
si dec -614 if ty <= -1868
z inc 28 if he <= -1376
he inc -666 if uz > 579
sy dec 584 if si == 666
sy inc 536 if o > 767
f dec 384 if t != -1342
jke dec 341 if xp != 625
w dec 894 if zwq <= 2139
si dec -871 if yu < -240
he inc 659 if nfi <= -838
qin inc 32 if xf == 2238
nfi dec -165 if z > -1938
h inc 473 if zwq == 2130
qin dec 666 if xf >= 2230
qin inc 469 if si > 1543
t dec 348 if h == -813
si inc 578 if jke != 3684
ke inc 186 if a == 1056
jke inc -61 if xp >= 616
u inc -347 if fkh > -1987
zwx dec -894 if ubi != 2968
h dec -204 if ke <= -768
yu dec -501 if sy != 1024
f dec 393 if wg > 1866
t inc 768 if hx != 766
he dec 459 if fkh == -1980
qin dec -650 if z >= -1933
sy inc 333 if yf <= 642
nfi inc 93 if xf >= 2247
z inc 829 if xp == 620
wg dec -396 if hx != 760
xp inc -71 if hx <= 765
w inc -837 if ty >= -1884
ty dec 380 if z < -1925
h inc -162 if yf <= 642
hx inc 324 if yu > 258
fkh dec -83 if ty > -2258
uz inc 716 if jke <= 3631
w inc -331 if nfi == -680
ubi dec 638 if wg >= 2252
wg inc 139 if ty < -2256
xp dec 21 if he >= -1387
fkh dec 723 if hx < 774
zwx dec -981 if f != -3170
f dec 650 if ty == -2263
f dec -247 if jke == 3623
hx inc -250 if z >= -1938
xp inc -236 if hx == 517
ke dec -408 if ubi == 2332
xp inc -266 if xp < 377
f inc -349 if hx > 509
u inc 945 if jke > 3621
si inc -843 if yu < 252
t dec 747 if ty == -2262
uz inc -684 if xf <= 2228
yu inc 73 if t <= -922
jke dec 435 if xf <= 2238
sy dec -495 if z < -1937
jke inc 293 if jke < 3198
fkh dec -220 if xf <= 2236
z dec -905 if wg >= 2252
wg dec 544 if nfi <= -679
ty inc 807 if a > 1050
qin dec 337 if ty < -1447
xf dec 178 if ty != -1455
nfi dec 119 if a >= 1055
he inc -956 if fkh < -2624
jke dec 224 if t == -923
fkh inc 135 if o != 765
si dec 428 if qin == -229
o inc -985 if si > 1114
he dec 100 if f != -3272
ty inc -707 if xp >= 94
jke dec 551 if w == -4895
yu dec -308 if h <= -968
h inc -429 if wg <= 1718
wg dec 278 if uz == 1299
uz inc -416 if fkh >= -2494
ty dec -876 if qin == -229
sy inc 213 if o >= 774
qin dec 664 if wg > 1434
h inc 273 if uz != 879
zwx inc -611 if ubi != 2334
hx dec 384 if wg >= 1429
he inc -84 if uz == 883
hx inc 23 if yu > 626
si dec 319 if wg == 1433
h dec 343 if ubi <= 2332
yf dec 941 if w == -4895
w inc -450 if u >= 2981
hx inc 435 if xf <= 2065
si dec -198 if xp <= 107
si inc -322 if he < -1467
o dec 21 if xf != 2055
zwx dec 251 if ty > -1284
ke dec 399 if yf > -309
f inc 965 if xf <= 2063
ke dec 488 if o != 749
a dec 163 if a != 1061
hx inc 2 if w != -4887
zwq inc -736 if uz < 888
qin inc 155 if a <= 884
zwx dec 798 if xf == 2060
o dec -566 if jke < 2933
yf inc 536 if u != 2965
f dec -782 if zwx != 575
nfi dec 603 if z <= -1024
f dec -409 if t == -929
zwx inc 140 if hx < 597
hx dec 778 if f > -1120
h dec -327 if wg > 1435
ke inc 146 if zwq <= 1406
sy dec -718 if xf != 2060
yf dec 125 if h < -1140
xf dec -154 if ubi == 2326
a dec 744 if xp > 93
yf inc 837 if si > 982
jke inc 526 if o < 1320
jke inc 919 if he <= -1470
xp dec -626 if xp != 102
h inc 18 if uz != 885
uz dec 39 if h >= -1133
o dec -642 if ubi > 2324
wg inc -500 if uz >= 842
zwx inc -530 if o <= 1956
u dec -334 if ke != -1100
yf dec -231 if o <= 1966
zwx dec 470 if fkh == -2488
zwq inc 345 if xp == 97
ubi dec -357 if fkh >= -2496
nfi dec 923 if ke >= -1100
ke inc 764 if si < 980
t inc 165 if fkh >= -2488
he inc -579 if yu > 626
xp dec 337 if w != -4897
o dec -573 if ubi < 2690
nfi inc -512 if jke != 4384
yf inc 85 if ubi != 2689
u dec 401 if zwq <= 1399
ty inc -528 if uz == 844
xf dec 254 if fkh == -2488
f dec 713 if z >= -1033
xf dec -632 if zwq > 1392
uz inc 166 if f >= -1823
zwq inc -492 if he >= -2051
hx inc 287 if uz != 851
ty inc -935 if wg != 929
h dec 74 if jke <= 4384
zwx inc 43 if hx == 102
jke inc 151 if z < -1025
w dec 839 if t == -764
wg dec -753 if fkh > -2492
o dec -751 if t != -764
ty inc -359 if yu > 635
yu inc -344 if z > -1024
uz dec -356 if xf >= 2440
u dec 797 if yu <= 634
zwq inc 141 if he != -2060
wg dec 365 if a < 156
t dec 382 if u < 2112
f inc 374 if wg == 1325
he dec -912 if qin >= -896
o dec 325 if o >= 2524
ty inc 276 if a > 143
ty inc 507 if zwx > 297
f dec -837 if yu > 627
wg inc 221 if ke != -1100
z dec 423 if si >= 977
o dec 551 if zwq < 1039
f inc 956 if si >= 978
fkh inc -236 if fkh >= -2496
he inc 206 if hx > 99
zwx dec -239 if he < -927
hx inc -246 if wg >= 1545
fkh inc 652 if he > -935
qin inc -429 if yf <= 1184
yu dec -3 if nfi == -2830
zwq dec -582 if sy <= 1359
ubi inc 728 if t >= -1138
fkh inc 327 if xp <= -231
w inc 85 if xp >= -227
t dec 983 if zwq < 1630
xf dec -568 if he >= -939
yu inc -193 if f >= 342
ty inc 210 if he < -925
f inc -345 if uz < 852
nfi dec -444 if h > -1206
xp inc -160 if nfi < -2389
f dec -919 if u > 2107
zwq inc 788 if ke > -1107
ty inc -628 if o != 2201
a inc 506 if jke > 4525
t inc 413 if t > -2130
nfi dec -131 if fkh == -1745
ke inc -475 if wg < 1553
wg dec 955 if jke > 4525
xf dec -41 if hx < -148
ubi dec 105 if uz < 846
h inc -312 if ke < -1568
ubi inc -552 if o != 2201
zwx dec -713 if w < -5732
zwq dec 437 if jke != 4520
a dec -164 if ke >= -1565
hx inc 189 if sy != 1356
o dec 856 if wg != 593
xf inc -563 if h > -1518
wg inc 313 if yf < 1186
he inc -628 if u >= 2102
he dec -537 if xf < 2447
zwq dec -64 if o >= 1345
t inc -465 if wg <= 905
jke inc -495 if u == 2107
qin dec -271 if zwq < 2046
zwx dec -18 if w == -5734
yu inc -376 if h == -1508
zwq dec 537 if zwq == 2044
nfi inc -751 if uz > 837
yf dec 135 if h < -1508
nfi inc 943 if u > 2106
si dec -835 if ty > -2889
zwq dec 334 if zwq > 1502
ubi inc 920 if jke != 4032
ke dec 939 if zwq > 1170
h dec -570 if jke != 4029
yf dec -80 if yf == 1047
h inc 104 if w >= -5731
a inc -173 if sy <= 1355
ke inc 689 if hx > 51
ubi dec -953 if si <= 1829
nfi inc -927 if qin <= -1060
qin inc 84 if qin < -1051
zwx dec -466 if u <= 2103
ubi dec -45 if xp <= -393
w dec 23 if fkh == -1745
u inc 658 if fkh >= -1738
wg dec -262 if uz == 844
f dec -46 if t <= -2176
si dec -622 if hx <= 46
qin dec -617 if uz > 837
uz dec 775 if sy <= 1361
ty inc 675 if t > -2191
xf inc -263 if nfi <= -2076
ke dec -502 if si <= 2436
z inc -704 if jke == 4031
nfi dec -154 if he > -1024
o inc 896 if he > -1027
hx dec 1 if qin != -440
sy inc -236 if h == -936
qin inc 38 if jke > 4021
wg inc 168 if ty == -2209
zwx inc 252 if ty > -2215
ty inc -296 if ty != -2215
a dec -346 if o > 2253
f inc 76 if u >= 2098
xp dec 22 if wg > 1330
xp dec 783 if w > -5754
sy dec -525 if yf >= 1037
xf inc -434 if yf >= 1046
u dec -160 if f < 117
nfi dec -498 if f > 124
fkh inc 654 if zwq >= 1164
yu dec 393 if sy != 1881
zwq dec 966 if qin > -404
zwx dec 146 if jke < 4032
nfi inc -531 if f > 108
si dec 607 if nfi < -2442
w inc -519 if u <= 2274
ke inc -299 if ty < -2502
zwx inc 1000 if nfi > -2456
o inc -746 if u >= 2269
ty inc -694 if ubi < 3941
z inc 37 if uz <= 75
fkh dec 785 if h < -938
sy dec -790 if yu <= 243
nfi dec -952 if u >= 2275
f inc -326 if ubi < 3957
u inc -716 if si >= 1826
xp inc -811 if z >= -2127
xf dec -825 if sy >= 2671
h dec -220 if jke >= 4023
t inc 405 if yf < 1038
qin inc 212 if t > -2188
h inc -738 if t < -2176
sy dec -659 if fkh > -1885
ke dec -94 if qin != -175
a inc 407 if a >= 653
qin inc 628 if h < -1456
a dec 363 if jke < 4033
ty dec 582 if zwx < 2376
zwx inc 93 if ubi < 3952
nfi dec -728 if xf >= 3265
fkh dec -652 if u != 1541
he dec -847 if fkh <= -1233
nfi inc 258 if t != -2185
a inc -703 if f >= -214
w dec 811 if nfi >= -1464
qin dec 41 if ty != -3082
xp inc 308 if uz != 71
zwx inc -688 if wg != 1328
zwq inc 319 if uz <= 61
he inc -906 if xf <= 3268
w inc -941 if ke >= -2722
h inc 74 if uz == 69
zwq inc 187 if uz <= 75
jke dec -909 if he <= -1921
z dec 820 if si < 1838
h inc -463 if uz > 68
ubi inc -3 if hx >= 44
w dec -250 if zwq == 394
t inc -910 if z > -2933
sy dec 917 if ty != -3087
yf inc -88 if nfi >= -1458
wg dec -945 if w < -7770
a inc 700 if zwx < 1778
jke inc 544 if h < -1848
o inc -646 if h <= -1857
h dec -640 if sy > 3324
zwq inc -743 if jke < 5478
w inc 13 if w <= -7770
u dec 806 if si < 1843
w dec 499 if si != 1826
wg inc -535 if uz >= 61
ubi inc -110 if si >= 1845
xf inc -114 if qin > 397
ke inc -509 if wg < 1747
xf dec -591 if t != -2181
ubi dec -5 if ubi < 3952
xf inc -123 if wg != 1744
u inc -84 if nfi < -1452
qin dec 489 if zwq != 387
z dec 399 if o == 2246
yu dec -468 if xf > 3145
zwq inc -882 if si == 1835
h dec 771 if he >= -1937
wg inc 11 if ubi < 3961
a inc -500 if ty < -3081
uz inc 809 if zwx < 1780
yf inc 364 if xf == 3148
o inc 324 if si == 1835
ke dec -113 if f < -215
xf inc 921 if uz > 872
zwx inc 143 if h <= -1974
t dec 163 if o > 2565
o dec -177 if si <= 1838
ubi dec -200 if fkh <= -1219
ke inc -62 if t <= -2340
f inc 546 if si >= 1830
t inc 467 if fkh >= -1226
z inc -229 if he < -1935
hx inc -486 if ubi < 4159
wg inc -290 if o < 2748
zwq dec 950 if ty < -3083
ubi inc 78 if uz != 886
h inc -842 if z <= -3331
ke inc 562 if fkh != -1233
u inc -464 if qin != -94
he inc 960 if wg == 1465
o dec -705 if a < 189
qin dec -769 if wg <= 1467
qin inc -43 if si < 1844
he inc -571 if yf == 1041
o inc 436 if t > -1883
zwq dec 839 if jke == 5484
z dec -233 if u <= 202
wg inc -313 if hx >= -451
ty inc 552 if zwx < 1913
ke inc 204 if si > 1826
yf inc -924 if si < 1840
u dec -30 if a < 197
z dec -753 if ke == -2523
qin dec -755 if uz <= 871
ke inc -787 if z > -2357
si inc -676 if qin <= 643
hx dec 301 if zwq != -2277
xp dec 617 if z <= -2346
ubi inc -445 if xp != -1529
h inc -784 if qin == 640
ty dec 524 if wg < 1143
t inc 313 if yu >= 701
zwq dec -716 if zwq < -2279
ke inc 258 if sy == 3332
wg dec -495 if w >= -8269
nfi inc -327 if uz >= 877
f inc -940 if zwx != 1923
jke inc -886 if uz <= 868
yu inc -619 if f >= -595
he inc -738 if h != -3613
fkh dec 354 if jke != 5486
h inc -6 if nfi != -1783
jke inc -691 if zwx < 1919
uz inc 142 if nfi == -1788
wg dec -303 if a > 186
jke dec -797 if yf >= 115
a dec -4 if xf <= 4075
xp dec -517 if zwx < 1919
xp inc -983 if ke >= -3050
f dec -83 if si != 1159
uz dec 110 if nfi >= -1793
si inc 219 if fkh != -1581
wg dec 946 if w < -8263
zwx dec -809 if nfi >= -1791
uz inc 664 if ty >= -3089
xp dec -210 if zwq != -2272
z inc -359 if ke > -3045
ke dec 863 if o == 3183
ty inc -748 if yu == 708
ty dec 539 if uz >= 1571
xp dec 666 if zwq < -2271
z dec 282 if h == -3615
u inc -702 if hx < -437
o dec -741 if yf > 114
h dec -238 if o > 3917
jke inc -344 if yf <= 118
qin dec -774 if qin < 648
xf dec -228 if uz < 1580
ubi inc 428 if f <= -602
yu inc -964 if xp < -1479
wg dec -725 if he <= -2273
sy inc 913 if ty <= -4378
xf inc 936 if nfi < -1796
yf inc 100 if xp > -1481
jke dec 876 if zwq == -2277
yu dec 373 if w > -8269
hx dec -542 if fkh >= -1572
xf inc 41 if yf >= 215
w inc -491 if qin < 1422
jke inc 643 if a == 200
si inc -74 if he == -2278
qin dec 842 if jke >= 5004
hx inc -797 if jke != 5009
sy dec 444 if uz != 1577
jke inc -606 if hx != -1244
qin inc -381 if sy > 2886
yf dec -922 if qin >= 184
ke inc 689 if ke > -3920
yf dec 850 if yf <= 1141
yu inc -120 if w >= -8750
ke inc 613 if uz != 1582
hx inc 620 if xf <= 4351
sy inc -631 if hx > -627
xp dec -781 if fkh <= -1569
nfi dec 196 if sy >= 2266
f dec -69 if yu >= 330
o inc 492 if ke > -2616
sy dec -837 if sy <= 2262
xf dec 862 if a != 203
yf inc -182 if zwq < -2272
wg inc -534 if o != 4406
si dec 788 if h > -3381
ty inc -85 if zwx == 2727
w inc 942 if hx == -619
o inc -880 if a >= 200
uz inc 654 if zwx <= 2732
u dec -710 if he != -2278
zwq dec -920 if f < -530
jke dec 21 if z > -2644
qin dec 529 if f != -537
jke inc -901 if u <= -470
w inc 900 if nfi <= -1783
ke inc 624 if o == 3536
wg dec 784 if qin == -338
yf dec 682 if w <= -6921
a dec 593 if sy <= 3097
xf dec 442 if hx != -616
nfi inc 852 if z == -2634
yf dec -338 if zwx < 2732
qin dec 511 if ty > -4451
xf dec -512 if si >= 508
u dec 172 if xf <= 3558
w dec -255 if jke >= 3476
zwq inc -879 if wg >= 408
zwx inc -498 if si < 518
xp dec -405 if f == -536
qin inc -76 if a != -391
nfi inc -734 if a >= -397
h dec -940 if o < 3541
o dec -41 if qin != -412
f dec -736 if h < -2436
fkh inc -180 if yu > 327
u inc 73 if ke < -1981
xf inc 932 if he > -2288
wg inc 103 if fkh < -1754
fkh inc 872 if fkh < -1757
xp dec 679 if si != 526
z inc 486 if w > -6661
jke inc -909 if f == 200
qin dec 443 if uz < 2223
f dec -653 if hx > -626
qin dec -106 if nfi >= -1675
uz inc 969 if uz == 2228
t inc -474 if w > -6660
xf inc -898 if f <= 854
zwq inc -246 if a <= -398
yf dec -931 if nfi <= -1665
h inc 770 if ty > -4461
u inc -20 if z == -2148
wg inc -317 if z == -2138
t inc -73 if a >= -384
xp dec -372 if fkh > -885
hx dec -592 if yu < 342
a inc 357 if uz == 3197
zwq dec 13 if si <= 520
h inc 97 if f <= 847
qin inc 133 if yu < 341
ty inc -437 if ke > -1988
ty dec -281 if yf <= 1374
uz inc 0 if xf < 3595
o inc -303 if fkh < -876
h inc -594 if yu == 335
zwq dec 422 if qin <= -173
xf dec 44 if u == -594
hx dec -264 if sy != 3087
si inc 539 if qin == -181
ke dec -667 if si < 523
uz dec 309 if he < -2269
yf inc -394 if zwx <= 2238
o inc -572 if w <= -6664
z inc 241 if t <= -2045
qin dec 285 if a < -27
xp dec 413 if zwq < -2667
ubi inc 317 if t >= -2033
yu inc -173 if sy <= 3094
nfi inc -262 if zwq <= -2669
a inc 98 if uz > 2878
sy inc 513 if wg == 514
yu inc -841 if ke != -1331
ke inc -426 if ubi != 4220
he dec 187 if he != -2277
fkh dec 717 if zwq >= -2661
f dec -191 if uz <= 2893
zwx dec -661 if yf != 972
fkh dec -112 if ubi <= 4220
ty dec 800 if fkh >= -775
sy inc 981 if xp > -1389
xp inc 893 if wg <= 510
nfi inc 944 if qin != -458
zwq inc -250 if qin != -454
uz inc -398 if jke != 2577
w dec -486 if hx >= 230
z dec -205 if xf < 3551
f dec 777 if xf == 3542
wg inc 667 if zwx != 2880
z dec -851 if ty != -5258
w dec 653 if t < -2036
he inc 459 if z > -1091
yf dec 331 if si != 516
zwx dec 327 if qin < -452
xf dec -293 if wg == 1181
fkh inc -469 if yu >= -679
a dec 440 if f >= 261
he dec -292 if xf >= 3833
xf inc 405 if uz == 2490
si inc 825 if sy <= 4588
ubi dec 306 if z != -1085
fkh dec -949 if jke < 2577
zwx dec 703 if o <= 3280
hx inc 951 if o >= 3268
ke inc 134 if z != -1088
w inc -621 if o <= 3274
sy inc 883 if he == -2177
w dec -900 if jke >= 2586
sy inc -56 if xf >= 4232
si dec -994 if zwx == 1860
u inc 726 if yu <= -675
si inc 989 if u <= 140
yf dec 609 if si > 3324
jke inc -872 if si < 3323
hx dec 873 if ubi < 3917
xp dec -284 if o <= 3280
zwq dec -69 if o <= 3280
yf inc 921 if he < -2169
wg dec -859 if h >= -2257
nfi inc -605 if u != 132
fkh inc -567 if yu > -682
w dec 260 if ty < -5262
si dec -809 if h != -2258
f dec 604 if qin > -460
nfi dec 603 if ke < -1609
jke inc -568 if nfi == -1583
ke dec 694 if a <= -378
t inc -188 if yu != -681
fkh dec 328 if w >= -7445
fkh inc 27 if si >= 4126
o dec -358 if f >= 267
xf inc -895 if ubi < 3913
fkh dec 829 if ke < -2315
qin dec 41 if uz == 2490
sy inc 649 if f != 259
wg inc 807 if t < -2224
ubi inc 580 if w == -7446
jke dec -195 if zwx == 1860
f inc -722 if si < 4131
xp inc -694 if xp > -1097
yu inc 810 if h == -2261
f inc -521 if uz == 2499
sy inc -534 if xp >= -1107
zwq dec 330 if nfi <= -1582
ke dec -846 if xp == -1098
h inc -585 if o != 3639
nfi inc 135 if yu <= 137
jke inc -779 if u != 138
a inc 509 if f > 265
uz inc -421 if h != -2848
he inc -36 if h != -2840
o inc 458 if wg == 1988
h dec -88 if wg > 1987
yf dec 98 if a == 131
h inc 729 if si != 4134
xp inc -973 if xf == 3345
zwx dec -483 if z < -1089
hx inc -171 if o > 4089
fkh dec -256 if nfi > -1462
xp inc 578 if h >= -2028
xp dec -194 if uz < 2062
ubi inc -933 if xf == 3347
h dec 944 if zwq == -3182
u dec -139 if ubi >= 4481
qin dec 581 if jke != 1998
ke dec 532 if yf >= 1805
sy inc -101 if fkh > -574
w dec -934 if ubi < 4491
t dec 799 if sy <= 4638
he inc -446 if xp > -2075
"""
    let largestValue = processInstructions(input: input)
    print("largestValue: \(largestValue)")
  }
}

Tests.defaultTestSuite.run()
