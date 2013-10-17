//
//  ProdutoUtils.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 16/10/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "ProdutoUtils.h"
#import "Produto.h"

@implementation ProdutoUtils

+ (NSMutableArray *)produtosComDicionario:(NSDictionary *)dicionario
{
    NSArray *arrayDoDicionarioProduto;
    
    NSObject *dicionarioProduto = [dicionario objectForKey:@"produto"];
    
    if ([dicionarioProduto isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *produto = [dicionario objectForKey:@"produto"];
        arrayDoDicionarioProduto = [[NSArray alloc] initWithObjects:produto, nil];
    }
    else if ([dicionarioProduto isKindOfClass:[NSArray class]])
    {
        arrayDoDicionarioProduto = [dicionario objectForKey:@"produto"];
    }
    
    
    NSMutableArray *produtos = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itemDoArray in arrayDoDicionarioProduto) {
        [produtos addObject:[[Produto alloc] initWithDicionario:itemDoArray]];
    }
    
    return produtos;
}

@end
