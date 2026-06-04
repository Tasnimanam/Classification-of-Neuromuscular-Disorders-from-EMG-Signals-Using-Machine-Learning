# Classification of Neuromuscular Disorders from EMG Signals Using Machine Learning

## Project Overview

This project focuses on the classification of neuromuscular disorders, specifically **Neuropathy** and **Myopathy**, using Electromyography (EMG) signals and Machine Learning techniques.

The system processes raw EMG signals, extracts significant time-domain and frequency-domain features, and applies machine learning algorithms to classify subjects into:

- Healthy
- Myopathy
- Neuropathy

The project combines the strengths of:

- MATLAB for signal processing and feature extraction
- Python for machine learning model development and evaluation

---

## Objectives

- Preprocess EMG signals by removing noise and artifacts.
- Extract important time-domain and frequency-domain features.
- Train and evaluate machine learning models.
- Compare classifier performance using multiple evaluation metrics.
- Develop an accurate framework for neuromuscular disorder classification.

---

## Dataset

The EMG dataset was obtained from PhysioNet:

https://physionet.org/content/emgdb/1.0.0/

The dataset contains EMG recordings from:

- Healthy subjects
- Myopathy patients
- Neuropathy patients

---

## Methodology

### Signal Processing (MATLAB)

1. Load EMG signals
2. Remove 50 Hz power-line interference using a notch filter
3. Apply band-pass filtering
4. Compute FFT analysis
5. Perform signal rectification
6. Generate RMS envelope
7. Generate Linear Envelope
8. Segment signals into epochs
9. Extract statistical features

### Feature Extraction

Time-domain features:

- Root Mean Square (RMS)
- Average Rectified Value (ARV)
- Variance
- Maximum Amplitude
- Integration Value
- Skewness
- Kurtosis
- Total Peaks

Frequency-domain feature:

- Power Spectrum

---

## Machine Learning Models

The following classifiers were implemented:

- Support Vector Machine (SVM)
- K-Nearest Neighbors (kNN)
- XGBoost
- Voting Classifier (Ensemble)

---

## Evaluation Metrics

Model performance was evaluated using:

- Accuracy
- Precision
- Recall
- F1-Score
- Confusion Matrix
- ROC Curve
- Kappa Score
- MCC (Matthews Correlation Coefficient)

---

## Technologies Used

### MATLAB

- Signal preprocessing
- FFT analysis
- Feature extraction
- Visualization

### Python

Libraries used:

```python
numpy
scipy
matplotlib
scikit-learn
xgboost
pandas
