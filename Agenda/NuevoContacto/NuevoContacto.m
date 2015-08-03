//
//  NuevoContacto.m
//  Agenda
//
//  Created by GuimelGMC on 02/08/15.
//  Copyright (c) 2015 GuimelGMC. All rights reserved.
//

#import "NuevoContacto.h"
#import "CoreDataAPI.h"
#import "ComponentesCompartidosAPI.h"
#import "Contactos.h"

@interface NuevoContacto (){
    Contactos *contacto;
}
@end

@implementation NuevoContacto

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTeclado)];
    [self.view addGestureRecognizer:tap];
    
    [_imagenPerfil setContentMode:UIViewContentModeScaleAspectFill];
    [_imagenPerfil setClipsToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)dismissTeclado {
    [self.view endEditing:YES];
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

- (IBAction)Guardar:(id)sender {
        [self guardarDatos];
    
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
        [_imagenPerfil setImage: chosenImage];
        [_imagenPerfil setContentMode:UIViewContentModeScaleAspectFill];
        [_imagenPerfil setClipsToBounds:YES];
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

#pragma mark- Metodos CoreData

-(void)guardarDatos{
    [self dismissTeclado];
    NSString *res = [self validarCamposRequeridos];
    if ([res length] == 0) {
       
            contacto = [[[CoreDataAPI instanciaCompartida] ejecutaComando:@"insert" conEntidad:@"Contactos" yPredicado:nil] objectForKey:@"newEntity"];
            
            NSData *dataImg = ([_imagenPerfil image]!=nil) ? UIImageJPEGRepresentation([_imagenPerfil image], 0.4) : nil;
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
        
        [self dismissViewControllerAnimated:YES completion:nil];
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