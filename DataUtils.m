//
//  DataUtils.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 28/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils

- (NSString *)mesAtual
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"MMM"];
    NSDate *dataAtual = [NSDate date];
    
    return [dateFormatter stringFromDate:dataAtual];
}

- (NSString *)mesSeguinte
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [dateFormatter setDateFormat:@"MMM"];
    NSDate *dataAtual = [NSDate date];

    [dateComponents setMonth:1];
    NSDate *dataComMesSeguinte = [calendar dateByAddingComponents:dateComponents toDate:dataAtual options:0];
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:dataComMesSeguinte]];
}

- (NSString *)mesAnterior
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [dateFormatter setDateFormat:@"MMM"];
    NSDate *dataAtual = [NSDate date];
    
    [dateComponents setMonth:-1];
    NSDate *dataComMesAnterior = [calendar dateByAddingComponents:dateComponents toDate:dataAtual options:0];
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:dataComMesAnterior]];
}

@end
