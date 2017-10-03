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

-(void)updateAssistTable:(NSMutableArray *)newContent{
    
    NSLog(@"updateTable");
    
    _players = newContent;
    
    
    
    [_assistTable reloadData];
}

@end
