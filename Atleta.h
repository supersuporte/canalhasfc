//
//  Atleta.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 20/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SituacaoFinanceira;

@interface Atleta : NSObject

@property (strong, nonatomic) NSNumber *codigo;
@property (strong, nonatomic) NSString *nome;
@property (strong, nonatomic) SituacaoFinanceira *situacaoFinanceira;

- (id)initWithDicionario:(NSDictionary *)dicionario;

@end
