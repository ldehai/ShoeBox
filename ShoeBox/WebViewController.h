//
//  WebViewController.h
//  Baker
//
//  Created by andy on 12/1/13.
//
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    NSString *url;
    BOOL bShowImage;
    UIImageView *imageView;
}
@property (retain, nonatomic) IBOutlet UIWebView *myweb;

- (id)initWithUrl:(NSString*)strUrl;
- (id)initWithImage:(NSString*)strImagePath;
@end
