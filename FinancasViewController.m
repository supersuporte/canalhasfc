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
#import "DataUtils.h"

@interface FinancasViewController ()
{
    Financa *financa;
    
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
    
    float larguraDaTela;
    float alturaDaTela;
}

@end

@implementation FinancasViewController

@synthesize atletasTableView;

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
    larguraDaTela = self.view.frame.size.width;
    alturaDaTela = self.view.frame.size.height;

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
    [self montaResultadoResumo];
    [self montaResultadoAtletas];
}

- (void)montaResultadoAtletas
{
    // Atletas
    UILabel *labelAtletasBg = [[UILabel alloc] initWithFrame:CGRectMake(0, 76, larguraDaTela, 15)];
    [labelAtletasBg setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:labelAtletasBg];
    
    UILabel *labelAtletas = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 100, 15)];
    [labelAtletas setBackgroundColor:[UIColor clearColor]];
    [labelAtletas setTextColor:[UIColor whiteColor]];
    [labelAtletas setFont:[UIFont boldSystemFontOfSize:12]];
    [labelAtletas setText:@"Atletas"];
    [labelAtletasBg addSubview:labelAtletas];
    
    UILabel *labelAtletasMesAnterior = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-120, 0, 30, 15)];
    [labelAtletasMesAnterior setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesAnterior setTextColor:[UIColor whiteColor]];
    [labelAtletasMesAnterior setFont:[UIFont boldSystemFontOfSize:12]];
    [labelAtletasMesAnterior setTextAlignment:NSTextAlignmentRight];
    [labelAtletasMesAnterior setText:[[DataUtils alloc] mesAnterior]];
    [labelAtletasBg addSubview:labelAtletasMesAnterior];
    
    UILabel *labelAtletasMesAtual = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-80, 0, 30, 15)];
    [labelAtletasMesAtual setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesAtual setTextColor:[UIColor whiteColor]];
    [labelAtletasMesAtual setFont:[UIFont boldSystemFontOfSize:12]];
    [labelAtletasMesAtual setTextAlignment:NSTextAlignmentRight];
    [labelAtletasMesAtual setText:[[DataUtils alloc] mesAtual]];
    [labelAtletasBg addSubview:labelAtletasMesAtual];
    
    UILabel *labelAtletasMesSeguinte = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-40, 0, 30, 15)];
    [labelAtletasMesSeguinte setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesSeguinte setTextColor:[UIColor whiteColor]];
    [labelAtletasMesSeguinte setFont:[UIFont boldSystemFontOfSize:12]];
    [labelAtletasMesSeguinte setTextAlignment:NSTextAlignmentRight];
    [labelAtletasMesSeguinte setText:[[DataUtils alloc] mesSeguinte]];
    [labelAtletasBg addSubview:labelAtletasMesSeguinte];
    
    atletasTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 91, larguraDaTela, alturaDaTela-91)];
    [atletasTableView setAllowsSelection:NO];
    [atletasTableView setBackgroundColor:[UIColor blackColor]];
    [atletasTableView setOpaque:YES];
    [atletasTableView setBackgroundView:nil];
    [atletasTableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [atletasTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [atletasTableView setSeparatorColor:[UIColor darkGrayColor]];
    
    [atletasTableView setDataSource:self];
    [atletasTableView setDelegate:self];
    
    [self.view addSubview:atletasTableView];    
}

- (void)montaResultadoResumo
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0.00"];
    [formatter setGroupingSeparator:@"."];
    [formatter setDecimalSeparator:@","];
    
    // Saldo
    UILabel *labelSaldoAtual = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 120, 15)];
    [labelSaldoAtual setBackgroundColor:[UIColor clearColor]];
    [labelSaldoAtual setTextColor:[UIColor whiteColor]];
    [labelSaldoAtual setFont:[UIFont systemFontOfSize:14]];
    [labelSaldoAtual setText:@"Saldo Atual:"];
    [self.view addSubview:labelSaldoAtual];
    
    double saldoAtual = [[financa saldoAtual] doubleValue];
    UILabel *valorSaldoAtual = [[UILabel alloc] initWithFrame:CGRectMake(100, 6, 90, 15)];
    [valorSaldoAtual setBackgroundColor:[UIColor clearColor]];
    [valorSaldoAtual setTextColor:[UIColor whiteColor]];
    [valorSaldoAtual setFont:[UIFont systemFontOfSize:14]];
    [valorSaldoAtual setTextAlignment:NSTextAlignmentRight];
    [valorSaldoAtual setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:saldoAtual]]]];
    [self.view addSubview:valorSaldoAtual];
    
    // Caixa
    UILabel *labelCaixa = [[UILabel alloc] initWithFrame:CGRectMake(6, 26, 120, 15)];
    [labelCaixa setBackgroundColor:[UIColor clearColor]];
    [labelCaixa setTextColor:[UIColor whiteColor]];
    [labelCaixa setFont:[UIFont systemFontOfSize:14]];
    [labelCaixa setText:@"Caixa:"];
    [self.view addSubview:labelCaixa];
    
    double caixa = [[financa caixa] doubleValue];
    UILabel *valorCaixa = [[UILabel alloc] initWithFrame:CGRectMake(100, 26, 90, 15)];
    [valorCaixa setBackgroundColor:[UIColor clearColor]];
    [valorCaixa setTextColor:[UIColor whiteColor]];
    [valorCaixa setFont:[UIFont systemFontOfSize:14]];
    [valorCaixa setTextAlignment:NSTextAlignmentRight];
    [valorCaixa setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:caixa]]]];
    [self.view addSubview:valorCaixa];
    
	// Total
    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(6, 46, 120, 15)];
    [labelTotal setBackgroundColor:[UIColor clearColor]];
    [labelTotal setTextColor:[UIColor whiteColor]];
    [labelTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [labelTotal setText:@"Saldo + Caixa:"];
    [self.view addSubview:labelTotal];
    
    double total = saldoAtual + caixa;
    UILabel *valorTotal = [[UILabel alloc] initWithFrame:CGRectMake(100, 46, 90, 15)];
    [valorTotal setBackgroundColor:[UIColor clearColor]];
    [valorTotal setTextColor:[UIColor whiteColor]];
    [valorTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [valorTotal setTextAlignment:NSTextAlignmentRight];
    [valorTotal setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:total]]]];
    [self.view addSubview:valorTotal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [financa.atletas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    
	return cell;
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
