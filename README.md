# Overview

The code is in MATLAB. Problem set source files included. (template scripts and input images.)

Remember to enable the parallel computing toolbox for the parallel for loops etc. You may need to download and install the package if your MATLAB distribution does not come with it.

**Progress**

	- Complete: PS1
	- Ongoing: PS2

**What's below**

Specific comments and noteworthy discussions in some PS's.


## PS2

### Ground-true disparity data

Very helpful training set, such as `./ps2_matlab/input/pair1-L.png` vs `./ps2_matlab/input/pair1-D_L.png`.

### Disparity with SSE (sum of squared errors) method parameters implications

1. Matching original image pairs using different window sizes (20 vs. 10)
	- It is clear that the larger window size, the "smoother" the results, which is good for indication of main object  groups. However, the edges look distorted and some fine/small objects are missing.
	- By contrast, a small window size will capture a lot more small objects and clearly defined edges, however with the introduction of more "noises".
2. Matching image pairs after adding moderate Gausian noises ($\sigma = 0.1$)
	- The impact on smaller window size matching is heavier.
3. Matching image pairs with brightness misalignment ($I_L\times1.1$)
	- Performance decreases, i.e. the mismatch of the overall intensity between the images has significant negative impact on matching results. Both big and small window sizes are largely affected.

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
