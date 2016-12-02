//
//  UIViewController+NoticiasView.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "NoticiasView.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "CellNoticiasView.h"
#import "NoticiaImagen.h"
#import "NoticiaVideo.h"

@implementation NoticiasView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_botonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    objetosNoticias = [[NSMutableArray alloc]init];
    
    _tablaNoticias.delegate = self;
    _tablaNoticias.dataSource = self;
    
    [self traerNoticias];
    
}

-(void)traerNoticias{
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self activarIndicador];
    });
    
    PFQuery * query = [PFQuery queryWithClassName:@"Noticias"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if(!error){
            [objetosNoticias removeAllObjects];
            
            for(PFObject *object in objects){
                [objetosNoticias addObject:object];
            }
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self desactivarIndicador];
            });
            
            [_tablaNoticias reloadData];
            
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
    
    return [objetosNoticias count];

}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellNoticiasView *cell = [tableView dequeueReusableCellWithIdentifier:@"CellNoticiasView" forIndexPath:indexPath];
    
    if (!cell)
        cell = [[CellNoticiasView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellNoticiasView"];
    
    PFObject *noticia = [objetosNoticias objectAtIndex:indexPath.row];
    
    
    cell.titulo.text = noticia[@"titulo"];
    
    PFFile *noticiaImage = noticia[@"imagen"];
    [noticiaImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.image.image = image;
        }
    }];
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tablaNoticias deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *noticia = [objetosNoticias objectAtIndex:indexPath.row];
    
    if([noticia[@"tipo"] isEqualToString:@"imagen"]){
        
        NoticiaImagen * noticiaImagen = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticiaImagen"];
        
        noticiaImagen.objetoParse = noticia;
        
        [self.navigationController pushViewController:noticiaImagen animated:YES];
        
    }else{
        NoticiaVideo * noticiaVideo = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticiaVideo"];
        
        noticiaVideo.objetoParse = noticia;
        
        [self.navigationController pushViewController:noticiaVideo animated:YES];
    }
    
    
    
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
