//
//  NoticiasDetalhesViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 06/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "NoticiasDetalhesViewController.h"

@interface NoticiasDetalhesViewController ()
{
    Noticia *noticia;
}

@end

@implementation NoticiasDetalhesViewController

- (void)viewWillAppear:(BOOL)animated
{
}

- (id)initWithNoticia:(Noticia *)_noticia
{
    noticia = _noticia;
    
    self = [super initWithNibName:@"NoticiasDetalhesViewController" bundle:[NSBundle mainBundle]];
    [self setTitle:@"Notícias"];
    [self.view setBackgroundColor:[UIColor blackColor]];

    //[self.navigationItem.backBarButtonItem setTitle:@"Voltar"];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
