//
//  UIViewController+NoticiasView.h
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface NoticiasView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *objetosNoticias;
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) IBOutlet UIButton *botonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tablaNoticias;

@end
