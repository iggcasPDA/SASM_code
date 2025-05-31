您说得对，输出为.md文件确实更专业。以下是按照Nature杂志标准修改的README.md文件：

```markdown
# South Asian Summer Monsoon Index Reconstruction (1850-2010)

## Abstract

This repository provides the complete computational workflow for reconstructing the South Asian Summer Monsoon Index (SASMI) over the period 1850-2010 using paleoclimate proxy records. The reconstruction methodology employs an ensemble-based approach combining Partial Least Squares (PLS), Principal Component Regression (PCR), and Optimal Information Extraction (OIE) techniques to produce a statistically robust reconstruction with quantified uncertainties.

## Data Availability Statement

All data required to reproduce this analysis are included in this repository:
- Proxy data: `SASM_proxy_withoutcoral.mat` (non-coral proxy records)
- Instrumental data: `SASM_inst.mat` (ERA5 reanalysis-based SASMI)
- Calibration periods: `group_list.csv`
- Final reconstruction: `SASMI_oie_recon_1850_2010_20250123.csv`

## System Requirements

### Software Dependencies
- MATLAB R2020a or later
- MATLAB Statistics and Machine Learning Toolbox v11.7 or later
- Third-party function: `natsort.m` (available from MATLAB File Exchange)

### Hardware Requirements
- Standard desktop computer with at least 8 GB RAM
- No special hardware required
- Typical run time: ~30 minutes on a standard desktop computer

## Installation Guide

1. Clone this repository or download all files to a local directory
2. Ensure MATLAB and required toolboxes are installed
3. Download and add `natsort.m` to MATLAB path
4. Set MATLAB working directory to the repository folder

Installation time: < 5 minutes

## Reproducibility

### Random Number Generation
All stochastic processes use a fixed random seed (`rng(3407)`) to ensure reproducibility.

### Workflow Execution
Execute the following scripts in sequence:
```matlab
% Step 0: Data preprocessing
step0_extract_inst.m

% Step 1: Proxy screening (correlation-based selection)
step1_select_data.m

% Step 2: Data normalization and ensemble generation
step2_divide_into_group.m

% Step 3: Regression analysis (PLS and PCR)
step3_PLS_PCR.m

% Step 4: Optimal Information Extraction
step4_oie.m

% Step 5: Final reconstruction compilation
step5_get_results.m
```

## Methodological Details

### Proxy Selection Criteria
- Temporal overlap with instrumental period (1945-2010)
- Correlation significance: p < 0.1 for both raw and detrended series
- Minimum data availability within calibration windows

### Reconstruction Approach
1. **Ensemble Generation**: 100 random draws of 85% of available proxies
2. **Regression Methods**: 
   - PLS with 1-3 components
   - PCR with 1-3 principal components
3. **Cross-validation**: 25% hold-out validation
4. **Uncertainty Quantification**: 5,000 Monte Carlo simulations per ensemble member
5. **Final Reconstruction**: Weighted median of all ensemble members

### Statistical Validation
- Root Mean Square Error (RMSE) weighting
- Temporal cross-validation across multiple calibration periods
- Detrended correlation analysis

## Output Description

### Primary Output
`SASMI_oie_recon_1850_2010_20250123.csv` contains:
- Column 1: Year (1850-2010)
- Columns 2-16: Individual group reconstructions
- Column 17: Ensemble median reconstruction

### Uncertainty Estimates
`oie_result_tt.mat` contains:
- 3D array: [years × groups × ensemble members]
- Enables calculation of percentile-based uncertainty bounds

## Quality Control

- Automated removal of NaN values and empty columns
- Normalization within calibration periods to prevent artificial trends
- Multiple regression methods to assess methodological uncertainty
- Ensemble approach to quantify parametric uncertainty

## Code Availability

All source code is provided under the MIT License. 


## References

[Include relevant methodological papers and data sources]

## Corresponding Author

[Your name and institutional email address]

## Supplementary Information

Additional documentation and extended methodology descriptions are available upon request.

