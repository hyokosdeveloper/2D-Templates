//
//  FriendsPickerViewController.h
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^FriendsPickerCancelButtonPressed)();
typedef void (^FriendsPickerChallengeButtonPressed)();

@interface FriendsPickerViewController : UIViewController

//1
@property (nonatomic, copy) FriendsPickerCancelButtonPressed cancelButtonPressedBlock;
//2
@property (nonatomic, copy) FriendsPickerChallengeButtonPressed challengeButtonPressedBlock;

-(id)initWithScore:(int64_t)score;

@end
