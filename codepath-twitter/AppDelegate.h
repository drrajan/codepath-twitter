//
//  AppDelegate.h
//  codepath-twitter
//
//  Created by David Rajan on 2/17/15.
//  Copyright (c) 2015 David Rajan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@property (strong, nonatomic) UIWindow *window;


@end

