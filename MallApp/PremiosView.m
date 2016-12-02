//
//  UIViewController+PremiosView.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "PremiosView.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "CellPremiosView.h"
#import "PremiosInfo.h"

@implementation PremiosView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_botonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    objetosPremios = [[NSMutableArray alloc]init];
    
    _tablaPremios.delegate = self;
    _tablaPremios.dataSource = self;
    
    [self traerPremios];
    
}

-(void)traerPremios{
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    PFQuery * query = [PFQuery queryWithClassName:@"Premios"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if(!error){
            [objetosPremios removeAllObjects];
            
            for(PFObject *object in objects){
                [objetosPremios addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
            
            [_tablaPremios reloadData];
            
        }else{
            NSLog(@"Error: %@",error);
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
        }
        
        
        
    }];
    
}

-(NSInteger) numberOfSectionsTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [objetosPremios count];
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellPremiosView *cell = [tableView dequeueReusableCellWithIdentifier:@"CellPremiosView" forIndexPath:indexPath];
    
    if (!cell)
        cell = [[CellPremiosView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellPremiosView"];
    
    PFObject *premio = [objetosPremios objectAtIndex:indexPath.row];
    
    
    cell.titulo.text = premio[@"titulo"];
    
    PFFile *premioImage = premio[@"imagen"];
    [premioImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.image.image = image;
        }
    }];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tablaPremios deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *premio = [objetosPremios objectAtIndex:indexPath.row];
    
    PremiosInfo * premioInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"PremiosInfo"];
    
    premioInfo.objetoParse = premio;
    
    [self.navigationController pushViewController:premioInfo animated:YES];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
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



@end
