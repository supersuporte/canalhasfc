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
        
        Noticia *noticia = [[Noticia alloc] init];
        
        NSString *data = [NSString stringWithFormat:@"%@", [itemDoArray objectForKey:@"data"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        [noticia setData:[dateFormatter dateFromString:data]];

        [noticia setImagem:[itemDoArray objectForKey:@"imagem"]];
        [noticia setTitulo:[itemDoArray objectForKey:@"titulo"]];
        [noticia setTexto:[itemDoArray objectForKey:@"texto"]];
        
        [noticias addObject:noticia];
    }
    
    return noticias;
}

@end
