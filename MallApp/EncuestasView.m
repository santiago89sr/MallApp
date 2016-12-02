//
//  UIViewController+EncuestasView.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "EncuestasView.h"
#import "SWRevealViewController.h"

@implementation EncuestasView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_botonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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


- (IBAction)botonShare:(id)sender {
    
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
//    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
//                                   UIActivityTypePrint,
//                                   UIActivityTypeAssignToContact,
//                                   UIActivityTypeSaveToCameraRoll,
//                                   UIActivityTypeAddToReadingList,
//                                   UIActivityTypePostToFlickr,
//                                   UIActivityTypePostToVimeo];
//    
//    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
@end
