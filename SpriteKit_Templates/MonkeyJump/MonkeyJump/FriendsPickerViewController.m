//
//  FriendsPickerViewController.m
//  MonkeyJump
//
//  Created by Fahim Farook on 18/8/12.
//
//

#import "FriendsPickerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kPlayerKey @"player"
#define kScoreKey @"score"
#define kIsChallengedKey @"isChallenged"

#define kCheckMarkTag 4

@interface FriendsPickerViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GameKitHelperProtocol> {
    NSMutableDictionary *_dataSource;
    int64_t _score;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *challengeTextField;

@end

@implementation FriendsPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithScore:(int64_t) score {
    self = [super initWithNibName:@"FriendsPickerViewController" bundle:nil];
    if (self) {
        _score = score;
		_dataSource = [NSMutableDictionary dictionary];
		GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
		gameKitHelper.delegate = self;
		[gameKitHelper findScoresOfFriendsToChallenge];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton =
	[[UIBarButtonItem alloc]
	 initWithTitle:@"Cancel"
	 style:UIBarButtonItemStylePlain
	 target:self
	 action:@selector(cancelButtonPressed:)];
    
    UIBarButtonItem *challengeButton =
	[[UIBarButtonItem alloc]
	 initWithTitle:@"Challenge"
	 style:UIBarButtonItemStylePlain
	 target:self
	 action:@selector(challengeButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem =
	cancelButton;
    self.navigationItem.rightBarButtonItem =
	challengeButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelButtonPressed:(id) sender {
    if (self.cancelButtonPressedBlock != nil) {
        self.cancelButtonPressedBlock();
    }
}

- (void)challengeButtonPressed:
(id) sender {
    
    //1
    if(self.challengeTextField.text.
	   length > 0) {
        
        //2
        NSMutableArray *playerIds =
		[NSMutableArray array];
        NSArray *allValues =
		[_dataSource allValues];
		
        for (NSDictionary *dict in allValues) {
            if ([dict[kIsChallengedKey]
				 boolValue] == YES) {
                
                GKPlayer *player =
				dict[kPlayerKey];
                [playerIds addObject:
				 player.playerID];
            }
        }
        if (playerIds.count > 0) {
            
            //3
            [[GameKitHelper sharedGameKitHelper]
			 sendScoreChallengeToPlayers:playerIds
			 withScore:_score message:
			 self.challengeTextField.text];
        }
        
        if (self.challengeButtonPressedBlock) {
            self.challengeButtonPressedBlock();
        }
    } else {
        self.challengeTextField.layer.
		borderWidth = 2;
        self.challengeTextField.layer.
		borderColor =
		[UIColor redColor].CGColor;
    }
}

-(void)onScoresOfFriendsToChallengeListReceived:(NSArray*)scores {
    //1
    NSMutableArray *playerIds =
	[NSMutableArray array];
    
    //2
    [scores enumerateObjectsUsingBlock:
	 ^(id obj, NSUInteger idx, BOOL *stop){
		 
		 GKScore *score = (GKScore*) obj;
		 
		 //3
		 if(_dataSource[score.playerID]
			== nil) {
			 _dataSource[score.playerID] =
			 [NSMutableDictionary dictionary];
			 [playerIds addObject:score.playerID];
		 }
		 
		 //4
		 if (score.value < _score) {
			 [_dataSource[score.playerID]
			  setObject:[NSNumber numberWithBool:YES]
			  forKey:kIsChallengedKey];
		 }
		 
		 //5
		 [_dataSource[score.playerID]
		  setObject:score forKey:kScoreKey];
	 }];
    
    //6
    [[GameKitHelper sharedGameKitHelper]
	 getPlayerInfo:playerIds];
    [self.tableView reloadData];
}

-(void) onPlayerInfoReceived:(NSArray*)players {
    //1
    
    [players
	 enumerateObjectsUsingBlock:
	 ^(id obj, NSUInteger idx, BOOL *stop) {
		 
		 GKPlayer *player = (GKPlayer*)obj;
		 
		 //2
		 if (_dataSource[player.playerID]
			 == nil) {
			 _dataSource[player.playerID] =
			 [NSMutableDictionary dictionary];
		 }
		 [_dataSource[player.playerID]
		  setObject:player forKey:kPlayerKey];
		 
		 //3
		 [self.tableView reloadData];
	 }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell identifier";
    static int ScoreLabelTag = 1;
    static int PlayerImageTag = 2;
    static int PlayerNameTag = 3;
    
    UITableViewCell *tableViewCell =
	[tableView
	 dequeueReusableCellWithIdentifier:
	 CellIdentifier];
    
    if (!tableViewCell) {
        
        tableViewCell =
		[[UITableViewCell alloc]
		 initWithStyle:UITableViewCellStyleDefault
		 reuseIdentifier:CellIdentifier];
        tableViewCell.selectionStyle =
		UITableViewCellSelectionStyleGray;
        tableViewCell.textLabel.textColor =
		[UIColor whiteColor];
        
        UILabel *playerName =
		[[UILabel alloc] initWithFrame:
		 CGRectMake(50, 0, 150, 44)];
        playerName.tag = PlayerNameTag;
        playerName.font = [UIFont systemFontOfSize:18];
        playerName.backgroundColor =
		[UIColor clearColor];
        playerName.textAlignment =
		UIControlContentVerticalAlignmentCenter;
        [tableViewCell addSubview:playerName];
        
        UIImageView *playerImage =
		[[UIImageView alloc]
		 initWithFrame:CGRectMake(0, 0, 44, 44)];
        playerImage.tag = PlayerImageTag;
        [tableViewCell addSubview:playerImage];
        
        UILabel *scoreLabel =
		[[UILabel alloc]
		 initWithFrame:
		 CGRectMake(395, 0, 30,
					tableViewCell.frame.size.height)];
        
        scoreLabel.tag = ScoreLabelTag;
        scoreLabel.backgroundColor =
		[UIColor clearColor];
        scoreLabel.textColor =
		[UIColor whiteColor];
        [tableViewCell.contentView
		 addSubview:scoreLabel];
        
        UIImageView *checkmark =
		[[UIImageView alloc]
		 initWithImage:[UIImage
						imageNamed:@"checkmark.png"]];
        checkmark.tag = kCheckMarkTag;
        checkmark.hidden = YES;
        CGRect frame = checkmark.frame;
        frame.origin =
		CGPointMake(tableView.frame.size.width - 16, 13);
        checkmark.frame = frame;
        [tableViewCell.contentView
		 addSubview:checkmark];
    }
    NSDictionary *dict =
	[_dataSource allValues][indexPath.row];
    GKScore *score = dict[kScoreKey];
    GKPlayer *player = dict[kPlayerKey];
    
    NSNumber *number = dict[kIsChallengedKey];
    
    UIImageView *checkmark =
	(UIImageView*)[tableViewCell
				   viewWithTag:kCheckMarkTag];
    
    if ([number boolValue] == YES) {
        checkmark.hidden = NO;
    } else {
        checkmark.hidden = YES;
    }
    
    [player
	 loadPhotoForSize:GKPhotoSizeSmall
	 withCompletionHandler:
	 ^(UIImage *photo, NSError *error) {
		 if (!error) {
			 UIImageView *playerImage =
			 (UIImageView*)[tableView
							viewWithTag:PlayerImageTag];
			 playerImage.image = photo;
		 } else {
			 NSLog(@"Error loading image");
		 }
	 }];
    
    UILabel *playerName =
	(UILabel*)[tableViewCell
			   viewWithTag:PlayerNameTag];
    playerName.text = player.displayName;
    
    UILabel *scoreLabel =
	(UILabel*)[tableViewCell
			   viewWithTag:ScoreLabelTag];
    scoreLabel.text = score.formattedValue;
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    BOOL isChallenged = NO;
    
    //1
    UITableViewCell *tableViewCell =
	[tableView cellForRowAtIndexPath:
	 indexPath];
    
    //2
    UIImageView *checkmark =
	(UIImageView*)[tableViewCell
				   viewWithTag:kCheckMarkTag];
    
    //3
    if (checkmark.isHidden == NO) {
        checkmark.hidden = YES;
    } else {
        checkmark.hidden = NO;
        isChallenged = YES;
    }
    NSArray *array =
	[_dataSource allValues];
    
    NSMutableDictionary *dict =
	array[indexPath.row];
    
    //4
    [dict setObject:[NSNumber
                     numberWithBool:isChallenged]
			 forKey:kIsChallengedKey];
    [tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
}

@end
