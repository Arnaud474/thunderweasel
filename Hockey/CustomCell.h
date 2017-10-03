//
//  CustomCell.h
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-22.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
- (IBAction)changeFirstName:(UITextField *)sender;
- (IBAction)changeFamilyName:(UITextField *)sender;
- (IBAction)changeNumber:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *goal;
@property NSString *familyName;
@property NSString *firstName;
@property NSString *number;

@property (weak, nonatomic) IBOutlet UITextField *textPrenom;

@property (weak, nonatomic) IBOutlet UITextField *textNom;
@property (weak, nonatomic) IBOutlet UITextField *textNumero;

@end

