## sparse-matrix-convolution-accelerator-with-clock-gate
process : 7nm-FinFET

||Without clock gating|clock gating|
|:--:|:--:|:--:|
Area|4796 μm2 |4929 μm2|
Power| 248 μW|116 μW|
Power / Area |0.0517 W/m2|0.0235 W/m2|
Clock rate | 1GHz | 1GHz|

### sparse matrix
In numerical analysis and scientific computing, a sparse matrix or sparse array is a matrix in which most of the elements are zero.
Some of the calculations like Numx0 = 0 or 0xNum cause redundant power consumptions.
This project use clock_gate_or and mux to save these power consumptions.

