//
//  StoreViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "StoreViewController.h"
#import "Produto.h"
#import "ProdutoUtils.h"
#import "Conexao.h"

@interface StoreViewController ()
{
    NSMutableArray *produtos;
    int produtoAtual;
   
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation StoreViewController

@synthesize navigationBar;
@synthesize view01;
@synthesize view02;
@synthesize setaEsquerda;
@synthesize setaDireita;

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
    
    UIBarButtonItem *voltar = [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(voltar)];
    self.navigationItem.backBarButtonItem = voltar;
    
    UIImage *titulo = [UIImage imageNamed:@"titleStore"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titulo];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    NSDictionary *storeNCTitulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                                      UITextAttributeTextColor,
                                      [UIColor clearColor],
                                      UITextAttributeTextShadowColor, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:storeNCTitulo];

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(140.0, 180.0, 40.0, 40.0);
    
    [self.view addSubview:activityIndicator];
    [activityIndicator stopAnimating];
    
    [self pesquisaWebServices];
}

- (void)pesquisaWebServices
{
    [activityIndicator startAnimating];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [[Conexao alloc] webServices], @"store.json"];
    
    [self consomeWebServices:url];
}

- (void)consomeWebServices:(NSString *)url
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    jsonData = [[NSMutableData alloc] init];
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *req = [NSURLRequest requestWithURL:nsurl];
    
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)dados
{
    [jsonData appendData:dados];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
    
    if (!error)
    {
        produtos = [ProdutoUtils produtosComDicionario:jsonDictionary];
        [self montaResultado];
    }
    
    jsonData = nil;
    connection = nil;
    
    [activityIndicator stopAnimating];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
    
    connection = nil;
    jsonData = nil;
    
    NSString *errorString = [NSString stringWithFormat:@"Erro de conexão: %@", [error localizedDescription]];
    
    Conexao *conexao = [Conexao alloc];
    if ([conexao conexaoComInternet] && [conexao conexaoComWebServices])
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"Não foi possível se conectar ao servidor"
                                                      message:errorString
                                                     delegate:nil
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:nil];
        [av show];
    }
}

- (void)montaResultado
{
    [self setView:[self view01] comProduto:[produtos objectAtIndex:0]];
    produtoAtual = 0;
    [self verificaSetasDeNavegacao];
}

- (void)setView:(UIView *)view comProduto:(Produto *)produto
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0.00"];
    [formatter setGroupingSeparator:@"."];
    [formatter setDecimalSeparator:@","];
    
    [[view.subviews objectAtIndex:0] setImage:[produto imagem]];
    [[view.subviews objectAtIndex:1] setText:[produto nome]];
    [[view.subviews objectAtIndex:2] setText:[produto descricao]];
    [[view.subviews objectAtIndex:2] sizeToFit];
    [[view.subviews objectAtIndex:3] setText:[NSString stringWithFormat:@"%@%@",
                                                     @"R$ ",
                                                     [formatter stringFromNumber:[NSNumber numberWithDouble:[[produto valor] doubleValue]]]]];
}

- (IBAction)produtoSeguinte:(id)sender
{
    produtoAtual++;
    UIView *viewAtiva = [self getViewAtiva];
    UIView *viewInativa = [self getViewInativa];
    
    [self setView:viewInativa comProduto:[produtos objectAtIndex:produtoAtual]];

    [viewInativa setFrame:CGRectMake(320, 0, 320, 448)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [viewAtiva setFrame:CGRectMake(-320, 0, 320, 448)];
    }];

    [UIView animateWithDuration:0.3 animations:^{
        [viewInativa setFrame:CGRectMake(0, 0, 320, 448)];
    }];
    
    [self verificaSetasDeNavegacao];
}

- (IBAction)produtoAnterior:(id)sender
{
    produtoAtual--;
    UIView *viewAtiva = [self getViewAtiva];
    UIView *viewInativa = [self getViewInativa];

    [self setView:[self getViewInativa] comProduto:[produtos objectAtIndex:produtoAtual]];
    
    [viewInativa setFrame:CGRectMake(-320, 0, 320, 448)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [viewInativa setFrame:CGRectMake(0, 0, 320, 448)];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [viewAtiva setFrame:CGRectMake(320, 0, 320, 448)];
    }];
    
    [self verificaSetasDeNavegacao];
}

- (UIView *)getViewAtiva
{
    if (self.view01.frame.origin.x == 0)
    {
        return self.view01;
    }
    else
    {
        return self.view02;
    }
}

- (UIView *)getViewInativa
{
    if (self.view01.frame.origin.x != 0)
    {
        return self.view01;
    }
    else
    {
        return self.view02;
    }
}

- (void)verificaSetasDeNavegacao
{
    if (produtoAtual == 0)
    {
        [self.setaEsquerda setHidden:true];
    }
    else
    {
        [self.setaEsquerda setHidden:false];
    }
    
    if (produtoAtual == [produtos count]-1)
    {
        [self.setaDireita setHidden:true];
    }
    else
    {
        [self.setaDireita setHidden:false];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
