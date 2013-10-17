//
//  Produto.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 16/10/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Produto : NSObject

@property (strong, nonatomic) NSString *nome;
@property (strong, nonatomic) NSString *imagem;
@property (strong, nonatomic) NSString *descricao;
@property (strong, nonatomic) NSDecimalNumber *valor;

- (id)initWithDicionario:(NSDictionary *)dicionario;

@end
