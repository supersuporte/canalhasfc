//
//  Produto.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 16/10/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "Produto.h"

@implementation Produto

@synthesize nome;
@synthesize imagem;
@synthesize descricao;
@synthesize valor;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    [self setNome:[dicionario objectForKey:@"nome"]];
    [self setDescricao:[dicionario objectForKey:@"descricao"]];
    [self setValor:[dicionario objectForKey:@"valor"]];
    
    NSURL *imgUrl = [NSURL URLWithString:[dicionario objectForKey:@"imagem"]];
    NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    [self setImagem:[UIImage imageWithData:imgData]];

    return self;
}

@end
