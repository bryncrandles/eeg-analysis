R codes used for classification testing using CC,PL,SWP where SWP is calculated using coherence values

LDA Folder
-LDACrossValidation.R estimates total and group accuracies with 10-fold cross validation
-LDA_EEGanalysis.R estimates the accuracy for different combinations of CC,PL,SWP with PCA
-LDAntrial.R can be used to get a more accurate estimation by using n trials
-LDAindivNode.R estimates accuracy for each individual node
-LDAmisclassification.R retrieves which patients are being misclassified the most
-LDARemovePCs.R estimates accuracy when removing PC's to find which principle component is doing most of the work

QDA_RDA folder
-contains similar codes as LDA but for using QDA and RDA instead

FinalModel.R plots principle components of final model against each other as well as finds the eigenvectors
FinalModelPC4densityplot.R retrieves the graph of the group density estimation for PC4 (or any of the other PC's)
FinalModelPermtest.R confirms the accuracy of the final model with a permutation test