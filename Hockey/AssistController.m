//
//  AssistController.m
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-28.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import "AssistController.h"

@interface AssistController ()
@property (weak, nonatomic) IBOutlet UITableView *assistTable;

@end

@implementation AssistController
@synthesize players = _players;
int counter = 0; //keep track of how many rows are selected
int maxNum = 2; //Most cells allowed to be selected
BOOL selectionArray[] = { NO, NO, NO, NO, NO}; //Array used to know which player is selected
int hiddenPlayerId = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Should display");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [[_players objectAtIndex:indexPath.row] capitalizedString];
    return cell;
}

//Called when the user selects a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //If the cell isn't checked and there aren't the maximum allowed selected yet
    if (cell.accessoryType != UITableViewCellAccessoryCheckmark)
    {
        //Don't do anything if the cell isn't checked and the maximum has been reached
        if (counter < maxNum)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            counter++;
            selectionArray[indexPath.row] = YES;
        }
        return;
    }
    //If cell is checked and gets selected again, deselect it
    else if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        counter--;
        selectionArray[indexPath.row] = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float heightForRow = tableView.rowHeight;
    
    if(indexPath.row==hiddenPlayerId)
        return 0;
    else
        return heightForRow;
}

-(BOOL*)getAssist {
    return selectionArray;
}

-(void)updateAssistTable:(NSMutableArray *)newContent :(int)hiddenPlayer{
    
    NSLog(@"updateTable");
    _players = newContent;
    counter = 0;
    _assistTable.allowsMultipleSelection = YES;
    for(int i=0; i < 5 ; i++)
        selectionArray[i] = NO;
    hiddenPlayerId = hiddenPlayer;
}

//called when the OK button is pressed
- (IBAction)okPress:(id)sender {
    NSLog(@"Ok");
    
    //Send the segue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"goal" sender:self];
    });
    
}

@end
