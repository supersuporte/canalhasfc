//
//  Noticia.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 04/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Noticia : NSObject

@property (strong, nonatomic) NSDate *data;
@property (strong, nonatomic) NSString *imagem;
@property (strong, nonatomic) NSString *titulo;
@property (strong, nonatomic) NSString *texto;

@end
