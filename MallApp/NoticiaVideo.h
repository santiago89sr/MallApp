//
//  UIViewController+NoticiaVideo.h
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "YTPlayerView.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface NoticiaVideo : UIViewController<YTPlayerViewDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (strong, nonatomic) PFObject *objetoParse;
@property (weak, nonatomic) IBOutlet YTPlayerView *playerVideo;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UITextView *descripcion;

- (IBAction)btnVolver:(id)sender;


@end
