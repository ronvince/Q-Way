//
//  infoViewController.h
//  IndoorNavigationApp
//
//  Created by user on 7/10/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "Places.h"

@interface infoViewController : UIViewController
@property (nonatomic, assign) UIPopoverArrowDirection arrowDirection;

/// The view containing the anchor rectangle for the popover.
@property (nonatomic, weak) UIView *sourceView;

/// The rectangle in the specified view in which to anchor the popover.
@property (nonatomic, assign) CGRect sourceRect;

/// The preferred size for the popover’s view.
@property (nonatomic, assign) CGSize contentSize;

/// The color of the popover’s backdrop view.
@property (nonatomic, strong) UIColor *backgroundColor;

/// An array of views that the user can interact with while the popover is visible.
@property (nonatomic, strong) NSArray *passthroughViews;

///The margins that define the portion of the screen in which it is permissible to display the popover.
@property (nonatomic, assign) UIEdgeInsets popoverLayoutMargins;
// to display details of employee
@property (strong, nonatomic) Employee* employe;

@property (strong, nonatomic) Places* place;
@property (nonatomic)  NSInteger *if_emp_place;

@end
