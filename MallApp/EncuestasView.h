//
//  UIViewController+EncuestasView.h
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface EncuestasView : UIViewController{
 
    MBProgressHUD *HUD;
    
}


@property (weak, nonatomic) IBOutlet UIButton *botonMenu;

- (IBAction)botonShare:(id)sender;
@end
