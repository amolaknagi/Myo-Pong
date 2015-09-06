//
//  GameViewController.m
//  Myo Pong
//
//  Created by Amolak Nagi on 9/5/15.
//  Copyright (c) 2015 Amolak Nagi. All rights reserved.
//

#import "GameViewController.h"
#import "PongBoardView.h"
#import <MyoKit/MyoKit.h>

@interface GameViewController ()

@property (nonatomic, strong) UIView *userPlatform;
@property (nonatomic, strong) UIView *computerPlatform;

@property (nonatomic, strong) UIView *ball;

@property (nonatomic, strong) NSTimer *ballTimer;
@property (nonatomic, strong) NSTimer *computerTimer;

@property (nonatomic, strong) UILabel *playerScore;

@property (nonatomic) BOOL up;
@property (nonatomic) BOOL right;

@property (nonatomic) int platformThickness;
@property (nonatomic) int platformWidth;
@property (nonatomic) int platformFromEdge;
@property (nonatomic) int midlineSpacing;
@property (nonatomic) int ballLength;

@property (nonatomic) int playerScoreCount;

@property (nonatomic, strong) UIView *optionsView;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation GameViewController





#pragma mark - View Initialization







- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self declareConstants];
    
    [self addUIElements];
    
    [self initializeMyo];


}







- (void)declareConstants;
{
    self.playerScoreCount = 0;
}








- (void)addUIElements
{
    //Add the background board drawing
    PongBoardView *boardView = [[PongBoardView alloc] initWithFrame:self.view.frame];
    [boardView setNeedsDisplay];
    [self.view addSubview:boardView];
    [self.view sendSubviewToBack:boardView];
    
    
    //Layout a clear button over so that when pressed the options panel will show
    UIButton *button = [[UIButton alloc] initWithFrame:self.view.frame];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(options) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    //Draw a score for the player
    self.playerScore = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 30, self.platformThickness + 10, 100, 100)];
    self.playerScore.font = [UIFont fontWithName:@"PressStart2P" size:30.0];
    self.playerScore.textAlignment = UITextAlignmentCenter;
    self.playerScore.text = @"0";
    self.playerScore.textColor = [UIColor whiteColor];
    [self.view addSubview:self.playerScore];
    
    
    //Initialize the moving platforms for the player and the computer
    [self initializeUserPlatform];
    [self initializeComputerPlatform];
    
    //Initialize the actual playing ball
    [self initializeBall];
}











- (void)initializeUserPlatform
{
    CGFloat x = self.view.frame.size.width - self.platformFromEdge;
    CGFloat y = (self.view.frame.size.height / 2) - (self.platformWidth / 2);
    CGFloat width = self.platformThickness;
    CGFloat height = self.platformWidth;
    CGRect frame = CGRectMake(x, y, width, height);
    
    self.userPlatform = [[UIView alloc] initWithFrame:frame];
    
    self.userPlatform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userPlatform];
    
    [self.view bringSubviewToFront:self.userPlatform];
}









- (void)initializeComputerPlatform
{
    CGFloat x = self.platformFromEdge - self.platformThickness;
    CGFloat y = (self.view.frame.size.height / 2) - (self.platformWidth / 2);
    CGFloat width = self.platformThickness;
    CGFloat height = self.platformWidth;
    CGRect frame = CGRectMake(x, y, width, height);
    
    self.computerPlatform = [[UIView alloc] initWithFrame:frame];
    
    self.computerPlatform.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.computerPlatform];
    
    self.computerTimer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(moveComputerPlatform) userInfo:nil repeats:YES];
    
}











- (void)initializeBall
{
    
    int widthFactor = self.view.frame.size.height - (2 * self.platformThickness) - self.ballLength;
    
    CGFloat yCoord = (arc4random() % widthFactor) + self.platformThickness;
    
    CGFloat x = self.userPlatform.frame.origin.x - self.ballLength;
    CGFloat y = yCoord;
    CGFloat width = self.ballLength;
    CGFloat height = self.ballLength;
    CGRect frame = CGRectMake(x, y, width, height);
    
    self.ball = [[UIView alloc] initWithFrame:frame];
    self.ball.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.ball];
    
    self.ballTimer = [NSTimer  scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
    //[self.ballTimer fire];
    //[[NSRunLoop currentRunLoop] addTimer:self.ballTimer forMode:NSRunLoopCommonModes];
    
    
    self.up = NO;
    self.right = NO;
}









#pragma mark - Options Panel









//Bring up the options panel when the user clicks the screen
- (void)options
{

    UIView *overView = [[UIView alloc] initWithFrame:self.view.frame];
    overView.backgroundColor = [UIColor blackColor];
    overView.alpha = 0.8;
    self.optionsView = overView;
    [self.view addSubview:overView];
    [self.view bringSubviewToFront:overView];
    [self.ballTimer invalidate];
    
    CGFloat buttonWidth = 150;
    CGFloat buttonHeight = 80;
    
    self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    self.continueButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor whiteColor];
    [self.continueButton addTarget:self action:@selector(continueGame) forControlEvents:UIControlEventTouchUpInside];
    self.continueButton.center = CGPointMake( 2.8 * self.view.frame.size.width / 4 , 2.8 * self.view.frame.size.height / 4);
    
    [overView addSubview:self.continueButton];
    
    
    self.connectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    [self.connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
    self.connectButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.connectButton.backgroundColor = [UIColor whiteColor];
    [self.connectButton addTarget:self action:@selector(connectMyo) forControlEvents:UIControlEventTouchUpInside];
    self.connectButton.center = CGPointMake( 2.8 * self.view.frame.size.width / 4 , 1.2 * self.view.frame.size.height / 4);
    
    [overView addSubview:self.connectButton];
    
    
    
    self.restartButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    [self.restartButton setTitle:@"RESTART" forState:UIControlStateNormal];
    self.restartButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.restartButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.restartButton.backgroundColor = [UIColor whiteColor];
    [self.restartButton addTarget:self action:@selector(restartGame) forControlEvents:UIControlEventTouchUpInside];
    self.restartButton.center = CGPointMake( 1.2 * self.view.frame.size.width / 4 , 1.2 * self.view.frame.size.height / 4);
    
    [overView addSubview:self.restartButton];
    
    self.quitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 80)];
    [self.quitButton setTitle:@"QUIT" forState:UIControlStateNormal];
    self.quitButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.quitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.quitButton.backgroundColor = [UIColor whiteColor];
    [self.quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
    self.quitButton.center = CGPointMake( 1.2 * self.view.frame.size.width / 4 , 2.8 * self.view.frame.size.height / 4);
    
    [overView addSubview:self.quitButton];
}











- (void)restartGame
{
    [self.optionsView removeFromSuperview];
    [self.ball removeFromSuperview];
    [self.playerScore removeFromSuperview];
    [self.userPlatform removeFromSuperview];
    [self.computerPlatform removeFromSuperview];
    [self viewDidLoad];
    [self viewDidAppear:NO];
}









- (void)quitGame
{
    [self.navigationController popViewControllerAnimated:YES];
}









- (void)connectMyo
{
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    // Present the settings view controller modally.
    [self presentViewController:controller animated:YES completion:nil];
}










- (void)continueGame
{
    [self.optionsView removeFromSuperview];
    self.ballTimer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
}










#pragma mark - NSTimer Function Calls






- (void)moveBall
{
    CGFloat x;
    CGFloat y;
    CGFloat width = self.ballLength;
    CGFloat height = self.ballLength;
    
    
    
    if (self.up)
    {
        if (self.ball.frame.origin.y <= self.platformThickness)
        {
            self.up = NO;
            y = self.ball.frame.origin.y + 1;
        }
        else
        {
            y = self.ball.frame.origin.y - 1;
        }
    }
    else
    {
        if (self.ball.frame.origin.y + self.ballLength >= self.view.frame.size.height - self.platformThickness)
        {
            self.up = YES;
            y = self.ball.frame.origin.y - 1;
        }
        else
        {
            y = self.ball.frame.origin.y + 1;
        }
    }
    
    
    if (self.right)
    {
        if (self.ball.frame.origin.x + self.ballLength >= self.userPlatform.frame.origin.x)
        {
            
            CGFloat upperBall = self.ball.frame.origin.y;
            CGFloat lowerBall = self.ball.frame.origin.y + self.ball.frame.size.height;
            
            CGFloat upperUserPlatform = self.userPlatform.frame.origin.y;
            CGFloat lowerUserPlatform = self.userPlatform.frame.origin.y + self.userPlatform.frame.size.height;
            
            if (upperUserPlatform > lowerBall || lowerUserPlatform < upperBall)
            {
                NSLog(@"LOSER");
                [self.ballTimer invalidate];
                self.playerScoreCount = 0;
                self.playerScore.text = [NSString stringWithFormat:@"0"];
                [self.ball removeFromSuperview];
                [self initializeBall];
                return;
            }
            self.playerScoreCount++;
            self.playerScore.text = [NSString stringWithFormat:@"%i",self.playerScoreCount];

            self.right = NO;
            x = self.ball.frame.origin.x - 1;
        }
        else
        {
            x = self.ball.frame.origin.x + 1;
        }
    }
    else
    {
        if (self.ball.frame.origin.x <= self.platformFromEdge)
        {
            self.right = YES;
            x = self.ball.frame.origin.x + 1;
        }
        else
        {
            x = self.ball.frame.origin.x - 1;
        }
    }
    
    
    CGRect frame = CGRectMake(x, y, width, height);
    self.ball.frame = frame;
    
}







- (void)moveComputerPlatform
{
    CGFloat computerTop = self.computerPlatform.frame.origin.y;
    CGFloat computerBottom = self.computerPlatform.frame.origin.y + self.computerPlatform.frame.size.height;
    
    if (computerTop > self.ball.center.y)
    {
        self.computerPlatform.frame = CGRectMake(self.computerPlatform.frame.origin.x, self.computerPlatform.frame.origin.y - 1, self.computerPlatform.frame.size.width, self.computerPlatform.frame.size.height);
    }
    else if (computerBottom < self.ball.center.y)
    {
        self.computerPlatform.frame = CGRectMake(self.computerPlatform.frame.origin.x, self.computerPlatform.frame.origin.y + 1, self.computerPlatform.frame.size.width, self.computerPlatform.frame.size.height);
    }

}









#pragma mark - Myo Setup

- (void)initializeMyo
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didConnectDevice:)
                                                 name:TLMHubDidConnectDeviceNotification
                                               object:nil];
    // Posted whenever a TLMMyo disconnects.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didDisconnectDevice:)
                                                 name:TLMHubDidDisconnectDeviceNotification
                                               object:nil];
    // Posted when a new orientation event is available from a TLMMyo. Notifications are posted at a rate of 50 Hz.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveOrientationEvent:)
                                                 name:TLMMyoDidReceiveOrientationEventNotification
                                               object:nil];

}






- (void)didConnectDevice:(NSNotification *)notification
{
    // Access the connected device.
    TLMMyo *myo = notification.userInfo[kTLMKeyMyo];
    NSLog(@"Connected to %@.", myo.name);
    //self.connectButton.enabled = NO;
    
}




- (void)didDisconnectDevice:(NSNotification *)notification
{
    // Access the disconnected device.
    TLMMyo *myo = notification.userInfo[kTLMKeyMyo];
    NSLog(@"Disconnected from %@.", myo.name);
    //self.connectButton.enabled = YES;
    
}








- (void)didReceiveOrientationEvent:(NSNotification *)notification {
    // Retrieve the orientation from the NSNotification's userInfo with the kTLMKeyOrientationEvent key.
    TLMOrientationEvent *orientationEvent = notification.userInfo[kTLMKeyOrientationEvent];
    
    // Create Euler angles from the quaternion of the orientation.
    TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
    
    CGFloat screenWidth = self.view.frame.size.width;
    
    CGFloat ourAngle = angles.roll.degrees + 180;
    
    CGFloat widthFactor = self.view.frame.size.height - (2 * self.platformThickness) - self.platformWidth;
    
    CGFloat yCoord = (ourAngle/360) * widthFactor + self.platformThickness;
    
    self.userPlatform.frame = CGRectMake(self.userPlatform.frame.origin.x, yCoord, self.userPlatform.frame.size.width, self.userPlatform.frame.size.height);
    
    
}


@end

