//
//  iAd.m
//  Cocos2d_3_iAd
//
//  Created by Gururaj T on 18/02/14.
//  Copyright (c) 2014 Gururaj T. All rights reserved.
//

#import "MyiAd.h"
#import "AppDelegate.h"

@implementation MyiAd

@synthesize adBannerViewIsVisible = _adBannerViewIsVisible;


-(id)init
{
    if(self=[super init])
    {
        mIsLoaded = false;
        _adBannerViewIsVisible = false;
        [self createAdBannerView];
        
    }
    return self;
}

- (void)createAdBannerView
{
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adBannerView.delegate = self;
   [_adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    CGRect frame = _adBannerView.frame;
    
    frame.origin.y = -(frame.size.height); //(IS_IPAD) ? -66.0f : -50.0f;
    frame.origin.x = 0.0f;
    
    _adBannerView.frame = frame;
    
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    [app.navController.view addSubview:_adBannerView];
}


#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    mIsLoaded = true;
    
    [self showBannerView];
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    {
        _adBannerViewIsVisible = false;
        
    }
    
    if(_adBannerView)
    {
        [_adBannerView removeFromSuperview];
        _adBannerView = nil;
    }
    
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    [app bannerDidFail];
}

-(void)RemoveiAd
{
    _adBannerViewIsVisible = false;
    
    [self dismissAdView];
    //[_adBannerView removeFromSuperview];
}


-(void)showBannerView
{
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    if (_adBannerViewIsVisible  || !(app.isBannerOn) || !mIsLoaded)
    {
        return;
    }
    
    
    if (_adBannerView)
    {
        _adBannerViewIsVisible = true;
        
        CGSize s = [[CCDirector sharedDirector] viewSize];
        
        CGRect frame = _adBannerView.frame;
        
        if(app.isBannerOnTop)
        {
            frame.origin.x = 0.0f;
            frame.origin.y = -_adBannerView.frame.size.height;// - _adBannerView.frame.size.height;
            
        }
        else
        {
            frame.origin.x = 0.0f;
            frame.origin.y = s.height;// - _adBannerView.frame.size.height;
        }
        
        
        _adBannerView.frame = frame;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        
        if(app.isBannerOnTop)
        {
            frame.origin.x = 0.0f;
            frame.origin.y = 0.0f;
        }
        else
        {
            frame.origin.x = 0.0f;
            frame.origin.y = s.height - _adBannerView.frame.size.height;
        }
        
        _adBannerView.frame = frame;
        
        [UIView commitAnimations];
    }
    
}


-(void)hideBannerView
{
    AppDelegate * app = (((AppDelegate*) [UIApplication sharedApplication].delegate));

    if (!_adBannerViewIsVisible)
    {
        return;
    }
    
    if (_adBannerView)
    {
        _adBannerViewIsVisible = false;
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        CGSize s = [[CCDirector sharedDirector] viewSize];
        
        
        CGRect frame = _adBannerView.frame;
        
        if(app.isBannerOnTop)
        {
            frame.origin.x = 0.0f;
            frame.origin.y = -_adBannerView.frame.size.height ;
        }
        else
        {
            frame.origin.x = 0.0f;
            frame.origin.y = s.height ;
        }
        
        _adBannerView.frame = frame;
        
        [UIView commitAnimations];
    }
    
}


-(void)dismissAdView
{
    if (_adBannerView)
    {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             CGSize s = [[CCDirector sharedDirector] viewSize];
             
             CGRect frame = _adBannerView.frame;
             frame.origin.y = s.height;
             frame.origin.x = 0.0f;
             _adBannerView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             [_adBannerView removeFromSuperview];
             _adBannerView.delegate = nil;
             _adBannerView = nil;
             
         }];
    }
    
}




@end
