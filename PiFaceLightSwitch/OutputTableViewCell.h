//
//  OutputTableViewCell.h
//  PiFaceLightSwitch
//
//  Created by Rees, Nathan on 9/6/15.
//  Copyright (c) 2015 Simply Automationized. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutputTableViewCell : UITableViewCell
-(void)setOutputStatus:(BOOL)status;
-(void)setLabelText:(NSString*)text;
@property (nonatomic,copy) void(^cmd)(int output);
@property int output;
@end
