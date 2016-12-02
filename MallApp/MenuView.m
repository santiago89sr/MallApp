//
//  UIViewController+MenuView.m
//  MallApp
//
//  Created by Iris Mac 2 on 22/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import "MenuView.h"
#import "SWRevealViewController.h"

@implementation MenuView

-(void)viewDidLoad{
    [super viewDidLoad];
    
    menu = [[NSArray alloc]initWithObjects:@"home",@"perfil", nil];
    
}

-(NSInteger) numberOfSectionsTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menu count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if([segue isKindOfClass:[SWRevealViewControllerSegue class]]){
//        
//        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*)segue;
//        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController*svc,UIViewController* dvc){
//            
//            UINavigationController * navController = (UINavigationController*)self.revealViewController.frontViewController;
//            
//            [navController setViewControllers:@[dvc] animated:NO];
//            
//            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
//            
//            
//        };
//    }
//}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
