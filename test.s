// Initiate
// huffman table Y C
x1 = 0 + x0
x2 = 250 + x0
x3 = 16 + x0
x4 = 0 + x0
x5 = 11 + x0
x6 = 16 + x0
while x2 >= x1,
    mem[x1 + 275] = x0
    mem[x1 + 801] = x0
    x7 = 1 + x0
    while x7 < x5,
        x8 = x7 + x1
        mem[x8 + 275] = x3
        mem[x8 + 801] = x3
        x7 = x7 + 1
    endwhile
    while x7 < x6,
        x8 = x7 + x1
        mem[x8 + 275] = x0
        mem[x8 + 801] = x0
        x7 = x7 + 1
    endwhile
    x1 = x1 + 16
endwhile

// quantization table
x1 = 1052 + x0
x2 = 1179 + x0
x3 = 65536
while x2 >= x1,
    mem[x1 + 0] = x3
    x1 = x1 + 1
endwhile

define // save to the memory file
    1    <- 2
    2    <- 3
    3    <- 4
    4    <- 5
    5    <- 6
    6    <- 14
    7    <- 30
    8    <- 62
    9    <- 126
    10   <- 254
    11   <- 510
    12   <- 2
    13   <- 3
    14   <- 3
    15   <- 3
    16   <- 3
    17   <- 3
    18   <- 4
    19   <- 5
    20   <- 6
    21   <- 7
    22   <- 8
    23   <- 9
    24   <- 10
    26   <- 1
    27   <- 4
    28   <- 11
    29   <- 26
    30   <- 120
    31   <- 248
    32   <- 1014
    33   <- 65410
    34   <- 65411
    41   <- 12
    42   <- 27
    43   <- 121
    44   <- 502
    45   <- 2038
    46   <- 65412
    47   <- 65413
    48   <- 65414
    49   <- 65415
    50   <- 65416
    57   <- 28
    58   <- 249
    59   <- 1015
    60   <- 4084
    61   <- 65417
    62   <- 65418
    63   <- 65419
    64   <- 65420
    65   <- 65421
    66   <- 65422
    73   <- 58
    74   <- 503
    75   <- 4085
    76   <- 65423
    77   <- 65424
    78   <- 65425
    79   <- 65426
    80   <- 65427
    81   <- 65428
    82   <- 65429
    89   <- 59
    90   <- 1016
    91   <- 65430
    92   <- 65431
    93   <- 65432
    94   <- 65433
    95   <- 65434
    96   <- 65435
    97   <- 65436
    98   <- 65437
    105  <- 122
    106  <- 2039
    107  <- 65438
    108  <- 65439
    109  <- 65440
    110  <- 65441
    111  <- 65442
    112  <- 65443
    113  <- 65444
    114  <- 65445
    121  <- 123
    122  <- 4086
    123  <- 65446
    124  <- 65447
    125  <- 65448
    126  <- 65449
    127  <- 65450
    128  <- 65451
    129  <- 65452
    130  <- 65453
    137  <- 250
    138  <- 4087
    139  <- 65454
    140  <- 65455
    141  <- 65456
    142  <- 65457
    143  <- 65458
    144  <- 65459
    145  <- 65460
    146  <- 65461
    153  <- 504
    154  <- 32704
    155  <- 65462
    156  <- 65463
    157  <- 65464
    158  <- 65465
    159  <- 65466
    160  <- 65467
    161  <- 65468
    162  <- 65469
    169  <- 505
    170  <- 65470
    171  <- 65471
    172  <- 65472
    173  <- 65473
    174  <- 65474
    175  <- 65475
    176  <- 65476
    177  <- 65477
    178  <- 65478
    185  <- 506
    186  <- 65479
    187  <- 65480
    188  <- 65481
    189  <- 65482
    190  <- 65483
    191  <- 65484
    192  <- 65485
    193  <- 65486
    194  <- 65487
    201  <- 1017
    202  <- 65488
    203  <- 65489
    204  <- 65490
    205  <- 65491
    206  <- 65492
    207  <- 65493
    208  <- 65494
    209  <- 65495
    210  <- 65496
    217  <- 1018
    218  <- 65497
    219  <- 65498
    220  <- 65499
    221  <- 65500
    222  <- 65501
    223  <- 65502
    224  <- 65503
    225  <- 65504
    226  <- 65505
    233  <- 2040
    234  <- 65506
    235  <- 65507
    236  <- 65508
    237  <- 65509
    238  <- 65510
    239  <- 65511
    240  <- 65512
    241  <- 65513
    242  <- 65514
    249  <- 65515
    250  <- 65516
    251  <- 65517
    252  <- 65518
    253  <- 65519
    254  <- 65520
    255  <- 65521
    256  <- 65522
    257  <- 65523
    258  <- 65524
    264  <- 2041
    265  <- 65525
    266  <- 65526
    267  <- 65527
    268  <- 65528
    269  <- 65529
    270  <- 65530
    271  <- 65531
    272  <- 65532
    273  <- 65533
    274  <- 65534
    275  <- 4
    276  <- 2
    277  <- 2
    278  <- 3
    279  <- 4
    280  <- 5
    281  <- 7
    282  <- 8
    283  <- 10
    292  <- 4
    293  <- 5
    294  <- 7
    295  <- 9
    296  <- 11
    308  <- 5
    309  <- 8
    310  <- 10
    311  <- 12
    324  <- 6
    325  <- 9
    326  <- 12
    340  <- 6
    341  <- 10
    356  <- 7
    357  <- 11
    372  <- 7
    373  <- 12
    388  <- 8
    389  <- 12
    404  <- 9
    405  <- 15
    420  <- 9
    436  <- 9
    452  <- 10
    468  <- 10
    484  <- 11
    515  <- 11
    527  <- 1
    528  <- 2
    529  <- 6
    530  <- 14
    531  <- 30
    532  <- 62
    533  <- 126
    534  <- 254
    535  <- 510
    536  <- 1022
    537  <- 2046
    538  <- 2
    539  <- 2
    540  <- 2
    541  <- 3
    542  <- 4
    543  <- 5
    544  <- 6
    545  <- 7
    546  <- 8
    547  <- 9
    548  <- 10
    549  <- 11
    551  <- 1
    552  <- 4
    553  <- 10
    554  <- 24
    555  <- 25
    556  <- 56
    557  <- 120
    558  <- 500
    559  <- 1014
    560  <- 4084
    567  <- 11
    568  <- 57
    569  <- 246
    570  <- 501
    571  <- 2038
    572  <- 4085
    573  <- 65416
    574  <- 65417
    575  <- 65418
    576  <- 65419
    583  <- 26
    584  <- 247
    585  <- 1015
    586  <- 4086
    587  <- 32706
    588  <- 65420
    589  <- 65421
    590  <- 65422
    591  <- 65423
    592  <- 65424
    599  <- 27
    600  <- 248
    601  <- 1016
    602  <- 4087
    603  <- 65425
    604  <- 65426
    605  <- 65427
    606  <- 65428
    607  <- 65429
    608  <- 65430
    615  <- 58
    616  <- 502
    617  <- 65431
    618  <- 65432
    619  <- 65433
    620  <- 65434
    621  <- 65435
    622  <- 65436
    623  <- 65437
    624  <- 65438
    631  <- 59
    632  <- 1017
    633  <- 65439
    634  <- 65440
    635  <- 65441
    636  <- 65442
    637  <- 65443
    638  <- 65444
    639  <- 65445
    640  <- 65446
    647  <- 121
    648  <- 2039
    649  <- 65447
    650  <- 65448
    651  <- 65449
    652  <- 65450
    653  <- 65451
    654  <- 65452
    655  <- 65453
    656  <- 65454
    663  <- 122
    664  <- 2040
    665  <- 65455
    666  <- 65456
    667  <- 65457
    668  <- 65458
    669  <- 65459
    670  <- 65460
    671  <- 65461
    672  <- 65462
    679  <- 249
    680  <- 65463
    681  <- 65464
    682  <- 65465
    683  <- 65466
    684  <- 65467
    685  <- 65468
    686  <- 65469
    687  <- 65470
    688  <- 65471
    695  <- 503
    696  <- 65472
    697  <- 65473
    698  <- 65474
    699  <- 65475
    700  <- 65476
    701  <- 65477
    702  <- 65478
    703  <- 65479
    704  <- 65480
    711  <- 504
    712  <- 65481
    713  <- 65482
    714  <- 65483
    715  <- 65484
    716  <- 65485
    717  <- 65486
    718  <- 65487
    719  <- 65488
    720  <- 65489
    727  <- 505
    728  <- 65490
    729  <- 65491
    730  <- 65492
    731  <- 65493
    732  <- 65494
    733  <- 65495
    734  <- 65496
    735  <- 65497
    736  <- 65498
    743  <- 506
    744  <- 65499
    745  <- 65500
    746  <- 65501
    747  <- 65502
    748  <- 65503
    749  <- 65504
    750  <- 65505
    751  <- 65506
    752  <- 65507
    759  <- 2041
    760  <- 65508
    761  <- 65509
    762  <- 65510
    763  <- 65511
    764  <- 65512
    765  <- 65513
    766  <- 65514
    767  <- 65515
    768  <- 65516
    775  <- 16352
    776  <- 65517
    777  <- 65518
    778  <- 65519
    779  <- 65520
    780  <- 65521
    781  <- 65522
    782  <- 65523
    783  <- 65524
    784  <- 65525
    790  <- 1018
    791  <- 32707
    792  <- 65526
    793  <- 65527
    794  <- 65528
    795  <- 65529
    796  <- 65530
    797  <- 65531
    798  <- 65532
    799  <- 65533
    800  <- 65534
    801  <- 2
    802  <- 2
    803  <- 3
    804  <- 4
    805  <- 5
    806  <- 5
    807  <- 6
    808  <- 7
    809  <- 9
    810  <- 10
    811  <- 12
    818  <- 4
    819  <- 6
    820  <- 8
    821  <- 9
    822  <- 11
    823  <- 12
    834  <- 5
    835  <- 8
    836  <- 10
    837  <- 12
    838  <- 15
    850  <- 5
    851  <- 8
    852  <- 10
    853  <- 12
    866  <- 6
    867  <- 9
    882  <- 6
    883  <- 10
    898  <- 7
    899  <- 11
    914  <- 7
    915  <- 11
    930  <- 8
    946  <- 9
    962  <- 9
    978  <- 9
    994  <- 9
    1010 <- 11
    1026 <- 14
    1041 <- 10
    1042 <- 15
    1180 <- 51471
    1181 <- 30385
    1182 <- 16054
    1183 <- 8149
    1184 <- 4090
    1185 <- 2047
    1186 <- 1023
    1198 <- 46341
    1199 <- 65536
    1200 <- 12868
    1208 <- 551903297
    1209 <- 1211180777
    1210 <- 210453397
    1211 <- -317827579
    1212 <- -624917741
    1213 <- 942745321
    1214 <- -790273982
    1215 <- -152471339

endefine

// Main function
// ------------------------------------------------------------------
// RegFile Work Aera 1: Re-Order Minimum coded (MCU)
// Avialiable register remaind: x23
// ------------------------------------------------------------------
// blocks: 1216 Y 1280 U 1344 V 1408 Block 1472 MidBlock
x20 = 206800
x21 = 2000
x28 = mem[x20 + 0]
x29 = mem[x20 + 1]
mem[x0 + 1187] = x28
mem[x0 + 1188] = x29
x1 = 4
x28 = x28 >> x1
x27 = x29 >> x1
mem[x0 + 1189] = x28
mem[x0 + 1190] = x27

x1 = 0
x2 = 0
x3 = 0
x4 = 0
x5 = 0
x6 = 0
x26 = 16
x25 = 8
x24 = 2

while x2 != x28,
    x10 = x26 *l x29
    x10 = x10 *l x2
    x10 = x10 + 2
    while x1 != x27,
        x11 = x26 *l x1
        x11 = x11 + x10
        while x4 != x24,
            x12 = x25 *l x29
            x12 = x12 *l x4 
            x12 = x12 + x11
            while x3 != x24,
                x13 = x25 *l x3
                x13 = x13 + x12
                while x5 != x25,
                    x14 = x5 + x13
                    while x6 != x25,
                        x15 = x29 *l x6
                        x15 = x15 + x14
                        x15 = x20 + x15
                        x19 = 255 + x0
                        x16 = mem[x15 + 0] // uart[x15]
                        x16 = x16 >> x26
                        x16 = x16 & x19
                        x17 = mem[x15 + 0] // uart[x15]
                        x17 = x17 >> x25
                        x17 = x17 & x19
                        x18 = mem[x15 + 0] // uart[x15]
                        x18 = x18 & x19
                        x19 = mem[x0 + 1208]
                        x19 = x19 *h x16
                        x30 = mem[x0 + 1209]
                        x30 = x30 *h x17
                        x19 = x19 + x30
                        x30 = mem[x0 + 1210]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 16
                        x22 = x19 + 0  // Y
                        x19 = mem[x0 + 1211]
                        x19 = x19 *h x16
                        x30 = mem[x0 + 1212]
                        x30 = x30 *h x17
                        x19 = x19 + x30
                        x30 = mem[x0 + 1213]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 128
                        x19 = x19 << x25
                        x22 = x19 + x22 // Cb
                        x19 = mem[x0 + 1214]
                        x19 = x19 *h x17
                        x30 = mem[x0 + 1213]
                        x30 = x30 *h x16 
                        x19 = x19 + x30
                        x30 = mem[x0 + 1215]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 128
                        x19 = x19 << x26
                        x22 = x19 + x22 // Cr
                        mem[x21 + 0] = x22
                        x21 = x21 + 1

                        x6 = x6 + 1
                    endwhile
                    x6 = 0 + x0
                    x5 = x5 + 1
                endwhile
                x5 = 0 + x0
                x3 = x3 + 1
            endwhile
            x3 = 0 + x0
            x4 = x4 + 1
        endwhile
        x4 = 0 + x0
        x1 = x1 + 1
    endwhile
    x1 = 0 + x0
    x2 = x2 + 1
endwhile

// clear uart
x10 = 206800
x11 = 207826
while x10 != x11,
    mem[x10 + 0] = x0
    x10 = x10 + 1
endwhile

// ------------------------------------------------------------------
// RegFile Work Aera 2: Block Process and Huffman endcode
// ------------------------------------------------------------------

// Function used regiters
x26 = 32 // Huffman code stack space very 32 bit
x25 = 206800 // UART interface, where to save Huffman code
// x28 return key and mode
// x29 differential DC value

// Function Entry
x0 == x0 goto EndBlockProcess
BlockProcess:

// ------------------------------------
// 8x8 matrix subtraction: Sub Area 1
// ------------------------------------

x1 = 0 + x0
x2 = 64 + x0
while x1 != x2,
    x3 = mem[x1 + 1408]
    x3 = x3 + -128
    mem[x1 + 1472] = x3
    mem[x1 + 1408] = x0
    x1 = x1 + 1
endwhile

// debug
x1 = 111
x2 = 411600
mem[x2 + 0] = x1

// ------------------------------------
// Discrete Cosine Transform: Sub Area 2
// ------------------------------------

// SubFunction: CORDIC cosine
x0 == x0 goto ENDCORDIC
CORDIC:
    x8 = 0 + x0
    x20 = 205887  // dust will help
    x21 = -411775 // dust will help
    x22 = 102944  // dust will help
    while x20 < x9, 
        x9 = x9 + x21
    endwhile
    if x22 < x9,
        x8 = 1 + x0
        x20 = x20 ^ -1
        x20 = x20 + 1
        x9 = x9 + x20
        x0 == x0 goto endelse2
    endif
        x22 = x22 ^ -1 
        x22 = x22 + 1
        if x9 < x22,
            x8 = 1 + x0
            x9 = x9 + x20
        endif
    endelse2:
    x10 = 0 + x0
    mem[x0 + 1191] = x0
    mem[x0 + 1192] = x0
    mem[x0 + 1193] = x0
    mem[x0 + 1194] = x0
    mem[x0 + 1195] = x0
    mem[x0 + 1196] = x0
    mem[x0 + 1197] = x0
    x7 = 0 + x0
    x22 = 7 + x0
    while x7 != x22,
        if x9 < x10,
            x20 = mem[x7 + 1180]
            x20 = x20 ^ -1
            x20 = x20 + 1
            x10 = x10 + x20
            x21 = 1 + x0
            mem[x7 + 1191] = x21
            x0 == x0 goto endelse3
        endif
            x20 = mem[x7 + 1180]
            x10 = x10 + x20
            mem[x7 + 1191] = x0
        endelse3:
        x7 = x7 + 1
    endwhile
    x1 = 39797 // dust will help
    x2 = 0 + x0
    x7 = 6 + x0
    x21 = 1 + x0
    x23 = -1 + x0
    while x7 != x23,
        x20 = mem[x7 + 1191]
        x22 = x2 >> x7
        if x20 == x21,
            x22 = x22 ^ -1
            x22 = x22 + 1
            x1 = x1 + x22
            x22 = x1 >> x7
            x0 == x0 goto endelse4
        endif
            x1 = x1 + x22
            x22 = x1 >> x7
            x22 = x22 ^ -1
            x22 = x22 + 1
        endelse4:
        x2 = x22 + x2
        x7 = x7 + -1
    endwhile
    if x8 == x21,
        x1 = x1 ^ -1
        x1 = x1 + 1
    endif
// CORDIC return gate
// return key: x24
x21 = 1 + x0
x24 == x0 goto CORDICGate0
x24 == x21 goto CORDICGate1
ENDCORDIC:

// DCT
x15 = 8 + x0
x17 = 2 + x0
x3 = 0 + x0
x4 = 0 + x0
x5 = 0 + x0
x6 = 0 + x0
while x3 != x15,
    if x3 == x0,
        x11 = mem[x0 + 1198]
        x0 == x0 goto endelse5
    endif
        x11 = mem[x0 + 1199]
    endelse5:
    while x4 != x15,
        if x4 == x0,
            x12 = mem[x0 + 1198]
            x0 == x0 goto endelse6
        endif
            x12 = mem[x0 + 1199]
        endelse6:
        x14 = 0 + x0
        while x5 != x15,
            while x6 != x15,
                x16 = x5 *l x15
                x16 = x16 + x6
                x13 = mem[x16 + 1472]
                x9 = x17 *l x5
                x9 = x9 + 1
                x9 = x9 *l x3
                x23 = mem[x0 + 1200]
                x9 = x9 *l x23
                x24 = 0 + x0 // return key
                x0 == x0 goto CORDIC // call function
                CORDICGate0: // return gate
                x13 = x13 *l x1
                x13 = x13 >> x15
                x9 = x17 *l x6
                x9 = x9 + 1
                x9 = x9 *l x4
                x23 = mem[x0 + 1200]
                x9 = x9 *l x23
                x24 = 1 + x0// return key
                x0 == x0 goto CORDIC // call function
                CORDICGate1: // return gate
                x13 = x13 *l x1
                x13 = x13 >> x15
                x14 = x14 + x13
                x6 = x6 + 1
            endwhile
            x6 = 0 + x0
            x5 = x5 + 1
        endwhile
        x16 = x11 *h x12
        x13 = x11 *l x12
        x18 = 15 + x0
        x16 = x16 << x18
        x18 = x18 + 1
        x13 = x13 >> x18
        x13 = x13 | x16
        x13 = x13 *h x14
        x18 = 3 + x0
        x13 = x13 >> x18
        if x13 != x0,
            x13 = x13 + 1
        endif
        x16 = x3 *l x15
        x16 = x4 + x16
        mem[x16 + 1408] = x13
        x5 = 0 + x0
        x4 = x4 + 1
    endwhile
    x4 = 0 + x0
    x3 = x3 + 1
endwhile

// ------------------------------------
// Quantization: Sub Area 3
// ------------------------------------

x2 = 1052 + x0
if x28 == x0,
    x2 = 1116 + x0
endif
x1 = 0 + x0
x5 = 64 + x0 
x7 = 16 + x0
while x1 != x5,
    x6 = x1 + x2
    x3 = mem[x6 + 0]
    x4 = mem[x1 + 1408]
    x3 = x3 *l x4
    x3 = x3 >> x7
    mem[x1 + 1408] = x0
    mem[x1 + 1472] = x3
    x1 = x1 + 1
endwhile

// debug
x1 = 222
x2 = 411600
mem[x2 + 0] = x1

// ------------------------------------
// Zigzag Scan: Sub Area 4
// ------------------------------------

x1 = 0 + x0
x2 = 0 + x0
x5 = 0 + x0
x3 = 1 + x0
x4 = 0 + x0
x6 = 7 + x0
x7 = 8 + x0
x9 = 1 + x0
// Differential DC Value:
x27 = mem[x0 + 1472]
x29 = x29 ^ -1
x29 = x29 + 1
x11 = x27 + x29
mem[x0 + 1408] = x11
while x0 == x0,
    // special if structure
    x1 == x0 goto iformark0
    x1 == x6 goto iformark0
    x0 == x0 goto endiformark0
    iformark0:
        x2 = x2 + 1
        x4 = 1 + x0
        x0 == x0 goto endelseifmark0
    endiformark0:
    x2 == x0 goto iformark1
    x2 == x6 goto iformark1
    x0 == x0 goto endelseifmark0
    iformark1:
        x1 = x1 + 1
        x4 = 1 + x0
    endelseifmark0:
    if x4 == x9,
        x4 = 0 + x0
        x3 = x3 ^ -1
        x3 = x3 + 1
        x5 = x5 + 1
        x12 = x2 *l x7
        x12 = x12 + x1
        x11 = mem[x12 + 1472]
        mem[x5 + 1408] = x11
    endif
    // if x1 == x6 and x2 == x6:
    x2 != x6 goto ifandmark0
    x1 != x6 goto ifandmark0
        x0 == x0 goto breakmark0
    ifandmark0:
    x5  = x5  + 1
    x13 = x3  ^ -1
    x13 = x13 + 1
    x1  = x13 + x1
    x2  = x2  + x3
    x12 = x2 *l x7
    x12 = x12 + x1
    x11 = mem[x12 + 1472]
    mem[x5 + 1408] = x11
endwhile
breakmark0:

// debug
x1 = 333 
x2 = 411600
mem[x2 + 0] = x1

// ------------------------------------
// Huffman Encode: Sub Area 6
// ------------------------------------

// 0 for Luminace
if x28 == x0,
    x10 = 0 + x0
    x11 = 12 + x0
    x12 = 24 + x0
    x13 = 275 + x0
    x0 == x0 goto endelse7
endif
    x10 = 526 + x0
    x11 = 538 + x0
    x12 = 550 + x0
    x13 = 801 + x0
endelse7:

// SubFunction: Get data and size
x0 == x0 goto EndGetDataAndSize
GetDataAndSize:
    x14 = 0 + x0
    x15 = 0 + x0
    x17 = 1 + x0
    if x1 < x0,
        x1 = x1 ^ -1
        x1 = x1 + 1
        x15 = 1 + x0
    endif
    x2 = x1 + 0
    while x1 != x0,
        x1 = x1 >> x17
        x14 = x14 + 1
    endwhile
    x3 = x14 + 0
    if x15 == x17,
        x16 = 0 + x0
        while x14 != x0,
            x16 = x16 << x17
            x16 = x16 + 1
            x14 = x14 + -1
        endwhile
        x2 = x2 ^ -1
        x2 = x2 & x16
    endif

// Get data and size return gate
// return key: x24
x19 = 1 + x0
x24 == x0 goto GetDataAndSizeReturnGate0
x24 == x19 goto GetDataAndSizeReturnGate1
EndGetDataAndSize:

// SubFunction: Push Huffman bit stack
x0 == x0 goto EndPushHuffmanBitStack
PushHuffmanBitStack:
    x14 = mem[x25 + 0]
    if x26 >= x5,
        x5 = x5 ^ -1
        x5 = x5 + 1
        x18 = x26 + x5
        x18 = x4 << x18
        x14 = x14 + x18
        mem[x25 + 0] = x14
        x26 = x26 + x5
        x0 == x0 goto endelse8
    endif
        x19 = x26 ^ -1
        x19 = x19 + 1
        x18 = x5 + x19
        x18 = x4 >> x18
        x14 = x14 | x18
        mem[x25 + 0] = x14 
        x5 = x5 + x19
        x15 = x5 + 0
        x16 = 0 + x0
        x19 = x0 + 1
        while x15 != x0,
            x16 = x16 << x19
            x16 = x16 + 1
            x15 = x15 + -1
        endwhile
        x16 = x16 & x4
        x19 = x5 ^ -1
        x19 = x19 + 1
        x26 = 32 + x19
        x17 = x16 << x26
        x25 = x25 + 1
        mem[x25 + 0] = x17
    endelse8:

// Push Huffman bit stack return gate
// return key: x23
x19 = 1 + x0
x18 = 2 + x0
x5 = 3 + x0
x23 == x0 goto PushHuffmanBitStackReturnGate0
x23 == x19 goto PushHuffmanBitStackReturnGate1
x23 == x18 goto PushHuffmanBitStackReturnGate2
x23 == x5 goto PushHuffmanBitStackReturnGate3
EndPushHuffmanBitStack:

// DC
x1 = mem[x0 + 1408]
x24 = x0 + 0
x0 == x0 goto GetDataAndSize
GetDataAndSizeReturnGate0:
x14 = x10 + x3
x6 = mem[x14 + 0]
x14 = x11 + x3
x7 = mem[x14 + 0]
x4 = x6 << x3
x4 = x4 + x2
x5 = x3 + x7
x23 = x0 + 0
x0 == x0 goto PushHuffmanBitStack
PushHuffmanBitStackReturnGate0:

// AC
x9 = 0 + x0
x20 = 1 + x0
x21 = 64 + x0
x22 = 15 + x0
while x20 != x21,
    x15 = mem[x20 + 1408]
    if x15 == x0,
        x9 = x9 + 1
        x0 == x0 goto endelse9
    endif
        while x22 < x9, // zeros over than 15
            x9 = x9 + -16
            x4 = mem[x12 + 240]
            x5 = mem[x13 + 240]
            x23 = x0 + 0
            x0 == x0 goto PushHuffmanBitStack
            PushHuffmanBitStackReturnGate1:
        endwhile
        // Assembly
        x1 = mem[x20 + 1408]
        x24 = x0 + 1
        x0 == x0 goto GetDataAndSize
        GetDataAndSizeReturnGate1:
        x17 = 4
        x8 = x9 << x17
        x8 = x8 + x3
        x14 = x12 + x8
        x6 = mem[x14 + 0]
        x14 = x13 + x8
        x7 = mem[x14 + 0]
        x4 = x6 << x3
        x4 = x4 + x2
        x5 = x3 + x7
        x23 = x0 + 0
        x0 == x0 goto PushHuffmanBitStack
        PushHuffmanBitStackReturnGate2:
        x9 = 0 + x0
    endelse9:
    x20 = x20 + 1
endwhile

// EOB
if x9 != x0,
    x4 = mem[x12 + 0]
    x5 = mem[x13 + 0]
    x23 = x0 + 0
    x0 == x0 goto PushHuffmanBitStack
    PushHuffmanBitStackReturnGate3:
endif

// debug
x1 = 444
x2 = 411600
mem[x2 + 0] = x1

// ------------------------------------
// Function Return Gate
// ------------------------------------

x1 = 0 + x0
x2 = 1 + x0
x3 = 2 + x0
x28 == x1 goto BlockProcessReturnGate0
x28 == x2 goto BlockProcessReturnGate1
x28 == x3 goto BlockProcessReturnGate2
EndBlockProcess:

// ------------------------------------------------------------------
// RegFile Work Aera 3: Sampling
// ------------------------------------------------------------------

mem[x0 + 1201] = x0
mem[x0 + 1202] = x0
mem[x0 + 1203] = x0
mem[x0 + 1204] = x0
mem[x0 + 1205] = x0
mem[x0 + 1206] = x0
x1 = 256 + x0 // 16 * 16
x2 = mem[x0 + 1189]
x1 = x1 *l x2
x2 = mem[x0 + 1190]
x4 = x1 *l x2
mem[x0 + 1207] = x4
x1 = 0 + x0
x2 = 0 + x0
x3 = 0 + x0

while x1 != x4,
    x6 = mem[x1 + 2000]
    x10 = 255 + x0
    x11 = 8 + x0
    x12 = 16 + x0
    x6 = x10 & x6
    mem[x2 + 1216] = x6
    x6 = mem[x1 + 2000]
    x6 = x6 >> x11
    x6 = x6 & x10
    x7 = mem[x2 + 1280]
    x6 = x6 + x7
    mem[x2 + 1280] = x6
    x6 = mem[x1 + 2000]
    x7 = mem[x2 + 1344]
    x6 = x6 >> x12
    x6 = x6 & x10
    x6 = x6 + x7
    mem[x2 + 1344] = x6
    x6 = 63 + x0
    if x2 == x6,
        mem[x0 + 1201] = x1
        mem[x0 + 1203] = x3
        x6 = 64 + x0
        x7 = 0 + x0
        while x7 != x6,
            x9 = mem[x7 + 1216]
            mem[x7 + 1408] = x9
            x7 = x7 + 1
        endwhile
        x29 = mem[x0 + 1204]
        x28 = 0 + x0// return key
        x0 == x0 goto BlockProcess // Call function
        BlockProcessReturnGate0: // Return Gate 0
        mem[x0 + 1204] = x27
        x3 = mem[x0 + 1203]
        x8 = 3 + x0
        if x3 == x8,
            x6 = 64 + x0
            x7 = 0 + x0
            while x7 != x6,
                x9 = mem[x7 + 1280]
                x5 = 2 + x0
                x9 = x9 >> x5
                mem[x7 + 1408] = x9
                x7 = x7 + 1
            endwhile
            x29 = mem[x0 + 1205]
            x28 = 1 + x0 // return key
            x0 == x0 goto BlockProcess // Call function
            BlockProcessReturnGate1: // Return Gate 1
            mem[x0 + 1205] = x27
            x6 = 64 + x0
            x7 = 0 + x0
            while x7 != x6,
                x9 = mem[x7 + 1344]
                x5 = 2 + x0
                x9 = x9 >> x5
                mem[x7 + 1408] = x9
                x7 = x7 + 1
            endwhile
            x29 = mem[x0 + 1206]
            x28 = 2 + x0 // return key
            x0 == x0 goto BlockProcess // Call function
            BlockProcessReturnGate2: // Return Gate 2
            mem[x0 + 1206] = x27
            x6 = 64 + x0
            x7 = 0 + x0
            while x7 != x6,
                mem[x7 + 1280] = x0
                mem[x7 + 1344] = x0
                x7 = x7 + 1
            endwhile
            x3 = 0 + x0
            x0 == x0 goto endelse0
        endif
            x3 = x3 + 1
        endelse0:
        x2 = 0 + x0
        x1 = mem[x0 + 1201]
        x4 = mem[x0 + 1207]
        x0 == x0 goto endelse1
    endif
        x2 = x2 + 1
    endelse1:
    x1 = x1 + 1
endwhile

// ------------------------------------------------------------------
// RegFile Work Aera 4: Post Process
// ------------------------------------------------------------------

x13 = 0
x1 = 1
while x26 != x0,
    x13 = x13 << x1
    x13 = x13 + 1
    x26 = x26 + -1
endwhile
x2 = mem[x25 + 0]
x13 = x13 + x2
mem[x25 + 0] = x13

// end of program signature

x31 = 9999
