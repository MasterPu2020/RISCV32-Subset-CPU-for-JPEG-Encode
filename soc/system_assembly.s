// ------------------------------------------------------------------
// Initiate
// ------------------------------------------------------------------
// huffman table Y C
addi 0 x0 x1 // x1 = 0 + x0
addi 250 x0 x2 // x2 = 250 + x0
addi 16 x0 x3 // x3 = 16 + x0
addi 0 x0 x4 // x4 = 0 + x0
addi 11 x0 x5 // x5 = 11 + x0
addi 16 x0 x6 // x6 = 16 + x0
startwhilemark0_0:
blt x1 x2 endwhilemark0_0 // x2 < x1 goto endwhilemark0_0
sw x0 x1 275 //     mem[x1 + 275] = x0
sw x0 x1 801 //     mem[x1 + 801] = x0
addi 1 x0 x7 //     x7 = 1 + x0
startwhilemark1_0:
bge x5 x7 endwhilemark1_0 //     x7 >= x5 goto endwhilemark1_0
add x1 x7 x8 //         x8 = x7 + x1
sw x3 x8 275 //         mem[x8 + 275] = x3
sw x3 x8 801 //         mem[x8 + 801] = x3
addi 1 x7 x7 //         x7 = x7 + 1
beq x0 x0 startwhilemark1_0 // x0 == x0 goto startwhilemark1_0
    endwhilemark1_0:
startwhilemark1_1:
bge x6 x7 endwhilemark1_1 //     x7 >= x6 goto endwhilemark1_1
add x1 x7 x8 //         x8 = x7 + x1
sw x0 x8 275 //         mem[x8 + 275] = x0
sw x0 x8 801 //         mem[x8 + 801] = x0
addi 1 x7 x7 //         x7 = x7 + 1
beq x0 x0 startwhilemark1_1 // x0 == x0 goto startwhilemark1_1
    endwhilemark1_1:
addi 16 x1 x1 //     x1 = x1 + 16
beq x0 x0 startwhilemark0_0 // x0 == x0 goto startwhilemark0_0
endwhilemark0_0:
// quantization table
addi 1052 x0 x1 // x1 = 1052 + x0
addi 1179 x0 x2 // x2 = 1179 + x0
addi 32 x0 x30 // x30 = x0 + 32 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 0 x0 x31 // x31 = x0 + 0 
or x31 x30 x3 // x3 = x30 | x31
startwhilemark0_1:
blt x1 x2 endwhilemark0_1 // x2 < x1 goto endwhilemark0_1
sw x3 x1 0 //     mem[x1 + 0] = x3
addi 1 x1 x1 //     x1 = x1 + 1
beq x0 x0 startwhilemark0_1 // x0 == x0 goto startwhilemark0_1
endwhilemark0_1:
addi 22 x0 x31 // x31 = x0 + 22 
addi -189 x0 x29 // x29 = x0 + -189 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 1196 x0 x30 // x30 = x0 + 1196 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 66 x0 x31 // x31 = x0 + 66 
or x29 x31 x1 // x1 = x31 | x29
sw x1 x0 1214 // mem[x0 + 1214] = x1 // mem[1214] = -790273982
addi 22 x0 x31 // x31 = x0 + 22 
addi -149 x0 x29 // x29 = x0 + -149 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 16 x0 x30 // x30 = x0 + 16 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 787 x0 x31 // x31 = x0 + 787 
or x29 x31 x2 // x2 = x31 | x29
sw x2 x0 1212 // mem[x0 + 1212] = x2 // mem[1212] = -624917741
addi 22 x0 x31 // x31 = x0 + 22 
addi -76 x0 x29 // x29 = x0 + -76 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 458 x0 x30 // x30 = x0 + 458 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 1541 x0 x31 // x31 = x0 + 1541 
or x29 x31 x3 // x3 = x31 | x29
sw x3 x0 1211 // mem[x0 + 1211] = x3 // mem[1211] = -317827579
addi 22 x0 x31 // x31 = x0 + 22 
addi -37 x0 x29 // x29 = x0 + -37 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 1327 x0 x30 // x30 = x0 + 1327 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 213 x0 x31 // x31 = x0 + 213 
or x29 x31 x4 // x4 = x31 | x29
sw x4 x0 1215 // mem[x0 + 1215] = x4 // mem[1215] = -152471339
addi 1 x0 x5 // x5 = x0 + 1
sw x5 x0 26 // mem[x0 + 26] = x5 // mem[26] = 1
sw x5 x0 527 // mem[x0 + 527] = x5 // mem[527] = 1
sw x5 x0 551 // mem[x0 + 551] = x5 // mem[551] = 1
addi 2 x0 x6 // x6 = x0 + 2
sw x6 x0 1 // mem[x0 + 1] = x6 // mem[1] = 2
sw x6 x0 12 // mem[x0 + 12] = x6 // mem[12] = 2
sw x6 x0 276 // mem[x0 + 276] = x6 // mem[276] = 2
sw x6 x0 277 // mem[x0 + 277] = x6 // mem[277] = 2
sw x6 x0 528 // mem[x0 + 528] = x6 // mem[528] = 2
sw x6 x0 538 // mem[x0 + 538] = x6 // mem[538] = 2
sw x6 x0 539 // mem[x0 + 539] = x6 // mem[539] = 2
sw x6 x0 540 // mem[x0 + 540] = x6 // mem[540] = 2
sw x6 x0 801 // mem[x0 + 801] = x6 // mem[801] = 2
sw x6 x0 802 // mem[x0 + 802] = x6 // mem[802] = 2
addi 3 x0 x7 // x7 = x0 + 3
sw x7 x0 2 // mem[x0 + 2] = x7 // mem[2] = 3
sw x7 x0 13 // mem[x0 + 13] = x7 // mem[13] = 3
sw x7 x0 14 // mem[x0 + 14] = x7 // mem[14] = 3
sw x7 x0 15 // mem[x0 + 15] = x7 // mem[15] = 3
sw x7 x0 16 // mem[x0 + 16] = x7 // mem[16] = 3
sw x7 x0 17 // mem[x0 + 17] = x7 // mem[17] = 3
sw x7 x0 278 // mem[x0 + 278] = x7 // mem[278] = 3
sw x7 x0 541 // mem[x0 + 541] = x7 // mem[541] = 3
sw x7 x0 803 // mem[x0 + 803] = x7 // mem[803] = 3
addi 4 x0 x8 // x8 = x0 + 4
sw x8 x0 3 // mem[x0 + 3] = x8 // mem[3] = 4
sw x8 x0 18 // mem[x0 + 18] = x8 // mem[18] = 4
sw x8 x0 27 // mem[x0 + 27] = x8 // mem[27] = 4
sw x8 x0 275 // mem[x0 + 275] = x8 // mem[275] = 4
sw x8 x0 279 // mem[x0 + 279] = x8 // mem[279] = 4
sw x8 x0 292 // mem[x0 + 292] = x8 // mem[292] = 4
sw x8 x0 542 // mem[x0 + 542] = x8 // mem[542] = 4
sw x8 x0 552 // mem[x0 + 552] = x8 // mem[552] = 4
sw x8 x0 804 // mem[x0 + 804] = x8 // mem[804] = 4
sw x8 x0 818 // mem[x0 + 818] = x8 // mem[818] = 4
addi 5 x0 x9 // x9 = x0 + 5
sw x9 x0 4 // mem[x0 + 4] = x9 // mem[4] = 5
sw x9 x0 19 // mem[x0 + 19] = x9 // mem[19] = 5
sw x9 x0 280 // mem[x0 + 280] = x9 // mem[280] = 5
sw x9 x0 293 // mem[x0 + 293] = x9 // mem[293] = 5
sw x9 x0 308 // mem[x0 + 308] = x9 // mem[308] = 5
sw x9 x0 543 // mem[x0 + 543] = x9 // mem[543] = 5
sw x9 x0 805 // mem[x0 + 805] = x9 // mem[805] = 5
sw x9 x0 806 // mem[x0 + 806] = x9 // mem[806] = 5
sw x9 x0 834 // mem[x0 + 834] = x9 // mem[834] = 5
sw x9 x0 850 // mem[x0 + 850] = x9 // mem[850] = 5
addi 6 x0 x10 // x10 = x0 + 6
sw x10 x0 5 // mem[x0 + 5] = x10 // mem[5] = 6
sw x10 x0 20 // mem[x0 + 20] = x10 // mem[20] = 6
sw x10 x0 324 // mem[x0 + 324] = x10 // mem[324] = 6
sw x10 x0 340 // mem[x0 + 340] = x10 // mem[340] = 6
sw x10 x0 529 // mem[x0 + 529] = x10 // mem[529] = 6
sw x10 x0 544 // mem[x0 + 544] = x10 // mem[544] = 6
sw x10 x0 807 // mem[x0 + 807] = x10 // mem[807] = 6
sw x10 x0 819 // mem[x0 + 819] = x10 // mem[819] = 6
sw x10 x0 866 // mem[x0 + 866] = x10 // mem[866] = 6
sw x10 x0 882 // mem[x0 + 882] = x10 // mem[882] = 6
addi 7 x0 x11 // x11 = x0 + 7
sw x11 x0 21 // mem[x0 + 21] = x11 // mem[21] = 7
sw x11 x0 281 // mem[x0 + 281] = x11 // mem[281] = 7
sw x11 x0 294 // mem[x0 + 294] = x11 // mem[294] = 7
sw x11 x0 356 // mem[x0 + 356] = x11 // mem[356] = 7
sw x11 x0 372 // mem[x0 + 372] = x11 // mem[372] = 7
sw x11 x0 545 // mem[x0 + 545] = x11 // mem[545] = 7
sw x11 x0 808 // mem[x0 + 808] = x11 // mem[808] = 7
sw x11 x0 898 // mem[x0 + 898] = x11 // mem[898] = 7
sw x11 x0 914 // mem[x0 + 914] = x11 // mem[914] = 7
addi 8 x0 x12 // x12 = x0 + 8
sw x12 x0 22 // mem[x0 + 22] = x12 // mem[22] = 8
sw x12 x0 282 // mem[x0 + 282] = x12 // mem[282] = 8
sw x12 x0 309 // mem[x0 + 309] = x12 // mem[309] = 8
sw x12 x0 388 // mem[x0 + 388] = x12 // mem[388] = 8
sw x12 x0 546 // mem[x0 + 546] = x12 // mem[546] = 8
sw x12 x0 820 // mem[x0 + 820] = x12 // mem[820] = 8
sw x12 x0 835 // mem[x0 + 835] = x12 // mem[835] = 8
sw x12 x0 851 // mem[x0 + 851] = x12 // mem[851] = 8
sw x12 x0 930 // mem[x0 + 930] = x12 // mem[930] = 8
addi 9 x0 x13 // x13 = x0 + 9
sw x13 x0 23 // mem[x0 + 23] = x13 // mem[23] = 9
sw x13 x0 295 // mem[x0 + 295] = x13 // mem[295] = 9
sw x13 x0 325 // mem[x0 + 325] = x13 // mem[325] = 9
sw x13 x0 404 // mem[x0 + 404] = x13 // mem[404] = 9
sw x13 x0 420 // mem[x0 + 420] = x13 // mem[420] = 9
sw x13 x0 436 // mem[x0 + 436] = x13 // mem[436] = 9
sw x13 x0 547 // mem[x0 + 547] = x13 // mem[547] = 9
sw x13 x0 809 // mem[x0 + 809] = x13 // mem[809] = 9
sw x13 x0 821 // mem[x0 + 821] = x13 // mem[821] = 9
sw x13 x0 867 // mem[x0 + 867] = x13 // mem[867] = 9
sw x13 x0 946 // mem[x0 + 946] = x13 // mem[946] = 9
sw x13 x0 962 // mem[x0 + 962] = x13 // mem[962] = 9
sw x13 x0 978 // mem[x0 + 978] = x13 // mem[978] = 9
sw x13 x0 994 // mem[x0 + 994] = x13 // mem[994] = 9
addi 10 x0 x14 // x14 = x0 + 10
sw x14 x0 24 // mem[x0 + 24] = x14 // mem[24] = 10
sw x14 x0 283 // mem[x0 + 283] = x14 // mem[283] = 10
sw x14 x0 310 // mem[x0 + 310] = x14 // mem[310] = 10
sw x14 x0 341 // mem[x0 + 341] = x14 // mem[341] = 10
sw x14 x0 452 // mem[x0 + 452] = x14 // mem[452] = 10
sw x14 x0 468 // mem[x0 + 468] = x14 // mem[468] = 10
sw x14 x0 548 // mem[x0 + 548] = x14 // mem[548] = 10
sw x14 x0 553 // mem[x0 + 553] = x14 // mem[553] = 10
sw x14 x0 810 // mem[x0 + 810] = x14 // mem[810] = 10
sw x14 x0 836 // mem[x0 + 836] = x14 // mem[836] = 10
sw x14 x0 852 // mem[x0 + 852] = x14 // mem[852] = 10
sw x14 x0 883 // mem[x0 + 883] = x14 // mem[883] = 10
sw x14 x0 1041 // mem[x0 + 1041] = x14 // mem[1041] = 10
addi 11 x0 x15 // x15 = x0 + 11
sw x15 x0 28 // mem[x0 + 28] = x15 // mem[28] = 11
sw x15 x0 296 // mem[x0 + 296] = x15 // mem[296] = 11
sw x15 x0 357 // mem[x0 + 357] = x15 // mem[357] = 11
sw x15 x0 484 // mem[x0 + 484] = x15 // mem[484] = 11
sw x15 x0 515 // mem[x0 + 515] = x15 // mem[515] = 11
sw x15 x0 549 // mem[x0 + 549] = x15 // mem[549] = 11
sw x15 x0 567 // mem[x0 + 567] = x15 // mem[567] = 11
sw x15 x0 822 // mem[x0 + 822] = x15 // mem[822] = 11
sw x15 x0 899 // mem[x0 + 899] = x15 // mem[899] = 11
sw x15 x0 915 // mem[x0 + 915] = x15 // mem[915] = 11
sw x15 x0 1010 // mem[x0 + 1010] = x15 // mem[1010] = 11
addi 12 x0 x16 // x16 = x0 + 12
sw x16 x0 41 // mem[x0 + 41] = x16 // mem[41] = 12
sw x16 x0 311 // mem[x0 + 311] = x16 // mem[311] = 12
sw x16 x0 326 // mem[x0 + 326] = x16 // mem[326] = 12
sw x16 x0 373 // mem[x0 + 373] = x16 // mem[373] = 12
sw x16 x0 389 // mem[x0 + 389] = x16 // mem[389] = 12
sw x16 x0 811 // mem[x0 + 811] = x16 // mem[811] = 12
sw x16 x0 823 // mem[x0 + 823] = x16 // mem[823] = 12
sw x16 x0 837 // mem[x0 + 837] = x16 // mem[837] = 12
sw x16 x0 853 // mem[x0 + 853] = x16 // mem[853] = 12
addi 14 x0 x17 // x17 = x0 + 14
sw x17 x0 6 // mem[x0 + 6] = x17 // mem[6] = 14
sw x17 x0 530 // mem[x0 + 530] = x17 // mem[530] = 14
sw x17 x0 1026 // mem[x0 + 1026] = x17 // mem[1026] = 14
addi 15 x0 x18 // x18 = x0 + 15
sw x18 x0 405 // mem[x0 + 405] = x18 // mem[405] = 15
sw x18 x0 838 // mem[x0 + 838] = x18 // mem[838] = 15
sw x18 x0 1042 // mem[x0 + 1042] = x18 // mem[1042] = 15
addi 24 x0 x19 // x19 = x0 + 24
sw x19 x0 554 // mem[x0 + 554] = x19 // mem[554] = 24
addi 25 x0 x20 // x20 = x0 + 25
sw x20 x0 555 // mem[x0 + 555] = x20 // mem[555] = 25
addi 26 x0 x21 // x21 = x0 + 26
sw x21 x0 29 // mem[x0 + 29] = x21 // mem[29] = 26
sw x21 x0 583 // mem[x0 + 583] = x21 // mem[583] = 26
addi 27 x0 x22 // x22 = x0 + 27
sw x22 x0 42 // mem[x0 + 42] = x22 // mem[42] = 27
sw x22 x0 599 // mem[x0 + 599] = x22 // mem[599] = 27
addi 28 x0 x23 // x23 = x0 + 28
sw x23 x0 57 // mem[x0 + 57] = x23 // mem[57] = 28
addi 30 x0 x24 // x24 = x0 + 30
sw x24 x0 7 // mem[x0 + 7] = x24 // mem[7] = 30
sw x24 x0 531 // mem[x0 + 531] = x24 // mem[531] = 30
addi 56 x0 x25 // x25 = x0 + 56
sw x25 x0 556 // mem[x0 + 556] = x25 // mem[556] = 56
addi 57 x0 x26 // x26 = x0 + 57
sw x26 x0 568 // mem[x0 + 568] = x26 // mem[568] = 57
addi 58 x0 x27 // x27 = x0 + 58
sw x27 x0 73 // mem[x0 + 73] = x27 // mem[73] = 58
sw x27 x0 615 // mem[x0 + 615] = x27 // mem[615] = 58
addi 59 x0 x28 // x28 = x0 + 59
sw x28 x0 89 // mem[x0 + 89] = x28 // mem[89] = 59
sw x28 x0 631 // mem[x0 + 631] = x28 // mem[631] = 59
addi 62 x0 x29 // x29 = x0 + 62
sw x29 x0 8 // mem[x0 + 8] = x29 // mem[8] = 62
sw x29 x0 532 // mem[x0 + 532] = x29 // mem[532] = 62
addi 120 x0 x1 // x1 = x0 + 120
sw x1 x0 30 // mem[x0 + 30] = x1 // mem[30] = 120
sw x1 x0 557 // mem[x0 + 557] = x1 // mem[557] = 120
addi 121 x0 x2 // x2 = x0 + 121
sw x2 x0 43 // mem[x0 + 43] = x2 // mem[43] = 121
sw x2 x0 647 // mem[x0 + 647] = x2 // mem[647] = 121
addi 122 x0 x3 // x3 = x0 + 122
sw x3 x0 105 // mem[x0 + 105] = x3 // mem[105] = 122
sw x3 x0 663 // mem[x0 + 663] = x3 // mem[663] = 122
addi 123 x0 x4 // x4 = x0 + 123
sw x4 x0 121 // mem[x0 + 121] = x4 // mem[121] = 123
addi 126 x0 x5 // x5 = x0 + 126
sw x5 x0 9 // mem[x0 + 9] = x5 // mem[9] = 126
sw x5 x0 533 // mem[x0 + 533] = x5 // mem[533] = 126
addi 246 x0 x6 // x6 = x0 + 246
sw x6 x0 569 // mem[x0 + 569] = x6 // mem[569] = 246
addi 247 x0 x7 // x7 = x0 + 247
sw x7 x0 584 // mem[x0 + 584] = x7 // mem[584] = 247
addi 248 x0 x8 // x8 = x0 + 248
sw x8 x0 31 // mem[x0 + 31] = x8 // mem[31] = 248
sw x8 x0 600 // mem[x0 + 600] = x8 // mem[600] = 248
addi 249 x0 x9 // x9 = x0 + 249
sw x9 x0 58 // mem[x0 + 58] = x9 // mem[58] = 249
sw x9 x0 679 // mem[x0 + 679] = x9 // mem[679] = 249
addi 250 x0 x10 // x10 = x0 + 250
sw x10 x0 137 // mem[x0 + 137] = x10 // mem[137] = 250
addi 254 x0 x11 // x11 = x0 + 254
sw x11 x0 10 // mem[x0 + 10] = x11 // mem[10] = 254
sw x11 x0 534 // mem[x0 + 534] = x11 // mem[534] = 254
addi 500 x0 x12 // x12 = x0 + 500
sw x12 x0 558 // mem[x0 + 558] = x12 // mem[558] = 500
addi 501 x0 x13 // x13 = x0 + 501
sw x13 x0 570 // mem[x0 + 570] = x13 // mem[570] = 501
addi 502 x0 x14 // x14 = x0 + 502
sw x14 x0 44 // mem[x0 + 44] = x14 // mem[44] = 502
sw x14 x0 616 // mem[x0 + 616] = x14 // mem[616] = 502
addi 503 x0 x15 // x15 = x0 + 503
sw x15 x0 74 // mem[x0 + 74] = x15 // mem[74] = 503
sw x15 x0 695 // mem[x0 + 695] = x15 // mem[695] = 503
addi 504 x0 x16 // x16 = x0 + 504
sw x16 x0 153 // mem[x0 + 153] = x16 // mem[153] = 504
sw x16 x0 711 // mem[x0 + 711] = x16 // mem[711] = 504
addi 505 x0 x17 // x17 = x0 + 505
sw x17 x0 169 // mem[x0 + 169] = x17 // mem[169] = 505
sw x17 x0 727 // mem[x0 + 727] = x17 // mem[727] = 505
addi 506 x0 x18 // x18 = x0 + 506
sw x18 x0 185 // mem[x0 + 185] = x18 // mem[185] = 506
sw x18 x0 743 // mem[x0 + 743] = x18 // mem[743] = 506
addi 510 x0 x19 // x19 = x0 + 510
sw x19 x0 11 // mem[x0 + 11] = x19 // mem[11] = 510
sw x19 x0 535 // mem[x0 + 535] = x19 // mem[535] = 510
addi 1014 x0 x20 // x20 = x0 + 1014
sw x20 x0 32 // mem[x0 + 32] = x20 // mem[32] = 1014
sw x20 x0 559 // mem[x0 + 559] = x20 // mem[559] = 1014
addi 1015 x0 x21 // x21 = x0 + 1015
sw x21 x0 59 // mem[x0 + 59] = x21 // mem[59] = 1015
sw x21 x0 585 // mem[x0 + 585] = x21 // mem[585] = 1015
addi 1016 x0 x22 // x22 = x0 + 1016
sw x22 x0 90 // mem[x0 + 90] = x22 // mem[90] = 1016
sw x22 x0 601 // mem[x0 + 601] = x22 // mem[601] = 1016
addi 1017 x0 x23 // x23 = x0 + 1017
sw x23 x0 201 // mem[x0 + 201] = x23 // mem[201] = 1017
sw x23 x0 632 // mem[x0 + 632] = x23 // mem[632] = 1017
addi 1018 x0 x24 // x24 = x0 + 1018
sw x24 x0 217 // mem[x0 + 217] = x24 // mem[217] = 1018
sw x24 x0 790 // mem[x0 + 790] = x24 // mem[790] = 1018
addi 1022 x0 x25 // x25 = x0 + 1022
sw x25 x0 536 // mem[x0 + 536] = x25 // mem[536] = 1022
addi 1023 x0 x26 // x26 = x0 + 1023
sw x26 x0 1186 // mem[x0 + 1186] = x26 // mem[1186] = 1023
addi 2038 x0 x27 // x27 = x0 + 2038
sw x27 x0 45 // mem[x0 + 45] = x27 // mem[45] = 2038
sw x27 x0 571 // mem[x0 + 571] = x27 // mem[571] = 2038
addi 2039 x0 x28 // x28 = x0 + 2039
sw x28 x0 106 // mem[x0 + 106] = x28 // mem[106] = 2039
sw x28 x0 648 // mem[x0 + 648] = x28 // mem[648] = 2039
addi 2040 x0 x29 // x29 = x0 + 2040
sw x29 x0 233 // mem[x0 + 233] = x29 // mem[233] = 2040
sw x29 x0 664 // mem[x0 + 664] = x29 // mem[664] = 2040
addi 2041 x0 x1 // x1 = x0 + 2041
sw x1 x0 264 // mem[x0 + 264] = x1 // mem[264] = 2041
sw x1 x0 759 // mem[x0 + 759] = x1 // mem[759] = 2041
addi 2046 x0 x2 // x2 = x0 + 2046
sw x2 x0 537 // mem[x0 + 537] = x2 // mem[537] = 2046
addi 2047 x0 x3 // x3 = x0 + 2047
sw x3 x0 1185 // mem[x0 + 1185] = x3 // mem[1185] = 2047
addi 2043 x1 x4 // x4 = x1 + 2043
sw x4 x0 60 // mem[x0 + 60] = x4 // mem[60] = 4084
sw x4 x0 560 // mem[x0 + 560] = x4 // mem[560] = 4084
addi 2044 x1 x5 // x5 = x1 + 2044
sw x5 x0 75 // mem[x0 + 75] = x5 // mem[75] = 4085
sw x5 x0 572 // mem[x0 + 572] = x5 // mem[572] = 4085
addi 2045 x1 x6 // x6 = x1 + 2045
sw x6 x0 122 // mem[x0 + 122] = x6 // mem[122] = 4086
sw x6 x0 586 // mem[x0 + 586] = x6 // mem[586] = 4086
addi 2046 x1 x7 // x7 = x1 + 2046
sw x7 x0 138 // mem[x0 + 138] = x7 // mem[138] = 4087
sw x7 x0 602 // mem[x0 + 602] = x7 // mem[602] = 4087
addi 2044 x2 x8 // x8 = x2 + 2044
sw x8 x0 1184 // mem[x0 + 1184] = x8 // mem[1184] = 4090
addi 3 x0 x30 // x30 = x0 + 3 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2005 x0 x31 // x31 = x0 + 2005 
or x31 x30 x9 // x9 = x30 | x31
sw x9 x0 1183 // mem[x0 + 1183] = x9 // mem[1183] = 8149
addi 6 x0 x30 // x30 = x0 + 6 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 580 x0 x31 // x31 = x0 + 580 
or x31 x30 x10 // x10 = x30 | x31
sw x10 x0 1200 // mem[x0 + 1200] = x10 // mem[1200] = 12868
addi 1468 x10 x30 // x30 = x10 + 1468
addi 1718 x0 x31 // x31 = x0 + 1718 
or x31 x30 x11 // x11 = x30 | x31
sw x11 x0 1182 // mem[x0 + 1182] = x11 // mem[1182] = 16054
addi 298 x11 x12 // x12 = x11 + 298
sw x12 x0 775 // mem[x0 + 775] = x12 // mem[775] = 16352
addi 14 x0 x30 // x30 = x0 + 14 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1713 x0 x31 // x31 = x0 + 1713 
or x31 x30 x13 // x13 = x30 | x31
sw x13 x0 1181 // mem[x0 + 1181] = x13 // mem[1181] = 30385
addi 335 x13 x30 // x30 = x13 + 335
addi 1984 x0 x31 // x31 = x0 + 1984 
or x31 x30 x14 // x14 = x30 | x31
sw x14 x0 154 // mem[x0 + 154] = x14 // mem[154] = 32704
addi 2 x14 x15 // x15 = x14 + 2
sw x15 x0 587 // mem[x0 + 587] = x15 // mem[587] = 32706
addi 3 x14 x16 // x16 = x14 + 3
sw x16 x0 791 // mem[x0 + 791] = x16 // mem[791] = 32707
addi 22 x0 x30 // x30 = x0 + 22 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1285 x0 x31 // x31 = x0 + 1285 
or x31 x30 x17 // x17 = x30 | x31
sw x17 x0 1198 // mem[x0 + 1198] = x17 // mem[1198] = 46341
addi 25 x0 x30 // x30 = x0 + 25 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 271 x0 x31 // x31 = x0 + 271 
or x31 x30 x18 // x18 = x30 | x31
sw x18 x0 1180 // mem[x0 + 1180] = x18 // mem[1180] = 51471
addi 31 x0 x30 // x30 = x0 + 31 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1922 x0 x31 // x31 = x0 + 1922 
or x31 x30 x19 // x19 = x30 | x31
sw x19 x0 33 // mem[x0 + 33] = x19 // mem[33] = 65410
addi 1 x19 x20 // x20 = x19 + 1
sw x20 x0 34 // mem[x0 + 34] = x20 // mem[34] = 65411
addi 2 x19 x21 // x21 = x19 + 2
sw x21 x0 46 // mem[x0 + 46] = x21 // mem[46] = 65412
addi 3 x19 x22 // x22 = x19 + 3
sw x22 x0 47 // mem[x0 + 47] = x22 // mem[47] = 65413
addi 4 x19 x23 // x23 = x19 + 4
sw x23 x0 48 // mem[x0 + 48] = x23 // mem[48] = 65414
addi 5 x19 x24 // x24 = x19 + 5
sw x24 x0 49 // mem[x0 + 49] = x24 // mem[49] = 65415
addi 6 x19 x25 // x25 = x19 + 6
sw x25 x0 50 // mem[x0 + 50] = x25 // mem[50] = 65416
sw x25 x0 573 // mem[x0 + 573] = x25 // mem[573] = 65416
addi 7 x19 x26 // x26 = x19 + 7
sw x26 x0 61 // mem[x0 + 61] = x26 // mem[61] = 65417
sw x26 x0 574 // mem[x0 + 574] = x26 // mem[574] = 65417
addi 8 x19 x27 // x27 = x19 + 8
sw x27 x0 62 // mem[x0 + 62] = x27 // mem[62] = 65418
sw x27 x0 575 // mem[x0 + 575] = x27 // mem[575] = 65418
addi 9 x19 x28 // x28 = x19 + 9
sw x28 x0 63 // mem[x0 + 63] = x28 // mem[63] = 65419
sw x28 x0 576 // mem[x0 + 576] = x28 // mem[576] = 65419
addi 10 x19 x29 // x29 = x19 + 10
sw x29 x0 64 // mem[x0 + 64] = x29 // mem[64] = 65420
sw x29 x0 588 // mem[x0 + 588] = x29 // mem[588] = 65420
addi 11 x19 x1 // x1 = x19 + 11
sw x1 x0 65 // mem[x0 + 65] = x1 // mem[65] = 65421
sw x1 x0 589 // mem[x0 + 589] = x1 // mem[589] = 65421
addi 1 x1 x2 // x2 = x1 + 1
sw x2 x0 66 // mem[x0 + 66] = x2 // mem[66] = 65422
sw x2 x0 590 // mem[x0 + 590] = x2 // mem[590] = 65422
addi 2 x1 x3 // x3 = x1 + 2
sw x3 x0 76 // mem[x0 + 76] = x3 // mem[76] = 65423
sw x3 x0 591 // mem[x0 + 591] = x3 // mem[591] = 65423
addi 3 x1 x4 // x4 = x1 + 3
sw x4 x0 77 // mem[x0 + 77] = x4 // mem[77] = 65424
sw x4 x0 592 // mem[x0 + 592] = x4 // mem[592] = 65424
addi 4 x1 x5 // x5 = x1 + 4
sw x5 x0 78 // mem[x0 + 78] = x5 // mem[78] = 65425
sw x5 x0 603 // mem[x0 + 603] = x5 // mem[603] = 65425
addi 5 x1 x6 // x6 = x1 + 5
sw x6 x0 79 // mem[x0 + 79] = x6 // mem[79] = 65426
sw x6 x0 604 // mem[x0 + 604] = x6 // mem[604] = 65426
addi 6 x1 x7 // x7 = x1 + 6
sw x7 x0 80 // mem[x0 + 80] = x7 // mem[80] = 65427
sw x7 x0 605 // mem[x0 + 605] = x7 // mem[605] = 65427
addi 7 x1 x8 // x8 = x1 + 7
sw x8 x0 81 // mem[x0 + 81] = x8 // mem[81] = 65428
sw x8 x0 606 // mem[x0 + 606] = x8 // mem[606] = 65428
addi 8 x1 x9 // x9 = x1 + 8
sw x9 x0 82 // mem[x0 + 82] = x9 // mem[82] = 65429
sw x9 x0 607 // mem[x0 + 607] = x9 // mem[607] = 65429
addi 9 x1 x10 // x10 = x1 + 9
sw x10 x0 91 // mem[x0 + 91] = x10 // mem[91] = 65430
sw x10 x0 608 // mem[x0 + 608] = x10 // mem[608] = 65430
addi 10 x1 x11 // x11 = x1 + 10
sw x11 x0 92 // mem[x0 + 92] = x11 // mem[92] = 65431
sw x11 x0 617 // mem[x0 + 617] = x11 // mem[617] = 65431
addi 11 x1 x12 // x12 = x1 + 11
sw x12 x0 93 // mem[x0 + 93] = x12 // mem[93] = 65432
sw x12 x0 618 // mem[x0 + 618] = x12 // mem[618] = 65432
addi 12 x1 x13 // x13 = x1 + 12
sw x13 x0 94 // mem[x0 + 94] = x13 // mem[94] = 65433
sw x13 x0 619 // mem[x0 + 619] = x13 // mem[619] = 65433
addi 13 x1 x14 // x14 = x1 + 13
sw x14 x0 95 // mem[x0 + 95] = x14 // mem[95] = 65434
sw x14 x0 620 // mem[x0 + 620] = x14 // mem[620] = 65434
addi 14 x1 x15 // x15 = x1 + 14
sw x15 x0 96 // mem[x0 + 96] = x15 // mem[96] = 65435
sw x15 x0 621 // mem[x0 + 621] = x15 // mem[621] = 65435
addi 15 x1 x16 // x16 = x1 + 15
sw x16 x0 97 // mem[x0 + 97] = x16 // mem[97] = 65436
sw x16 x0 622 // mem[x0 + 622] = x16 // mem[622] = 65436
addi 16 x1 x17 // x17 = x1 + 16
sw x17 x0 98 // mem[x0 + 98] = x17 // mem[98] = 65437
sw x17 x0 623 // mem[x0 + 623] = x17 // mem[623] = 65437
addi 17 x1 x18 // x18 = x1 + 17
sw x18 x0 107 // mem[x0 + 107] = x18 // mem[107] = 65438
sw x18 x0 624 // mem[x0 + 624] = x18 // mem[624] = 65438
addi 18 x1 x19 // x19 = x1 + 18
sw x19 x0 108 // mem[x0 + 108] = x19 // mem[108] = 65439
sw x19 x0 633 // mem[x0 + 633] = x19 // mem[633] = 65439
addi 19 x1 x20 // x20 = x1 + 19
sw x20 x0 109 // mem[x0 + 109] = x20 // mem[109] = 65440
sw x20 x0 634 // mem[x0 + 634] = x20 // mem[634] = 65440
addi 20 x1 x21 // x21 = x1 + 20
sw x21 x0 110 // mem[x0 + 110] = x21 // mem[110] = 65441
sw x21 x0 635 // mem[x0 + 635] = x21 // mem[635] = 65441
addi 21 x1 x22 // x22 = x1 + 21
sw x22 x0 111 // mem[x0 + 111] = x22 // mem[111] = 65442
sw x22 x0 636 // mem[x0 + 636] = x22 // mem[636] = 65442
addi 22 x1 x23 // x23 = x1 + 22
sw x23 x0 112 // mem[x0 + 112] = x23 // mem[112] = 65443
sw x23 x0 637 // mem[x0 + 637] = x23 // mem[637] = 65443
addi 23 x1 x24 // x24 = x1 + 23
sw x24 x0 113 // mem[x0 + 113] = x24 // mem[113] = 65444
sw x24 x0 638 // mem[x0 + 638] = x24 // mem[638] = 65444
addi 24 x1 x25 // x25 = x1 + 24
sw x25 x0 114 // mem[x0 + 114] = x25 // mem[114] = 65445
sw x25 x0 639 // mem[x0 + 639] = x25 // mem[639] = 65445
addi 25 x1 x26 // x26 = x1 + 25
sw x26 x0 123 // mem[x0 + 123] = x26 // mem[123] = 65446
sw x26 x0 640 // mem[x0 + 640] = x26 // mem[640] = 65446
addi 26 x1 x27 // x27 = x1 + 26
sw x27 x0 124 // mem[x0 + 124] = x27 // mem[124] = 65447
sw x27 x0 649 // mem[x0 + 649] = x27 // mem[649] = 65447
addi 27 x1 x28 // x28 = x1 + 27
sw x28 x0 125 // mem[x0 + 125] = x28 // mem[125] = 65448
sw x28 x0 650 // mem[x0 + 650] = x28 // mem[650] = 65448
addi 28 x1 x29 // x29 = x1 + 28
sw x29 x0 126 // mem[x0 + 126] = x29 // mem[126] = 65449
sw x29 x0 651 // mem[x0 + 651] = x29 // mem[651] = 65449
addi 29 x1 x1 // x1 = x1 + 29
sw x1 x0 127 // mem[x0 + 127] = x1 // mem[127] = 65450
sw x1 x0 652 // mem[x0 + 652] = x1 // mem[652] = 65450
addi 1 x1 x2 // x2 = x1 + 1
sw x2 x0 128 // mem[x0 + 128] = x2 // mem[128] = 65451
sw x2 x0 653 // mem[x0 + 653] = x2 // mem[653] = 65451
addi 2 x1 x3 // x3 = x1 + 2
sw x3 x0 129 // mem[x0 + 129] = x3 // mem[129] = 65452
sw x3 x0 654 // mem[x0 + 654] = x3 // mem[654] = 65452
addi 3 x1 x4 // x4 = x1 + 3
sw x4 x0 130 // mem[x0 + 130] = x4 // mem[130] = 65453
sw x4 x0 655 // mem[x0 + 655] = x4 // mem[655] = 65453
addi 4 x1 x5 // x5 = x1 + 4
sw x5 x0 139 // mem[x0 + 139] = x5 // mem[139] = 65454
sw x5 x0 656 // mem[x0 + 656] = x5 // mem[656] = 65454
addi 5 x1 x6 // x6 = x1 + 5
sw x6 x0 140 // mem[x0 + 140] = x6 // mem[140] = 65455
sw x6 x0 665 // mem[x0 + 665] = x6 // mem[665] = 65455
addi 6 x1 x7 // x7 = x1 + 6
sw x7 x0 141 // mem[x0 + 141] = x7 // mem[141] = 65456
sw x7 x0 666 // mem[x0 + 666] = x7 // mem[666] = 65456
addi 7 x1 x8 // x8 = x1 + 7
sw x8 x0 142 // mem[x0 + 142] = x8 // mem[142] = 65457
sw x8 x0 667 // mem[x0 + 667] = x8 // mem[667] = 65457
addi 8 x1 x9 // x9 = x1 + 8
sw x9 x0 143 // mem[x0 + 143] = x9 // mem[143] = 65458
sw x9 x0 668 // mem[x0 + 668] = x9 // mem[668] = 65458
addi 9 x1 x10 // x10 = x1 + 9
sw x10 x0 144 // mem[x0 + 144] = x10 // mem[144] = 65459
sw x10 x0 669 // mem[x0 + 669] = x10 // mem[669] = 65459
addi 10 x1 x11 // x11 = x1 + 10
sw x11 x0 145 // mem[x0 + 145] = x11 // mem[145] = 65460
sw x11 x0 670 // mem[x0 + 670] = x11 // mem[670] = 65460
addi 11 x1 x12 // x12 = x1 + 11
sw x12 x0 146 // mem[x0 + 146] = x12 // mem[146] = 65461
sw x12 x0 671 // mem[x0 + 671] = x12 // mem[671] = 65461
addi 12 x1 x13 // x13 = x1 + 12
sw x13 x0 155 // mem[x0 + 155] = x13 // mem[155] = 65462
sw x13 x0 672 // mem[x0 + 672] = x13 // mem[672] = 65462
addi 13 x1 x14 // x14 = x1 + 13
sw x14 x0 156 // mem[x0 + 156] = x14 // mem[156] = 65463
sw x14 x0 680 // mem[x0 + 680] = x14 // mem[680] = 65463
addi 14 x1 x15 // x15 = x1 + 14
sw x15 x0 157 // mem[x0 + 157] = x15 // mem[157] = 65464
sw x15 x0 681 // mem[x0 + 681] = x15 // mem[681] = 65464
addi 15 x1 x16 // x16 = x1 + 15
sw x16 x0 158 // mem[x0 + 158] = x16 // mem[158] = 65465
sw x16 x0 682 // mem[x0 + 682] = x16 // mem[682] = 65465
addi 16 x1 x17 // x17 = x1 + 16
sw x17 x0 159 // mem[x0 + 159] = x17 // mem[159] = 65466
sw x17 x0 683 // mem[x0 + 683] = x17 // mem[683] = 65466
addi 17 x1 x18 // x18 = x1 + 17
sw x18 x0 160 // mem[x0 + 160] = x18 // mem[160] = 65467
sw x18 x0 684 // mem[x0 + 684] = x18 // mem[684] = 65467
addi 18 x1 x19 // x19 = x1 + 18
sw x19 x0 161 // mem[x0 + 161] = x19 // mem[161] = 65468
sw x19 x0 685 // mem[x0 + 685] = x19 // mem[685] = 65468
addi 19 x1 x20 // x20 = x1 + 19
sw x20 x0 162 // mem[x0 + 162] = x20 // mem[162] = 65469
sw x20 x0 686 // mem[x0 + 686] = x20 // mem[686] = 65469
addi 20 x1 x21 // x21 = x1 + 20
sw x21 x0 170 // mem[x0 + 170] = x21 // mem[170] = 65470
sw x21 x0 687 // mem[x0 + 687] = x21 // mem[687] = 65470
addi 21 x1 x22 // x22 = x1 + 21
sw x22 x0 171 // mem[x0 + 171] = x22 // mem[171] = 65471
sw x22 x0 688 // mem[x0 + 688] = x22 // mem[688] = 65471
addi 22 x1 x23 // x23 = x1 + 22
sw x23 x0 172 // mem[x0 + 172] = x23 // mem[172] = 65472
sw x23 x0 696 // mem[x0 + 696] = x23 // mem[696] = 65472
addi 23 x1 x24 // x24 = x1 + 23
sw x24 x0 173 // mem[x0 + 173] = x24 // mem[173] = 65473
sw x24 x0 697 // mem[x0 + 697] = x24 // mem[697] = 65473
addi 24 x1 x25 // x25 = x1 + 24
sw x25 x0 174 // mem[x0 + 174] = x25 // mem[174] = 65474
sw x25 x0 698 // mem[x0 + 698] = x25 // mem[698] = 65474
addi 25 x1 x26 // x26 = x1 + 25
sw x26 x0 175 // mem[x0 + 175] = x26 // mem[175] = 65475
sw x26 x0 699 // mem[x0 + 699] = x26 // mem[699] = 65475
addi 26 x1 x27 // x27 = x1 + 26
sw x27 x0 176 // mem[x0 + 176] = x27 // mem[176] = 65476
sw x27 x0 700 // mem[x0 + 700] = x27 // mem[700] = 65476
addi 27 x1 x28 // x28 = x1 + 27
sw x28 x0 177 // mem[x0 + 177] = x28 // mem[177] = 65477
sw x28 x0 701 // mem[x0 + 701] = x28 // mem[701] = 65477
addi 28 x1 x29 // x29 = x1 + 28
sw x29 x0 178 // mem[x0 + 178] = x29 // mem[178] = 65478
sw x29 x0 702 // mem[x0 + 702] = x29 // mem[702] = 65478
addi 29 x1 x1 // x1 = x1 + 29
sw x1 x0 186 // mem[x0 + 186] = x1 // mem[186] = 65479
sw x1 x0 703 // mem[x0 + 703] = x1 // mem[703] = 65479
addi 1 x1 x2 // x2 = x1 + 1
sw x2 x0 187 // mem[x0 + 187] = x2 // mem[187] = 65480
sw x2 x0 704 // mem[x0 + 704] = x2 // mem[704] = 65480
addi 2 x1 x3 // x3 = x1 + 2
sw x3 x0 188 // mem[x0 + 188] = x3 // mem[188] = 65481
sw x3 x0 712 // mem[x0 + 712] = x3 // mem[712] = 65481
addi 3 x1 x4 // x4 = x1 + 3
sw x4 x0 189 // mem[x0 + 189] = x4 // mem[189] = 65482
sw x4 x0 713 // mem[x0 + 713] = x4 // mem[713] = 65482
addi 4 x1 x5 // x5 = x1 + 4
sw x5 x0 190 // mem[x0 + 190] = x5 // mem[190] = 65483
sw x5 x0 714 // mem[x0 + 714] = x5 // mem[714] = 65483
addi 5 x1 x6 // x6 = x1 + 5
sw x6 x0 191 // mem[x0 + 191] = x6 // mem[191] = 65484
sw x6 x0 715 // mem[x0 + 715] = x6 // mem[715] = 65484
addi 6 x1 x7 // x7 = x1 + 6
sw x7 x0 192 // mem[x0 + 192] = x7 // mem[192] = 65485
sw x7 x0 716 // mem[x0 + 716] = x7 // mem[716] = 65485
addi 7 x1 x8 // x8 = x1 + 7
sw x8 x0 193 // mem[x0 + 193] = x8 // mem[193] = 65486
sw x8 x0 717 // mem[x0 + 717] = x8 // mem[717] = 65486
addi 8 x1 x9 // x9 = x1 + 8
sw x9 x0 194 // mem[x0 + 194] = x9 // mem[194] = 65487
sw x9 x0 718 // mem[x0 + 718] = x9 // mem[718] = 65487
addi 9 x1 x10 // x10 = x1 + 9
sw x10 x0 202 // mem[x0 + 202] = x10 // mem[202] = 65488
sw x10 x0 719 // mem[x0 + 719] = x10 // mem[719] = 65488
addi 10 x1 x11 // x11 = x1 + 10
sw x11 x0 203 // mem[x0 + 203] = x11 // mem[203] = 65489
sw x11 x0 720 // mem[x0 + 720] = x11 // mem[720] = 65489
addi 11 x1 x12 // x12 = x1 + 11
sw x12 x0 204 // mem[x0 + 204] = x12 // mem[204] = 65490
sw x12 x0 728 // mem[x0 + 728] = x12 // mem[728] = 65490
addi 12 x1 x13 // x13 = x1 + 12
sw x13 x0 205 // mem[x0 + 205] = x13 // mem[205] = 65491
sw x13 x0 729 // mem[x0 + 729] = x13 // mem[729] = 65491
addi 13 x1 x14 // x14 = x1 + 13
sw x14 x0 206 // mem[x0 + 206] = x14 // mem[206] = 65492
sw x14 x0 730 // mem[x0 + 730] = x14 // mem[730] = 65492
addi 14 x1 x15 // x15 = x1 + 14
sw x15 x0 207 // mem[x0 + 207] = x15 // mem[207] = 65493
sw x15 x0 731 // mem[x0 + 731] = x15 // mem[731] = 65493
addi 15 x1 x16 // x16 = x1 + 15
sw x16 x0 208 // mem[x0 + 208] = x16 // mem[208] = 65494
sw x16 x0 732 // mem[x0 + 732] = x16 // mem[732] = 65494
addi 16 x1 x17 // x17 = x1 + 16
sw x17 x0 209 // mem[x0 + 209] = x17 // mem[209] = 65495
sw x17 x0 733 // mem[x0 + 733] = x17 // mem[733] = 65495
addi 17 x1 x18 // x18 = x1 + 17
sw x18 x0 210 // mem[x0 + 210] = x18 // mem[210] = 65496
sw x18 x0 734 // mem[x0 + 734] = x18 // mem[734] = 65496
addi 18 x1 x19 // x19 = x1 + 18
sw x19 x0 218 // mem[x0 + 218] = x19 // mem[218] = 65497
sw x19 x0 735 // mem[x0 + 735] = x19 // mem[735] = 65497
addi 19 x1 x20 // x20 = x1 + 19
sw x20 x0 219 // mem[x0 + 219] = x20 // mem[219] = 65498
sw x20 x0 736 // mem[x0 + 736] = x20 // mem[736] = 65498
addi 20 x1 x21 // x21 = x1 + 20
sw x21 x0 220 // mem[x0 + 220] = x21 // mem[220] = 65499
sw x21 x0 744 // mem[x0 + 744] = x21 // mem[744] = 65499
addi 21 x1 x22 // x22 = x1 + 21
sw x22 x0 221 // mem[x0 + 221] = x22 // mem[221] = 65500
sw x22 x0 745 // mem[x0 + 745] = x22 // mem[745] = 65500
addi 22 x1 x23 // x23 = x1 + 22
sw x23 x0 222 // mem[x0 + 222] = x23 // mem[222] = 65501
sw x23 x0 746 // mem[x0 + 746] = x23 // mem[746] = 65501
addi 23 x1 x24 // x24 = x1 + 23
sw x24 x0 223 // mem[x0 + 223] = x24 // mem[223] = 65502
sw x24 x0 747 // mem[x0 + 747] = x24 // mem[747] = 65502
addi 24 x1 x25 // x25 = x1 + 24
sw x25 x0 224 // mem[x0 + 224] = x25 // mem[224] = 65503
sw x25 x0 748 // mem[x0 + 748] = x25 // mem[748] = 65503
addi 25 x1 x26 // x26 = x1 + 25
sw x26 x0 225 // mem[x0 + 225] = x26 // mem[225] = 65504
sw x26 x0 749 // mem[x0 + 749] = x26 // mem[749] = 65504
addi 26 x1 x27 // x27 = x1 + 26
sw x27 x0 226 // mem[x0 + 226] = x27 // mem[226] = 65505
sw x27 x0 750 // mem[x0 + 750] = x27 // mem[750] = 65505
addi 27 x1 x28 // x28 = x1 + 27
sw x28 x0 234 // mem[x0 + 234] = x28 // mem[234] = 65506
sw x28 x0 751 // mem[x0 + 751] = x28 // mem[751] = 65506
addi 28 x1 x29 // x29 = x1 + 28
sw x29 x0 235 // mem[x0 + 235] = x29 // mem[235] = 65507
sw x29 x0 752 // mem[x0 + 752] = x29 // mem[752] = 65507
addi 29 x1 x1 // x1 = x1 + 29
sw x1 x0 236 // mem[x0 + 236] = x1 // mem[236] = 65508
sw x1 x0 760 // mem[x0 + 760] = x1 // mem[760] = 65508
addi 1 x1 x2 // x2 = x1 + 1
sw x2 x0 237 // mem[x0 + 237] = x2 // mem[237] = 65509
sw x2 x0 761 // mem[x0 + 761] = x2 // mem[761] = 65509
addi 2 x1 x3 // x3 = x1 + 2
sw x3 x0 238 // mem[x0 + 238] = x3 // mem[238] = 65510
sw x3 x0 762 // mem[x0 + 762] = x3 // mem[762] = 65510
addi 3 x1 x4 // x4 = x1 + 3
sw x4 x0 239 // mem[x0 + 239] = x4 // mem[239] = 65511
sw x4 x0 763 // mem[x0 + 763] = x4 // mem[763] = 65511
addi 4 x1 x5 // x5 = x1 + 4
sw x5 x0 240 // mem[x0 + 240] = x5 // mem[240] = 65512
sw x5 x0 764 // mem[x0 + 764] = x5 // mem[764] = 65512
addi 5 x1 x6 // x6 = x1 + 5
sw x6 x0 241 // mem[x0 + 241] = x6 // mem[241] = 65513
sw x6 x0 765 // mem[x0 + 765] = x6 // mem[765] = 65513
addi 6 x1 x7 // x7 = x1 + 6
sw x7 x0 242 // mem[x0 + 242] = x7 // mem[242] = 65514
sw x7 x0 766 // mem[x0 + 766] = x7 // mem[766] = 65514
addi 7 x1 x8 // x8 = x1 + 7
sw x8 x0 249 // mem[x0 + 249] = x8 // mem[249] = 65515
sw x8 x0 767 // mem[x0 + 767] = x8 // mem[767] = 65515
addi 8 x1 x9 // x9 = x1 + 8
sw x9 x0 250 // mem[x0 + 250] = x9 // mem[250] = 65516
sw x9 x0 768 // mem[x0 + 768] = x9 // mem[768] = 65516
addi 9 x1 x10 // x10 = x1 + 9
sw x10 x0 251 // mem[x0 + 251] = x10 // mem[251] = 65517
sw x10 x0 776 // mem[x0 + 776] = x10 // mem[776] = 65517
addi 10 x1 x11 // x11 = x1 + 10
sw x11 x0 252 // mem[x0 + 252] = x11 // mem[252] = 65518
sw x11 x0 777 // mem[x0 + 777] = x11 // mem[777] = 65518
addi 11 x1 x12 // x12 = x1 + 11
sw x12 x0 253 // mem[x0 + 253] = x12 // mem[253] = 65519
sw x12 x0 778 // mem[x0 + 778] = x12 // mem[778] = 65519
addi 12 x1 x13 // x13 = x1 + 12
sw x13 x0 254 // mem[x0 + 254] = x13 // mem[254] = 65520
sw x13 x0 779 // mem[x0 + 779] = x13 // mem[779] = 65520
addi 13 x1 x14 // x14 = x1 + 13
sw x14 x0 255 // mem[x0 + 255] = x14 // mem[255] = 65521
sw x14 x0 780 // mem[x0 + 780] = x14 // mem[780] = 65521
addi 14 x1 x15 // x15 = x1 + 14
sw x15 x0 256 // mem[x0 + 256] = x15 // mem[256] = 65522
sw x15 x0 781 // mem[x0 + 781] = x15 // mem[781] = 65522
addi 15 x1 x16 // x16 = x1 + 15
sw x16 x0 257 // mem[x0 + 257] = x16 // mem[257] = 65523
sw x16 x0 782 // mem[x0 + 782] = x16 // mem[782] = 65523
addi 16 x1 x17 // x17 = x1 + 16
sw x17 x0 258 // mem[x0 + 258] = x17 // mem[258] = 65524
sw x17 x0 783 // mem[x0 + 783] = x17 // mem[783] = 65524
addi 17 x1 x18 // x18 = x1 + 17
sw x18 x0 265 // mem[x0 + 265] = x18 // mem[265] = 65525
sw x18 x0 784 // mem[x0 + 784] = x18 // mem[784] = 65525
addi 18 x1 x19 // x19 = x1 + 18
sw x19 x0 266 // mem[x0 + 266] = x19 // mem[266] = 65526
sw x19 x0 792 // mem[x0 + 792] = x19 // mem[792] = 65526
addi 19 x1 x20 // x20 = x1 + 19
sw x20 x0 267 // mem[x0 + 267] = x20 // mem[267] = 65527
sw x20 x0 793 // mem[x0 + 793] = x20 // mem[793] = 65527
addi 20 x1 x21 // x21 = x1 + 20
sw x21 x0 268 // mem[x0 + 268] = x21 // mem[268] = 65528
sw x21 x0 794 // mem[x0 + 794] = x21 // mem[794] = 65528
addi 21 x1 x22 // x22 = x1 + 21
sw x22 x0 269 // mem[x0 + 269] = x22 // mem[269] = 65529
sw x22 x0 795 // mem[x0 + 795] = x22 // mem[795] = 65529
addi 22 x1 x23 // x23 = x1 + 22
sw x23 x0 270 // mem[x0 + 270] = x23 // mem[270] = 65530
sw x23 x0 796 // mem[x0 + 796] = x23 // mem[796] = 65530
addi 23 x1 x24 // x24 = x1 + 23
sw x24 x0 271 // mem[x0 + 271] = x24 // mem[271] = 65531
sw x24 x0 797 // mem[x0 + 797] = x24 // mem[797] = 65531
addi 24 x1 x25 // x25 = x1 + 24
sw x25 x0 272 // mem[x0 + 272] = x25 // mem[272] = 65532
sw x25 x0 798 // mem[x0 + 798] = x25 // mem[798] = 65532
addi 25 x1 x26 // x26 = x1 + 25
sw x26 x0 273 // mem[x0 + 273] = x26 // mem[273] = 65533
sw x26 x0 799 // mem[x0 + 799] = x26 // mem[799] = 65533
addi 26 x1 x27 // x27 = x1 + 26
sw x27 x0 274 // mem[x0 + 274] = x27 // mem[274] = 65534
sw x27 x0 800 // mem[x0 + 800] = x27 // mem[800] = 65534
addi 28 x1 x28 // x28 = x1 + 28
sw x28 x0 1199 // mem[x0 + 1199] = x28 // mem[1199] = 65536
addi 22 x0 x31 // x31 = x0 + 22 
addi 50 x0 x29 // x29 = x0 + 50 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 360 x0 x30 // x30 = x0 + 360 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 917 x0 x31 // x31 = x0 + 917 
or x29 x31 x29 // x29 = x31 | x29
sw x29 x0 1210 // mem[x0 + 1210] = x29 // mem[1210] = 210453397
addi 22 x0 x31 // x31 = x0 + 22 
addi 131 x0 x29 // x29 = x0 + 131 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 1196 x0 x30 // x30 = x0 + 1196 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 65 x0 x31 // x31 = x0 + 65 
or x29 x31 x1 // x1 = x31 | x29
sw x1 x0 1208 // mem[x0 + 1208] = x1 // mem[1208] = 551903297
addi 22 x0 x31 // x31 = x0 + 22 
addi 224 x0 x29 // x29 = x0 + 224 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 1572 x0 x30 // x30 = x0 + 1572 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 1769 x0 x31 // x31 = x0 + 1769 
or x29 x31 x2 // x2 = x31 | x29
sw x2 x0 1213 // mem[x0 + 1213] = x2 // mem[1213] = 942745321
addi 22 x0 x31 // x31 = x0 + 22 
addi 288 x0 x29 // x29 = x0 + 288 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 1572 x0 x30 // x30 = x0 + 1572 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 1769 x0 x31 // x31 = x0 + 1769 
or x29 x31 x3 // x3 = x31 | x29
sw x3 x0 1209 // mem[x0 + 1209] = x3 // mem[1209] = 1211180777
// ------------------------------------------------------------------
// SoC sub-units management
// ------------------------------------------------------------------
systemwait:
addi 201 x0 x30 // x30 = x0 + 201 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 50 x0 x31 // x31 = x0 + 50 
or x31 x30 x1 // x1 = x30 | x31
lw 0 x1 x2 // x2 = mem[x1 + 0]
addi 1 x0 x4 // x4 = 1 + x0
bne x4 x2 endifmark0_0 // x2 != x4 goto endifmark0_0 // interruption by uart, clear uart memory area
addi 100 x0 x30 // x30 = x0 + 100 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2000 x0 x31 // x31 = x0 + 2000 
or x31 x30 x10 // x10 = x30 | x31
startwhilemark0_2:
beq x1 x10 endwhilemark0_2 //     x10 == x1 goto endwhilemark0_2
sw x0 x10 0 //         mem[x10 + 0] = x0
addi 1 x10 x10 //         x10 = x10 + 1
beq x0 x0 startwhilemark0_2 // x0 == x0 goto startwhilemark0_2
    endwhilemark0_2:
lw 2 x1 x3 //     x3 = mem[x1 + 2] // clear button request
endifmark0_0:
lw 2 x1 x3 // x3 = mem[x1 + 2] // read button request
beq x3 x4 Main // x4 == x3 goto Main // start main function
beq x0 x0 systemwait // x0 == x0 goto systemwait
// Main function
Main:
// ------------------------------------------------------------------
// RegFile Work Aera 1: Re-Order Minimum coded (MCU)
// Avialiable register remaind: x23
// ------------------------------------------------------------------
// blocks: 1216 Y 1280 U 1344 V 1408 Block 1472 MidBlock
addi 100 x0 x30 // x30 = x0 + 100 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2000 x0 x31 // x31 = x0 + 2000 
or x31 x30 x20 // x20 = x30 | x31
addi 2000 x0 x21 // x21 = x0 + 2000
lw 0 x20 x28 // x28 = mem[x20 + 0]
lw 1 x20 x29 // x29 = mem[x20 + 1]
sw x28 x0 1187 // mem[x0 + 1187] = x28
sw x29 x0 1188 // mem[x0 + 1188] = x29
addi 4 x0 x1 // x1 = x0 + 4
sra x1 x28 x28 // x28 = x28 >> x1
sra x1 x29 x27 // x27 = x29 >> x1
sw x28 x0 1189 // mem[x0 + 1189] = x28
sw x27 x0 1190 // mem[x0 + 1190] = x27
addi 0 x0 x1 // x1 = x0 + 0
addi 0 x0 x2 // x2 = x0 + 0
addi 0 x0 x3 // x3 = x0 + 0
addi 0 x0 x4 // x4 = x0 + 0
addi 0 x0 x5 // x5 = x0 + 0
addi 0 x0 x6 // x6 = x0 + 0
addi 16 x0 x26 // x26 = x0 + 16
addi 8 x0 x25 // x25 = x0 + 8
addi 2 x0 x24 // x24 = x0 + 2
startwhilemark0_3:
beq x28 x2 endwhilemark0_3 // x2 == x28 goto endwhilemark0_3
mul x29 x26 x10 //     x10 = x26 *l x29
mul x2 x10 x10 //     x10 = x10 *l x2
addi 2 x10 x10 //     x10 = x10 + 2
startwhilemark1_2:
beq x27 x1 endwhilemark1_2 //     x1 == x27 goto endwhilemark1_2
mul x1 x26 x11 //         x11 = x26 *l x1
add x10 x11 x11 //         x11 = x11 + x10
startwhilemark2_0:
beq x24 x4 endwhilemark2_0 //         x4 == x24 goto endwhilemark2_0
mul x29 x25 x12 //             x12 = x25 *l x29
mul x4 x12 x12 //             x12 = x12 *l x4 
add x11 x12 x12 //             x12 = x12 + x11
startwhilemark3_0:
beq x24 x3 endwhilemark3_0 //             x3 == x24 goto endwhilemark3_0
mul x3 x25 x13 //                 x13 = x25 *l x3
add x12 x13 x13 //                 x13 = x13 + x12
startwhilemark4_0:
beq x25 x5 endwhilemark4_0 //                 x5 == x25 goto endwhilemark4_0
add x13 x5 x14 //                     x14 = x5 + x13
startwhilemark5_0:
beq x25 x6 endwhilemark5_0 //                     x6 == x25 goto endwhilemark5_0
mul x6 x29 x15 //                         x15 = x29 *l x6
add x14 x15 x15 //                         x15 = x15 + x14
add x15 x20 x15 //                         x15 = x20 + x15
addi 255 x0 x19 //                         x19 = 255 + x0
lw 0 x15 x16 //                         x16 = mem[x15 + 0] // uart[x15]
sra x26 x16 x16 //                         x16 = x16 >> x26
and x19 x16 x16 //                         x16 = x16 & x19
lw 0 x15 x17 //                         x17 = mem[x15 + 0] // uart[x15]
sra x25 x17 x17 //                         x17 = x17 >> x25
and x19 x17 x17 //                         x17 = x17 & x19
lw 0 x15 x18 //                         x18 = mem[x15 + 0] // uart[x15]
and x19 x18 x18 //                         x18 = x18 & x19
lw 1208 x0 x19 //                         x19 = mem[x0 + 1208]
mulh x16 x19 x19 //                         x19 = x19 *h x16
lw 1209 x0 x30 //                         x30 = mem[x0 + 1209]
mulh x17 x30 x30 //                         x30 = x30 *h x17
add x30 x19 x19 //                         x19 = x19 + x30
lw 1210 x0 x30 //                         x30 = mem[x0 + 1210]
mulh x18 x30 x30 //                         x30 = x30 *h x18
add x30 x19 x19 //                         x19 = x19 + x30
addi 16 x19 x19 //                         x19 = x19 + 16
addi 0 x19 x22 //                         x22 = x19 + 0  // Y
lw 1211 x0 x19 //                         x19 = mem[x0 + 1211]
mulh x16 x19 x19 //                         x19 = x19 *h x16
lw 1212 x0 x30 //                         x30 = mem[x0 + 1212]
mulh x17 x30 x30 //                         x30 = x30 *h x17
add x30 x19 x19 //                         x19 = x19 + x30
lw 1213 x0 x30 //                         x30 = mem[x0 + 1213]
mulh x18 x30 x30 //                         x30 = x30 *h x18
add x30 x19 x19 //                         x19 = x19 + x30
addi 128 x19 x19 //                         x19 = x19 + 128
sll x25 x19 x19 //                         x19 = x19 << x25
add x22 x19 x22 //                         x22 = x19 + x22 // Cb
lw 1214 x0 x19 //                         x19 = mem[x0 + 1214]
mulh x17 x19 x19 //                         x19 = x19 *h x17
lw 1213 x0 x30 //                         x30 = mem[x0 + 1213]
mulh x16 x30 x30 //                         x30 = x30 *h x16 
add x30 x19 x19 //                         x19 = x19 + x30
lw 1215 x0 x30 //                         x30 = mem[x0 + 1215]
mulh x18 x30 x30 //                         x30 = x30 *h x18
add x30 x19 x19 //                         x19 = x19 + x30
addi 128 x19 x19 //                         x19 = x19 + 128
sll x26 x19 x19 //                         x19 = x19 << x26
add x22 x19 x22 //                         x22 = x19 + x22 // Cr
sw x22 x21 0 //                         mem[x21 + 0] = x22
addi 1 x21 x21 //                         x21 = x21 + 1
addi 1 x6 x6 //                         x6 = x6 + 1
beq x0 x0 startwhilemark5_0 // x0 == x0 goto startwhilemark5_0
                    endwhilemark5_0:
addi 0 x0 x6 //                     x6 = 0 + x0
addi 1 x5 x5 //                     x5 = x5 + 1
beq x0 x0 startwhilemark4_0 // x0 == x0 goto startwhilemark4_0
                endwhilemark4_0:
addi 0 x0 x5 //                 x5 = 0 + x0
addi 1 x3 x3 //                 x3 = x3 + 1
beq x0 x0 startwhilemark3_0 // x0 == x0 goto startwhilemark3_0
            endwhilemark3_0:
addi 0 x0 x3 //             x3 = 0 + x0
addi 1 x4 x4 //             x4 = x4 + 1
beq x0 x0 startwhilemark2_0 // x0 == x0 goto startwhilemark2_0
        endwhilemark2_0:
addi 0 x0 x4 //         x4 = 0 + x0
addi 1 x1 x1 //         x1 = x1 + 1
beq x0 x0 startwhilemark1_2 // x0 == x0 goto startwhilemark1_2
    endwhilemark1_2:
addi 0 x0 x1 //     x1 = 0 + x0
addi 1 x2 x2 //     x2 = x2 + 1
beq x0 x0 startwhilemark0_3 // x0 == x0 goto startwhilemark0_3
endwhilemark0_3:
// clear uart
addi 100 x0 x30 // x30 = x0 + 100 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2000 x0 x31 // x31 = x0 + 2000 
or x31 x30 x10 // x10 = x30 | x31
addi 201 x0 x30 // x30 = x0 + 201 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 50 x0 x31 // x31 = x0 + 50 
or x31 x30 x11 // x11 = x30 | x31
startwhilemark0_4:
beq x11 x10 endwhilemark0_4 // x10 == x11 goto endwhilemark0_4
sw x0 x10 0 //     mem[x10 + 0] = x0
addi 1 x10 x10 //     x10 = x10 + 1
beq x0 x0 startwhilemark0_4 // x0 == x0 goto startwhilemark0_4
endwhilemark0_4:
// ------------------------------------------------------------------
// RegFile Work Aera 2: Block Process and Huffman endcode
// ------------------------------------------------------------------
// Function used regiters
addi 32 x0 x26 // x26 = x0 + 32
addi 100 x0 x30 // x30 = x0 + 100 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2000 x0 x31 // x31 = x0 + 2000 
or x31 x30 x25 // x25 = x30 | x31
// x28 return key and mode
// x29 differential DC value
// Function Entry
beq x0 x0 EndBlockProcess // x0 == x0 goto EndBlockProcess
BlockProcess:
// ------------------------------------
// 8x8 matrix subtraction: Sub Area 1
// ------------------------------------
addi 0 x0 x1 // x1 = 0 + x0
addi 64 x0 x2 // x2 = 64 + x0
startwhilemark0_5:
beq x2 x1 endwhilemark0_5 // x1 == x2 goto endwhilemark0_5
lw 1408 x1 x3 //     x3 = mem[x1 + 1408]
addi -128 x3 x3 //     x3 = x3 + -128
sw x3 x1 1472 //     mem[x1 + 1472] = x3
sw x0 x1 1408 //     mem[x1 + 1408] = x0
addi 1 x1 x1 //     x1 = x1 + 1
beq x0 x0 startwhilemark0_5 // x0 == x0 goto startwhilemark0_5
endwhilemark0_5:
// ------------------------------------
// Discrete Cosine Transform: Sub Area 2
// ------------------------------------
// SubFunction: CORDIC cosine
beq x0 x0 ENDCORDIC // x0 == x0 goto ENDCORDIC
CORDIC:
addi 0 x0 x8 //     x8 = 0 + x0
addi 100 x0 x30 // x30 = x0 + 100 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1087 x0 x31 // x31 = x0 + 1087 
or x31 x30 x20 // x20 = x30 | x31
addi -202 x0 x30 // x30 = x0 + -202 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1921 x0 x31 // x31 = x0 + 1921 
or x31 x30 x21 // x21 = x30 | x31
addi 50 x0 x30 // x30 = x0 + 50 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 544 x0 x31 // x31 = x0 + 544 
or x31 x30 x22 // x22 = x30 | x31
startwhilemark0_6:
bge x9 x20 endwhilemark0_6 //     x20 >= x9 goto endwhilemark0_6 
add x21 x9 x9 //         x9 = x9 + x21
beq x0 x0 startwhilemark0_6 // x0 == x0 goto startwhilemark0_6
    endwhilemark0_6:
bge x9 x22 endifmark0_1 //     x22 >= x9 goto endifmark0_1
addi 1 x0 x8 //         x8 = 1 + x0
xori -1 x20 x20 //         x20 = x20 ^ -1
addi 1 x20 x20 //         x20 = x20 + 1
add x20 x9 x9 //         x9 = x9 + x20
beq x0 x0 endelse2 //         x0 == x0 goto endelse2
    endifmark0_1:
xori -1 x22 x22 //         x22 = x22 ^ -1 
addi 1 x22 x22 //         x22 = x22 + 1
bge x22 x9 endifmark0_2 //         x9 >= x22 goto endifmark0_2
addi 1 x0 x8 //             x8 = 1 + x0
add x20 x9 x9 //             x9 = x9 + x20
        endifmark0_2:
    endelse2:
addi 0 x0 x10 //     x10 = 0 + x0
sw x0 x0 1191 //     mem[x0 + 1191] = x0
sw x0 x0 1192 //     mem[x0 + 1192] = x0
sw x0 x0 1193 //     mem[x0 + 1193] = x0
sw x0 x0 1194 //     mem[x0 + 1194] = x0
sw x0 x0 1195 //     mem[x0 + 1195] = x0
sw x0 x0 1196 //     mem[x0 + 1196] = x0
sw x0 x0 1197 //     mem[x0 + 1197] = x0
addi 0 x0 x7 //     x7 = 0 + x0
addi 7 x0 x22 //     x22 = 7 + x0
startwhilemark0_7:
beq x22 x7 endwhilemark0_7 //     x7 == x22 goto endwhilemark0_7
bge x10 x9 endifmark0_3 //         x9 >= x10 goto endifmark0_3
lw 1180 x7 x20 //             x20 = mem[x7 + 1180]
xori -1 x20 x20 //             x20 = x20 ^ -1
addi 1 x20 x20 //             x20 = x20 + 1
add x20 x10 x10 //             x10 = x10 + x20
addi 1 x0 x21 //             x21 = 1 + x0
sw x21 x7 1191 //             mem[x7 + 1191] = x21
beq x0 x0 endelse3 //             x0 == x0 goto endelse3
        endifmark0_3:
lw 1180 x7 x20 //             x20 = mem[x7 + 1180]
add x20 x10 x10 //             x10 = x10 + x20
sw x0 x7 1191 //             mem[x7 + 1191] = x0
        endelse3:
addi 1 x7 x7 //         x7 = x7 + 1
beq x0 x0 startwhilemark0_7 // x0 == x0 goto startwhilemark0_7
    endwhilemark0_7:
addi 19 x0 x30 // x30 = x0 + 19 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 885 x0 x31 // x31 = x0 + 885 
or x31 x30 x1 // x1 = x30 | x31
addi 0 x0 x2 //     x2 = 0 + x0
addi 6 x0 x7 //     x7 = 6 + x0
addi 1 x0 x21 //     x21 = 1 + x0
addi -1 x0 x23 //     x23 = -1 + x0
startwhilemark0_8:
beq x23 x7 endwhilemark0_8 //     x7 == x23 goto endwhilemark0_8
lw 1191 x7 x20 //         x20 = mem[x7 + 1191]
sra x7 x2 x22 //         x22 = x2 >> x7
bne x21 x20 endifmark0_4 //         x20 != x21 goto endifmark0_4
xori -1 x22 x22 //             x22 = x22 ^ -1
addi 1 x22 x22 //             x22 = x22 + 1
add x22 x1 x1 //             x1 = x1 + x22
sra x7 x1 x22 //             x22 = x1 >> x7
beq x0 x0 endelse4 //             x0 == x0 goto endelse4
        endifmark0_4:
add x22 x1 x1 //             x1 = x1 + x22
sra x7 x1 x22 //             x22 = x1 >> x7
xori -1 x22 x22 //             x22 = x22 ^ -1
addi 1 x22 x22 //             x22 = x22 + 1
        endelse4:
add x2 x22 x2 //         x2 = x22 + x2
addi -1 x7 x7 //         x7 = x7 + -1
beq x0 x0 startwhilemark0_8 // x0 == x0 goto startwhilemark0_8
    endwhilemark0_8:
bne x21 x8 endifmark0_5 //     x8 != x21 goto endifmark0_5
xori -1 x1 x1 //         x1 = x1 ^ -1
addi 1 x1 x1 //         x1 = x1 + 1
    endifmark0_5:
// CORDIC return gate
// return key: x24
addi 1 x0 x21 // x21 = 1 + x0
beq x0 x24 CORDICGate0 // x24 == x0 goto CORDICGate0
beq x21 x24 CORDICGate1 // x24 == x21 goto CORDICGate1
ENDCORDIC:
// DCT
addi 8 x0 x15 // x15 = 8 + x0
addi 2 x0 x17 // x17 = 2 + x0
addi 0 x0 x3 // x3 = 0 + x0
addi 0 x0 x4 // x4 = 0 + x0
addi 0 x0 x5 // x5 = 0 + x0
addi 0 x0 x6 // x6 = 0 + x0
startwhilemark0_9:
beq x15 x3 endwhilemark0_9 // x3 == x15 goto endwhilemark0_9
bne x0 x3 endifmark0_6 //     x3 != x0 goto endifmark0_6
lw 1198 x0 x11 //         x11 = mem[x0 + 1198]
beq x0 x0 endelse5 //         x0 == x0 goto endelse5
    endifmark0_6:
lw 1199 x0 x11 //         x11 = mem[x0 + 1199]
    endelse5:
startwhilemark1_3:
beq x15 x4 endwhilemark1_3 //     x4 == x15 goto endwhilemark1_3
bne x0 x4 endifmark0_7 //         x4 != x0 goto endifmark0_7
lw 1198 x0 x12 //             x12 = mem[x0 + 1198]
beq x0 x0 endelse6 //             x0 == x0 goto endelse6
        endifmark0_7:
lw 1199 x0 x12 //             x12 = mem[x0 + 1199]
        endelse6:
addi 0 x0 x14 //         x14 = 0 + x0
startwhilemark2_1:
beq x15 x5 endwhilemark2_1 //         x5 == x15 goto endwhilemark2_1
startwhilemark3_1:
beq x15 x6 endwhilemark3_1 //             x6 == x15 goto endwhilemark3_1
mul x15 x5 x16 //                 x16 = x5 *l x15
add x6 x16 x16 //                 x16 = x16 + x6
lw 1472 x16 x13 //                 x13 = mem[x16 + 1472]
mul x5 x17 x9 //                 x9 = x17 *l x5
addi 1 x9 x9 //                 x9 = x9 + 1
mul x3 x9 x9 //                 x9 = x9 *l x3
lw 1200 x0 x23 //                 x23 = mem[x0 + 1200]
mul x23 x9 x9 //                 x9 = x9 *l x23
addi 0 x0 x24 //                 x24 = 0 + x0 // return key
beq x0 x0 CORDIC //                 x0 == x0 goto CORDIC // call function
                CORDICGate0: // return gate
mul x1 x13 x13 //                 x13 = x13 *l x1
sra x15 x13 x13 //                 x13 = x13 >> x15
mul x6 x17 x9 //                 x9 = x17 *l x6
addi 1 x9 x9 //                 x9 = x9 + 1
mul x4 x9 x9 //                 x9 = x9 *l x4
lw 1200 x0 x23 //                 x23 = mem[x0 + 1200]
mul x23 x9 x9 //                 x9 = x9 *l x23
addi 1 x0 x24 //                 x24 = 1 + x0// return key
beq x0 x0 CORDIC //                 x0 == x0 goto CORDIC // call function
                CORDICGate1: // return gate
mul x1 x13 x13 //                 x13 = x13 *l x1
sra x15 x13 x13 //                 x13 = x13 >> x15
add x13 x14 x14 //                 x14 = x14 + x13
addi 1 x6 x6 //                 x6 = x6 + 1
beq x0 x0 startwhilemark3_1 // x0 == x0 goto startwhilemark3_1
            endwhilemark3_1:
addi 0 x0 x6 //             x6 = 0 + x0
addi 1 x5 x5 //             x5 = x5 + 1
beq x0 x0 startwhilemark2_1 // x0 == x0 goto startwhilemark2_1
        endwhilemark2_1:
mulh x12 x11 x16 //         x16 = x11 *h x12
mul x12 x11 x13 //         x13 = x11 *l x12
addi 22 x0 x31 // x31 = x0 + 22 
addi 511 x0 x29 // x29 = x0 + 511 
sll x31 x29 x29 // x29 = x29 << x31
addi 11 x0 x31 // x31 = x0 + 11 
addi 2047 x0 x30 // x30 = x0 + 2047 
sll x31 x30 x30 // x30 = x30 << x31
or x29 x30 x29 // x29 = x30 | x29
addi 2047 x0 x31 // x31 = x0 + 2047 
or x29 x31 x21 // x21 = x31 | x29
and x21 x13 x13 //         x13 = x13 & x21
addi 15 x0 x18 //         x18 = 15 + x0
sll x18 x16 x16 //         x16 = x16 << x18
addi 1 x18 x18 //         x18 = x18 + 1
sra x18 x13 x13 //         x13 = x13 >> x18
or x16 x13 x13 //         x13 = x13 | x16
mulh x14 x13 x13 //         x13 = x13 *h x14
addi 3 x0 x18 //         x18 = 3 + x0
sra x18 x13 x13 //         x13 = x13 >> x18
beq x0 x13 endifmark0_8 //         x13 == x0 goto endifmark0_8
addi 1 x13 x13 //             x13 = x13 + 1
        endifmark0_8:
mul x15 x3 x16 //         x16 = x3 *l x15
add x16 x4 x16 //         x16 = x4 + x16
sw x13 x16 1408 //         mem[x16 + 1408] = x13
addi 0 x0 x5 //         x5 = 0 + x0
addi 1 x4 x4 //         x4 = x4 + 1
beq x0 x0 startwhilemark1_3 // x0 == x0 goto startwhilemark1_3
    endwhilemark1_3:
addi 0 x0 x4 //     x4 = 0 + x0
addi 1 x3 x3 //     x3 = x3 + 1
beq x0 x0 startwhilemark0_9 // x0 == x0 goto startwhilemark0_9
endwhilemark0_9:
// ------------------------------------
// Quantization: Sub Area 3
// ------------------------------------
addi 1052 x0 x2 // x2 = 1052 + x0
bne x0 x28 endifmark0_9 // x28 != x0 goto endifmark0_9
addi 1116 x0 x2 //     x2 = 1116 + x0
endifmark0_9:
addi 0 x0 x1 // x1 = 0 + x0
addi 64 x0 x5 // x5 = 64 + x0 
addi 16 x0 x7 // x7 = 16 + x0
startwhilemark0_10:
beq x5 x1 endwhilemark0_10 // x1 == x5 goto endwhilemark0_10
add x2 x1 x6 //     x6 = x1 + x2
lw 0 x6 x3 //     x3 = mem[x6 + 0]
lw 1408 x1 x4 //     x4 = mem[x1 + 1408]
mul x4 x3 x3 //     x3 = x3 *l x4
sra x7 x3 x3 //     x3 = x3 >> x7
sw x0 x1 1408 //     mem[x1 + 1408] = x0
sw x3 x1 1472 //     mem[x1 + 1472] = x3
addi 1 x1 x1 //     x1 = x1 + 1
beq x0 x0 startwhilemark0_10 // x0 == x0 goto startwhilemark0_10
endwhilemark0_10:
// ------------------------------------
// Zigzag Scan: Sub Area 4
// ------------------------------------
addi 0 x0 x1 // x1 = 0 + x0
addi 0 x0 x2 // x2 = 0 + x0
addi 0 x0 x5 // x5 = 0 + x0
addi 1 x0 x3 // x3 = 1 + x0
addi 0 x0 x4 // x4 = 0 + x0
addi 7 x0 x6 // x6 = 7 + x0
addi 8 x0 x7 // x7 = 8 + x0
addi 1 x0 x9 // x9 = 1 + x0
// Differential DC Value:
lw 1204 x28 x29 // x29 = mem[x28 + 1204]
lw 1472 x0 x27 // x27 = mem[x0 + 1472]
xori -1 x29 x29 // x29 = x29 ^ -1
addi 1 x29 x29 // x29 = x29 + 1
add x29 x27 x11 // x11 = x27 + x29
sw x27 x28 1204 // mem[x28 + 1204] = x27
sw x11 x0 1408 // mem[x0 + 1408] = x11
startwhilemark0_11:
bne x0 x0 endwhilemark0_11 // x0 != x0 goto endwhilemark0_11
    // special if structure
beq x0 x1 iformark0 //     x1 == x0 goto iformark0
beq x6 x1 iformark0 //     x1 == x6 goto iformark0
beq x0 x0 endiformark0 //     x0 == x0 goto endiformark0
    iformark0:
addi 1 x2 x2 //         x2 = x2 + 1
addi 1 x0 x4 //         x4 = 1 + x0
beq x0 x0 endelseifmark0 //         x0 == x0 goto endelseifmark0
    endiformark0:
beq x0 x2 iformark1 //     x2 == x0 goto iformark1
beq x6 x2 iformark1 //     x2 == x6 goto iformark1
beq x0 x0 endelseifmark0 //     x0 == x0 goto endelseifmark0
    iformark1:
addi 1 x1 x1 //         x1 = x1 + 1
addi 1 x0 x4 //         x4 = 1 + x0
    endelseifmark0:
bne x9 x4 endifmark0_10 //     x4 != x9 goto endifmark0_10
addi 0 x0 x4 //         x4 = 0 + x0
xori -1 x3 x3 //         x3 = x3 ^ -1
addi 1 x3 x3 //         x3 = x3 + 1
addi 1 x5 x5 //         x5 = x5 + 1
mul x7 x2 x12 //         x12 = x2 *l x7
add x1 x12 x12 //         x12 = x12 + x1
lw 1472 x12 x11 //         x11 = mem[x12 + 1472]
sw x11 x5 1408 //         mem[x5 + 1408] = x11
    endifmark0_10:
    // if x1 == x6 and x2 == x6:
bne x6 x2 ifandmark0 //     x2 != x6 goto ifandmark0
bne x6 x1 ifandmark0 //     x1 != x6 goto ifandmark0
beq x0 x0 breakmark0 //         x0 == x0 goto breakmark0
    ifandmark0:
addi 1 x5 x5 //     x5  = x5  + 1
xori -1 x3 x13 //     x13 = x3  ^ -1
addi 1 x13 x13 //     x13 = x13 + 1
add x1 x13 x1 //     x1  = x13 + x1
add x3 x2 x2 //     x2  = x2  + x3
mul x7 x2 x12 //     x12 = x2 *l x7
add x1 x12 x12 //     x12 = x12 + x1
lw 1472 x12 x11 //     x11 = mem[x12 + 1472]
sw x11 x5 1408 //     mem[x5 + 1408] = x11
beq x0 x0 startwhilemark0_11 // x0 == x0 goto startwhilemark0_11
endwhilemark0_11:
breakmark0:
// ------------------------------------
// Huffman Encode: Sub Area 6
// ------------------------------------
// 0 for Luminace
bne x0 x28 endifmark0_11 // x28 != x0 goto endifmark0_11
addi 0 x0 x10 //     x10 = 0 + x0
addi 12 x0 x11 //     x11 = 12 + x0
addi 24 x0 x12 //     x12 = 24 + x0
addi 275 x0 x13 //     x13 = 275 + x0
beq x0 x0 endelse7 //     x0 == x0 goto endelse7
endifmark0_11:
addi 526 x0 x10 //     x10 = 526 + x0
addi 538 x0 x11 //     x11 = 538 + x0
addi 550 x0 x12 //     x12 = 550 + x0
addi 801 x0 x13 //     x13 = 801 + x0
endelse7:
// SubFunction: Get data and size
beq x0 x0 EndGetDataAndSize // x0 == x0 goto EndGetDataAndSize
GetDataAndSize:
addi 0 x0 x14 //     x14 = 0 + x0
addi 0 x0 x15 //     x15 = 0 + x0
addi 1 x0 x17 //     x17 = 1 + x0
bge x0 x1 endifmark0_12 //     x1 >= x0 goto endifmark0_12 // x1: data < 0 then -x1
xori -1 x1 x1 //         x1 = x1 ^ -1
addi 1 x1 x1 //         x1 = x1 + 1
addi 1 x0 x15 //         x15 = 1 + x0 // less than 1 flag
    endifmark0_12:
addi 0 x1 x2 //     x2 = x1 + 0 // x2: data
startwhilemark0_12:
beq x0 x1 endwhilemark0_12 //     x1 == x0 goto endwhilemark0_12
sra x17 x1 x1 //         x1 = x1 >> x17 // x1 >> 1
addi 1 x14 x14 //         x14 = x14 + 1
beq x0 x0 startwhilemark0_12 // x0 == x0 goto startwhilemark0_12
    endwhilemark0_12:
addi 0 x14 x3 //     x3 = x14 + 0
bne x17 x15 endifmark0_13 //     x15 != x17 goto endifmark0_13
addi 0 x0 x16 //         x16 = 0 + x0
startwhilemark0_13:
beq x0 x14 endwhilemark0_13 //         x14 == x0 goto endwhilemark0_13
sll x17 x16 x16 //             x16 = x16 << x17
addi 1 x16 x16 //             x16 = x16 + 1
addi -1 x14 x14 //             x14 = x14 + -1
beq x0 x0 startwhilemark0_13 // x0 == x0 goto startwhilemark0_13
        endwhilemark0_13:
xori -1 x2 x2 //         x2 = x2 ^ -1
and x16 x2 x2 //         x2 = x2 & x16
    endifmark0_13:
// Get data and size return gate
// return key: x24
addi 1 x0 x19 // x19 = 1 + x0
beq x0 x24 GetDataAndSizeReturnGate0 // x24 == x0 goto GetDataAndSizeReturnGate0
beq x19 x24 GetDataAndSizeReturnGate1 // x24 == x19 goto GetDataAndSizeReturnGate1
beq x0 x0 Main // x0 == x0 goto Main // debug
EndGetDataAndSize:
// SubFunction: Push Huffman bit stack
beq x0 x0 EndPushHuffmanBitStack // x0 == x0 goto EndPushHuffmanBitStack
PushHuffmanBitStack:
lw 0 x25 x14 //     x14 = mem[x25 + 0]
blt x5 x26 endifmark0_14 //     x26 < x5 goto endifmark0_14 // stack spave >= push size
xori -1 x5 x5 //         x5 = x5 ^ -1
addi 1 x5 x5 //         x5 = x5 + 1
add x5 x26 x18 //         x18 = x26 + x5
sll x18 x4 x18 //         x18 = x4 << x18 // push data
add x18 x14 x14 //         x14 = x14 + x18
sw x14 x25 0 //         mem[x25 + 0] = x14
add x5 x26 x26 //         x26 = x26 + x5
beq x0 x0 endelse8 //         x0 == x0 goto endelse8
    endifmark0_14:
xori -1 x26 x19 //         x19 = x26 ^ -1
addi 1 x19 x19 //         x19 = x19 + 1
add x19 x5 x18 //         x18 = x5 + x19 // push size - stack space
sra x18 x4 x18 //         x18 = x4 >> x18 // push data >> 
or x18 x14 x14 //         x14 = x14 | x18 // last data | push data
sw x14 x25 0 //         mem[x25 + 0] = x14 // fill the former space
add x19 x5 x5 //         x5 = x5 + x19 // rest push size
addi 0 x5 x15 //         x15 = x5 + 0
addi 0 x0 x16 //         x16 = 0 + x0
addi 1 x0 x19 //         x19 = x0 + 1
startwhilemark0_14:
beq x0 x15 endwhilemark0_14 //         x15 == x0 goto endwhilemark0_14
sll x19 x16 x16 //             x16 = x16 << x19
addi 1 x16 x16 //             x16 = x16 + 1
addi -1 x15 x15 //             x15 = x15 + -1
beq x0 x0 startwhilemark0_14 // x0 == x0 goto startwhilemark0_14
        endwhilemark0_14:
and x4 x16 x16 //         x16 = x16 & x4 // trim the push data
xori -1 x5 x19 //         x19 = x5 ^ -1
addi 1 x19 x19 //         x19 = x19 + 1
addi 32 x19 x26 //         x26 = 32 + x19 // rest space
sll x26 x16 x17 //         x17 = x16 << x26 // new data
addi 1 x25 x25 //         x25 = x25 + 1
sw x17 x25 0 //         mem[x25 + 0] = x17
    endelse8:
// Push Huffman bit stack return gate
// return key: x23
addi 1 x0 x19 // x19 = 1 + x0
addi 2 x0 x18 // x18 = 2 + x0
addi 3 x0 x5 // x5 = 3 + x0
beq x0 x23 PushHuffmanBitStackReturnGate0 // x23 == x0 goto PushHuffmanBitStackReturnGate0
beq x19 x23 PushHuffmanBitStackReturnGate1 // x23 == x19 goto PushHuffmanBitStackReturnGate1
beq x18 x23 PushHuffmanBitStackReturnGate2 // x23 == x18 goto PushHuffmanBitStackReturnGate2
beq x5 x23 PushHuffmanBitStackReturnGate3 // x23 == x5 goto PushHuffmanBitStackReturnGate3
beq x0 x0 Main // x0 == x0 goto Main // debug
EndPushHuffmanBitStack:
// DC
lw 1408 x0 x1 // x1 = mem[x0 + 1408]
addi 0 x0 x24 // x24 = x0 + 0
beq x0 x0 GetDataAndSize // x0 == x0 goto GetDataAndSize
GetDataAndSizeReturnGate0:
add x3 x10 x14 // x14 = x10 + x3
lw 0 x14 x6 // x6 = mem[x14 + 0]
add x3 x11 x14 // x14 = x11 + x3
lw 0 x14 x7 // x7 = mem[x14 + 0]
sll x3 x6 x4 // x4 = x6 << x3
add x2 x4 x4 // x4 = x4 + x2
add x7 x3 x5 // x5 = x3 + x7
addi 0 x0 x23 // x23 = x0 + 0
beq x0 x0 PushHuffmanBitStack // x0 == x0 goto PushHuffmanBitStack
PushHuffmanBitStackReturnGate0:
// AC
addi 0 x0 x9 // x9 = 0 + x0
addi 1 x0 x20 // x20 = 1 + x0
addi 64 x0 x21 // x21 = 64 + x0
addi 15 x0 x22 // x22 = 15 + x0
startwhilemark0_15:
beq x21 x20 endwhilemark0_15 // x20 == x21 goto endwhilemark0_15
lw 1408 x20 x15 //     x15 = mem[x20 + 1408]
bne x0 x15 endifmark0_15 //     x15 != x0 goto endifmark0_15
addi 1 x9 x9 //         x9 = x9 + 1
beq x0 x0 endelse9 //         x0 == x0 goto endelse9
    endifmark0_15:
startwhilemark1_4:
bge x9 x22 endwhilemark1_4 //         x22 >= x9 goto endwhilemark1_4 // zeros over than 15
addi -16 x9 x9 //             x9 = x9 + -16
lw 240 x12 x4 //             x4 = mem[x12 + 240]
lw 240 x13 x5 //             x5 = mem[x13 + 240]
addi 1 x0 x23 //             x23 = x0 + 1
beq x0 x0 PushHuffmanBitStack //             x0 == x0 goto PushHuffmanBitStack
            PushHuffmanBitStackReturnGate1:
beq x0 x0 startwhilemark1_4 // x0 == x0 goto startwhilemark1_4
        endwhilemark1_4:
        // Assembly
lw 1408 x20 x1 //         x1 = mem[x20 + 1408]
addi 1 x0 x24 //         x24 = x0 + 1
beq x0 x0 GetDataAndSize //         x0 == x0 goto GetDataAndSize
        GetDataAndSizeReturnGate1:
addi 4 x0 x17 // x17 = x0 + 4
sll x17 x9 x8 //         x8 = x9 << x17
add x3 x8 x8 //         x8 = x8 + x3
add x8 x12 x14 //         x14 = x12 + x8
lw 0 x14 x6 //         x6 = mem[x14 + 0]
add x8 x13 x14 //         x14 = x13 + x8
lw 0 x14 x7 //         x7 = mem[x14 + 0]
sll x3 x6 x4 //         x4 = x6 << x3
add x2 x4 x4 //         x4 = x4 + x2
add x7 x3 x5 //         x5 = x3 + x7
addi 2 x0 x23 //         x23 = x0 + 2
beq x0 x0 PushHuffmanBitStack //         x0 == x0 goto PushHuffmanBitStack
        PushHuffmanBitStackReturnGate2:
addi 0 x0 x9 //         x9 = 0 + x0
    endelse9:
addi 1 x20 x20 //     x20 = x20 + 1
beq x0 x0 startwhilemark0_15 // x0 == x0 goto startwhilemark0_15
endwhilemark0_15:
// EOB
beq x0 x9 endifmark0_16 // x9 == x0 goto endifmark0_16
lw 0 x12 x4 //     x4 = mem[x12 + 0]
lw 0 x13 x5 //     x5 = mem[x13 + 0]
addi 3 x0 x23 //     x23 = x0 + 3
beq x0 x0 PushHuffmanBitStack //     x0 == x0 goto PushHuffmanBitStack
    PushHuffmanBitStackReturnGate3:
endifmark0_16:
// debug
addi 200 x0 x30 // x30 = x0 + 200 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 2000 x0 x31 // x31 = x0 + 2000 
or x31 x30 x2 // x2 = x30 | x31
sw x26 x2 0 // mem[x2 + 0] = x26
// ------------------------------------
// Function Return Gate
// ------------------------------------
addi 0 x0 x1 // x1 = 0 + x0
addi 1 x0 x2 // x2 = 1 + x0
addi 2 x0 x3 // x3 = 2 + x0
beq x1 x28 BlockProcessReturnGate0 // x28 == x1 goto BlockProcessReturnGate0
beq x2 x28 BlockProcessReturnGate1 // x28 == x2 goto BlockProcessReturnGate1
beq x3 x28 BlockProcessReturnGate2 // x28 == x3 goto BlockProcessReturnGate2
EndBlockProcess:
// ------------------------------------------------------------------
// RegFile Work Aera 3: Sampling
// ------------------------------------------------------------------
sw x0 x0 1201 // mem[x0 + 1201] = x0
sw x0 x0 1202 // mem[x0 + 1202] = x0
sw x0 x0 1203 // mem[x0 + 1203] = x0
sw x0 x0 1204 // mem[x0 + 1204] = x0
sw x0 x0 1205 // mem[x0 + 1205] = x0
sw x0 x0 1206 // mem[x0 + 1206] = x0
addi 256 x0 x1 // x1 = 256 + x0 // 16 * 16
lw 1189 x0 x2 // x2 = mem[x0 + 1189]
mul x2 x1 x1 // x1 = x1 *l x2
lw 1190 x0 x2 // x2 = mem[x0 + 1190]
mul x2 x1 x4 // x4 = x1 *l x2
sw x4 x0 1207 // mem[x0 + 1207] = x4
addi 0 x0 x1 // x1 = 0 + x0
addi 0 x0 x2 // x2 = 0 + x0
addi 0 x0 x3 // x3 = 0 + x0
startwhilemark0_16:
beq x4 x1 endwhilemark0_16 // x1 == x4 goto endwhilemark0_16
lw 2000 x1 x6 //     x6 = mem[x1 + 2000]
addi 255 x0 x10 //     x10 = 255 + x0
addi 8 x0 x11 //     x11 = 8 + x0
addi 16 x0 x12 //     x12 = 16 + x0
and x6 x10 x6 //     x6 = x10 & x6
sw x6 x2 1216 //     mem[x2 + 1216] = x6
lw 2000 x1 x6 //     x6 = mem[x1 + 2000]
sra x11 x6 x6 //     x6 = x6 >> x11
and x10 x6 x6 //     x6 = x6 & x10
lw 1280 x2 x7 //     x7 = mem[x2 + 1280]
add x7 x6 x6 //     x6 = x6 + x7
sw x6 x2 1280 //     mem[x2 + 1280] = x6
lw 2000 x1 x6 //     x6 = mem[x1 + 2000]
lw 1344 x2 x7 //     x7 = mem[x2 + 1344]
sra x12 x6 x6 //     x6 = x6 >> x12
and x10 x6 x6 //     x6 = x6 & x10
add x7 x6 x6 //     x6 = x6 + x7
sw x6 x2 1344 //     mem[x2 + 1344] = x6
addi 63 x0 x6 //     x6 = 63 + x0
bne x6 x2 endifmark0_17 //     x2 != x6 goto endifmark0_17
sw x1 x0 1201 //         mem[x0 + 1201] = x1
sw x3 x0 1203 //         mem[x0 + 1203] = x3
addi 64 x0 x6 //         x6 = 64 + x0
addi 0 x0 x7 //         x7 = 0 + x0
startwhilemark1_5:
beq x6 x7 endwhilemark1_5 //         x7 == x6 goto endwhilemark1_5
lw 1216 x7 x9 //             x9 = mem[x7 + 1216]
sw x9 x7 1408 //             mem[x7 + 1408] = x9
addi 1 x7 x7 //             x7 = x7 + 1
beq x0 x0 startwhilemark1_5 // x0 == x0 goto startwhilemark1_5
        endwhilemark1_5:
addi 0 x0 x28 //         x28 = 0 + x0// return key
beq x0 x0 BlockProcess //         x0 == x0 goto BlockProcess // Call function
        BlockProcessReturnGate0: // Return Gate 0
lw 1203 x0 x3 //         x3 = mem[x0 + 1203]
addi 3 x0 x8 //         x8 = 3 + x0
bne x8 x3 endifmark1_0 //         x3 != x8 goto endifmark1_0
addi 64 x0 x6 //             x6 = 64 + x0
addi 0 x0 x7 //             x7 = 0 + x0
startwhilemark1_6:
beq x6 x7 endwhilemark1_6 //             x7 == x6 goto endwhilemark1_6
lw 1280 x7 x9 //                 x9 = mem[x7 + 1280]
addi 2 x0 x5 //                 x5 = 2 + x0
sra x5 x9 x9 //                 x9 = x9 >> x5
sw x9 x7 1408 //                 mem[x7 + 1408] = x9
addi 1 x7 x7 //                 x7 = x7 + 1
beq x0 x0 startwhilemark1_6 // x0 == x0 goto startwhilemark1_6
            endwhilemark1_6:
addi 1 x0 x28 //             x28 = 1 + x0 // return key
beq x0 x0 BlockProcess //             x0 == x0 goto BlockProcess // Call function
            BlockProcessReturnGate1: // Return Gate 1
addi 64 x0 x6 //             x6 = 64 + x0
addi 0 x0 x7 //             x7 = 0 + x0
startwhilemark1_7:
beq x6 x7 endwhilemark1_7 //             x7 == x6 goto endwhilemark1_7
lw 1344 x7 x9 //                 x9 = mem[x7 + 1344]
addi 2 x0 x5 //                 x5 = 2 + x0
sra x5 x9 x9 //                 x9 = x9 >> x5
sw x9 x7 1408 //                 mem[x7 + 1408] = x9
addi 1 x7 x7 //                 x7 = x7 + 1
beq x0 x0 startwhilemark1_7 // x0 == x0 goto startwhilemark1_7
            endwhilemark1_7:
addi 2 x0 x28 //             x28 = 2 + x0 // return key
beq x0 x0 BlockProcess //             x0 == x0 goto BlockProcess // Call function
            BlockProcessReturnGate2: // Return Gate 2
addi 64 x0 x6 //             x6 = 64 + x0
addi 0 x0 x7 //             x7 = 0 + x0
startwhilemark1_8:
beq x6 x7 endwhilemark1_8 //             x7 == x6 goto endwhilemark1_8
sw x0 x7 1280 //                 mem[x7 + 1280] = x0
sw x0 x7 1344 //                 mem[x7 + 1344] = x0
addi 1 x7 x7 //                 x7 = x7 + 1
beq x0 x0 startwhilemark1_8 // x0 == x0 goto startwhilemark1_8
            endwhilemark1_8:
addi 0 x0 x3 //             x3 = 0 + x0
beq x0 x0 endelse0 //             x0 == x0 goto endelse0
        endifmark1_0:
addi 1 x3 x3 //             x3 = x3 + 1
        endelse0:
addi 0 x0 x2 //         x2 = 0 + x0
lw 1201 x0 x1 //         x1 = mem[x0 + 1201]
lw 1207 x0 x4 //         x4 = mem[x0 + 1207]
beq x0 x0 endelse1 //         x0 == x0 goto endelse1
    endifmark0_17:
addi 1 x2 x2 //         x2 = x2 + 1
    endelse1:
addi 1 x1 x1 //     x1 = x1 + 1
beq x0 x0 startwhilemark0_16 // x0 == x0 goto startwhilemark0_16
endwhilemark0_16:
// ------------------------------------------------------------------
// RegFile Work Aera 4: Post Process
// ------------------------------------------------------------------
addi 0 x0 x13 // x13 = x0 + 0
addi 1 x0 x1 // x1 = x0 + 1
startwhilemark0_17:
beq x0 x26 endwhilemark0_17 // x26 == x0 goto endwhilemark0_17
sll x1 x13 x13 //     x13 = x13 << x1
addi 1 x13 x13 //     x13 = x13 + 1
addi -1 x26 x26 //     x26 = x26 + -1
beq x0 x0 startwhilemark0_17 // x0 == x0 goto startwhilemark0_17
endwhilemark0_17:
lw 0 x25 x2 // x2 = mem[x25 + 0]
add x2 x13 x13 // x13 = x13 + x2
sw x13 x25 0 // mem[x25 + 0] = x13
// goto SoC wait
addi 201 x0 x30 // x30 = x0 + 201 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 51 x0 x31 // x31 = x0 + 51 
or x31 x30 x1 // x1 = x30 | x31
addi 1 x0 x2 // x2 = x0 + 1
sw x2 x1 0 // mem[x1 + 0] = x2 // uart send code
beq x0 x0 systemwait // x0 == x0 goto systemwait

