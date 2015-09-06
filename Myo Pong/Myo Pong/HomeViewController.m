//
//  HomeViewController.m
//  Myo Pong
//
//  Created by Amolak Nagi on 9/5/15.
//  Copyright © 2015 Amolak Nagi. All rights reserved.
//

#import "HomeViewController.h"
#import <MyoKit/MyoKit.h>

@interface HomeViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UITextView *aboutView;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray *fallingBalls;
@property (nonatomic, strong) NSTimer *addBall;
@property (nonatomic, strong) NSTimer *moveBalls;

@end

@implementation HomeViewController


#pragma mark - View Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialize the array of falling balls on the home page
    self.fallingBalls = [NSMutableArray array];
    
    //Set up the timers for adding new falling balls and moving the current ones
    self.addBall = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addBall) userInfo:nil repeats:YES];
    self.moveBalls = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBalls) userInfo:nil repeats:YES];
    
    //Add all the UI for this page.
    [self addUIElements];
}





- (void)addUIElements
{
    [self addHomePageElements];
    
    [self addAboutPageElements];
}









- (void)addHomePageElements
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 100)];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"PressStart2P" size:50.0];
    self.titleLabel.center = CGPointMake(self.view.frame.size.width / 2, 0);
    self.titleLabel.text = @"MYO PONG";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^
     {
         self.titleLabel.alpha = 1;
         self.titleLabel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4);
     }];
    
    
    CGFloat startButtonX = self.view.frame.size.width / 2;
    CGFloat connectButtonX = self.view.frame.size.width / 4;
    CGFloat aboutButtonX = 3 * self.view.frame.size.width / 4;
    CGFloat buttonYPreAnimation = self.view.frame.size.height + 40;
    CGFloat buttonYPostAnimation = 2.8 * self.view.frame.size.height / 4;
    
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    self.startButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.startButton.alpha = 0;
    self.startButton.backgroundColor = [UIColor whiteColor];
    [self.startButton addTarget:self action:@selector(pushToGame) forControlEvents:UIControlEventTouchUpInside];
    
    self.startButton.center = CGPointMake(startButtonX, buttonYPreAnimation);
    
    [self.view addSubview:self.startButton];
    
    self.connectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    [self.connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
    self.connectButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.connectButton.backgroundColor = [UIColor whiteColor];
    self.connectButton.alpha = 0;
    self.connectButton.center = CGPointMake(connectButtonX, buttonYPreAnimation);
    [self.connectButton addTarget:self action:@selector(connectMyo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.connectButton];
    
    self.aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    [self.aboutButton setTitle:@"ABOUT" forState:UIControlStateNormal];
    self.aboutButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.aboutButton.backgroundColor = [UIColor whiteColor];
    self.aboutButton.alpha = 0;
    self.aboutButton.center = CGPointMake(aboutButtonX, buttonYPreAnimation);
    [self.aboutButton addTarget:self action:@selector(userPressedAbout) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.aboutButton];
    
    
    [UIView animateWithDuration:1 animations:^{
        self.startButton.center = CGPointMake(startButtonX , buttonYPostAnimation);
        self.startButton.alpha = 1;
    }];
    
    [UIView animateWithDuration:1 delay:0.3
                        options:nil
                     animations:^{
                         self.connectButton.center = CGPointMake(connectButtonX, buttonYPostAnimation);
                         self.connectButton.alpha = 1;
                     }completion:nil];
    
    [UIView animateWithDuration:1 delay:0.6
                        options:nil
                     animations:^{
                         self.aboutButton.center = CGPointMake(aboutButtonX, buttonYPostAnimation);
                         self.aboutButton.alpha = 1;
                     }completion:nil];
}









- (void)addAboutPageElements
{
    self.aboutView = [[UITextView alloc] initWithFrame:CGRectMake(100 + self.view.frame.size.width, 100, self.view.frame.size.width - 200, self.view.frame.size.height - 200)];
    
    self.aboutView.backgroundColor = [UIColor clearColor];
    self.aboutView.text = @"  It's 4 AM and the PennApps hackathon is nearing its end, so what do you do? Do you sleep and get a good night's rest for the week ahead? Or do you pick up a motion sensor from the hardware stand and stay up another hour making something that's cool but probably has no purpose? I think the choice is obvious. \n \n I used the Myo motion sensor's rotation capabilities to control a player in Pong. The UI to set up the device is a simple as it can be, and it's a pretty cool last minute hack. If I ever get more time I'll see if there's a way to connect two Myo's at a time for multiplayer, though I doubt that's possible.";
    
    
    self.aboutView.textColor = [UIColor whiteColor];
    self.aboutView.font = [UIFont fontWithName:@"PressStart2P" size:15.0];
    [self.view addSubview:self.aboutView];
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    [self.doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font =  [UIFont fontWithName:@"PressStart2P" size:20.0];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.doneButton.backgroundColor = [UIColor whiteColor];
    self.doneButton.center = CGPointMake(3 * self.view.frame.size.width / 2, self.view.frame.size.height - 40);
    [self.doneButton addTarget:self action:@selector(userPressedDone) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.self.doneButton];
}










#pragma mark - User Interaction







- (void)userPressedDone
{
    [UIView animateWithDuration:1 delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.aboutButton.frame = CGRectMake(self.aboutButton.frame.origin.x + self.view.frame.size.width,
                                                             self.aboutButton.frame.origin.y,
                                                             self.aboutButton.frame.size.width,
                                                             self.aboutButton.frame.size.height);
                         
                         self.aboutView.frame = CGRectMake(self.aboutView.frame.origin.x + self.view.frame.size.width,
                                                           self.aboutView.frame.origin.y,
                                                           self.aboutView.frame.size.width,
                                                           self.aboutView.frame.size.height);
                         
                         self.doneButton.frame = CGRectMake(self.doneButton.frame.origin.x + self.view.frame.size.width,
                                                            self.doneButton.frame.origin.y,
                                                            self.doneButton.frame.size.width,
                                                            self.doneButton.frame.size.height);
                         
                         
                     }completion:nil];
    
    [UIView animateWithDuration:1 delay:0.3
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.startButton.frame = CGRectMake(self.startButton.frame.origin.x + self.view.frame.size.width,
                                                             self.startButton.frame.origin.y,
                                                             self.startButton.frame.size.width,
                                                             self.startButton.frame.size.height);
                         
                         self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.view.frame.size.width,
                                                            self.titleLabel.frame.origin.y,
                                                            self.titleLabel.frame.size.width,
                                                            self.titleLabel.frame.size.height);
                         
                     }completion:nil];
    
    [UIView animateWithDuration:1 delay:0.6
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.connectButton.frame = CGRectMake(self.connectButton.frame.origin.x + self.view.frame.size.width,
                                                               self.connectButton.frame.origin.y,
                                                               self.connectButton.frame.size.width,
                                                               self.connectButton.frame.size.height);
                     }completion:nil];

}








- (void)userPressedAbout
{
    [UIView animateWithDuration:1 delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.connectButton.frame = CGRectMake(self.connectButton.frame.origin.x - self.view.frame.size.width,
                                                               self.connectButton.frame.origin.y,
                                                               self.connectButton.frame.size.width,
                                                               self.connectButton.frame.size.height);
                     }completion:nil];
    
    [UIView animateWithDuration:1 delay:0.3
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.startButton.frame = CGRectMake(self.startButton.frame.origin.x - self.view.frame.size.width,
                                                             self.startButton.frame.origin.y,
                                                             self.startButton.frame.size.width,
                                                             self.startButton.frame.size.height);
                         
                         self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x - self.view.frame.size.width,
                                                            self.titleLabel.frame.origin.y,
                                                            self.titleLabel.frame.size.width,
                                                            self.titleLabel.frame.size.height);
                     }completion:nil];
    
    
    [UIView animateWithDuration:1 delay:0.6
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.aboutButton.frame = CGRectMake(self.aboutButton.frame.origin.x - self.view.frame.size.width,
                                                             self.aboutButton.frame.origin.y,
                                                             self.aboutButton.frame.size.width,
                                                             self.aboutButton.frame.size.height);
                         
                         self.aboutView.frame = CGRectMake(self.aboutView.frame.origin.x - self.view.frame.size.width,
                                                           self.aboutView.frame.origin.y,
                                                           self.aboutView.frame.size.width,
                                                           self.aboutView.frame.size.height);
                         
                         self.doneButton.frame = CGRectMake(self.doneButton.frame.origin.x - self.view.frame.size.width,
                                                            self.doneButton.frame.origin.y,
                                                            self.doneButton.frame.size.width,
                                                            self.doneButton.frame.size.height);
                         

                     }completion:nil];

    
}






- (void)pushToGame
{
    [self performSegueWithIdentifier:@"pushToGame" sender:nil];
}





- (void)connectMyo
{
    //Present the Myo setup table
    UINavigationController *controller = [TLMSettingsViewController settingsInNavigationController];
    [self presentViewController:controller animated:YES completion:nil];
}







#pragma mark - Animation Calls










- (void)addBall
{
    int ballLength = 10;
    
    //Determine the range of values that the origin x CGFloat can be
    int widthFactor = self.view.frame.size.width - ballLength;
    
    //Randomize this value in the width factor to get the coordinates
    int random = arc4random();
    int xCoord = random % widthFactor;
    int yCoord = -ballLength;
    
    //Create the frame, add it to the view, and add it to the array of falling balls
    UIView *square = [[UIView alloc] initWithFrame:CGRectMake(xCoord, yCoord, ballLength, ballLength)];
    square.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:square];
    [self.fallingBalls addObject:square];
}








- (void)moveBalls
{
    //Iterate through every ball that's on the screen
    for (UIView *square in self.fallingBalls)
    {
        //If the ball has fallen below, remove it from the superview
        if (square.frame.origin.y >= self.view.frame.size.height)
        {
            //[self.fallingBalls removeObject:square];
            [square removeFromSuperview];
        }
        //Otherwise, just drop the ball one pt
        else
        {
            square.frame = CGRectMake(square.frame.origin.x,
                                      square.frame.origin.y + 1,
                                      square.frame.size.width,
                                      square.frame.size.height);
        }
        
    }
}




@end
