//
//  UITableViewCell+CellOfertaView.h
//  MallApp
//
//  Created by Iris Mac 2 on 21/09/16.
//  Copyright © 2016 Grupoiris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellOfertaView : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *categoria;
@property (weak, nonatomic) IBOutlet UILabel *local;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@end
