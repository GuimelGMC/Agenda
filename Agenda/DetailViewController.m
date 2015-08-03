//
//  DetailViewController.m
//  Agenda
//
//  Created by GuimelGMC on 31/07/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "DetailViewController.h"
#import "Contactos.h"
#import "ComponentesCompartidosAPI.h"
#import "NuevoContacto.h"
#import "CoreDataAPI.h"

@interface DetailViewController (){
    Contactos *contacto;
    NSArray *campos;
}

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        contacto = (Contactos *)_detailItem;
    }
}
-(void)dismissTeclado {
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTeclado)];
    [self.view addGestureRecognizer:tap];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _fotoPerfil.layer.cornerRadius = 150 / 2;
    }else{
        _fotoPerfil.layer.cornerRadius = 120 / 2;
    }
    _fotoPerfil.layer.masksToBounds = YES;
    [_fotoPerfil setContentMode:UIViewContentModeScaleAspectFill];
    [_fotoPerfil setClipsToBounds:YES];
    
    campos = @[_apodo,_nombre,_apPaterno,_apMaterno,_telCelular,_telCasa,_mail,_calle,_cp,_municipio,_estado,_pais];
    for (UITextField *t in campos) {
        [t setDelegate:self];
    }
    
    [self obtenerDatosCoreData];
}

- (IBAction)activarEdicion:(id)sender {
    UIBarButtonItem * btn = (UIBarButtonItem *)sender;
    NSString *tituloBTN = [btn title];
    if ([tituloBTN isEqualToString:@"Editar"]) {
        [_btnCamera setUserInteractionEnabled:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [_btnCamera setAlpha:1];
            [_btnEditar setTitle:@"Guardar"];
            [_apodo setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.5F]];
            [_nombre setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.5F]];
            [_apPaterno setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.5F]];
            [_apMaterno setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.5F]];
            for (UITextField *t in campos) {
                [t setEnabled:YES];
            }
        }];
    }else if ([tituloBTN isEqualToString:@"Guardar"]){
        [UIView animateWithDuration:0.5 animations:^{
            [_btnCamera setAlpha:0];
            [_btnEditar setTitle:@"Editar"];
            [_apodo setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.0F]];
            [_nombre setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.0F]];
            [_apPaterno setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.0F]];
            [_apMaterno setBackgroundColor:[UIColor colorWithRed:1.000000F green:1.000000F blue:1.000000F alpha:0.0F]];
            for (UITextField *t in campos) {
                [t setEnabled:NO];
            }
        }];
        [self guardarDatos];
        [_btnCamera setUserInteractionEnabled:NO];
    }
    
    
}

- (IBAction)tomarFoto:(id)sender {
    UIAlertController *alertaController = [UIAlertController alertControllerWithTitle:@"Imagen de perfil" message:@"Elige una opción:" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *tomarFortografiaAction = [UIAlertAction actionWithTitle:@"Cámara" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self activarCamaraOGaleriaConOpcion:@"Camera"];
    }];
    UIAlertAction *mostrarGaleriaAction = [UIAlertAction actionWithTitle:@"Galería" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self activarCamaraOGaleriaConOpcion:@"Galery"];
    }];
    UIAlertAction *cancelarAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    [alertaController addAction:tomarFortografiaAction];
    [alertaController addAction:mostrarGaleriaAction];
    [alertaController addAction:cancelarAction];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [alertaController setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertaController popoverPresentationController];
        [popPresenter setPermittedArrowDirections:UIPopoverArrowDirectionAny];
        [popPresenter setSourceRect:[_btnCamera frame]];
        [popPresenter setSourceView:self.view];
    }
    [self presentViewController:alertaController animated:YES completion:nil];
    
}
#pragma mark- UIImagePicker
-(void)activarCamaraOGaleriaConOpcion:(NSString *)opcion{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    if ([opcion isEqualToString:@"Camera"]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            [picker setModalPresentationStyle:UIModalPresentationPopover];
            UIPopoverPresentationController *popPresenter = [picker popoverPresentationController];
            [popPresenter setPermittedArrowDirections:UIPopoverArrowDirectionAny];
            [popPresenter setSourceRect:[_btnCamera frame]];
            [popPresenter setSourceView:self.view];
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *chosenImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [_fotoPerfil setImage: chosenImage];
    }];
}

#pragma mark- UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    
    if ([textField isEqual:_telCasa] || [textField isEqual:_telCelular] || [textField isEqual:_cp]) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
            return NO; //Solo Numericos
    }
    
    if ([textField isEqual:_apodo]) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound)
            return NO; //Solo alfanumericos
    }
    
    if([textField isEqual:_nombre] || [textField isEqual: _apPaterno] || [textField isEqual:_apMaterno] || [textField isEqual:_municipio] || [textField isEqual:_pais] || [textField isEqual:_calle]){
        //Acepta Letras con espacios unicamente
        if ([string isEqualToString:@" "]) {
            if (([string rangeOfCharacterFromSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]].location != NSNotFound))
                return NO;
        }else{
            if (([string rangeOfCharacterFromSet:[[NSCharacterSet letterCharacterSet] invertedSet]].location != NSNotFound))
                return NO;
        }
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if([textField isEqual:_nombre] || [textField isEqual: _apPaterno] || [textField isEqual:_apMaterno]){
        if (newLength > 40) return NO;
    }
    else if([textField isEqual: _cp]) {
        if (newLength > 5) return NO;
    }
    else if([textField isEqual:_calle] || [textField isEqual:_municipio] || [textField isEqual:_estado] || [textField isEqual:_pais]) {
        if (newLength > 60) return NO;
    }
    else if([textField isEqual: _apodo]) {
        if (newLength > 50) return NO;
    }
    else if([textField isEqual: _telCelular] || [textField isEqual: _telCasa]) {
        if (newLength > 10) return NO;
    }
    
    return YES;
}


#pragma mark- CoreData Metodos

-(void)obtenerDatosCoreData{
        UIImage *dataImg = [UIImage imageWithData:[contacto conFoto]];
        if (dataImg != nil) {
            [_fotoPerfil setImage:dataImg];
        }
        [_nombre setText:[contacto conNombre]];
        [_apPaterno setText:[contacto conApePaterno]];
        [_apMaterno setText:[contacto conApeMaterno]];
        [_telCelular setText:[contacto conCelular]];
        [_telCasa setText: [contacto conTelFijo]];
        [_mail setText: [contacto conCorreo]];
        [_apodo setText: [contacto conApodo]];
        [_calle setText:[contacto conCalle]];
        [_cp setText: [contacto conCP]];
        [_municipio setText:[contacto conMunicipio]];
        [_estado setText:[contacto conEstado]];
        [_pais setText:[contacto conPais]];
}
-(void)guardarDatos{
    NSString *res = [self validarCamposRequeridos];
    if ([res length] == 0) {
        
        NSData *dataImg = ([_fotoPerfil image]!=nil) ? UIImageJPEGRepresentation([_fotoPerfil image], 0.4) : nil;
        if (dataImg != nil) {
            [contacto setConFoto:dataImg];
        }
        [contacto setConNombre: [_nombre text]];
        [contacto setConApePaterno:[_apPaterno text]];
        [contacto setConApeMaterno:[_apMaterno text]];
        [contacto setConCelular:[_telCelular text]];
        [contacto setConTelFijo:[_telCasa text]];
        [contacto setConCorreo:[_mail text]];
        [contacto setConApodo:[_apodo text]];
        [contacto setConCalle:[_calle text]];
        [contacto setConCP:[_cp text]];
        [contacto setConMunicipio:[_municipio text]];
        [contacto setConEstado:[_estado text]];
        [contacto setConPais:[_pais text]];
        
        [[CoreDataAPI instanciaCompartida] salvarContexto];

    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:res delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}
#pragma mark- Validaciones

-(NSString *)validarCamposRequeridos{
    NSString *res = @"";
    if ([[_nombre text] length] == 0 || [[_apPaterno text] length] == 0 || [[_telCelular text] length] < 10) {
        res = @"Se necesita llenar todos los campos requeridos correctamente.";
    }
    return res;
}

@end
