//
//  AssistController.h
//  Hockey
//
//  Created by Girardin, Arnaud on 17-09-28.
//  Copyright © 2017 Girardin, Arnaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistController : UIViewController <UITableViewDelegate, UITableViewDataSource>
-(void) updateAssistTable:(NSMutableArray*)newContent :(int)hiddenPlayer;
-(BOOL*)getAssist;
@property NSMutableArray *players;
@end
