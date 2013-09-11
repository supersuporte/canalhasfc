//
//  NoticiasDetalhesViewController.h
//  CanalhasFC
//
//  Created by Carlos Gomes on 06/09/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Noticia.h"

@interface NoticiasDetalhesViewController : UIViewController

- (id)initWithNoticia:(Noticia *)noticia eImagem:(UIImage *)imagem;

@end
