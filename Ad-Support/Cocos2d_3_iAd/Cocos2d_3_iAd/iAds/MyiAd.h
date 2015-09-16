//
//  MyiAd.h
//  iScienceQuiz
//
//  Created by Gururaj T on 15/12/12.
//  Copyright (c) 2012 GururajTallur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "iAd/ADBannerView.h"

@interface MyiAd : NSObject<ADBannerViewDelegate>
{
    ADBannerView *_adBannerView;
    bool _adBannerViewIsVisible;
    UIView *_contentView;
    bool mIsLoaded;
}

 @property (nonatomic) bool adBannerViewIsVisible;

-(void)showBannerView;
-(void)RemoveiAd ;
- (void)createAdBannerView ;
-(void)hideBannerView;
@end