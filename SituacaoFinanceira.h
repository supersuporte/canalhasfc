//
//  SituacaoFinanceira.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 20/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Atleta.h"

@interface SituacaoFinanceira : NSObject

@property (readwrite, nonatomic) BOOL mesAtual;
@property (readwrite, nonatomic) BOOL mesSeguinte;
@property (readwrite, nonatomic) BOOL mesAnterior;

- (id)initWithDicionario:(NSDictionary *)dicionario;

@end
