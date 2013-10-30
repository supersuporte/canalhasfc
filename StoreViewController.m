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
    
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation StoreViewController

@synthesize navigationBar;
@synthesize imagem;
@synthesize nome;
@synthesize descricao;
@synthesize valor;

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
    
    NSDictionary *titulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                            UITextAttributeTextColor,
                            [UIColor clearColor],
                            UITextAttributeTextShadowColor, nil];

    [self.navigationBar setTitleTextAttributes:titulo];

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(140.0, 180.0, 40.0, 40.0);
    
    [self.view addSubview:activityIndicator];
    [activityIndicator stopAnimating];
    
    [self pesquisaWebServices];
}

- (void)pesquisaWebServices
{
    [activityIndicator startAnimating];
    
    //NSString *url = [NSString stringWithFormat:@"http://www.supersuporte.com.br/canalhasfc/store.json"];
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1/canalhasfc/store.json"];
    
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

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0.00"];
    [formatter setGroupingSeparator:@"."];
    [formatter setDecimalSeparator:@","];

    
    Produto *produto = [produtos objectAtIndex:0];

    NSURL *imgUrl = [NSURL URLWithString:[produto imagem]];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *img = [UIImage imageWithData:imgData];
    [self.imagem setImage:img];

    [self.nome setText:[produto nome]];
    [self.descricao setText:[produto descricao]];
    [self.valor setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:[[produto valor] doubleValue]]]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
