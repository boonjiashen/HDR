Run baseline algorithm
---
Requires MATLAB and Image Processing toolbox.

1. Download zip file of test images from [Zhang](http://pages.cs.wisc.edu/~jiaxu/misc/exposures.zip).
2. Unzip to zhang/ subdirectory.
2. On MATLAB terminal, run:

>>> clear all; folder = 'zhang'; extension = 'jpg'; baseline;

Register images in lamp series
---

Lamp series is a series of images of a lamp, taken by Jia-Shen Boon.

1. Download images from [here](https://www.dropbox.com/sh/z3tlqvyl3j3ij15/AADg49yG62HyMWsq8V66mWVUa?dl=0) into lamp_series/ subdirectory
2. On MATLAB, run `align_lamp` script from top-level directory.
