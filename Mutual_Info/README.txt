Summer Research Project
Mutual Information of EEG recordings

Sent EEG data and functions to compute canada.
miarray.m returns an array with all MI estimates between each pair of nodes
	up to a specified amount of time delay
mihist.m does the estimate for a pair of electrodes
mitimedelay.m shifts data so that MI can be estimated with a time delay

mieeg301.m is an example of calculating the MI array for EEG dataset 301
mieeg301.sh is the corresponding shell script

Used results_compiler.m to assemble all data from each patient number into
	one cell structure in matlab

Small World Propensity
https://www.nature.com/articles/srep22057
Used this method to capture "small-world-ness" of each patient for a given
	condition.  Code for their functions which we used can be found on 
	this website: https://complexsystemsupenn.com/

SWeeg.m computes a small-world-propensity value for each patient and each 
	condition and outputted them in a matrix
globalCCPL.m computes global average CC and PL for all patients for all 3 conditions

All actual analysis was done in R using the RepMeasPermTest.R (Repeated
	Measures Permutation Test)