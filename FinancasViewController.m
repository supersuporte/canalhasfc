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
#import "Atleta.h"
#import "SituacaoFinanceira.h"

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
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@", [[Conexao alloc] webServices], @"financas.json"];
    
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
    UILabel *lineTotal = [[UILabel alloc] initWithFrame:CGRectMake(6, 45, 185, 1)];
    [lineTotal setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lineTotal];

    UILabel *labelTotal = [[UILabel alloc] initWithFrame:CGRectMake(6, 50, 120, 15)];
    [labelTotal setBackgroundColor:[UIColor clearColor]];
    [labelTotal setTextColor:[UIColor whiteColor]];
    [labelTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [labelTotal setText:@"Saldo + Caixa:"];
    [self.view addSubview:labelTotal];
    
    double total = saldoAtual + caixa;
    UILabel *valorTotal = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 90, 15)];
    [valorTotal setBackgroundColor:[UIColor clearColor]];
    [valorTotal setTextColor:[UIColor whiteColor]];
    [valorTotal setFont:[UIFont boldSystemFontOfSize:14]];
    [valorTotal setTextAlignment:NSTextAlignmentRight];
    [valorTotal setText:[NSString stringWithFormat:@"%@%@", @"R$ ", [formatter stringFromNumber:[NSNumber numberWithDouble:total]]]];
    [self.view addSubview:valorTotal];
}

- (void)montaResultadoAtletas
{
    // Atletas
    UILabel *labelAtletasBg = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, larguraDaTela, 19)];
    [labelAtletasBg setBackgroundColor:[UIColor whiteColor]];
    [labelAtletasBg setAlpha:0.1];
    [self.view addSubview:labelAtletasBg];

    UILabel *labelAtletasLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, larguraDaTela, 1)];
    [labelAtletasLine setBackgroundColor:[UIColor whiteColor]];
    [labelAtletasBg addSubview:labelAtletasLine];

    UILabel *labelAtletasFrame = [[UILabel alloc] initWithFrame:CGRectMake(0, 81, larguraDaTela, 18)];
    [labelAtletasFrame setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:labelAtletasFrame];

    UILabel *labelAtletas = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 100, 15)];
    [labelAtletas setBackgroundColor:[UIColor clearColor]];
    [labelAtletas setTextColor:[UIColor yellowColor]];
    [labelAtletas setAlpha:(0.8)];
    [labelAtletas setFont:[UIFont boldSystemFontOfSize:14]];
    [labelAtletas setText:@"Atletas"];
    [labelAtletasFrame addSubview:labelAtletas];
    
    UILabel *labelAtletasMesAnterior = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-120, 0, 30, 15)];
    [labelAtletasMesAnterior setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesAnterior setTextColor:[UIColor yellowColor]];
    [labelAtletasMesAnterior setAlpha:(0.8)];
    [labelAtletasMesAnterior setFont:[UIFont boldSystemFontOfSize:14]];
    [labelAtletasMesAnterior setTextAlignment:NSTextAlignmentCenter];
    [labelAtletasMesAnterior setText:[[DataUtils alloc] mesAnterior]];
    [labelAtletasFrame addSubview:labelAtletasMesAnterior];
    
    UILabel *labelAtletasMesAtual = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-80, 0, 30, 15)];
    [labelAtletasMesAtual setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesAtual setTextColor:[UIColor yellowColor]];
    [labelAtletasMesAtual setAlpha:(0.8)];
    [labelAtletasMesAtual setFont:[UIFont boldSystemFontOfSize:14]];
    [labelAtletasMesAtual setTextAlignment:NSTextAlignmentCenter];
    [labelAtletasMesAtual setText:[[DataUtils alloc] mesAtual]];
    [labelAtletasFrame addSubview:labelAtletasMesAtual];
    
    UILabel *labelAtletasMesSeguinte = [[UILabel alloc] initWithFrame:CGRectMake(larguraDaTela-40, 0, 30, 15)];
    [labelAtletasMesSeguinte setBackgroundColor:[UIColor clearColor]];
    [labelAtletasMesSeguinte setTextColor:[UIColor yellowColor]];
    [labelAtletasMesSeguinte setAlpha:(0.8)];
    [labelAtletasMesSeguinte setFont:[UIFont boldSystemFontOfSize:14]];
    [labelAtletasMesSeguinte setTextAlignment:NSTextAlignmentCenter];
    [labelAtletasMesSeguinte setText:[[DataUtils alloc] mesSeguinte]];
    [labelAtletasFrame addSubview:labelAtletasMesSeguinte];
    
    atletasTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 99, larguraDaTela, alturaDaTela-190)];
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
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        
        UIImageView *icoMesAnterior = [[UIImageView alloc] initWithFrame:CGRectMake(larguraDaTela-110, 14, 15, 15)];
        [icoMesAnterior setTag:1];
        [cell.contentView addSubview:icoMesAnterior];

        UIImageView *icoMesAtual = [[UIImageView alloc] initWithFrame:CGRectMake(larguraDaTela-70, 14, 15, 15)];
        [icoMesAtual setTag:2];
        [cell.contentView addSubview:icoMesAtual];

        UIImageView *icoMesSeguinte = [[UIImageView alloc] initWithFrame:CGRectMake(larguraDaTela-30, 14, 15, 15)];
        [icoMesSeguinte setTag:3];
        [cell.contentView addSubview:icoMesSeguinte];
	}
    Atleta *atleta = [financa.atletas objectAtIndex:[indexPath row]];
    [cell.textLabel setText:[atleta nome]];
    
    SituacaoFinanceira *situacaoFinanceira = [atleta situacaoFinanceira];
    
    UIImage *ballRed = [UIImage imageNamed:@"ballRed"];
    UIImage *ballGreen = [UIImage imageNamed:@"ballGreen"];
    UIImage *ballGray = [UIImage imageNamed:@"ballGray"];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
    [imgView setImage:([situacaoFinanceira mesAnterior] ? ballGreen : ballRed)];
    
    imgView = (UIImageView *)[cell viewWithTag:2];
    [imgView setImage:([situacaoFinanceira mesAtual] ? ballGreen : ballRed)];
    
    imgView = (UIImageView *)[cell viewWithTag:3];
    [imgView setImage:([situacaoFinanceira mesSeguinte] ? ballGreen : ballGray)];

	return cell;
}

- (void)voltar
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
