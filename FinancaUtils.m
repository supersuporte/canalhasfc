//
//  FinancaUtils.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 19/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "FinancaUtils.h"
#import "Financa.h"

@implementation FinancaUtils

+ (NSMutableArray *)financasComDicionario:(NSDictionary *)dicionario
{
    NSArray *arrayDoDicionarioFinanca;
    
    NSObject *dicionarioFinanca = [dicionario objectForKey:@"financa"];
    
    if ([dicionarioFinanca isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *financa = [dicionario objectForKey:@"financa"];
        arrayDoDicionarioFinanca = [[NSArray alloc] initWithObjects:financa, nil];
    }
    else if ([dicionarioFinanca isKindOfClass:[NSArray class]])
    {
        arrayDoDicionarioFinanca = [dicionario objectForKey:@"financa"];
    }
    
    
    NSMutableArray *financas = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itemDoArray in arrayDoDicionarioFinanca) {
        
        Financa *financa = [[Financa alloc] init];
        
        [financa setSaldoAtual:[itemDoArray objectForKey:@"saldoAtual"]];
        [financa setCaixa:[itemDoArray objectForKey:@"caixa"]];

        [financas addObject:financa];
    }
    
    return financas;
}

@end
