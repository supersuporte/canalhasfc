//
//  Financa.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 19/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "Financa.h"
#import "AtletaUtils.h"

@implementation Financa

@synthesize saldoAtual;
@synthesize caixa;
@synthesize atletas;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    NSDictionary *financaDicionario = [dicionario objectForKey:@"financa"];
    
    [self setSaldoAtual:[financaDicionario objectForKey:@"saldoAtual"]];
    [self setCaixa:[financaDicionario objectForKey:@"caixa"]];
    [self setAtletas:[AtletaUtils atletasComDicionario:dicionario]];

    return self;
}

@end
