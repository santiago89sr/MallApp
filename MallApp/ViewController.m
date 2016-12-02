//
//  ViewController.m
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //PRUEBA DE CARGA GIT
    
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
   
    
    self.beaconRegion = [[CLBeaconRegion alloc]
                         initWithProximityUUID:[[NSUUID alloc]
                                                initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                         identifier:@"ranged region"];
    /*[self.beaconManager startMonitoringForRegion:[[CLBeaconRegion alloc]
                                                  initWithProximityUUID:[[NSUUID alloc]
                                                                         initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                                                  major:5923 minor:35241 identifier:@"beacon promocion"]];
     */
     [self.beaconManager requestAlwaysAuthorization];
    
    _correotf.delegate = self;
    _passtf.delegate = self;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"viewWillAppear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"viewDidDisappear");
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody =
    @"Prueba de Notificacion con beacons. "
    "Mensaje de Promociones!";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    
    NSLog(@"Fallo Region: Manager:%@ Region:%@ Error:%@",manager,region,error);
    
}

-(void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"Status:%d",status);
    
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region{
    
    //    UILocalNotification *notification = [[UILocalNotification alloc]init];
    //    notification.alertBody = @"Funciona Salio!";
    //    NSLog(@"Salio!");
    //    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(id)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    if([beacons count] > 0){
        CLBeacon * closesBeacon = beacons[0];
        
        
        if(closesBeacon.proximity == CLProximityNear){//|| closesBeacon.proximity == CLProximityImmediate){
            
            NSLog(@"identificador %@",region.identifier);
        
        }
    }
    
            
}

- (void)loginWithFacebook {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString * internet = [self stringFromStatus:status];
    
    
    if ([internet isEqualToString:@"1"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self activarIndicador];
        });
        
        // Set permissions required from the facebook user account
        NSArray *permissionsArray = @[ @"public_profile",@"email"];
        
        // Login PFUser using Facebook
        [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
            if (!user) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self desactivarIndicador];
                });
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
                [self userDataFB];
            } else {
                NSLog(@"User logged in through Facebook!");
                [self userDataFB];
            }
            
            if(error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self desactivarIndicador];
                });
                NSLog(@"Este es el error: %@, %@",error,error.description);
            }
        }];
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sin conexión" message:@"Sin conexión a internet no se puede registrar" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

-(void)userDataFB{
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"id,name,email,picture,first_name,last_name" forKey:@"fields"];
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:parameters]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *pictureURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]];
             
             NSLog(@"pictureURL %@",pictureURL);
             
             
             NSString *encodedImageUrlString = [pictureURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             NSURL *imageURL = [NSURL URLWithString: encodedImageUrlString];
             
             NSData * dataImagen = [NSData dataWithContentsOfURL:imageURL];
             
             PFFile *imagenPerfil = [PFFile fileWithName:@"imagenPerfil.png" data:dataImagen];
             
             PFUser * user = [PFUser currentUser];
             user.username = [result objectForKey:@"email"];
             user[@"nombre"] = [result objectForKey:@"first_name"];
             user[@"apellido"] = [result objectForKey:@"last_name"];
             user[@"email"] = [result objectForKey:@"email"];
             user[@"imagenPerfil"] = imagenPerfil;
             
             [user saveInBackgroundWithBlock:^(BOOL success,NSError*error){
                 
                 if(error){
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self desactivarIndicador];
                         
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:ok];
                         
                         [self presentViewController:alertController animated:YES completion:nil];
                         
                     });
                     
                     
                 }else{
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self desactivarIndicador];
                     });
                     
//                     CompletarDatosVC * CompletarDatosVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CompletarDatosVC"];
//                     
//                     [self.navigationController pushViewController:CompletarDatosVC animated:YES];
                     
                 }
                 
             }];
             
         }else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self desactivarIndicador];
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:ok];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
             });
             
         }
     }];
    
}


- (IBAction)btnFB:(id)sender {
    
    [self loginWithFacebook];
    
}

- (IBAction)btnGoogle:(id)sender {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString * internet = [self stringFromStatus:status];
    
    if ([internet isEqualToString:@"1"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self activarIndicador];
        });
        
        [[GIDSignIn sharedInstance] signIn];
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sin conexión" message:@"Sin conexión a internet no se puede registrar" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
    
}

- (IBAction)btnEntrar:(id)sender {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    NSString *internet = [self stringFromStatus:status];
    
    if ([internet isEqualToString:@"1"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self activarIndicador];
        });
        
        [PFUser logInWithUsernameInBackground:_correotf.text password:_passtf.text block:^(PFUser *user, NSError *error){
            
            if(user){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self desactivarIndicador];
                });
                
                NSLog(@"Entro con exito!");
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self desactivarIndicador];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                });
            }
            
        }];
        
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sin conexión" message:@"Sin conexión a internet no se puede registrar" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[UIActivityIndicatorView stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self desactivarIndicador];
    });
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

@end
