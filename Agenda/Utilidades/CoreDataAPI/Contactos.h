//
//  Contactos.h
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contactos : NSManagedObject

@property (nonatomic, retain) NSNumber * conId;
@property (nonatomic, retain) NSString * conNombre;
@property (nonatomic, retain) NSString * conApePaterno;
@property (nonatomic, retain) NSString * conApeMaterno;
@property (nonatomic, retain) NSData * conFoto;
@property (nonatomic, retain) NSDate * conFechaNaci;
@property (nonatomic, retain) NSString * conCorreo;
@property (nonatomic, retain) NSString * conCP;
@property (nonatomic, retain) NSString * conMunicipio;
@property (nonatomic, retain) NSString * conEstado;
@property (nonatomic, retain) NSString * conCalle;
@property (nonatomic, retain) NSString * conApodo;
@property (nonatomic, retain) NSString * conPais;
@property (nonatomic, retain) NSString * conTelFijo;
@property (nonatomic, retain) NSString * conCelular;

@end
