/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
View controller for camera interface.
*/


@import UIKit;
@class AAPLPreviewView;
@protocol AAPLCameraVCDelegate;

@interface AAPLCameraViewController : UIViewController
@property (nonatomic, weak) AAPLPreviewView *_previewView;
@property (retain) id <AAPLCameraVCDelegate> delegate;

- (void)changeCamera;
- (void)toggleMovieRecording;


@end
