//
//  CustomCell.m
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-22.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize firstName = _firstName;
@synthesize familyName = _familyName;
@synthesize number = _number;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _firstName = @"";
    _familyName = @"";
    _number = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeFirstName:(UITextField *)sender {
    _firstName = sender.text;
}

- (IBAction)changeFamilyName:(UITextField *)sender {
    _familyName = sender.text;
}

- (IBAction)changeNumber:(UITextField *)sender {
    _number = sender.text;
}
@end
