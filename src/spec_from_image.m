clear; clc; close all;

%% 1) Read image
fname = "lightShift_R.jpg";   
img = imread(fname);
imgd = im2double(img);

% Grayscale intensity
I = 0.2126*imgd(:,:,1) + 0.7152*imgd(:,:,2) + 0.0722*imgd(:,:,3);

%% 2) Select ROI using two mouse clicks
figure; imshow(img);
title({"Click TOP-LEFT then BOTTOM-RIGHT of ROI around RIGHT 1st-order spectrum", ...
       "(avoid the bright center line if possible)"});

[x, y] = ginput(2);
x = round(x); y = round(y);

x1 = max(1, min(x));
x2 = min(size(I,2), max(x));
y1 = max(1, min(y));
y2 = min(size(I,1), max(y));

ROI = I(y1:y2, x1:x2);

close;

%% 3) Collapse 2D -> 1D spectrum
% Lines are vertical -> dispersion is horizontal -> average across rows:
spec = mean(ROI, 1);

% Normalize
spec = spec - min(spec);
if max(spec) > 0
    spec = spec / max(spec);
end

%% 4) Background subtract + smooth
bg = median(spec);
spec_bs = spec - bg;
spec_bs(spec_bs < 0) = 0;

win = 9;                 
spec_s = movmean(spec_bs, win);

%% 5) Peak finding
minProm = 0.02;           
minDist = 10;            

[pks, locs] = findpeaks(spec_s, ...
    "MinPeakProminence", minProm, ...
    "MinPeakDistance",  minDist);

%% 6) Plot results
figure;
plot(spec_s, "LineWidth", 1.5); hold on;
plot(locs, pks, "o", "LineWidth", 1.5);
grid on;
title("Extracted 1D Spectrum (pixel domain) + detected peaks");
xlabel("Pixel (within ROI, left-to-right)");
ylabel("Relative intensity");
legend("Smoothed spectrum", "Peaks");

figure;
imagesc(ROI); axis image; colormap gray;
title("ROI used (grayscale)");
xlabel("x (pixel)"); ylabel("y (pixel)");

%% 7) Print peak locations for calibration
disp("Peak pixel locations (within ROI):");
disp(locs);

%% 8) Wavelength calibration

% Known mercury lines in CFL (nm): 436 (blue), 546 (green), 577/579 (yellow)
px = [84  393  496];      % pixel positions (within ROI) for blue, green, yellow-ish
wl = [436 546 579];       % wavelengths (nm)

% Fit wavelength = a*pixel + b
p = polyfit(px, wl, 1);

% Build wavelength axis
pix_axis = 1:length(spec_s);
wl_axis  = polyval(p, pix_axis);

% Convert detected peak pixels -> wavelengths
peak_wl = polyval(p, locs);

% Plot calibrated spectrum
figure;
plot(wl_axis, spec_s, "LineWidth", 1.5); hold on;
plot(peak_wl, spec_s(locs), "o", "LineWidth", 1.5);
grid on;
title("Calibrated Spectrum (approx.)");
xlabel("Wavelength (nm)");
ylabel("Relative intensity");

% Print peak wavelengths
disp("Peak wavelengths (nm):");
disp(peak_wl);
