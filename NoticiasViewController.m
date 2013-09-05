//
//  NoticiasViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "NoticiasViewController.h"
#import "NoticiaUtils.h"
#import "Conexao.h"

@interface NoticiasViewController ()
{
    NSMutableArray *noticias;
    
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *activityIndicatorLabel;
}

@end

@implementation NoticiasViewController

@synthesize noticiasTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self pesquisaWebServices];
    }
    return self;
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Notícias"];
    [self.view setBackgroundColor:[UIColor blackColor]];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSDictionary *noticiasNCTitulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                                      UITextAttributeTextColor,
                                      [UIColor clearColor],
                                      UITextAttributeTextShadowColor, nil];

    [self.navigationController.navigationBar setTitleTextAttributes:noticiasNCTitulo];


    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.frame = CGRectMake(40.0, 10.0, 40.0, 40.0);
    
    activityIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0, 9.0, 100.0, 40.0)];
    activityIndicatorLabel.backgroundColor = [UIColor clearColor];
    activityIndicatorLabel.textColor = [UIColor whiteColor];
    activityIndicatorLabel.adjustsFontSizeToFitWidth = YES;
    activityIndicatorLabel.text = @"Carregando...";
    
    [self.view addSubview: activityIndicator];
    [self.view addSubview: activityIndicatorLabel];
    [activityIndicator stopAnimating];
    [activityIndicatorLabel setHidden:YES];
}

- (void)pesquisaWebServices
{
    [activityIndicator startAnimating];
    [activityIndicatorLabel setHidden:NO];
    
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.17/noticias.json"];
    
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
        noticias = [NoticiaUtils noticiasComDicionario:jsonDictionary];
        [self montaResultado];
    }
    
    jsonData = nil;
    connection = nil;
    
    [activityIndicator stopAnimating];
    [activityIndicatorLabel setHidden:YES];
}

-(void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
    [activityIndicatorLabel setHidden:YES];
    
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
    return [noticias count];
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
}

@end
