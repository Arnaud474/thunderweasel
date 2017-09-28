//
//  ViewController.m
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-22.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "AssistController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *firstTeamTable;
@property (weak, nonatomic) IBOutlet UITableView *secondTeamTable;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UIStepper *stepperPeriod;
@property NSMutableArray *team1;
@property NSMutableArray *team2;
@property NSMutableArray *selectedTeam;
- (IBAction)startGame:(id)sender;
- (IBAction)stepperPeriod:(UIStepper *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _stepperPeriod.hidden = YES;
    
    _firstTeamTable.allowsSelection = NO;
    _secondTeamTable.allowsSelection = NO;
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
        
        _firstTeamTable.allowsSelection = YES;
        _secondTeamTable.allowsSelection = YES;
        
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(tableView == _firstTeamTable){
        _selectedTeam = [[NSMutableArray alloc] initWithArray:_team1];
    }
    else if(tableView == _secondTeamTable){
       _selectedTeam = [[NSMutableArray alloc] initWithArray:_team2];
    }
    
    CustomCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@", selectedCell.field);
    
    //Setup the array so we don't have the name of the player that scored the goal
    [_selectedTeam removeObjectAtIndex:indexPath.row];
    
    NSLog(@"%lu", _selectedTeam.count);
    
    //I don't know, you tell me
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"go" sender:selectedCell];
    });

    
}

//Start game
- (IBAction)startGame:(id)sender {
    NSLog(@"Start Game");
    
    _stepperPeriod.hidden = NO;
    
    //Init arrays
    _team1 = [[NSMutableArray alloc] init];
    _team2 = [[NSMutableArray alloc] init];
    
    for(NSInteger i=0;i<5;i++){
        
        //Getting the cell at index
        CustomCell *cell1 = [_firstTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        CustomCell *cell2 = [_secondTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        
        //Adding fields to array
        [_team1 addObject:cell1.field];
        [_team2 addObject:cell2.field];
        
        //So we can select the row without editing when the game is started
        [cell1.textField setUserInteractionEnabled:NO];
        [cell2.textField setUserInteractionEnabled:NO];
        
        NSLog(@"Team 1 Player : %@", [_team1 objectAtIndex:i]);
        NSLog(@"Team 2 Player : %@", [_team2 objectAtIndex:i]);
        
    }
    
}


- (IBAction)unwindToApp:(UIStoryboardSegue*)sender{
    [sender.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

//Update period method
- (IBAction)stepperPeriod:(UIStepper *)sender {
    NSInteger value = sender.value;
    NSLog(@"%ld", value);
    _period.text = [NSString stringWithFormat:@"%ld",value];
    
}

//For sending data to assist view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"go"]) {
        
        // Get destination view
        AssistController *vc = [segue destinationViewController];
        
        //Update assist table inside view
        [vc updateAssistTable:_selectedTeam];
        
        
        
    }
}

@end
