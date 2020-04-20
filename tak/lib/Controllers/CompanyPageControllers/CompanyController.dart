import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tak/Objects/Company.dart';

class CompanyController{
  final StreamController _streamController = new StreamController.broadcast();

  Sink get input => _streamController.sink;
  Stream get output => _streamController.stream;

  Company _company;

  bool _autovalidate = false;     // Controle de validação do formulário
  bool _editMode = false;         // Controle de permissão de edição do formulário
  final formKey = GlobalKey<FormState>();

  File _image;

  Future setImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this._image = image;
    if(this._image != null){
      List<int> imageBytes = this._image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      this._company.img = base64Image;
      print('\n Imagem: '+this._company.img+'\n');
      // this._streamController.add(this._image);
      this._streamController.add(this._company);
    }
    
  }
  
  void getCompany(){
    this._company = company;
    this._streamController.add(this._company);
  }

  void dispose(){
    this._streamController.close(); 
  }

  bool getAutoValidate() => this._autovalidate;

  void setAutoValidate(bool value){
    this._autovalidate = value;
    this._streamController.add(this._autovalidate);
  }

  bool getEditMode() => this._editMode;

  void setEditMode(bool value){
    this._editMode = value;
    this._streamController.add(this._editMode);
  }

  IconData getIcon() => (this._editMode)? MdiIcons.contentSave : MdiIcons.leadPencil;

  ImageProvider getImage(){ 
    if (this._company.img  == null){ 
      return AssetImage('images/profile.png');
    }else{ 
      Uint8List image = base64Decode(this._company.img);
      return MemoryImage(image);
      //return FileImage(image); 
    }
  }//Image.file(_image);

  // Getters do Formulário
  String getName() => this._company.name;
  String getCNPJ() => this._company.cnpj;
  String getPhoneNumber() => this._company.phoneNumber;
  String getEmail() => this._company.email;
  String getPassword() => this._company.password;

  // Setters do Formulário
  void setName(String value) {
    this._company.name = value;
    this._streamController.add(this._company);
  } 
  void setCNPJ(String value) {
    this._company.cnpj = value;
    this._streamController.add(this._company);
  } 
  void setPhoneNumber(String value) {
    this._company.phoneNumber = value;
    this._streamController.add(this._company);
  } 
  void setEmail(String value) {
    this._company.email = value;
    this._streamController.add(this._company);
  } 
  void setPassword(String value) {
    this._company.password = value;
    this._streamController.add(this._company);
  } 


  
  bool submit(){
    if(this.formKey.currentState.validate()){
      this.formKey.currentState.save();
      return true;
    }else{
      this.setAutoValidate(true);
      return false;
    }
  }
}
