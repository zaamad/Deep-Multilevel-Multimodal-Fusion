# Deep-Multilevel-Multimodal-Fusion
Datasets and codes for Deep Multilevel Multimodal Fusion for Human Action Recognition

1)	Download the datsets from the link : https://www.kaggle.com/zaamad/deep-multilevel-fusion-datasets-and-codes
2)	 The ImageFolders_KinectV2Dataset folder has all the images related to Kinect V2 dataset.
3)	 The ImageFolders_UTD-MHAD Dataset folder has images of UTD-MHAD dataset.
4)	 To run the code on Matlab, Place all the subfolders of  folder “ImageFolders_KinectV2Dataset” and  matlab files on same Matlab’s working directory.
5)	Run the Matlab file “ FirstDeepFusionFramework.m” to see the results about the accuracy of 
    First fusion framework on Kinect V2 dataset.
6)	Similarly Run the Matlab file “ ThirdDeepFusionFramework” to see the results about the accuracy of Third fusion framework on Kinect V2 dataset.
7)	The Matlab files starting with the name “XONet” are trained CNN Models on image folders for Kinect V2 dataset.
8)	To execute the code on UTD-MHAD dataset you need to train CNN on the image folders present inside “ ImageFolders_UTD-MHAD Dataset ” and generate the CNN training Models like “XONet” files given for KinectV2. 
9)	You can easily generate models using attached Matlab files like “ CNN_DepthImages, CNN_FullAugmentedSignalImages and other attached CNN files.
10)	Inertial2SignalImages.m  converts the raw inertial data into images.
11)	Depth_ImagesFormation.m  converts the raw depth data into depth images. 
         
