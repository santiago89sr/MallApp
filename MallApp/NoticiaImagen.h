//
//  UIViewController+NoticiaImagen.h
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface NoticiaImagen : UIViewController{
    
    MBProgressHUD *HUD;
    
}

@property (strong, nonatomic) PFObject *objetoParse;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UITextView *descripcion;

- (IBAction)btoVolver:(id)sender;


@end
