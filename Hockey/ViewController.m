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
@property NSMutableArray *firstName1;
@property NSMutableArray *firstName2;
@property NSMutableArray *number1;
@property NSMutableArray *number2;
@property NSMutableArray *selectedTeam;
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
    
    NSLog(@"%@", selectedCell.familyName);
    
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

    //Init arrays
    _team1 = [[NSMutableArray alloc] init];
    _team2 = [[NSMutableArray alloc] init];
    _firstName1 = [[NSMutableArray alloc] init];
    _firstName2 = [[NSMutableArray alloc] init];
    _number1 = [[NSMutableArray alloc] init];
    _number2 = [[NSMutableArray alloc] init];
    
    for(NSInteger i=0;i<5;i++){
        
        //Getting the cell at index
        CustomCell *cell1 = [_firstTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        CustomCell *cell2 = [_secondTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        
        bool missingInfo = NO;
        NSString *message = @"Pour commencer la partie, entrez :";
        
        //Validation
        if (!_firstTeamTitle.text.length || !_secondTeamTitle.text.length){
            NSLog(@"patate");
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- les noms d'équipe"];
        
        }
        else if (_firstTeamTitle.text == _secondTeamTitle.text){
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- des noms d'équipe différents"];
        }
        
        if (!cell1.firstName.length || !cell2.firstName.length){
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- le prénom de tous les joueurs"];
        }
        
        if (!cell1.familyName.length || !cell2.familyName.length){
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- le nom de famille de tous les joueurs"];
        }
        
        if (!cell1.number.length || !cell2.number.length || ![cell1.number intValue] || ![cell2.number intValue]){
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- le numéro de tous les joueurs"];
        }
        
        if ([_number1 containsObject: cell1.number] || [_number2 containsObject:cell2.number]){
            NSLog(@"%@", cell1.number);
            missingInfo = YES;
            message = [message stringByAppendingString:@"\r- des numéros différents au sein d'une même équipe"];
        }
        
        if (missingInfo == YES){
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Information manquante"
                                        message:message
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* errorValidationAction = [UIAlertAction actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];

            [alert addAction:errorValidationAction];
            [self presentViewController:alert animated:YES completion:nil];
             return;

        }
        
        //Adding fields to array
        [_team1 addObject:cell1.familyName];
        [_team2 addObject:cell2.familyName];
        [_firstName1 addObject:cell1.firstName];
        [_firstName2 addObject:cell2.firstName];
        [_number1 addObject:cell1.number];
        [_number2 addObject:cell2.number];

    }
    
    
    for(NSInteger i=0;i<5;i++){
        
        //Getting the cell at index
        CustomCell *cell1 = [_firstTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        CustomCell *cell2 = [_secondTeamTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
        
        //So we can select the row without editing when the game is started
        [cell1.textPrenom setUserInteractionEnabled:NO];
        [cell1.textNom setUserInteractionEnabled:NO];
        [cell1.textNumero setUserInteractionEnabled:NO];
        [cell2.textPrenom setUserInteractionEnabled:NO];
        [cell2.textNom setUserInteractionEnabled:NO];
        [cell2.textNumero setUserInteractionEnabled:NO];
        
        NSLog(@"Team 1 Player : %@", [_team1 objectAtIndex:i]);
        NSLog(@"Team 2 Player : %@", [_team2 objectAtIndex:i]);
        
    }
    
    _stepperPeriod.hidden = NO;
    
    UIAlertController* alertStart = [UIAlertController
                                alertControllerWithTitle:@"DÉBUT DE LA PARTIE"
                                message:@"Cliquer sur le joueur marquant pour ajouter un but"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
    
    [alertStart addAction:okAction];
    [self presentViewController:alertStart animated:YES completion:nil];

    
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
