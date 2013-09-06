//
//  NoticiasViewController.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "NoticiasViewController.h"
#import "NoticiasDetalhesViewController.h"
#import "NoticiaUtils.h"
#import "Noticia.h"
#import "Conexao.h"

@interface NoticiasViewController ()
{
    NSMutableArray *noticias;
    
    NSURLConnection *connection;
    NSMutableData *jsonData;
    
    UIActivityIndicatorView *activityIndicator;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.noticiasTableView deselectRowAtIndexPath:[self.noticiasTableView indexPathForSelectedRow] animated:YES];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *voltar = [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                                       style:UIBarButtonItemStyleDone
                                                       target:self
                                                       action:@selector(voltar)];
    self.navigationItem.backBarButtonItem = voltar;

    [self setTitle:@"Notícias"];
    [self.view setBackgroundColor:[UIColor blackColor]];

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    NSDictionary *noticiasNCTitulo = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor yellowColor],
                                      UITextAttributeTextColor,
                                      [UIColor clearColor],
                                      UITextAttributeTextShadowColor, nil];

    [self.navigationController.navigationBar setTitleTextAttributes:noticiasNCTitulo];


    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.frame = CGRectMake(140.0, 180.0, 40.0, 40.0);
    
    [self.view addSubview: activityIndicator];
    [activityIndicator stopAnimating];

    [self pesquisaWebServices];
}

- (void)pesquisaWebServices
{
    [activityIndicator startAnimating];
    
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1/canalhasNoticias.json"];
    
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

        UIImage *avImage = [UIImage imageNamed:@"setaDireita.png"];
        UIImageView *avImageView = [[UIImageView alloc] initWithImage:avImage];
        [cell setAccessoryView:avImageView];
        
        UIImageView *imagem = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 110, 78)];
        [imagem setTag:1];
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
    Noticia *noticia = [noticias objectAtIndex:[indexPath row]];

    UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
    NSURL *imgUrl = [NSURL URLWithString:[noticia imagem]];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    UIImage *img = [UIImage imageWithData:imgData];
    [imgView setImage:img];
   

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    UILabel *labelTexto = (UILabel *)[cell viewWithTag:2];
    [labelTexto setText:[NSString stringWithFormat:@"%@%@%@", [dateFormatter stringFromDate:[noticia data]], @" - ", [noticia titulo]]];
    [labelTexto sizeToFit];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Noticia *noticia = [noticias objectAtIndex:[indexPath row]];
    NoticiasDetalhesViewController *noticiasDetalhesViewController = [[NoticiasDetalhesViewController alloc] initWithNoticia:noticia];
    [self.navigationController pushViewController:noticiasDetalhesViewController animated:YES];
}

- (void) voltar {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
