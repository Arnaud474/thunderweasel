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
@property NSMutableArray *team1;
@property NSMutableArray *team2;
- (IBAction)startGame:(id)sender;
- (IBAction)stepperPeriod:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstTeamTitle;
@property (weak, nonatomic) IBOutlet UITextField *secondTeamTitle;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@", selectedCell.field);
    
}

//Start game
- (IBAction)startGame:(id)sender {
    NSLog(@"Start Game");

    //Init arrays
    _team1 = [[NSMutableArray alloc] init];
    _team2 = [[NSMutableArray alloc] init];
    
    for(NSInteger i=0;i<5;i++){
        
        //Getting the cell at index
        CustomCell *cell1 = [_firstTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        CustomCell *cell2 = [_secondTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        
        //Validation
        if (!_firstTeamTitle.text.length || !_secondTeamTitle.text.length){
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Information manquante"
                                        message:@"Veuillez entrer les noms d'équipe pour commencer la partie"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* errorValidationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
            
            [alert addAction:errorValidationAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;

        }
        else if (_firstTeamTitle.text == _secondTeamTitle.text){
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Information erronée"
                                        message:@"Veuillez entrer des noms d'équipe différents"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* errorValidationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
            
            [alert addAction:errorValidationAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        else if (!cell1.field.length || !cell2.field.length){
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Information manquante"
                                        message:@"Veuillez entrer tous les noms des joueurs pour commencer la partie"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* errorValidationAction = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {}];
            
            [alert addAction:errorValidationAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        else if ([_team1 containsObject:cell1.field] || [_team2 containsObject:cell2.field]){
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Information erronée"
                                        message:@"Veuillez entrer des noms de joueurs différents au sein d'une même équipe"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* errorValidationAction = [UIAlertAction actionWithTitle:@"OK"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
            
            [alert addAction:errorValidationAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
            
        }
        
        //Adding fields to array
        [_team1 addObject:cell1.field];
        [_team2 addObject:cell2.field];
        
        //So we can select the row without editing when the game is started
        [cell1.textField setUserInteractionEnabled:NO];
        [cell2.textField setUserInteractionEnabled:NO];
        
        
        NSLog(@"Team 1 Player : %@", [_team1 objectAtIndex:i]);
        NSLog(@"Team 2 Player : %@", [_team2 objectAtIndex:i]);
    }
                 
    _stepperPeriod.hidden = NO;
    
    
}

//Update period method
- (IBAction)stepperPeriod:(UIStepper *)sender {
    NSInteger value = sender.value;
    NSLog(@"%ld", value);
    _period.text = [NSString stringWithFormat:@"%ld",value];
    
}
@end
