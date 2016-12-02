//
//  UIViewController+LocalesServiciosInfo.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "LocalesServiciosInfo.h"

@implementation LocalesServiciosInfo

-(void)viewDidLoad{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    _local.text = _objetoParse[@"titulo"];
    
    PFObject *categoria = _objetoParse[@"categorias"];
    _categoria.text = categoria[@"titulo"];
    
    PFFile *localImage = _objetoParse[@"imagen"];
    [localImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            _image.image = image;
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
        }
    }];
    
    
}

- (NSString *)stringFromStatus:(NetworkStatus) status {
    
    NSString *string;
    switch(status) {
        case NotReachable:
            //Sin conexion.
            string = @"0";
            break;
        case ReachableViaWiFi:
            // Conexion WIFI
            string = @"1";
            break;
        case ReachableViaWWAN:
            // Conexion 3g o 4g
            string = @"1";
            break;
        default:
            string = @"0";
            break;
    }
    return string;
}



-(void)activarIndicador{
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.detailsLabelText = @"Cargando...";
    [self.view addSubview:HUD];
    [HUD show:YES];
    
}
-(void)desactivarIndicador{
    [HUD hide:YES];
}


- (IBAction)btnVolver:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
