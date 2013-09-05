//
//  Conexao.m
//  BITemplate
//
//  Created by Carlos Gomes on 01/08/12.
//  Copyright (c) 2012 Carlos Gomes. All rights reserved.
//

#import "Conexao.h"
#import "Reachability.h"
#import <arpa/inet.h>

@implementation Conexao

- (BOOL)conexaoComInternet
{
    if ([self conectadoAInternet] == FALSE) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Conexão Requerida"
                                    message:@"Você precisa estar conectado à Internet para usar este aplicativo."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
        [av show];
        
        return FALSE;
    }
    return TRUE;
}

- (BOOL)conexaoComWebServices
{
    if ([self acessivelWebServices] == FALSE) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Não foi possível de conectar ao servidor"
                                    message:@"O servidor está indisponível no momento. "
                                             "Por favor tente mais tarde. Se o problema persistir, "
                                             "contate o departamento de TI do Canalhas F&C."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil];
        [av show];
        
        return FALSE;
    }
    return TRUE;
}

- (BOOL)conectadoAInternet
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    Reachability *r = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return FALSE;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return TRUE;
}

- (BOOL)acessivelWebServices
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    struct sockaddr_in address;
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_port = htons(80);
    address.sin_addr.s_addr = inet_addr("www.supersuporte.com.br");
    
    Reachability *r = [Reachability reachabilityWithAddress:&address];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return FALSE;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return TRUE;
}

@end
