//
//  CustomCell.h
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-22.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
- (IBAction)changeText:(UITextField *)sender;
@property NSString *field;

@end

