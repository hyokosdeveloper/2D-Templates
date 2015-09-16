//
//  MyiAd.mm
//  iScienceQuiz
//
//  Created by Gururaj T on 15/12/12.
//  Copyright (c) 2012 GururajTallur. All rights reserved.
//

#import "MyiAd.h"
#import "CCAppDelegate.h"


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
    _adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    CGRect frame = _adBannerView.frame;
    frame.origin.y = -50.0f;
    frame.origin.x = 0.0f;
    
    _adBannerView.frame = frame;

    AppController * myDelegate = (((AppController*) [UIApplication sharedApplication].delegate));
    [myDelegate.navController.view addSubview:_adBannerView];
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
        [_adBannerView release];
        _adBannerView = nil;
    }
    
    [app_dsp bannerDidFail];
}

-(void)RemoveiAd
{
    _adBannerViewIsVisible = false;
    
    [self dismissAdView];
    //[_adBannerView removeFromSuperview];
}


-(void)showBannerView
{
    if (_adBannerViewIsVisible  || !(app_dsp.isBannerOn) || !mIsLoaded)
    {
        return;
    }
    
    
    if (_adBannerView)
    {
        _adBannerViewIsVisible = true;
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        CGRect frame = _adBannerView.frame;

        if(app_dsp.isBannerOnTop)
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
        
        
        if(app_dsp.isBannerOnTop)
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
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        
        CGRect frame = _adBannerView.frame;

        if(app_dsp.isBannerOnTop)
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
             CGSize s = [[CCDirector sharedDirector] winSize];
             
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


-(void)dealloc
{
    [super dealloc];
}


@end
