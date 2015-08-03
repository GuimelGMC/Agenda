//
//  ComponentesCompartidosAPI.h
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contactos.h"
@interface ComponentesCompartidosAPI : NSObject

@property (nonatomic,assign) BOOL editar;
@property (nonatomic,assign) BOOL consulta;
@property (nonatomic,retain) Contactos *contacto;

+(ComponentesCompartidosAPI *)instanciaCompartida;
@end
