//
//  OutputTableViewCell.m
//  PiFaceLightSwitch
//
//  Created by Rees, Nathan on 9/6/15.
//  Copyright (c) 2015 Simply Automationized. All rights reserved.
//

#import "OutputTableViewCell.h"
@interface OutputTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *outputLabel;
@property (strong, nonatomic) IBOutlet UIButton *cmdButton;

@end
@implementation OutputTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)buttonPressed:(id)sender {
    if(self.cmd)
        self.cmd(self.output);
}
-(void)setOutputStatus:(BOOL)status{
    if(status){
        self.cmdButton.backgroundColor = [UIColor yellowColor];
        [self.cmdButton setTitle:@"ON" forState:UIControlStateNormal];
    }
    else{
        self.cmdButton.backgroundColor = [UIColor grayColor];
        [self.cmdButton setTitle:@"OFF" forState:UIControlStateNormal];
    }
}
-(void)setLabelText:(NSString*)text{
    self.outputLabel.text = text;
}
-(void)prepareForReuse{
    self.outputLabel.text = nil;
    self.cmd = nil;
}
@end
