# Biomedical-Signal-and-Image-Processing
Projects at course Biomedical Signal and Image Processing.

1. The first project tackles the **QRS detection**: it first filters out the noise with high pass filtering (m-point moving average), then emphasizes the biggest changes in the measured
voltage with non-linear low-pass filtering, then finds spike on the ECG, that is the QRS complex with adaptive thresholding. 

2. Next project tackles **QRS complex classification**, the next step after QRS detection. We again first filtered the noise, with nonlinear high-pass filtering (combination of a 
trimmed moving average filter and delayed system), then emphasized the peaks with non-linear low-pass filtering. 
Then we classify normal and ventricular heartbeats by thresholding the peak height.

3. Last project describes a **Marr-Hildreth edge detection** algorithm and graphically shows each step (image smoothing, detection of edge points, edge localization and edge linking) 
and the final result on examples from CTMRI database.
