//
//  IssueViewController.h
//  Baker
//
//  ==========================================================================================
//
//  Copyright (c) 2010-2013, Davide Casali, Marco Colombo, Alessandro Morandi
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this list of
//  conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of
//  conditions and the following disclaimer in the documentation and/or other materials
//  provided with the distribution.
//  Neither the name of the Baker Framework nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written
//  permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <UIKit/UIKit.h>
#import "ShoeInfo.h"
@interface IssueViewController : UIViewController {
    ShoeInfo *shoeInfo;
}

@property (strong, nonatomic) UIButton *actionButton;
@property (strong, nonatomic) UIButton *archiveButton;
@property (strong, nonatomic) UILabel *loadingLabel;
@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIButton *issueCover;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *infoFont;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *infoLabel;

@property (copy, nonatomic) NSString *currentStatus;

@property (assign, nonatomic) BOOL bSelected;
@property (strong, nonatomic) UIImageView* bigImage;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIButton *favBtn;


#pragma mark - Structs
typedef struct {
    int cellPadding;
    float thumbWidth;
    float thumbHeight;
    int contentOffset;
} UI;

- (id)initWithShoe:(ShoeInfo*)shoe;
#pragma mark - Issue management
- (void)actionButtonPressed:(UIButton *)sender;
- (void)setFavorite;
- (void)updateTags:(NSString*)tags;
#pragma mark - Helper methods
+ (UI)getIssueContentMeasures;
+ (int)getIssueCellHeight;
+ (CGSize)getIssueCellSize;
+ (void)setStatus:(int)status;
+ (int)selectedCount;
+ (void)clearSelectCount;
@end

#ifdef BAKER_NEWSSTAND
@interface alertView: UIAlertView <UIActionSheetDelegate> {

}
@end
#endif
