//
//  Noticia.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 04/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "Noticia.h"

@implementation Noticia

@synthesize data;
@synthesize imagem;
@synthesize titulo;
@synthesize texto;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    NSString *dataSemFormatacao = [NSString stringWithFormat:@"%@", [dicionario objectForKey:@"data"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    [self setData:[dateFormatter dateFromString:dataSemFormatacao]];
    [self setTitulo:[dicionario objectForKey:@"titulo"]];
    [self setTexto:[dicionario objectForKey:@"texto"]];

    NSURL *imgUrl = [NSURL URLWithString:[dicionario objectForKey:@"imagem"]];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    [self setImagem:[UIImage imageWithData:imgData]];

    return self;
}

@end
