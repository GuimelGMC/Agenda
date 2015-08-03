//
//  CeldaCustom.m
//  Agenda
//
//  Created by GuimelGMC on 02/08/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "CeldaCustom.h"

@implementation CeldaCustom

- (void)awakeFromNib {
    // Initialization code
    _imagenPerfil.layer.cornerRadius = 60 / 2;
    _imagenPerfil.layer.masksToBounds = YES;
    _imagenPerfil.contentMode = UIViewContentModeScaleAspectFill;
    _imagenPerfil.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
