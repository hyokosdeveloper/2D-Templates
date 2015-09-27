//
//  RootViewController.m
//  MaskedCal
//
//  Created by Ray Wenderlich on 7/17/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "MBProgressHUD.h"

@implementation RootViewController
@synthesize homeButton = _homeButton;
@synthesize mailButton = _mailButton;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void)setupCocos2D {
    EAGLView *glView = [EAGLView viewWithFrame:self.view.bounds
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0                        // GL_DEPTH_COMPONENT16_OES
						];
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:glView atIndex:0];
    [[CCDirector sharedDirector] setOpenGLView:glView];
    CCScene *scene = [HelloWorldLayer sceneWithCalendar:1 rootViewController:self];
    [[CCDirector sharedDirector] runWithScene:scene];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];   
    _showingUI = YES;
    _mailCenterOrig = _mailButton.center;
    _homeCenterOrig = _homeButton.center;
    [self setupCocos2D];
}

- (void)toggleUI {
    _showingUI = !_showingUI;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {        
        if (_showingUI) {
            _mailButton.center = _mailCenterOrig;
            _homeButton.center = _homeCenterOrig;
        } else {
            _mailButton.center = CGPointMake(_mailCenterOrig.x+_mailButton.bounds.size.width, _mailCenterOrig.y+_mailButton.bounds.size.height);
            _homeButton.center = CGPointMake(_homeCenterOrig.x-_homeButton.bounds.size.width, _homeCenterOrig.y+_homeButton.bounds.size.height);
        }
    } completion:^(BOOL finished) {
    }];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setHomeButton:nil];
    [self setMailButton:nil];
    [super viewDidUnload];
    [[CCDirector sharedDirector] end];
}


- (void)dealloc {
    [_homeButton release];
    [_mailButton release];
    [super dealloc];
}


- (IBAction)homeTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mailData:(NSData *)data {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", @"")
                                                        message:NSLocalizedString(@"Your device cannot send mail.", @"") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
        
	// Start up mail picker
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
	UINavigationBar *bar = picker.navigationBar;
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Check out this cute wallpaper!"];
	[picker addAttachmentData:data mimeType:@"image/jpg" fileName:@"wallpaper.jpg"];
	
	// Set up the recipients.
	NSArray *toRecipients = [NSArray arrayWithObjects:nil];	
	[picker setToRecipients:toRecipients];
	
	// Fill out the email body text.
    NSString *actualBody = @"Check out this cute wallpaper!  You can download the fullscreen version for free from: http://www.vickiwenderlich.com";
	[picker setMessageBody:actualBody isHTML:NO];
	
	// Present the mail composition interface.
	[self presentModalViewController:picker animated:YES];
	
	bar.topItem.title = @"Email Wallpaper";
	
	[picker release]; // Can safely release the controller now.
}

- (IBAction)mailTapped:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Preparing wallpaper...";
    
    CCScene * scene = [[CCDirector sharedDirector] runningScene];
    HelloWorldLayer *layer = [scene.children objectAtIndex:0];
    UIImage *curImage = layer.curImage;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {        
        NSData *data = UIImageJPEGRepresentation(curImage, 0.8); 
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self mailData:data];
        });
    });
    
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end

