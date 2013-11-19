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
    UIImage *imagem;
}

@end

@implementation NoticiasDetalhesViewController

- (id)initWithNoticia:(Noticia *)_noticia eImagem:(UIImage *)_imagem
{
    noticia = _noticia;
    imagem = _imagem;
    
    self = [super initWithNibName:@"NoticiasDetalhesViewController" bundle:[NSBundle mainBundle]];
    [self setTitle:@"Notícias"];
    [self.view setBackgroundColor:[UIColor blackColor]];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat pos;
    
    CGRect dimensoes = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:dimensoes];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [self.view addSubview:scrollView];
    
    UILabel *titulo = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 0)];
    [titulo setBackgroundColor:[UIColor clearColor]];
    [titulo setTextAlignment:NSTextAlignmentLeft];
    [titulo setTextColor:[UIColor whiteColor]];
    [titulo setFont:[UIFont boldSystemFontOfSize:16]];
    [titulo setNumberOfLines:3];
    [titulo setText:[noticia titulo]];
    [titulo sizeToFit];
    [scrollView addSubview:titulo];
    pos = 5 + titulo.frame.size.height + 15;
    
    if (![[noticia imagem] isEqual:@""])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, pos, 300, 220)];
        [imgView setImage:imagem];
        [scrollView addSubview:imgView];
        pos += imgView.frame.size.height+15;
    }

    UILabel *texto = [[UILabel alloc] initWithFrame:CGRectMake(10, pos, 300, 500)];
    [texto setBackgroundColor:[UIColor clearColor]];
    [texto setTextAlignment:NSTextAlignmentLeft];
    [texto setTextColor:[UIColor whiteColor]];
    [texto setFont:[UIFont systemFontOfSize:14]];
    [texto setNumberOfLines:0];
    [texto setText:[noticia texto]];
    [texto sizeToFit];
    [scrollView addSubview:texto];
    pos += texto.frame.size.height;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        pos += 120;
    } else {
        pos += 200;
    }
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, pos)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
