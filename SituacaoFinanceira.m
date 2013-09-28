//
//  SituacaoFinanceira.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 20/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "SituacaoFinanceira.h"

@implementation SituacaoFinanceira

@synthesize mesAtual;
@synthesize mesSeguinte;
@synthesize mesAnterior;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    [self setMesAtual:[[dicionario objectForKey:@"mesAtual"] boolValue]];
    [self setMesSeguinte:[[dicionario objectForKey:@"mesSeguinte"] boolValue]];
    [self setMesAnterior:[[dicionario objectForKey:@"mesAnterior"] boolValue]];

    return self;
}

@end
