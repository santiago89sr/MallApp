//
//  UIViewController+LocalesServiciosView.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "LocalesServiciosView.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "CellLocalesServiciosView.h"
#import "LocalesServiciosInfo.h"

@implementation LocalesServiciosView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_botonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    objetosLocales = [[NSMutableArray alloc]init];
    filterLocales = [[NSMutableArray alloc]init];
    
    _tablaLocales.delegate = self;
    _tablaLocales.dataSource = self;
    _searchBar.delegate = self;
    
    [self traerLocales];
    
}

-(void)traerLocales{
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    PFQuery * query = [PFQuery queryWithClassName:@"Locales"];
    [query includeKey:@"categorias"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if(!error){
            [objetosLocales removeAllObjects];
            
            for(PFObject *object in objects){
                [objetosLocales addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
            [_tablaLocales reloadData];
            
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
    if(isFiltered){
        
        return [filterLocales count];
        
    }else{
        
        return [objetosLocales count];
        
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellLocalesServiciosView *cell = [tableView dequeueReusableCellWithIdentifier:@"CellLocalesServiciosView" forIndexPath:indexPath];
    
    if (!cell)
        cell = [[CellLocalesServiciosView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellLocalesServiciosView"];
    
    PFObject *local;
    if(isFiltered){
        local = [filterLocales objectAtIndex:indexPath.row];
    }else{
        local = [objetosLocales objectAtIndex:indexPath.row];
    }
    
    
    cell.local.text = local[@"titulo"];
    
    PFObject *categorias = local[@"categorias"];
    cell.categoria.text = categorias[@"titulo"];
    
    PFFile *localImage = local[@"imagen"];
    [localImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.image.image = image;
        }
    }];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tablaLocales deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *local;
    if(isFiltered){
        local = [filterLocales objectAtIndex:indexPath.row];
    }else{
        local = [objetosLocales objectAtIndex:indexPath.row];
    }
    
    [_searchBar resignFirstResponder];
    _searchBar.text = nil;
    isFiltered = FALSE;
    [self.tablaLocales reloadData];
    
    LocalesServiciosInfo * localInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"LocalesServiciosInfo"];
    
    localInfo.objetoParse = local;
    
    [self.navigationController pushViewController:localInfo animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    NSLog(@"sirve!");
    
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        [filterLocales removeAllObjects];
        
        for (PFObject* local in objetosLocales)
        {
            NSRange tituloLocal = [local[@"titulo"] rangeOfString:text options:NSCaseInsensitiveSearch];
            PFObject *categorias = local[@"categorias"];
            NSRange categoriaLocal = [categorias[@"titulo"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(tituloLocal.location != NSNotFound || categoriaLocal.location != NSNotFound)
            {
                [filterLocales addObject:local];
            }
        }
    }
    
    [self.tablaLocales reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = nil;
    isFiltered = FALSE;
    [self.tablaLocales reloadData];
    
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
