# Overview

The code is in MATLAB. Problem set source files included. (template scripts and input images.)

Remember to enable the parallel computing toolbox for the parallel for loops etc. You may need to download and install the package if your MATLAB distribution does not come with it.

**Progress**

	- Complete: PS1, PS2, PS3
	- Ongoing: ?

**What's below**

Specific comments and highlights in some PS's.


# PS2

### Ground-true disparity data

Very helpful training set, such as `./ps2_matlab/input/pair1-L.png` vs `./ps2_matlab/input/pair1-D_L.png`.

### Disparity with SSE (sum of squared errors) method 

1. Matching original image pairs using different window sizes (20 vs. 10)
	- It is clear that with larger window size, the results become "smoother", which is good for indicating main object groups. However, the edges look more distorted and some fine/small objects are missing.
	- By contrast, a small window size will capture many more small objects. It also defines edges more clearly. However, it introduces more "noises".
2. Matching image pairs after adding moderate Gausian noises ($\sigma = 0.1$)
	- The impact is heavier on smaller window size.
3. Matching image pairs with brightness misalignment ($I_L\times1.1$)
	- Performance decreases, i.e. the mismatch of the overall intensity between the images has significant negative impact on matching results. Both big and small window sizes are largely affected.
	- The implication is that you probably want to ajudst the brightness of the images beforehand, so that they match.

### Disparity with NCC (normalized cross-correlation) method

1. Runtime increased. From my experience at work (using Python), this is largely due to the normalisation process with moving  windows.
2.  Matching original images (window size 20 vs. 10)
	- Generally improvement over the SSE method. 
	- For small window size, noticeable improvement. Much less noises, greater smoothness in the inner area of large objects.
	- For big window size, more subtle improvement.
3. Matching image pairs after adding moderate Gausian noises ($\sigma = 0.1$)
	- The results show very low usability.
	-  With big window size, some objects can be vaguely identified, while with small window size, matching can be regarded as complete failure.
4. Matching image pairs with brightness misalignment ($I_L\times1.1$)
	- Under this condition, the results are superior than those obtained via SSE.
	- Both big and small window sizes are satisfactory.

### Potential of adaptive window size

For SSE method, the disparity results are highly dependent on the actual scene. For a scene that contains both large low-contrast objects and clear-cut small objects, the best window sizes are different. Big objects needs big windows, and likewise for small objects.

Perhaps running a prior round of kernel to establish a contrast profile in the images would be helpful. Of course, since the regions of the same object are different from the 2 images, some smoothing is necessary.

The NCC method inherently handles such situation with better tolerance. <mark>Therefore, for less noisy images, it can be argued that small-window NCC serves better as the default method.</mark>


# PS3

### Projective matrix via DLT (Direct Linear Transformation)

Tolve solve the M matrix, the easist way is using SVD, i.e. $A = UDV^T$. 

The solution will be the 12th column of the V matrix, which corresponds to the least non-zero singular value of A.

This method generally prefers more data points than less. With more than 16 points, the numerical result tends to have very low uncertainly and decently low square error.

### Fundamental matrix

1. Remember there are two SVD to perform. To check your sanity, remember the final result should be the estiamted fundamental matrix, usually denoted as $\hat{F}$, which should have rank 2. However, the result from the first SVD should have a F of rank 3.

2. To draw the epipolar lines, there is a trick based on the point-line duality.
	1. If we have the two end points of a line, we can easily draw it. 
	2. Intuitively, finding two end points from the leftmost and the rightmost, which are the intersects between the epipolar line and the edge lines of the frame.
	3. These two intersects can be computed via cross product, e.g. $p_1 = L_{left}\times L_{epipolar}$, where $L_{left}$ is just (1,0,0). Similarly, $L_{right}$ would be (1,0,width).
	4. Obtain $p_1$ and $p_2$ and then draw the line at ease.

3. What is slightly confusing is the different equations for epipolar lines. In the $p^TFp'=0$ relationship, the two lines are $L^T= p^TF$ and $L=Fp'$ respectively.
4. Normalising the pixel location values beforehand brings about significant improvement. But rembmer to handle it with normalisation matrix, not some random dividing and subtraction constants.
