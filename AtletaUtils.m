//
//  AtletaUtils.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 25/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "AtletaUtils.h"
#import "Atleta.h"

@implementation AtletaUtils

+ (NSMutableArray *)atletasComDicionario:(NSDictionary *)dicionario
{
    NSDictionary *financa = [dicionario objectForKey:@"financa"];
    NSArray *atletasArray = [financa objectForKey:@"atletas"];

    
    NSMutableArray *atletas = [[NSMutableArray alloc] init];
    
    for (NSDictionary *itemDoArray in atletasArray)
    {
        [atletas addObject:[[Atleta alloc] initWithDicionario:itemDoArray]];
    }
    
    return atletas;
}

@end
