//
//  IMPopoverController.m
//  IMPopoverController
//
//  Created by yoyokko on 10-8-28.
//  Copyright 2010 yoyokko@gmail.com. All rights reserved.
//

#import "IMPopoverController.h"

@implementation IMWindow

@synthesize delegate = delegate_;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.delegate touchesEnded:touches withEvent:event];
}

@end


@interface IMPopoverController (Private)

@property (nonatomic, retain) IMWindow *popOverWindow;

@end


@implementation IMPopoverController

@synthesize popOverSize = popOverSize_;
@synthesize bAnimate;

- (UIWindow *) popOverWindow
{
	return popOverWindow_;
}

- (void) setPopOverWindow:(UIWindow *) newValue
{
	if (popOverWindow_ != newValue)
	{
		popOverWindow_ = (IMWindow*)newValue;
	}
}

- (id) initWithContentViewController:(UIViewController *) con
{
	if (self = [super init]) {
		CGRect screenBounds = [[UIScreen mainScreen] bounds];

		self.popOverWindow = [[IMWindow alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height)];
		self.popOverWindow.windowLevel = UIWindowLevelAlert;
		self.popOverWindow.backgroundColor = [UIColor clearColor];
		self.popOverWindow.hidden = YES;
		self.popOverWindow.delegate = self;
		
		[self setContentViewController:con animated:NO];
	}
    
	return self;
}

- (UIViewController *) contentViewController
{
	return contentViewController_;
}

- (void) setContentViewController:(UIViewController *) newCon animated:(BOOL) animated
{
	if (contentViewController_ != newCon) {
		contentViewController_ = newCon;
	}
}

- (void) presentPopoverFromRect:(CGRect) rect inView:(UIView *) inView animated:(BOOL) animated
//- (void) presentPopoverFromRect:(CGRect) rect animated:(BOOL) animated
{
//	UIWindow *mainWin = [[[UIApplication sharedApplication] delegate] window];
	CGRect newFrame = rect;//[mainWin convertRect:rect fromWindow:mainWin];
	[[self contentViewController].view setFrame:CGRectMake(newFrame.origin.x, newFrame.origin.y, self.popOverSize.width, self.popOverSize.height)];
	[self.popOverWindow addSubview:[self contentViewController].view];
	self.popOverWindow.hidden = NO;
    
//    self.popOverWindow.backgroundColor = [UIColor clearColor];
	[self.popOverWindow makeKeyWindow];
}

- (void) dismissPopoverAnimated:(BOOL) animated
{
	//[self.popOverWindow resignKeyWindow];
	//self.popOverWindow.hidden = YES;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                        // chartview.view.alpha = 0.0;
                         if (bAnimate) {
                            [self.popOverWindow setFrame:CGRectMake(-500, 0, 300, 400)];
                         }
                         else
                            self.popOverWindow.hidden = YES;
                     }];

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *end = [[event allTouches] anyObject];
    CGPoint EndPoint = [end locationInView:[self contentViewController].view];
   
    if (EndPoint.x < 0 || EndPoint.x > self.contentViewController.view.frame.size.width ||
        EndPoint.y < 0 || EndPoint.y > self.contentViewController.view.frame.size.height)
    {         
        [self dismissPopoverAnimated:YES];

    }
  //  NSLog(@"end ponts x : %f y : %f", EndPoint.x, EndPoint.y);
    
	
}

- (void) dealloc
{
    self.contentViewController;
	self.popOverWindow = nil;
}

@end
