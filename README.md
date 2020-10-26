# Overview

The code is in MATLAB. Problem set source files included. (template scripts and input images.)

Remember to enable the parallel computing toolbox for the parallel for loops etc. You may need to download and install the package if your MATLAB distribution does not come with it.

**Progress**

	- Complete: PS1, PS2, PS3, PS4
	- Ongoing: PS5

**What's below**

Specific comments and highlights in some PS's.





# PS1

Nothing important to state..






# PS2 

### Ground-true disparity data

Very helpful training set, such as `./ps2_matlab/input/pair1-L.png` vs `./ps2_matlab/input/pair1-D_L.png`.

### Disparity with SSE (sum of squared errors) method 

1. Matching original image pairs using different window sizes (20 vs. 10)
	- It is clear that with larger window size, the results become "smoother", which is good for indicating main object groups. However, the edges look more distorted and some fine/small objects are missing.
	- By contrast, a small window size will capture many more small objects. It also defines edges more clearly. However, it introduces more "noises".
2. Matching image pairs after adding moderate Gaussian noises ($\sigma = 0.1$)
	- The impact is heavier on smaller window size.
3. Matching image pairs with brightness misalignment ($I_L\times1.1$)
	- Performance decreases, i.e. the mismatch of the overall intensity between the images has significant negative impact on matching results. Both big and small window sizes are largely affected.
	- The implication is that you probably want to adjust the brightness of the images beforehand, so that they match.

### Disparity with NCC (normalized cross-correlation) method

1. Runtime increased. From my experience at work (using Python), this is largely due to the normalisation process with moving  windows.
2.  Matching original images (window size 20 vs. 10)
	- Generally improvement over the SSE method. 
	- For small window size, noticeable improvement. Much less noises, greater smoothness in the inner area of large objects.
	- For big window size, subtle improvement.
3. Matching image pairs after adding moderate Gaussian noises ($\sigma = 0.1$)
	- The results show very low usability.
	- With big window size, some objects can be vaguely identified, while with small window size, matching fails completely.
4. Matching image pairs with brightness misalignment ($I_L\times1.1$)
	- Under this condition, the results are superior than those obtained via SSE.
	- Both big and small window sizes are satisfactory.

### Potentiality of adaptive window size

For SSE method, the disparity results are highly dependent on the actual scene. For a scene that contains both large low-contrast objects and clear-cut small objects, the best window sizes are different. Big objects needs big windows, and likewise for small objects.

Perhaps running a prior round with big kernel to establish a contrast profile in the images would be helpful. Of course, since the regions of the same object are different in the two images, some smoothing is necessary.

The NCC method inherently handles such situation with better tolerance. <mark>Therefore, for less noisy images, a small-window NCC arguably serves better as the default method.</mark>





# PS3

### Projective matrix via DLT (Direct Linear Transformation)

To solve the M matrix, the easiest way is using SVD, i.e. $A = UDV^T$. 

The solution will be the 12th column of the V matrix, which corresponds to the least non-zero singular value of A.

Using this method, you generally prefer more data points than less, but to a moderate extent. With more than 16 points the numerical result already tends to have very low uncertainly and low square error.

### Fundamental matrix

1. Remember there are two SVD to perform. To check your sanity, remember the final result should be the estimated fundamental matrix, usually denoted as $\hat{F}$, which should have rank 2. However, the result from the first SVD should have a F of rank 3.
2. To draw the epipolar lines on images, here is a trick based on the point-line duality:
  1. If we have the two end points of a line, we can easily draw it. 
  2. Intuitively, finding two end points from the leftmost and the rightmost, which are the intersects between the epipolar line and the edge lines of the frame.
  3. These two intersects can be computed via cross product, e.g. $p_1 = L_{left}\times L_{epipolar}$, where $L_{left}$ is just (1,0,0). Similarly, $L_{right}$ would be (1,0,width).
  4. Obtain $p_1$ and $p_2$ and then draw the line at ease.
3. What is slightly confusing is the different equations for epipolar lines. In the $p^TFp'=0$ relationship, the two lines are $L^T= p^TF$ and $L=Fp'$ respectively.
4. Normalising the pixel location values beforehand brings about significant improvement. But remember to handle it with a normalisation matrix, not some random dividing and subtraction constants...





# PS4

### Harris Corner

##### Overall procedure: #####

1. Compute Gaussian derivative at each pixel
2. Compute second moment matrix (M matrix) with a customised Gaussian Window
3. Compute the R value; threshold it for corner points (my approach is a 0.995 quantile value)
4. Apply non-local-minima filter (9x9 window etc.)

##### Strengths: #####

- Rotation invariant
- A commonly perceived problem is the scale variability. But it isn't as serious as I expect. So the scale invariant methods aren't always necessary, e.g. Harris-Laplacian method.
- However, if you are going to use SIFT descriptor later, you will need to manually specify the scale as a parameter.

##### Some corner points that a generic approach won't pick up

- low contrast region, such as white roof-top with greyish sky as background
- fine details, such as legs of chairs in a far distance.

### SIFT descriptor

Using the ```VLFeat``` library for SIFT descriptor to avoid fiddly work. Also, they have a very nice tight subplot function ```vl_tightsubplot```:

```matlab
figure(1)
vl_tightsubplot(1,2,1);
imshow(img1)
vl_tightsubplot(1,2,2);
imshow(img2)
```

Two main functions are used here:

1. ```vl_sift```, which takes the interest points' locations and the gradient directions as inputs, and it returns 2 variables, ```f``` and ```d```.
   - ```f``` is known as "a frame", whose elements are x, y coordinates, scale and orientation.
   - Each column of ```d``` is a 128-vector for that point.
2. ```vl_ubcmatch```, which performs the matching algorithm.
   - Inputs are the descriptors from both images.
   - Output is the match array ```matches```.

Call help function for more detailed explanations.

### RANSAC

##### Translation images pair:

- The unknown parameter ```p``` is a 2-vector.
- Easier way is just treat each image pair's translation as (x_i, y_i), and fit a line on it.
- In the matches obtained by ``vl_ubcmatch``, a scatter plot may show multiple clusters, which is result of having different translations in different regions of the image (e.g. two separate objects). In this case, when you run RANSAC, the results tend to diverge.
- Be patient with the data structure. I advise this:
  - Treat the consensus set C as an array of indices of the match array, namely ```matches```.
  - The match array should contain the indices of the feature array , namely ```f```.
- When the (local) scene really is translation, this method is very stable. 

##### Similarity images pair: #####

- The unknown parameter ```p``` is a 4-vector.
- Use 2 pairs of images to explicitly solve ```p```, and then use ```p``` the transform the points from image A (i.e. ```X``` to ```X_prime```) , and then compare their distances against the predefined distance cutoff. Count the number falling within the cutoff and form a consensus set ```C_i```. As the last step, keep the largest ```C_i```.
- My choice for the cutoff is 9.
- It is worthwhile to start with more interest points. (500+?)

##### Affine for the similarity pair #####

- The unknown parameter ```p``` is a 6-vector.
- Compared with the previous approach, this one is almost surely giving you more accurate results, but it may require more interests points in order to be more stable. 
- To handle noise better, increase to distance cut-off level.

##### Image warping #####

- Helpful for sanity check.
- Will contain quite a few high frequency noises.
- My experience is that affine performs slightly better in the building facet, but not by much.
- Easiest way is this:
  1. Create blank image the same size as A
  2. For each row i and column j, apply transform (similarity/affine matrix etc.) and get the index supposed to be on image B. Sample that.
  3. Now that you have a B-warped, take advantage of the colour channels and make overlay image for visualisation.

##### Some further comments #####

- When checking the RANSAC results, you may realise that the previous parameters used in running Harris detector or SIFT descriptor have to be improved. So prepare for <mark>some iterative work</mark>, and make your code's instructions clean and clear.





# PS5

### Basic Lucas-Kanade

##### window size and Gaussian sigma

- For the pre-gradient filter, a Gaussian of size 15x15 and sigma=1 can be adopted. It doesn't matter too much.
- For the M matrix summation, there is a window function. (mentioned Harris detector chapter). Ideally you should do some trial and error. Nonetheless, I found that larger and heavier filters tend to be more consistent.

##### Applicable scenarios

- It works fine if the displacement is just 1~2 pixels.

- If the displacement is more than 2 pixels, then this method cannot work. Blurring heavily can help find smoother optical flow fields, but the displacement magnitude will be significantly skewed. 

- By heavy, I mean sigma = 9. It feels quite excessive. But without it, the motion vector result is so noisy.

- To solve this, hierarchical approach is needed.

  

### Gaussian and Laplacian Pyramids implementation

##### REDUCE operator

- Apply smoothing kernel and then take every other pixels' value.
- The kernel can be different from Gaussian function (don't know why Burt and Adelson used the term Gaussian) .

##### EXPAND operator

- Create an empty array double the size of the current level, and then sample the values from this layer when appropriate.
- Read the paper or my note to brush exactly how this works.

##### Size of the original image

- if you decide you want to create a four-level pyramid, then check whether all these are integers:
  - n_1 = (n_0+1)/2
  - n_2 = (n_1+1)/2
  - n_3 = (n_2+1)/2
  - n_4 = (n_3+1)/2

# MATLAB plotting tips

#### refresh stuff in the same figure window without old stuff sticking around

```matlab
% this will remove all the colorbars and etc. existing in your figure
% it won't crash even if you haven't created any figure object.
ccc = gcf;
delete(ccc.Children);

figure(1);
subplot(1,1,1);
imshow(im1);
colorbar('SouthOutside');
colormap(gca,jet(100));

```

#### two subplots sharing the same scale of colormap

```matlab
% first determine the range
% then set the color axis to manual before running the colorbar function
U_min = min(min(U));
U_max = max(max(U));
V_min = min(min(V));
V_max = max(max(V));

bottom = min(U_min,V_min);
top = max(U_max,V_max);

figure(2);

subplot(1,2,1);
imagesc(U)
caxis manual;
caxis([bottom top]);
colorbar('SouthOutside');
colormap(gca,jet(100))

subplot(1,2,2);
imagesc(V)
caxis manual;
caxis([bottom top]);
colorbar('SouthOutside');
colormap(gca,jet(100))

```





