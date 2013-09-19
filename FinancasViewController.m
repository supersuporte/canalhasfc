//
//  FinancasViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "FinancasViewController.h"
#import "Financa.h"
#import "Conexao.h"

@interface FinancasViewController ()
{
    Financa *financa;
    
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation FinancasViewController

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
    
    [self setTitle:@"Finanças"];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSDictionary *financasNCTitulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                                      UITextAttributeTextColor,
                                      [UIColor clearColor],
                                      UITextAttributeTextShadowColor, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:financasNCTitulo];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(140.0, 180.0, 40.0, 40.0);
    
    [self.view addSubview:activityIndicator];
    [activityIndicator stopAnimating];
    
    [self pesquisaWebServices];
}

- (void)pesquisaWebServices
{
    [activityIndicator startAnimating];
    
    //NSString *url = [NSString stringWithFormat:@"http://www.supersuporte.com.br/canalhasfc/financas.json"];
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1/canalhasfc/f.json"];
    
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
        financa = [[Financa alloc] initWithDicionario:jsonDictionary];
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

    // Saldo
    UILabel *labelSaldoAtual = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 120, 15)];
    [labelSaldoAtual setBackgroundColor:[UIColor clearColor]];
    [labelSaldoAtual setTextColor:[UIColor whiteColor]];
    [labelSaldoAtual setFont:[UIFont systemFontOfSize:14]];
    [labelSaldoAtual setText:@"Saldo Atual:"];
    [self.view addSubview:labelSaldoAtual];

    double saldoAtual = [[financa saldoAtual] doubleValue];
    UILabel *valorSaldoAtual = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 90, 15)];
    [valorSaldoAtual setBackgroundColor:[UIColor clearColor]];
    [valorSaldoAtual setTextColor:[UIColor whiteColor]];
    [valorSaldoAtual setFont:[UIFont systemFontOfSize:14]];
    [valorSaldoAtual setTextAlignment:NSTextAlignmentRight];
    [valorSaldoAtual setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:saldoAtual]]]];
    [self.view addSubview:valorSaldoAtual];
   
    // Caixa
    UILabel *labelCaixa = [[UILabel alloc] initWithFrame:CGRectMake(6, 20, 120, 15)];
    [labelCaixa setBackgroundColor:[UIColor clearColor]];
    [labelCaixa setTextColor:[UIColor whiteColor]];
    [labelCaixa setFont:[UIFont systemFontOfSize:14]];
    [labelCaixa setText:@"Caixa:"];
    [self.view addSubview:labelCaixa];
    
    double caixa = [[financa caixa] doubleValue];
    UILabel *valorCaixa = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 90, 15)];
    [valorCaixa setBackgroundColor:[UIColor clearColor]];
    [valorCaixa setTextColor:[UIColor whiteColor]];
    [valorCaixa setFont:[UIFont systemFontOfSize:14]];
    [valorCaixa setTextAlignment:NSTextAlignmentRight];
    [valorCaixa setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:caixa]]]];
    [self.view addSubview:valorCaixa];

	// Total
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(6, 40, 120, 15)];
    [labelTotal setBackgroundColor:[UIColor clearColor]];
    [labelTotal setTextColor:[UIColor whiteColor]];
    [labelTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [labelTotal setText:@"Saldo + Caixa:"];
    [self.view addSubview:labelTotal];

    double total = saldoAtual + caixa;
    UILabel *valorTotal = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 90, 15)];
    [valorTotal setBackgroundColor:[UIColor clearColor]];
    [valorTotal setTextColor:[UIColor whiteColor]];
    [valorTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [valorTotal setTextAlignment:NSTextAlignmentRight];
    [valorTotal setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:total]]]];
    [self.view addSubview:valorTotal];
}

- (void)voltar
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
