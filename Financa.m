//
//  Financa.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 19/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "Financa.h"

@implementation Financa

@synthesize saldoAtual;
@synthesize caixa;

- (id)initWithDicionario:(NSDictionary *)dicionario
{
    NSDictionary *financaDic = [dicionario objectForKey:@"financa"];
    
    [self setSaldoAtual:[financaDic objectForKey:@"saldoAtual"]];
    [self setCaixa:[financaDic objectForKey:@"caixa"]];
    
    return self;
}

@end
