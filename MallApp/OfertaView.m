//
//  UIViewController+OfertaView.m
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "OfertaView.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "CellOfertaView.h"
#import "OfertaInfo.h"

@implementation OfertaView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_botonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    objetosOfertas = [[NSMutableArray alloc]init];
    filterOfertas = [[NSMutableArray alloc]init];
    
    _tablaOfertas.delegate = self;
    _tablaOfertas.dataSource = self;
    _searchBar.delegate = self;
    
    [self traerOfertas];
    
    
}

-(void)traerOfertas{
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    PFQuery * query = [PFQuery queryWithClassName:@"Ofertas"];
    [query includeKey:@"local"];
    [query includeKey:@"categorias"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if(!error){
            [objetosOfertas removeAllObjects];
            
            for(PFObject *object in objects){
                [objetosOfertas addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
            
            [_tablaOfertas reloadData];
            
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
        
        return [filterOfertas count];
        
    }else{
        
        return [objetosOfertas count];
        
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellOfertaView *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOfertaView" forIndexPath:indexPath];
    
    if (!cell)
        cell = [[CellOfertaView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellOfertaView"];
    
    PFObject *oferta;
    if(isFiltered){
        oferta = [filterOfertas objectAtIndex:indexPath.row];
    }else{
        oferta = [objetosOfertas objectAtIndex:indexPath.row];
    }
    
    
    cell.titulo.text = oferta[@"titulo"];
    
    PFObject *categorias = oferta[@"categorias"];
    cell.categoria.text = categorias[@"titulo"];
    
    PFObject *local = oferta[@"local"];
    cell.local.text = local[@"titulo"];
    
    PFFile *ofertaImage = oferta[@"imagen"];
    [ofertaImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.image.image = image;
        }
    }];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tablaOfertas deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *oferta;
    if(isFiltered){
        oferta = [filterOfertas objectAtIndex:indexPath.row];
    }else{
        oferta = [objetosOfertas objectAtIndex:indexPath.row];
    }
    
    [_searchBar resignFirstResponder];
    _searchBar.text = nil;
    isFiltered = FALSE;
    [self.tablaOfertas reloadData];
    
    OfertaInfo * ofertaInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"OfertaInfo"];
    
    ofertaInfo.objetoParse = oferta;
    
    [self.navigationController pushViewController:ofertaInfo animated:YES];
    
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
        [filterOfertas removeAllObjects];
        
        for (PFObject* oferta in objetosOfertas)
        {
            NSRange tituloOferta = [oferta[@"titulo"] rangeOfString:text options:NSCaseInsensitiveSearch];
            PFObject *local = oferta[@"local"];
            NSRange localOferta = [local[@"titulo"] rangeOfString:text options:NSCaseInsensitiveSearch];
            PFObject *categorias = oferta[@"categorias"];
            NSRange categoriaOferta = [categorias[@"titulo"] rangeOfString:text options:NSCaseInsensitiveSearch];
            if(tituloOferta.location != NSNotFound || localOferta.location != NSNotFound || categoriaOferta.location != NSNotFound)
            {
                [filterOfertas addObject:oferta];
            }
        }
    }
    
    [self.tablaOfertas reloadData];
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
    [self.tablaOfertas reloadData];
    
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
