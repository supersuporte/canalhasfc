//
//  Conexao.h
//  BITemplate
//
//  Created by Carlos Gomes on 01/08/12.
//  Copyright (c) 2012 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface Conexao : NSObject

- (BOOL)conexaoComInternet;
- (BOOL)conexaoComWebServices;

@end
