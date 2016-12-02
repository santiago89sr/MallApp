//
//  UIViewController+LocalesServiciosView.h
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface LocalesServiciosView : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *objetosLocales;
    NSMutableArray *filterLocales;
    BOOL isFiltered;
    MBProgressHUD * HUD;
    
}

@property (weak, nonatomic) IBOutlet UIButton *botonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tablaLocales;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
