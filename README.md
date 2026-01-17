# Raspberry-Pi-Spectrometer (Spectrometer Mk1)

A DIY, low-cost spectrometer built around Raspberry Pi, a camera module, a slit, and a transmission diffraction grating.
This project captures a slit image + its 1st order spectrum, then extracts an intensity-vs-pixel spectrum for comparison and future wavelength calibration.

---

## What it does
- Uses a **narrow slit** to forma  thin line source
- A **transmission diffraction grating** splits the light into spectral orders
- The camera captures:
  - the **0th order** (direct slit image)
  - the **1st order** spectrum (used for analysis)
- A simple processing script extracts a **1D spectrum** from the image(intesity vs pixel position)

---

## Hardware (MK1)
- Raspberry Pi + camera module
- C/CS-mount style lens (manual focus + iris)
- Light-tight enclosure with slit
- Transmission diffraction grating film (mounted in a "sandwich" frame)
- Test light sources (planned):
  - CFL light bulb (for discrete specral lines)
  - LED sources (for comparison)
