//
//  RootViewController.h
//  MaskedCal
//
//  Created by Ray Wenderlich on 7/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RootViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    BOOL _showingUI;
    UIButton *_homeButton;
    UIButton *_mailButton;
    CGPoint _mailCenterOrig;
    CGPoint _homeCenterOrig;
}
@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
- (IBAction)homeTapped:(id)sender;
- (IBAction)mailTapped:(id)sender;
- (void)toggleUI;

@end
