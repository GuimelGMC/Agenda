//
//  MasterViewController.m
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CeldaCustom.h"
#import "CoreDataAPI.h"
#import "Contactos.h"
#import "ComponentesCompartidosAPI.h"
@interface MasterViewController ()

@property (nonatomic,retain)NSMutableArray *contactos;
@property (nonatomic, strong) NSMutableArray *contactosFiltrados;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.definesPresentationContext = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _contactos = [NSMutableArray array];
    _contactos = [[[[CoreDataAPI instanciaCompartida] ejecutaComando:@"select" conEntidad:@"Contactos" yPredicado:nil] objectForKey:@"results"] mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        Contactos *contacto = [_contactos objectAtIndex:indexPath.row];
        [controller setDetailItem:contacto];
        [[ComponentesCompartidosAPI instanciaCompartida] setEditar:YES];
        [[ComponentesCompartidosAPI instanciaCompartida] setContacto:contacto];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return [_contactos count];
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CeldaCustom *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCustom" forIndexPath:indexPath];
    
    Contactos *contacto = [_contactos objectAtIndex:[indexPath row]];
    
    [cell.imagenPerfil setImage:[UIImage imageWithData:[contacto conFoto]]];
    [cell.nombreCompleto setText:[NSString stringWithFormat:@"%@ %@ %@",[contacto conNombre],[contacto conApePaterno],[contacto conApeMaterno]]];
    [cell.apodo setText:[contacto conApodo]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contactos *contacto = [_contactos objectAtIndex:[indexPath row]];
        [[CoreDataAPI instanciaCompartida] ejecutaComando:@"delete" conEntidad:contacto yPredicado:nil];
        [[CoreDataAPI instanciaCompartida]salvarContexto];
        
        
        [self.tableView beginUpdates];
        [_contactos removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        
        NSInteger nRows = [self.tableView numberOfRowsInSection:0];
        NSMutableArray *arrayIndex = [[NSMutableArray alloc] init];
        for (int i = 0; i < nRows; i++) {
            [arrayIndex addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:arrayIndex withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        arrayIndex = nil;

        _contactos = [[[[CoreDataAPI instanciaCompartida] ejecutaComando:@"select" conEntidad:@"Contactos" yPredicado:nil] objectForKey:@"results"] mutableCopy];
    }
}

#pragma mark- Metodos Search

@end
