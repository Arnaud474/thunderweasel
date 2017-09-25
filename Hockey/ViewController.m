//
//  ViewController.m
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-22.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *firstTeamTable;
@property (weak, nonatomic) IBOutlet UITableView *secondTeamTable;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UIStepper *stepperPeriod;
- (IBAction)startGame:(id)sender;
- (IBAction)stepperPeriod:(UIStepper *)sender;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _stepperPeriod.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //Hardcoded because thats the way it is for this project
    return NUM_PLAYERS;
}

//Load table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString *tableId = @"TableID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableId];
    
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        if (tableView == _firstTeamTable){
            //Alternate colors
            if( [indexPath row] % 2){
                cell.backgroundColor=[UIColor whiteColor];
            }
            else{
                cell.backgroundColor=[UIColor redColor];
            }
        }
        else if (tableView == _secondTeamTable){
            //Alternate colors
            if( [indexPath row] % 2){
                cell.backgroundColor=[UIColor whiteColor];
            }
            else{
                cell.backgroundColor=[UIColor blueColor];
            }
        }
        
        
    }
    
    
    return cell;
    
}


//Update period method
- (IBAction)startGame:(id)sender {
    NSLog(@"Start Game");
    
    _stepperPeriod.hidden = NO;
    
    for(NSInteger i=0;i<5;i++){
        CustomCell *cell = [_firstTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        
    }
    
}

- (IBAction)stepperPeriod:(UIStepper *)sender {
    NSInteger value = sender.value;
    NSLog(@"%ld", value);
    _period.text = [NSString stringWithFormat:@"%ld",value];
    
}
@end
