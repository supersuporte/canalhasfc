//
//  NoticiaUtils.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 04/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "NoticiaUtils.h"
#import "Noticia.h"

@implementation NoticiaUtils

+ (NSMutableArray *)noticiasComDicionario:(NSDictionary *)dicionario
{
    NSArray *arrayDoDicionarioNoticia;
    
    NSObject *dicionarioNoticia = [dicionario objectForKey:@"noticia"];
    
    if ([dicionarioNoticia isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *noticia = [dicionario objectForKey:@"noticia"];
        arrayDoDicionarioNoticia = [[NSArray alloc] initWithObjects:noticia, nil];
    }
    else if ([dicionarioNoticia isKindOfClass:[NSArray class]])
    {
        arrayDoDicionarioNoticia = [dicionario objectForKey:@"noticia"];
    }
    
    
    NSMutableArray *noticias = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itemDoArray in arrayDoDicionarioNoticia) {        
        [noticias addObject:[[Noticia alloc] initWithDicionario:itemDoArray]];
    }
    
    return noticias;
}

@end
