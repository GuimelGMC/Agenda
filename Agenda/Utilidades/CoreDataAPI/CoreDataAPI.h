//
//  CoreDataAPI.h
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataAPI : NSObject

@property(nonatomic,strong)NSManagedObjectContext *context;
@property(nonatomic,strong)NSManagedObjectModel *model;
@property(nonatomic,strong)NSPersistentStoreCoordinator *psc;

-(NSDictionary *)ejecutaComando:(NSString *)comando conEntidad:(id)entidad yPredicado:(NSPredicate *)predicado;
-(BOOL)salvarContexto;
+(CoreDataAPI *) instanciaCompartida;
@end
