//
//  ComponentesCompartidosAPI.m
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "ComponentesCompartidosAPI.h"

@implementation ComponentesCompartidosAPI

@synthesize editar,contacto,consulta;

+(ComponentesCompartidosAPI *)instanciaCompartida{
    static ComponentesCompartidosAPI *_instanciaCompartida = nil;
    static dispatch_once_t unaInstancia;
    
    dispatch_once(&unaInstancia,^{
        _instanciaCompartida = [[ComponentesCompartidosAPI alloc] init];
    });
    return _instanciaCompartida;
}
@end
