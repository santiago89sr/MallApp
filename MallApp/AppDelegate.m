//
//  AppDelegate.m
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"a7612a6ba05d68de47c189a6646aae4d77d9d2fc";
        configuration.clientKey = @"92e699559e7e43ead3327161cd044b90934cd042";
        configuration.server = @"http://ec2-54-68-124-164.us-west-2.compute.amazonaws.com:80/parse";
    }]];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    [[UIApplication sharedApplication]
     registerUserNotificationSettings:[UIUserNotificationSettings
                                       settingsForTypes:UIUserNotificationTypeAlert
                                       categories:nil]];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"irHome"];
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    } else {
        // show the signup or login screen
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
            annotation:(id)annotation{
    
    BOOL shouldOpen = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                     openURL:url
                                                           sourceApplication:sourceApplication
                                                                  annotation:annotation];
    
    shouldOpen = shouldOpen ? shouldOpen : [[GIDSignIn sharedInstance] handleURL:url
                                                               sourceApplication:sourceApplication
                                                                      annotation:annotation];
    
    
    return shouldOpen;
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    NSURL *imageURL = [user.profile imageURLWithDimension:120];
    // ...
    
    NSLog(@"DATOS DE GOOGLE: %@, %@, %@",userId,idToken,fullName);
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if(!error){
            
            if(objects.count == 0){
                
                [self signUpGoogleParse:givenName apellido:familyName googleId:userId correo:email imageURL:imageURL];
                
            }else{
                
                [self loginGoogleParse:userId correo:email];
                
            }
            
        }
        
    }];
    
}

-(void)loginGoogleParse:(NSString*)googleId correo:(NSString*)correo{
    
    [PFUser logInWithUsernameInBackground:correo password:googleId
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            
                                            NSLog(@"ENTRO POR LOGIN");
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            NSLog(@"ERROR EN LOGIN");
                                        }
                                    }];
    
}

-(void)signUpGoogleParse:(NSString*)nombre apellido:(NSString*)apellido googleId:(NSString*)googleId correo:(NSString*)correo imageURL:(NSURL*)imageURL{
    
    PFUser *user = [PFUser user];
    user.username = correo;
    user.password = googleId;
    user.email = correo;
    
    // other fields can be set just like with PFObject
    user[@"nombre"] = nombre;
    user[@"apellido"] = apellido;
    
    PFFile *imageFile = [PFFile fileWithName:@"imagenPerfil.png" data:[NSData dataWithContentsOfURL:imageURL]];
    
    user[@"imagenPerfil"] = imageFile;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            
            NSLog(@"SE REGISTRO BIEN");
            
        } else {
            
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            NSLog(@"ERROR AL REGISTRARSE.");
        }
    }];
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






@end
