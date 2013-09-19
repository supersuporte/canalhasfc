//
//  Financa.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 19/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Financa : NSObject

@property (strong, nonatomic) NSString *saldoAtual;
@property (strong, nonatomic) NSString *caixa;

- (id)initWithDicionario:(NSDictionary *)dicionario;

@end
