//
//  PongBoardView.m
//  Myo Pong
//
//  Created by Amolak Nagi on 9/5/15.
//  Copyright (c) 2015 Amolak Nagi. All rights reserved.
//

#import "PongBoardView.h"
#import "MyoPongConstants.h"

@implementation PongBoardView



- (void)drawRect:(CGRect)rect
{
    [self initializeBounds];
    
    [self initializeMidline];
}










- (void)initializeBounds
{
    CGFloat upperX = 0;
    CGFloat upperY = 0;
    CGFloat upperWidth = self.frame.size.width;
    CGFloat upperHeight = platformThickness;
    CGRect upperFrame = CGRectMake(upperX, upperY, upperWidth, upperHeight);
    
    UIView *upperBound = [[UIView alloc] initWithFrame:upperFrame];
    upperBound.backgroundColor = [UIColor whiteColor];
    [self addSubview:upperBound];
    
    
    CGFloat lowerX = 0;
    CGFloat lowerY = self.frame.size.height - platformThickness;
    CGFloat lowerWidth = self.frame.size.width;
    CGFloat lowerHeight = platformThickness;
    CGRect lowerFrame = CGRectMake(lowerX, lowerY, lowerWidth, lowerHeight);
    
    UIView *lowerBound = [[UIView alloc] initWithFrame:lowerFrame];
    lowerBound.backgroundColor = [UIColor whiteColor];
    [self addSubview:lowerBound];
}











- (void)initializeMidline
{
    CGFloat x = (self.frame.size.width / 2) - (platformThickness / 2);
    CGFloat y = 0;
    
    while (y < self.frame.size.height)
    {
        CGFloat lineX = x;
        CGFloat lineY = y;
        CGFloat lineWidth = platformThickness;
        CGFloat lineHeight = midlineSpacing;
        CGRect lineFrame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
        
        UIView *midlineLine = [[UIView alloc] initWithFrame:lineFrame];
        midlineLine.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:midlineLine];
        
        y += (2 * midlineSpacing);
    }
}
@end
