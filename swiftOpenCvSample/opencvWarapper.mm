//
//  opencvWarapper.m
//  swiftOpenCvSample
//
//  Created by neno naninu on 2018/05/24.
//  Copyright © 2018年 neno naninu. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "opencvWarapper.h"


@implementation opencvWarapper
-(UIImage *) toGray:(UIImage *) inputImg
{
    cv::Mat grayImg;
    UIImageToMat(inputImg,grayImg);
    
    cv::cvtColor(grayImg, grayImg, CV_BGR2GRAY);
    inputImg = MatToUIImage(grayImg);
    return inputImg;
}

@end
