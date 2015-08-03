//
//  DetailViewController.h
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextField *apodo;
@property (weak, nonatomic) IBOutlet UIImageView *fotoPerfil;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextField *apPaterno;
@property (weak, nonatomic) IBOutlet UITextField *apMaterno;
@property (weak, nonatomic) IBOutlet UITextField *telCelular;
@property (weak, nonatomic) IBOutlet UITextField *telCasa;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *calle;
@property (weak, nonatomic) IBOutlet UITextField *cp;
@property (weak, nonatomic) IBOutlet UITextField *municipio;
@property (weak, nonatomic) IBOutlet UITextField *estado;
@property (weak, nonatomic) IBOutlet UITextField *pais;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditar;

- (IBAction)activarEdicion:(id)sender;
- (IBAction)tomarFoto:(id)sender;
@end

