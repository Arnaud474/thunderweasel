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
@property (weak, nonatomic) IBOutlet UILabel *counterTeam1;
@property (weak, nonatomic) IBOutlet UILabel *counterTeam2;
@property (weak, nonatomic) IBOutlet UIStepper *stepperPeriod;
@property NSMutableArray *team1;
@property NSMutableArray *team2;
@property NSMutableArray *firstName1;
@property NSMutableArray *firstName2;
@property NSMutableArray *number1;
@property NSMutableArray *number2;
@property NSMutableArray *selectedTeam;
@property NSMutableArray * gameLog;
- (IBAction)startGame:(id)sender;
- (IBAction)stepperPeriod:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstTeamTitle;
@property (weak, nonatomic) IBOutlet UITextField *secondTeamTitle;
@end

@implementation ViewController

int selectedPlayer = -1;
int selectedTable = -1;
int team1Goals = 0;
int team2Goals = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _stepperPeriod.hidden = YES;
    
    _firstTeamTable.allowsSelection = NO;
    _secondTeamTable.allowsSelection = NO;
    
    _gameLog = [[NSMutableArray alloc] init];
    
    // Add arrays of zeros to each arrays in each team
    
    NSMutableArray *team;
    NSMutableArray *player;
    
    for(int i = 0; i < 2; i++){
        
        team = [[NSMutableArray alloc] init];

        for(int j = 0; j < 5; j++){
        
            NSMutableArray *player = [[NSMutableArray alloc] init];
            
            [player addObject: [NSNumber numberWithInt:0]];
            [player addObject: [NSNumber numberWithInt:0]];
            
            [team addObject:player];
        
        }
        
        [_gameLog addObject: [NSMutableArray arrayWithArray:team]];
    }
    
    
    //[self printGameLog];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printGameLog{
    
    NSLog(@"Game Log");
    
    for(NSMutableArray* team in _gameLog){
        
        NSLog(@"%lu", [team count]);
    
        for(NSMutableArray* player in team){
            
            NSLog(@"Goals : %d", [[player objectAtIndex:0] intValue]);
            NSLog(@"Assists : %d", [[player objectAtIndex:1] intValue]);
        }
        
        
    }
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
        selectedTable = 0;
    }
    else if(tableView == _secondTeamTable){
       _selectedTeam = [[NSMutableArray alloc] initWithArray:_team2];
        selectedTable = 1;
    }
    
    
    CustomCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@", selectedCell.familyName);
    
    selectedPlayer = (int)indexPath.row;
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
        /*if (!_firstTeamTitle.text.length || !_secondTeamTitle.text.length){
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

        }*/
        
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

- (IBAction)registerGoal:(UIStoryboardSegue*)sender{
    
    BOOL* selected = [((AssistController *)sender.sourceViewController) getAssist];
    
    UITableView * currentTable;
    
    //Get table view
    if(selectedTable == 0){
        currentTable = _firstTeamTable;
        team1Goals++;
        _counterTeam1.text = [NSString stringWithFormat:@"%d", team1Goals];;
    }
    else if (selectedTable == 1){
        currentTable = _secondTeamTable;
        team2Goals++;
        _counterTeam2.text = [NSString stringWithFormat:@"%d", team2Goals];
        
    }
    
    CustomCell *goalDude = [currentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPlayer inSection: 0]];
    
    
    NSNumber *g = [NSNumber numberWithInt:[[[[_gameLog objectAtIndex:selectedTable] objectAtIndex:selectedPlayer] objectAtIndex:0] intValue] + 1];
    
    [[[_gameLog objectAtIndex:selectedTable] objectAtIndex:selectedPlayer] replaceObjectAtIndex:0 withObject:g];
    
    NSLog(@" Goal by %@ %@", goalDude.firstName, goalDude.familyName);
    
    for(int i = 0; i < 5; i++){
        
        //If the index was selected
        if(selected[i]){
            
           CustomCell *cell = [currentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection: 0]];
            
           NSLog(@"Assisted by %@ %@", cell.firstName, cell.familyName);
           
            NSNumber *a = [NSNumber numberWithInt:[[[[_gameLog objectAtIndex:selectedTable] objectAtIndex:i] objectAtIndex:1] intValue] + 1];
            
            [[[_gameLog objectAtIndex:selectedTable] objectAtIndex:i] replaceObjectAtIndex:1 withObject:a];
            
        }
        
    }
    
    [self printGameLog];
    
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
        [vc updateAssistTable:_selectedTeam :selectedPlayer];
    }
    
}

@end
