//
//  NuevoContacto.h
//  Agenda
//
//  Created by GuimelGMC on 02/08/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NuevoContacto : UITableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imagenPerfil;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextField *apPaterno;
@property (weak, nonatomic) IBOutlet UITextField *apMaterno;
@property (weak, nonatomic) IBOutlet UITextField *telCelular;
@property (weak, nonatomic) IBOutlet UITextField *telCasa;
@property (weak, nonatomic) IBOutlet UITextField *mail;
@property (weak, nonatomic) IBOutlet UITextField *apodo;
@property (weak, nonatomic) IBOutlet UITextField *calle;
@property (weak, nonatomic) IBOutlet UITextField *cp;
@property (weak, nonatomic) IBOutlet UITextField *municipio;
@property (weak, nonatomic) IBOutlet UITextField *estado;
@property (weak, nonatomic) IBOutlet UITextField *pais;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

- (IBAction)tomarFoto:(id)sender;
- (IBAction)Guardar:(id)sender;
- (IBAction)cerrar:(id)sender;


@end
