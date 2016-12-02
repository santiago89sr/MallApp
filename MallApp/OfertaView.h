//
//  UIViewController+OfertaView.h
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface OfertaView : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    NSMutableArray *objetosOfertas;
    NSMutableArray *filterOfertas;
    BOOL isFiltered;
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *botonMenu;
@property (weak, nonatomic) IBOutlet UITableView *tablaOfertas;
@end
