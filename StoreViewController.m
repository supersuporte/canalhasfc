//
//  StoreViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "StoreViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize navigationBar;
@synthesize imagem;
@synthesize produto;
@synthesize descricao;
@synthesize preco;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tabBarItem = [self tabBarItem];
        [tabBarItem setTitle:@"Store"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *titulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                            UITextAttributeTextColor,
                            [UIColor clearColor],
                            UITextAttributeTextShadowColor, nil];

    [self.navigationBar setTitleTextAttributes:titulo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
