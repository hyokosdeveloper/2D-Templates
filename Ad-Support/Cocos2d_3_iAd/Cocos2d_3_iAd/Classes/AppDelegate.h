//
//  AppDelegate.h
//  Cocos2d_3_iAd
//
//  Created by Gururaj T on 18/02/14.
//  Copyright Gururaj T 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"

@class MyiAd;

@interface AppDelegate : CCAppDelegate
{
    MyiAd   *mIAd;
    bool                mIsBannerOn;
    
    bool   mBannerOnTop;
}

@property(nonatomic, assign) bool isBannerOn;
@property(nonatomic, assign) bool isBannerOnTop;

-(void)ShowIAdBanner;
-(void)hideIAdBanner;
-(void)bannerDidFail;
@end
