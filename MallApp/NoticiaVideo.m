//
//  UIViewController+NoticiaVideo.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "NoticiaVideo.h"

@implementation NoticiaVideo

-(void)viewDidLoad{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    self.playerVideo.delegate = self;
    [self.playerVideo loadWithVideoId:_objetoParse[@"video"]];
    [self.playerVideo playVideo];
    
    _titulo.text = _objetoParse[@"titulo"];
    _descripcion.text = _objetoParse[@"descripcion"];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self desactivarIndicador];
    });
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
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
