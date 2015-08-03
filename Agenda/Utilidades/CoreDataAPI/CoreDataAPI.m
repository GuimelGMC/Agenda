//
//  CoreDataAPI.m
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "CoreDataAPI.h"

@implementation CoreDataAPI

+(CoreDataAPI *)instanciaCompartida{
    static CoreDataAPI *_instanciaCompartida = nil;
    static dispatch_once_t unaInstancia;
    
    dispatch_once(&unaInstancia, ^{
        _instanciaCompartida = [[CoreDataAPI alloc] init];
    });
    return _instanciaCompartida;
}
-(NSDictionary *)ejecutaComando:(NSString *)comando conEntidad:(id)entidad yPredicado:(NSPredicate *)predicado{
    NSError *error;
    NSMutableDictionary *informacionObtenida = [NSMutableDictionary dictionary];
    
    if ([comando isEqualToString:@"select"]) {
        NSFetchRequest *peticion = [[NSFetchRequest alloc]init];
        [peticion setEntity:[NSEntityDescription entityForName:entidad inManagedObjectContext:[[CoreDataAPI instanciaCompartida] context]]];
        [peticion setPredicate:predicado];
        NSArray *resultados = [[[CoreDataAPI instanciaCompartida] context] executeFetchRequest:peticion error:&error];
        if (!error) {
            [informacionObtenida setObject:resultados forKey:@"results"];
        }else{
            informacionObtenida = nil;
            NSLog(@"ERROR(CoreDataApi -> executeCommand): %@", [error localizedDescription]);
        }
    }else if ([comando isEqualToString:@"insert"]){
        [informacionObtenida setObject:[NSEntityDescription insertNewObjectForEntityForName:entidad inManagedObjectContext:[[CoreDataAPI instanciaCompartida]context]] forKey:@"newEntity"];
    }else if ([comando isEqualToString:@"delete"]){
        [[[CoreDataAPI instanciaCompartida] context] deleteObject:entidad];
        NSLog(@"Se borro sección");
    }
    return informacionObtenida;
}
-(BOOL)salvarContexto{
    NSError *error;
    BOOL success;
    success = [[[CoreDataAPI instanciaCompartida] context] save:&error];
    if (error) {
        NSLog(@"ERROR(COREDATAAPI -> salvarContexto): %@)",[error localizedDescription]);
    }
    return success;
}

@end
