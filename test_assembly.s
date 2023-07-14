// Initiate
// huffman table Y C
addi 0 x0 x1
addi 250 x0 x2
addi 16 x0 x3
addi 0 x0 x4
addi 11 x0 x5
addi 16 x0 x6
startwhilemark0_0:
blt x1 x2 endwhilemark0_0
sw x0 x1 275
sw x0 x1 801
addi 1 x0 x7
startwhilemark1_0:
bge x5 x7 endwhilemark1_0
add x7 x1 x8
sw x3 x8 275
sw x3 x8 801
addi 1 x7 x7
beq x0 x0 startwhilemark1_0
    endwhilemark1_0:
startwhilemark1_1:
bge x6 x7 endwhilemark1_1
add x7 x1 x8
sw x0 x8 275
sw x0 x8 801
addi 1 x7 x7
beq x0 x0 startwhilemark1_1
    endwhilemark1_1:
addi 16 x1 x1
beq x0 x0 startwhilemark0_0
endwhilemark0_0:
// quantization table
addi 1052 x0 x1
addi 1179 x0 x2
addi 32 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 0 x0 x31
or x30 x31 x3
startwhilemark0_1:
blt x1 x2 endwhilemark0_1
sw x3 x1 0
addi 1 x1 x1
beq x0 x0 startwhilemark0_1
endwhilemark0_1:
addi 22 x0 x31
addi -189 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 1196 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 66 x0 x31
or x31 x29 x1
sw x1 x0 1214
addi 22 x0 x31
addi -149 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 16 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 787 x0 x31
or x31 x29 x2
sw x2 x0 1212
addi 22 x0 x31
addi -76 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 458 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 1541 x0 x31
or x31 x29 x3
sw x3 x0 1211
addi 22 x0 x31
addi -37 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 1327 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 213 x0 x31
or x31 x29 x4
sw x4 x0 1215
addi 1 x0 x5
sw x5 x0 26
sw x5 x0 527
sw x5 x0 551
addi 2 x0 x6
sw x6 x0 1
sw x6 x0 12
sw x6 x0 276
sw x6 x0 277
sw x6 x0 528
sw x6 x0 538
sw x6 x0 539
sw x6 x0 540
sw x6 x0 801
sw x6 x0 802
addi 3 x0 x7
sw x7 x0 2
sw x7 x0 13
sw x7 x0 14
sw x7 x0 15
sw x7 x0 16
sw x7 x0 17
sw x7 x0 278
sw x7 x0 541
sw x7 x0 803
addi 4 x0 x8
sw x8 x0 3
sw x8 x0 18
sw x8 x0 27
sw x8 x0 275
sw x8 x0 279
sw x8 x0 292
sw x8 x0 542
sw x8 x0 552
sw x8 x0 804
sw x8 x0 818
addi 5 x0 x9
sw x9 x0 4
sw x9 x0 19
sw x9 x0 280
sw x9 x0 293
sw x9 x0 308
sw x9 x0 543
sw x9 x0 805
sw x9 x0 806
sw x9 x0 834
sw x9 x0 850
addi 6 x0 x10
sw x10 x0 5
sw x10 x0 20
sw x10 x0 324
sw x10 x0 340
sw x10 x0 529
sw x10 x0 544
sw x10 x0 807
sw x10 x0 819
sw x10 x0 866
sw x10 x0 882
addi 7 x0 x11
sw x11 x0 21
sw x11 x0 281
sw x11 x0 294
sw x11 x0 356
sw x11 x0 372
sw x11 x0 545
sw x11 x0 808
sw x11 x0 898
sw x11 x0 914
addi 8 x0 x12
sw x12 x0 22
sw x12 x0 282
sw x12 x0 309
sw x12 x0 388
sw x12 x0 546
sw x12 x0 820
sw x12 x0 835
sw x12 x0 851
sw x12 x0 930
addi 9 x0 x13
sw x13 x0 23
sw x13 x0 295
sw x13 x0 325
sw x13 x0 404
sw x13 x0 420
sw x13 x0 436
sw x13 x0 547
sw x13 x0 809
sw x13 x0 821
sw x13 x0 867
sw x13 x0 946
sw x13 x0 962
sw x13 x0 978
sw x13 x0 994
addi 10 x0 x14
sw x14 x0 24
sw x14 x0 283
sw x14 x0 310
sw x14 x0 341
sw x14 x0 452
sw x14 x0 468
sw x14 x0 548
sw x14 x0 553
sw x14 x0 810
sw x14 x0 836
sw x14 x0 852
sw x14 x0 883
sw x14 x0 1041
addi 11 x0 x15
sw x15 x0 28
sw x15 x0 296
sw x15 x0 357
sw x15 x0 484
sw x15 x0 515
sw x15 x0 549
sw x15 x0 567
sw x15 x0 822
sw x15 x0 899
sw x15 x0 915
sw x15 x0 1010
addi 12 x0 x16
sw x16 x0 41
sw x16 x0 311
sw x16 x0 326
sw x16 x0 373
sw x16 x0 389
sw x16 x0 811
sw x16 x0 823
sw x16 x0 837
sw x16 x0 853
addi 14 x0 x17
sw x17 x0 6
sw x17 x0 530
sw x17 x0 1026
addi 15 x0 x18
sw x18 x0 405
sw x18 x0 838
sw x18 x0 1042
addi 24 x0 x19
sw x19 x0 554
addi 25 x0 x20
sw x20 x0 555
addi 26 x0 x21
sw x21 x0 29
sw x21 x0 583
addi 27 x0 x22
sw x22 x0 42
sw x22 x0 599
addi 28 x0 x23
sw x23 x0 57
addi 30 x0 x24
sw x24 x0 7
sw x24 x0 531
addi 56 x0 x25
sw x25 x0 556
addi 57 x0 x26
sw x26 x0 568
addi 58 x0 x27
sw x27 x0 73
sw x27 x0 615
addi 59 x0 x28
sw x28 x0 89
sw x28 x0 631
addi 62 x0 x29
sw x29 x0 8
sw x29 x0 532
addi 120 x0 x1
sw x1 x0 30
sw x1 x0 557
addi 121 x0 x2
sw x2 x0 43
sw x2 x0 647
addi 122 x0 x3
sw x3 x0 105
sw x3 x0 663
addi 123 x0 x4
sw x4 x0 121
addi 126 x0 x5
sw x5 x0 9
sw x5 x0 533
addi 246 x0 x6
sw x6 x0 569
addi 247 x0 x7
sw x7 x0 584
addi 248 x0 x8
sw x8 x0 31
sw x8 x0 600
addi 249 x0 x9
sw x9 x0 58
sw x9 x0 679
addi 250 x0 x10
sw x10 x0 137
addi 254 x0 x11
sw x11 x0 10
sw x11 x0 534
addi 500 x0 x12
sw x12 x0 558
addi 501 x0 x13
sw x13 x0 570
addi 502 x0 x14
sw x14 x0 44
sw x14 x0 616
addi 503 x0 x15
sw x15 x0 74
sw x15 x0 695
addi 504 x0 x16
sw x16 x0 153
sw x16 x0 711
addi 505 x0 x17
sw x17 x0 169
sw x17 x0 727
addi 506 x0 x18
sw x18 x0 185
sw x18 x0 743
addi 510 x0 x19
sw x19 x0 11
sw x19 x0 535
addi 1014 x0 x20
sw x20 x0 32
sw x20 x0 559
addi 1015 x0 x21
sw x21 x0 59
sw x21 x0 585
addi 1016 x0 x22
sw x22 x0 90
sw x22 x0 601
addi 1017 x0 x23
sw x23 x0 201
sw x23 x0 632
addi 1018 x0 x24
sw x24 x0 217
sw x24 x0 790
addi 1022 x0 x25
sw x25 x0 536
addi 1023 x0 x26
sw x26 x0 1186
addi 2038 x0 x27
sw x27 x0 45
sw x27 x0 571
addi 2039 x0 x28
sw x28 x0 106
sw x28 x0 648
addi 2040 x0 x29
sw x29 x0 233
sw x29 x0 664
addi 2041 x0 x1
sw x1 x0 264
sw x1 x0 759
addi 2046 x0 x2
sw x2 x0 537
addi 6 x1 x3
sw x3 x0 1185
addi 2043 x1 x4
sw x4 x0 60
sw x4 x0 560
addi 2044 x1 x5
sw x5 x0 75
sw x5 x0 572
addi 2045 x1 x6
sw x6 x0 122
sw x6 x0 586
addi 2046 x1 x7
sw x7 x0 138
sw x7 x0 602
addi 2044 x2 x8
sw x8 x0 1184
addi 3 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2005 x0 x31
or x30 x31 x9
sw x9 x0 1183
addi 6 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 580 x0 x31
or x30 x31 x10
sw x10 x0 1200
addi 1468 x10 x30
addi 1718 x0 x31
or x30 x31 x11
sw x11 x0 1182
addi 298 x11 x12
sw x12 x0 775
addi 14 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1713 x0 x31
or x30 x31 x13
sw x13 x0 1181
addi 335 x13 x30
addi 1984 x0 x31
or x30 x31 x14
sw x14 x0 154
addi 2 x14 x15
sw x15 x0 587
addi 3 x14 x16
sw x16 x0 791
addi 22 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1285 x0 x31
or x30 x31 x17
sw x17 x0 1198
addi 25 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 271 x0 x31
or x30 x31 x18
sw x18 x0 1180
addi 31 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1922 x0 x31
or x30 x31 x19
sw x19 x0 33
addi 1 x19 x20
sw x20 x0 34
addi 2 x19 x21
sw x21 x0 46
addi 3 x19 x22
sw x22 x0 47
addi 4 x19 x23
sw x23 x0 48
addi 5 x19 x24
sw x24 x0 49
addi 6 x19 x25
sw x25 x0 50
sw x25 x0 573
addi 7 x19 x26
sw x26 x0 61
sw x26 x0 574
addi 8 x19 x27
sw x27 x0 62
sw x27 x0 575
addi 9 x19 x28
sw x28 x0 63
sw x28 x0 576
addi 10 x19 x29
sw x29 x0 64
sw x29 x0 588
addi 11 x19 x1
sw x1 x0 65
sw x1 x0 589
addi 1 x1 x2
sw x2 x0 66
sw x2 x0 590
addi 2 x1 x3
sw x3 x0 76
sw x3 x0 591
addi 3 x1 x4
sw x4 x0 77
sw x4 x0 592
addi 4 x1 x5
sw x5 x0 78
sw x5 x0 603
addi 5 x1 x6
sw x6 x0 79
sw x6 x0 604
addi 6 x1 x7
sw x7 x0 80
sw x7 x0 605
addi 7 x1 x8
sw x8 x0 81
sw x8 x0 606
addi 8 x1 x9
sw x9 x0 82
sw x9 x0 607
addi 9 x1 x10
sw x10 x0 91
sw x10 x0 608
addi 10 x1 x11
sw x11 x0 92
sw x11 x0 617
addi 11 x1 x12
sw x12 x0 93
sw x12 x0 618
addi 12 x1 x13
sw x13 x0 94
sw x13 x0 619
addi 13 x1 x14
sw x14 x0 95
sw x14 x0 620
addi 14 x1 x15
sw x15 x0 96
sw x15 x0 621
addi 15 x1 x16
sw x16 x0 97
sw x16 x0 622
addi 16 x1 x17
sw x17 x0 98
sw x17 x0 623
addi 17 x1 x18
sw x18 x0 107
sw x18 x0 624
addi 18 x1 x19
sw x19 x0 108
sw x19 x0 633
addi 19 x1 x20
sw x20 x0 109
sw x20 x0 634
addi 20 x1 x21
sw x21 x0 110
sw x21 x0 635
addi 21 x1 x22
sw x22 x0 111
sw x22 x0 636
addi 22 x1 x23
sw x23 x0 112
sw x23 x0 637
addi 23 x1 x24
sw x24 x0 113
sw x24 x0 638
addi 24 x1 x25
sw x25 x0 114
sw x25 x0 639
addi 25 x1 x26
sw x26 x0 123
sw x26 x0 640
addi 26 x1 x27
sw x27 x0 124
sw x27 x0 649
addi 27 x1 x28
sw x28 x0 125
sw x28 x0 650
addi 28 x1 x29
sw x29 x0 126
sw x29 x0 651
addi 29 x1 x1
sw x1 x0 127
sw x1 x0 652
addi 1 x1 x2
sw x2 x0 128
sw x2 x0 653
addi 2 x1 x3
sw x3 x0 129
sw x3 x0 654
addi 3 x1 x4
sw x4 x0 130
sw x4 x0 655
addi 4 x1 x5
sw x5 x0 139
sw x5 x0 656
addi 5 x1 x6
sw x6 x0 140
sw x6 x0 665
addi 6 x1 x7
sw x7 x0 141
sw x7 x0 666
addi 7 x1 x8
sw x8 x0 142
sw x8 x0 667
addi 8 x1 x9
sw x9 x0 143
sw x9 x0 668
addi 9 x1 x10
sw x10 x0 144
sw x10 x0 669
addi 10 x1 x11
sw x11 x0 145
sw x11 x0 670
addi 11 x1 x12
sw x12 x0 146
sw x12 x0 671
addi 12 x1 x13
sw x13 x0 155
sw x13 x0 672
addi 13 x1 x14
sw x14 x0 156
sw x14 x0 680
addi 14 x1 x15
sw x15 x0 157
sw x15 x0 681
addi 15 x1 x16
sw x16 x0 158
sw x16 x0 682
addi 16 x1 x17
sw x17 x0 159
sw x17 x0 683
addi 17 x1 x18
sw x18 x0 160
sw x18 x0 684
addi 18 x1 x19
sw x19 x0 161
sw x19 x0 685
addi 19 x1 x20
sw x20 x0 162
sw x20 x0 686
addi 20 x1 x21
sw x21 x0 170
sw x21 x0 687
addi 21 x1 x22
sw x22 x0 171
sw x22 x0 688
addi 22 x1 x23
sw x23 x0 172
sw x23 x0 696
addi 23 x1 x24
sw x24 x0 173
sw x24 x0 697
addi 24 x1 x25
sw x25 x0 174
sw x25 x0 698
addi 25 x1 x26
sw x26 x0 175
sw x26 x0 699
addi 26 x1 x27
sw x27 x0 176
sw x27 x0 700
addi 27 x1 x28
sw x28 x0 177
sw x28 x0 701
addi 28 x1 x29
sw x29 x0 178
sw x29 x0 702
addi 29 x1 x1
sw x1 x0 186
sw x1 x0 703
addi 1 x1 x2
sw x2 x0 187
sw x2 x0 704
addi 2 x1 x3
sw x3 x0 188
sw x3 x0 712
addi 3 x1 x4
sw x4 x0 189
sw x4 x0 713
addi 4 x1 x5
sw x5 x0 190
sw x5 x0 714
addi 5 x1 x6
sw x6 x0 191
sw x6 x0 715
addi 6 x1 x7
sw x7 x0 192
sw x7 x0 716
addi 7 x1 x8
sw x8 x0 193
sw x8 x0 717
addi 8 x1 x9
sw x9 x0 194
sw x9 x0 718
addi 9 x1 x10
sw x10 x0 202
sw x10 x0 719
addi 10 x1 x11
sw x11 x0 203
sw x11 x0 720
addi 11 x1 x12
sw x12 x0 204
sw x12 x0 728
addi 12 x1 x13
sw x13 x0 205
sw x13 x0 729
addi 13 x1 x14
sw x14 x0 206
sw x14 x0 730
addi 14 x1 x15
sw x15 x0 207
sw x15 x0 731
addi 15 x1 x16
sw x16 x0 208
sw x16 x0 732
addi 16 x1 x17
sw x17 x0 209
sw x17 x0 733
addi 17 x1 x18
sw x18 x0 210
sw x18 x0 734
addi 18 x1 x19
sw x19 x0 218
sw x19 x0 735
addi 19 x1 x20
sw x20 x0 219
sw x20 x0 736
addi 20 x1 x21
sw x21 x0 220
sw x21 x0 744
addi 21 x1 x22
sw x22 x0 221
sw x22 x0 745
addi 22 x1 x23
sw x23 x0 222
sw x23 x0 746
addi 23 x1 x24
sw x24 x0 223
sw x24 x0 747
addi 24 x1 x25
sw x25 x0 224
sw x25 x0 748
addi 25 x1 x26
sw x26 x0 225
sw x26 x0 749
addi 26 x1 x27
sw x27 x0 226
sw x27 x0 750
addi 27 x1 x28
sw x28 x0 234
sw x28 x0 751
addi 28 x1 x29
sw x29 x0 235
sw x29 x0 752
addi 29 x1 x1
sw x1 x0 236
sw x1 x0 760
addi 1 x1 x2
sw x2 x0 237
sw x2 x0 761
addi 2 x1 x3
sw x3 x0 238
sw x3 x0 762
addi 3 x1 x4
sw x4 x0 239
sw x4 x0 763
addi 4 x1 x5
sw x5 x0 240
sw x5 x0 764
addi 5 x1 x6
sw x6 x0 241
sw x6 x0 765
addi 6 x1 x7
sw x7 x0 242
sw x7 x0 766
addi 7 x1 x8
sw x8 x0 249
sw x8 x0 767
addi 8 x1 x9
sw x9 x0 250
sw x9 x0 768
addi 9 x1 x10
sw x10 x0 251
sw x10 x0 776
addi 10 x1 x11
sw x11 x0 252
sw x11 x0 777
addi 11 x1 x12
sw x12 x0 253
sw x12 x0 778
addi 12 x1 x13
sw x13 x0 254
sw x13 x0 779
addi 13 x1 x14
sw x14 x0 255
sw x14 x0 780
addi 14 x1 x15
sw x15 x0 256
sw x15 x0 781
addi 15 x1 x16
sw x16 x0 257
sw x16 x0 782
addi 16 x1 x17
sw x17 x0 258
sw x17 x0 783
addi 17 x1 x18
sw x18 x0 265
sw x18 x0 784
addi 18 x1 x19
sw x19 x0 266
sw x19 x0 792
addi 19 x1 x20
sw x20 x0 267
sw x20 x0 793
addi 20 x1 x21
sw x21 x0 268
sw x21 x0 794
addi 21 x1 x22
sw x22 x0 269
sw x22 x0 795
addi 22 x1 x23
sw x23 x0 270
sw x23 x0 796
addi 23 x1 x24
sw x24 x0 271
sw x24 x0 797
addi 24 x1 x25
sw x25 x0 272
sw x25 x0 798
addi 25 x1 x26
sw x26 x0 273
sw x26 x0 799
addi 26 x1 x27
sw x27 x0 274
sw x27 x0 800
addi 28 x1 x28
sw x28 x0 1199
addi 22 x0 x31
addi 50 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 360 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 917 x0 x31
or x31 x29 x29
sw x29 x0 1210
addi 22 x0 x31
addi 131 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 1196 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 65 x0 x31
or x31 x29 x1
sw x1 x0 1208
addi 22 x0 x31
addi 224 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 1572 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 1769 x0 x31
or x31 x29 x2
sw x2 x0 1213
addi 22 x0 x31
addi 288 x0 x29
sll x29 x31 x29
addi 11 x0 x31
addi 1572 x0 x30
sll x30 x31 x30
or x30 x29 x29
addi 1769 x0 x31
or x31 x29 x3
sw x3 x0 1209
// Main function
// ------------------------------------------------------------------
// RegFile Work Aera 1: Re-Order Minimum coded (MCU)
// Avialiable register remaind: x23
// ------------------------------------------------------------------
// blocks: 1216 Y 1280 U 1344 V 1408 Block 1472 MidBlock
addi 100 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x20
addi 2000 x0 x21
lw 0 x20 x28
lw 1 x20 x29
sw x28 x0 1187
sw x29 x0 1188
addi 4 x0 x1
sra x28 x1 x28
sra x29 x1 x27
sw x28 x0 1189
sw x27 x0 1190
addi 0 x0 x1
addi 0 x0 x2
addi 0 x0 x3
addi 0 x0 x4
addi 0 x0 x5
addi 0 x0 x6
addi 16 x0 x26
addi 8 x0 x25
addi 2 x0 x24
startwhilemark0_2:
beq x28 x2 endwhilemark0_2
mul x26 x29 x10
mul x10 x2 x10
addi 2 x10 x10
startwhilemark1_2:
beq x27 x1 endwhilemark1_2
mul x26 x1 x11
add x11 x10 x11
startwhilemark2_0:
beq x24 x4 endwhilemark2_0
mul x25 x29 x12
mul x12 x4 x12
add x12 x11 x12
startwhilemark3_0:
beq x24 x3 endwhilemark3_0
mul x25 x3 x13
add x13 x12 x13
startwhilemark4_0:
beq x25 x5 endwhilemark4_0
add x5 x13 x14
startwhilemark5_0:
beq x25 x6 endwhilemark5_0
mul x29 x6 x15
add x15 x14 x15
add x20 x15 x15
addi 255 x0 x19
lw 0 x15 x16
sra x16 x26 x16
and x16 x19 x16
lw 0 x15 x17
sra x17 x25 x17
and x17 x19 x17
lw 0 x15 x18
and x18 x19 x18
lw 1208 x0 x19
mulh x19 x16 x19
lw 1209 x0 x30
mulh x30 x17 x30
add x19 x30 x19
lw 1210 x0 x30
mulh x30 x18 x30
add x19 x30 x19
addi 16 x19 x19
addi 0 x19 x22
lw 1211 x0 x19
mulh x19 x16 x19
lw 1212 x0 x30
mulh x30 x17 x30
add x19 x30 x19
lw 1213 x0 x30
mulh x30 x18 x30
add x19 x30 x19
addi 128 x19 x19
sll x19 x25 x19
add x19 x22 x22
lw 1214 x0 x19
mulh x19 x17 x19
lw 1213 x0 x30
mulh x30 x16 x30
add x19 x30 x19
lw 1215 x0 x30
mulh x30 x18 x30
add x19 x30 x19
addi 128 x19 x19
sll x19 x26 x19
add x19 x22 x22
sw x22 x21 0
addi 1 x21 x21
addi 1 x6 x6
beq x0 x0 startwhilemark5_0
                    endwhilemark5_0:
addi 0 x0 x6
addi 1 x5 x5
beq x0 x0 startwhilemark4_0
                endwhilemark4_0:
addi 0 x0 x5
addi 1 x3 x3
beq x0 x0 startwhilemark3_0
            endwhilemark3_0:
addi 0 x0 x3
addi 1 x4 x4
beq x0 x0 startwhilemark2_0
        endwhilemark2_0:
addi 0 x0 x4
addi 1 x1 x1
beq x0 x0 startwhilemark1_2
    endwhilemark1_2:
addi 0 x0 x1
addi 1 x2 x2
beq x0 x0 startwhilemark0_2
endwhilemark0_2:
// clear uart
addi 100 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x10
addi 101 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 978 x0 x31
or x30 x31 x11
startwhilemark0_3:
beq x11 x10 endwhilemark0_3
sw x0 x10 0
addi 1 x10 x10
beq x0 x0 startwhilemark0_3
endwhilemark0_3:
// ------------------------------------------------------------------
// RegFile Work Aera 2: Block Process and Huffman endcode
// ------------------------------------------------------------------
// Function used regiters
addi 32 x0 x26
addi 100 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x25
// x28 return key and mode
// x29 differential DC value
// Function Entry
beq x0 x0 EndBlockProcess
BlockProcess:
// ------------------------------------
// 8x8 matrix subtraction: Sub Area 1
// ------------------------------------
addi 0 x0 x1
addi 64 x0 x2
startwhilemark0_4:
beq x2 x1 endwhilemark0_4
lw 1408 x1 x3
addi -128 x3 x3
sw x3 x1 1472
sw x0 x1 1408
addi 1 x1 x1
beq x0 x0 startwhilemark0_4
endwhilemark0_4:
// debug
addi 111 x0 x1
addi 200 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x2
sw x1 x2 0
// ------------------------------------
// Discrete Cosine Transform: Sub Area 2
// ------------------------------------
// SubFunction: CORDIC cosine
beq x0 x0 ENDCORDIC
CORDIC:
addi 0 x0 x8
addi 100 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1087 x0 x31
or x30 x31 x20
addi -202 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1921 x0 x31
or x30 x31 x21
addi 50 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 544 x0 x31
or x30 x31 x22
startwhilemark0_5:
bge x9 x20 endwhilemark0_5
add x9 x21 x9
beq x0 x0 startwhilemark0_5
    endwhilemark0_5:
bge x9 x22 endifmark0_0
addi 1 x0 x8
xori -1 x20 x20
addi 1 x20 x20
add x9 x20 x9
beq x0 x0 endelse2
    endifmark0_0:
xori -1 x22 x22
addi 1 x22 x22
bge x22 x9 endifmark0_1
addi 1 x0 x8
add x9 x20 x9
        endifmark0_1:
    endelse2:
addi 0 x0 x10
sw x0 x0 1191
sw x0 x0 1192
sw x0 x0 1193
sw x0 x0 1194
sw x0 x0 1195
sw x0 x0 1196
sw x0 x0 1197
addi 0 x0 x7
addi 7 x0 x22
startwhilemark0_6:
beq x22 x7 endwhilemark0_6
bge x10 x9 endifmark0_2
lw 1180 x7 x20
xori -1 x20 x20
addi 1 x20 x20
add x10 x20 x10
addi 1 x0 x21
sw x21 x7 1191
beq x0 x0 endelse3
        endifmark0_2:
lw 1180 x7 x20
add x10 x20 x10
sw x0 x7 1191
        endelse3:
addi 1 x7 x7
beq x0 x0 startwhilemark0_6
    endwhilemark0_6:
addi 19 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 885 x0 x31
or x30 x31 x1
addi 0 x0 x2
addi 6 x0 x7
addi 1 x0 x21
addi -1 x0 x23
startwhilemark0_7:
beq x23 x7 endwhilemark0_7
lw 1191 x7 x20
sra x2 x7 x22
bne x21 x20 endifmark0_3
xori -1 x22 x22
addi 1 x22 x22
add x1 x22 x1
sra x1 x7 x22
beq x0 x0 endelse4
        endifmark0_3:
add x1 x22 x1
sra x1 x7 x22
xori -1 x22 x22
addi 1 x22 x22
        endelse4:
add x22 x2 x2
addi -1 x7 x7
beq x0 x0 startwhilemark0_7
    endwhilemark0_7:
bne x21 x8 endifmark0_4
xori -1 x1 x1
addi 1 x1 x1
    endifmark0_4:
// CORDIC return gate
// return key: x24
addi 1 x0 x21
beq x0 x24 CORDICGate0
beq x21 x24 CORDICGate1
ENDCORDIC:
// DCT
addi 8 x0 x15
addi 2 x0 x17
addi 0 x0 x3
addi 0 x0 x4
addi 0 x0 x5
addi 0 x0 x6
startwhilemark0_8:
beq x15 x3 endwhilemark0_8
bne x0 x3 endifmark0_5
lw 1198 x0 x11
beq x0 x0 endelse5
    endifmark0_5:
lw 1199 x0 x11
    endelse5:
startwhilemark1_3:
beq x15 x4 endwhilemark1_3
bne x0 x4 endifmark0_6
lw 1198 x0 x12
beq x0 x0 endelse6
        endifmark0_6:
lw 1199 x0 x12
        endelse6:
addi 0 x0 x14
startwhilemark2_1:
beq x15 x5 endwhilemark2_1
startwhilemark3_1:
beq x15 x6 endwhilemark3_1
mul x5 x15 x16
add x16 x6 x16
lw 1472 x16 x13
mul x17 x5 x9
addi 1 x9 x9
mul x9 x3 x9
lw 1200 x0 x23
mul x9 x23 x9
addi 0 x0 x24
beq x0 x0 CORDIC
                CORDICGate0: // return gate
mul x13 x1 x13
sra x13 x15 x13
mul x17 x6 x9
addi 1 x9 x9
mul x9 x4 x9
lw 1200 x0 x23
mul x9 x23 x9
addi 1 x0 x24
beq x0 x0 CORDIC
                CORDICGate1: // return gate
mul x13 x1 x13
sra x13 x15 x13
add x14 x13 x14
addi 1 x6 x6
beq x0 x0 startwhilemark3_1
            endwhilemark3_1:
addi 0 x0 x6
addi 1 x5 x5
beq x0 x0 startwhilemark2_1
        endwhilemark2_1:
mulh x11 x12 x16
mul x11 x12 x13
addi 15 x0 x18
sll x16 x18 x16
addi 1 x18 x18
sra x13 x18 x13
or x13 x16 x13
mulh x13 x14 x13
addi 3 x0 x18
sra x13 x18 x13
beq x0 x13 endifmark0_7
addi 1 x13 x13
        endifmark0_7:
mul x3 x15 x16
add x4 x16 x16
sw x13 x16 1408
addi 0 x0 x5
addi 1 x4 x4
beq x0 x0 startwhilemark1_3
    endwhilemark1_3:
addi 0 x0 x4
addi 1 x3 x3
beq x0 x0 startwhilemark0_8
endwhilemark0_8:
// ------------------------------------
// Quantization: Sub Area 3
// ------------------------------------
addi 1052 x0 x2
bne x0 x28 endifmark0_8
addi 1116 x0 x2
endifmark0_8:
addi 0 x0 x1
addi 64 x0 x5
addi 16 x0 x7
startwhilemark0_9:
beq x5 x1 endwhilemark0_9
add x1 x2 x6
lw 0 x6 x3
lw 1408 x1 x4
mul x3 x4 x3
sra x3 x7 x3
sw x0 x1 1408
sw x3 x1 1472
addi 1 x1 x1
beq x0 x0 startwhilemark0_9
endwhilemark0_9:
// debug
addi 222 x0 x1
addi 200 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x2
sw x1 x2 0
// ------------------------------------
// Zigzag Scan: Sub Area 4
// ------------------------------------
addi 0 x0 x1
addi 0 x0 x2
addi 0 x0 x5
addi 1 x0 x3
addi 0 x0 x4
addi 7 x0 x6
addi 8 x0 x7
addi 1 x0 x9
// Differential DC Value:
lw 1472 x0 x27
xori -1 x29 x29
addi 1 x29 x29
add x27 x29 x11
sw x11 x0 1408
startwhilemark0_10:
bne x0 x0 endwhilemark0_10
    // special if structure
beq x0 x1 iformark0
beq x6 x1 iformark0
beq x0 x0 endiformark0
    iformark0:
addi 1 x2 x2
addi 1 x0 x4
beq x0 x0 endelseifmark0
    endiformark0:
beq x0 x2 iformark1
beq x6 x2 iformark1
beq x0 x0 endelseifmark0
    iformark1:
addi 1 x1 x1
addi 1 x0 x4
    endelseifmark0:
bne x9 x4 endifmark0_9
addi 0 x0 x4
xori -1 x3 x3
addi 1 x3 x3
addi 1 x5 x5
mul x2 x7 x12
add x12 x1 x12
lw 1472 x12 x11
sw x11 x5 1408
    endifmark0_9:
    // if x1 == x6 and x2 == x6:
bne x6 x2 ifandmark0
bne x6 x1 ifandmark0
beq x0 x0 breakmark0
    ifandmark0:
addi 1 x5 x5
xori -1 x3 x13
addi 1 x13 x13
add x13 x1 x1
add x2 x3 x2
mul x2 x7 x12
add x12 x1 x12
lw 1472 x12 x11
sw x11 x5 1408
beq x0 x0 startwhilemark0_10
endwhilemark0_10:
breakmark0:
// debug
addi 333 x0 x1
addi 200 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x2
sw x1 x2 0
// ------------------------------------
// Huffman Encode: Sub Area 6
// ------------------------------------
// 0 for Luminace
bne x0 x28 endifmark0_10
addi 0 x0 x10
addi 12 x0 x11
addi 24 x0 x12
addi 275 x0 x13
beq x0 x0 endelse7
endifmark0_10:
addi 526 x0 x10
addi 538 x0 x11
addi 550 x0 x12
addi 801 x0 x13
endelse7:
// SubFunction: Get data and size
beq x0 x0 EndGetDataAndSize
GetDataAndSize:
addi 0 x0 x14
addi 0 x0 x15
addi 1 x0 x17
bge x0 x1 endifmark0_11
xori -1 x1 x1
addi 1 x1 x1
addi 1 x0 x15
    endifmark0_11:
addi 0 x1 x2
startwhilemark0_11:
beq x0 x1 endwhilemark0_11
sra x1 x17 x1
addi 1 x14 x14
beq x0 x0 startwhilemark0_11
    endwhilemark0_11:
addi 0 x14 x3
bne x17 x15 endifmark0_12
addi 0 x0 x16
startwhilemark0_12:
beq x0 x14 endwhilemark0_12
sll x16 x17 x16
addi 1 x16 x16
addi -1 x14 x14
beq x0 x0 startwhilemark0_12
        endwhilemark0_12:
xori -1 x2 x2
and x2 x16 x2
    endifmark0_12:
// Get data and size return gate
// return key: x24
addi 1 x0 x19
beq x0 x24 GetDataAndSizeReturnGate0
beq x19 x24 GetDataAndSizeReturnGate1
EndGetDataAndSize:
// SubFunction: Push Huffman bit stack
beq x0 x0 EndPushHuffmanBitStack
PushHuffmanBitStack:
lw 0 x25 x14
blt x5 x26 endifmark0_13
xori -1 x5 x5
addi 1 x5 x5
add x26 x5 x18
sll x4 x18 x18
add x14 x18 x14
sw x14 x25 0
add x26 x5 x26
beq x0 x0 endelse8
    endifmark0_13:
xori -1 x26 x19
addi 1 x19 x19
add x5 x19 x18
sra x4 x18 x18
or x14 x18 x14
sw x14 x25 0
add x5 x19 x5
addi 0 x5 x15
addi 0 x0 x16
addi 1 x0 x19
startwhilemark0_13:
beq x0 x15 endwhilemark0_13
sll x16 x19 x16
addi 1 x16 x16
addi -1 x15 x15
beq x0 x0 startwhilemark0_13
        endwhilemark0_13:
and x16 x4 x16
xori -1 x5 x19
addi 1 x19 x19
addi 32 x19 x26
sll x16 x26 x17
addi 1 x25 x25
sw x17 x25 0
    endelse8:
// Push Huffman bit stack return gate
// return key: x23
addi 1 x0 x19
addi 2 x0 x18
addi 3 x0 x5
beq x0 x23 PushHuffmanBitStackReturnGate0
beq x19 x23 PushHuffmanBitStackReturnGate1
beq x18 x23 PushHuffmanBitStackReturnGate2
beq x5 x23 PushHuffmanBitStackReturnGate3
EndPushHuffmanBitStack:
// DC
lw 1408 x0 x1
addi 0 x0 x24
beq x0 x0 GetDataAndSize
GetDataAndSizeReturnGate0:
add x10 x3 x14
lw 0 x14 x6
add x11 x3 x14
lw 0 x14 x7
sll x6 x3 x4
add x4 x2 x4
add x3 x7 x5
addi 0 x0 x23
beq x0 x0 PushHuffmanBitStack
PushHuffmanBitStackReturnGate0:
// AC
addi 0 x0 x9
addi 1 x0 x20
addi 64 x0 x21
addi 15 x0 x22
startwhilemark0_14:
beq x21 x20 endwhilemark0_14
lw 1408 x20 x15
bne x0 x15 endifmark0_14
addi 1 x9 x9
beq x0 x0 endelse9
    endifmark0_14:
startwhilemark1_4:
bge x9 x22 endwhilemark1_4
            x9 = x9 - 16
lw 240 x12 x4
lw 240 x13 x5
addi 0 x0 x23
beq x0 x0 PushHuffmanBitStack
            PushHuffmanBitStackReturnGate1:
beq x0 x0 startwhilemark1_4
        endwhilemark1_4:
        // Assembly
lw 1408 x20 x1
addi 1 x0 x24
beq x0 x0 GetDataAndSize
        GetDataAndSizeReturnGate1:
addi 4 x0 x17
sll x9 x17 x8
add x8 x3 x8
add x12 x8 x14
lw 0 x14 x6
add x13 x8 x14
lw 0 x14 x7
sll x6 x3 x4
add x4 x2 x4
add x3 x7 x5
addi 0 x0 x23
beq x0 x0 PushHuffmanBitStack
        PushHuffmanBitStackReturnGate2:
addi 0 x0 x9
    endelse9:
addi 1 x20 x20
beq x0 x0 startwhilemark0_14
endwhilemark0_14:
// EOB
beq x0 x9 endifmark0_15
lw 0 x12 x4
lw 0 x13 x5
addi 0 x0 x23
beq x0 x0 PushHuffmanBitStack
    PushHuffmanBitStackReturnGate3:
endifmark0_15:
// debug
addi 444 x0 x1
addi 200 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 2000 x0 x31
or x30 x31 x2
sw x1 x2 0
// ------------------------------------
// Function Return Gate
// ------------------------------------
addi 0 x0 x1
addi 1 x0 x2
addi 2 x0 x3
beq x1 x28 BlockProcessReturnGate0
beq x2 x28 BlockProcessReturnGate1
beq x3 x28 BlockProcessReturnGate2
EndBlockProcess:
// ------------------------------------------------------------------
// RegFile Work Aera 3: Sampling
// ------------------------------------------------------------------
sw x0 x0 1201
sw x0 x0 1202
sw x0 x0 1203
sw x0 x0 1204
sw x0 x0 1205
sw x0 x0 1206
addi 256 x0 x1
lw 1189 x0 x2
mul x1 x2 x1
lw 1190 x0 x2
mul x1 x2 x4
sw x4 x0 1207
addi 0 x0 x1
addi 0 x0 x2
addi 0 x0 x3
startwhilemark0_15:
beq x4 x1 endwhilemark0_15
lw 2000 x1 x6
addi 255 x0 x10
addi 8 x0 x11
addi 16 x0 x12
and x10 x6 x6
sw x6 x2 1216
lw 2000 x1 x6
sra x6 x11 x6
and x6 x10 x6
lw 1280 x2 x7
add x6 x7 x6
sw x6 x2 1280
lw 2000 x1 x6
lw 1344 x2 x7
sra x6 x12 x6
and x6 x10 x6
add x6 x7 x6
sw x6 x2 1344
addi 63 x0 x6
bne x6 x2 endifmark0_16
sw x1 x0 1201
sw x3 x0 1203
addi 64 x0 x6
addi 0 x0 x7
startwhilemark1_5:
beq x6 x7 endwhilemark1_5
lw 1216 x7 x9
sw x9 x7 1408
addi 1 x7 x7
beq x0 x0 startwhilemark1_5
        endwhilemark1_5:
lw 1204 x0 x29
addi 0 x0 x28
beq x0 x0 BlockProcess
        BlockProcessReturnGate0: // Return Gate 0
sw x27 x0 1204
lw 1203 x0 x3
addi 3 x0 x8
bne x8 x3 endifmark1_0
addi 64 x0 x6
addi 0 x0 x7
startwhilemark1_6:
beq x6 x7 endwhilemark1_6
lw 1280 x7 x9
addi 2 x0 x5
sra x9 x5 x9
sw x9 x7 1408
addi 1 x7 x7
beq x0 x0 startwhilemark1_6
            endwhilemark1_6:
lw 1205 x0 x29
addi 1 x0 x28
beq x0 x0 BlockProcess
            BlockProcessReturnGate1: // Return Gate 1
sw x27 x0 1205
addi 64 x0 x6
addi 0 x0 x7
startwhilemark1_7:
beq x6 x7 endwhilemark1_7
lw 1344 x7 x9
addi 2 x0 x5
sra x9 x5 x9
sw x9 x7 1408
addi 1 x7 x7
beq x0 x0 startwhilemark1_7
            endwhilemark1_7:
lw 1206 x0 x29
addi 2 x0 x28
beq x0 x0 BlockProcess
            BlockProcessReturnGate2: // Return Gate 2
sw x27 x0 1206
addi 64 x0 x6
addi 0 x0 x7
startwhilemark1_8:
beq x6 x7 endwhilemark1_8
sw x0 x7 1280
sw x0 x7 1344
addi 1 x7 x7
beq x0 x0 startwhilemark1_8
            endwhilemark1_8:
addi 0 x0 x3
beq x0 x0 endelse0
        endifmark1_0:
addi 1 x3 x3
        endelse0:
addi 0 x0 x2
lw 1201 x0 x1
lw 1207 x0 x4
beq x0 x0 endelse1
    endifmark0_16:
addi 1 x2 x2
    endelse1:
addi 1 x1 x1
beq x0 x0 startwhilemark0_15
endwhilemark0_15:
// ------------------------------------------------------------------
// RegFile Work Aera 4: Post Process
// ------------------------------------------------------------------
addi 0 x0 x13
addi 1 x0 x1
startwhilemark0_16:
beq x0 x26 endwhilemark0_16
sll x13 x1 x13
addi 1 x13 x13
addi -1 x26 x26
beq x0 x0 startwhilemark0_16
endwhilemark0_16:
lw 0 x25 x2
add x13 x2 x13
sw x13 x25 0
// end of program signature
addi 4 x0 x30
addi 11 x0 x31
sll x30 x31 x30
addi 1807 x0 x31
or x30 x31 x31

