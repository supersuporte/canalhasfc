//
//  StoreViewController.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 29/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *view01;
@property (weak, nonatomic) IBOutlet UIView *view02;
@property (weak, nonatomic) IBOutlet UIButton *setaEsquerda;
@property (weak, nonatomic) IBOutlet UIButton *setaDireita;

- (IBAction)produtoSeguinte:(id)sender;
- (IBAction)produtoAnterior:(id)sender;

@end
