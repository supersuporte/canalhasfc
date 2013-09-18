//
//  NoticiasViewController.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface NoticiasViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *noticiasTableView;

@end
