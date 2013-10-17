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
    [self setImagem:[dicionario objectForKey:@"imagem"]];
    [self setDescricao:[dicionario objectForKey:@"descricao"]];
    [self setValor:[dicionario objectForKey:@"valor"]];
    
    return self;
}

@end
