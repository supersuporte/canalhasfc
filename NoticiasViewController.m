//
//  NoticiasViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "NoticiasViewController.h"

@interface NoticiasViewController ()

@end

@implementation NoticiasViewController

@synthesize noticiasTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Notícias"];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSDictionary *noticiasNCTitulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                                      UITextAttributeTextColor,
                                      [UIColor clearColor],
                                      UITextAttributeTextShadowColor, nil];

    [self.navigationController.navigationBar setTitleTextAttributes:noticiasNCTitulo];
    [self montaResultado];
}

- (void)montaResultado
{
    noticiasTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 457)];
    [noticiasTableView setAllowsSelection:YES];
    [noticiasTableView setBackgroundColor:[UIColor blackColor]];
    [noticiasTableView setOpaque:YES];
    [noticiasTableView setBackgroundView:nil];
    [noticiasTableView setRowHeight:92];
    [noticiasTableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [noticiasTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [noticiasTableView setSeparatorColor:[UIColor darkGrayColor]];
    
    [noticiasTableView setDataSource:self];
    [noticiasTableView setDelegate:self];
    
    [self.view addSubview:noticiasTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
        UILabel *imagem = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 110, 78)];
        [imagem setTag:1];
        [imagem setBackgroundColor:[UIColor grayColor]];
        [imagem setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:imagem];

        UILabel *texto = [[UILabel alloc] initWithFrame:CGRectMake(122, 6, 190, 78)];
        [texto setTag:2];
        [texto setBackgroundColor:[UIColor clearColor]];
        [texto setTextAlignment:UITextAlignmentLeft];
        [texto setTextColor:[UIColor whiteColor]];
        [texto setFont:[UIFont systemFontOfSize:14]];
        [texto setNumberOfLines:4];
        [cell.contentView addSubview:texto];
	}
    
    UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];

    UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
    [lbl2 setText:[NSString stringWithFormat:@"%@", @"01/09/2013 - Churrasco no Canalhas Arena próxima quinta."]];
    [lbl2 sizeToFit];

	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
