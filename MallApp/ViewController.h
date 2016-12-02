//
//  ViewController.h
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/EstimoteSDK.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <Google/SignIn.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface ViewController : UIViewController<ESTBeaconManagerDelegate,GIDSignInUIDelegate,UITextFieldDelegate>{
    
    
    MBProgressHUD *HUD;
    
    
}


@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (weak, nonatomic) IBOutlet UITextField *correotf;
@property (weak, nonatomic) IBOutlet UITextField *passtf;

- (IBAction)btnFB:(id)sender;
- (IBAction)btnGoogle:(id)sender;
- (IBAction)btnEntrar:(id)sender;



@end

