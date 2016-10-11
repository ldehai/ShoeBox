//
//  IMPopoverController.h
//  IMPopoverController
//
//  Created by yoyokko on 10-8-28.
//  Copyright 2010 yoyokko@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMWindow : UIWindow
{
	id __unsafe_unretained delegate_;
}

@property (nonatomic, unsafe_unretained) id delegate;

@end


@interface IMPopoverController : NSObject {
	UIViewController	*contentViewController_;
	IMWindow	*popOverWindow_;
	CGSize	popOverSize_;
}

@property (nonatomic) CGSize popOverSize;
@property (nonatomic) BOOL bAnimate;

- (id) initWithContentViewController:(UIViewController *) con;
- (UIViewController *) contentViewController;
- (void) setContentViewController:(UIViewController *) newCon animated:(BOOL) animated;

- (void) presentPopoverFromRect:(CGRect) rect inView:(UIView *) inView animated:(BOOL) animated;
//- (void) presentPopoverFromRect:(CGRect) rect animated:(BOOL) animated;
- (void) dismissPopoverAnimated:(BOOL) animated;

@end
