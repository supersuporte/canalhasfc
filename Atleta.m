//
//  Atleta.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 20/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "Atleta.h"
#import "SituacaoFinanceira.h"

@implementation Atleta

@synthesize codigo;
@synthesize nome;
@synthesize situacaoFinanceira;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [self setCodigo:[nf numberFromString:[dicionario objectForKey:@"codigo"]]];
    [self setNome:[dicionario objectForKey:@"nome"]];
    [self setSituacaoFinanceira:[[SituacaoFinanceira alloc] initWithDicionario:[dicionario objectForKey:@"situacaoFinanceira"]]];

    return self;
}

@end
