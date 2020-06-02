// Função que verifica se o Código de Barras, padrão EAN-13, é válido
String ean13Validator(String value){

  if(value.length < 13){ 
    return 'Precisa de 13 Dígitos'; 
  }else if(value == ('0'*13)){ 
    return 'Código Inválido'; 
  }

  int counter = 0;
  bool flag = false;          // Bandeira de fazer a multiplicação por 1 (false) ou 3 (true)

  for (int index = 0; index < 12; index++) {
    
    int number = int.tryParse(value[index]);
    int weight = 1;

    if(number == null){
      return 'Código Inválido';
    }

    if(flag){weight = 3;}
    
    counter += number * weight;
    
    flag = !flag;           // Inverte o valor da bandeira
    
  }

  int vd;
  if((counter % 10) == 0){
    vd = 0;
  }else{
    int number = (counter/10).truncate();  // Arredonda o valor pra baixo
    number = (number + 1) * 10; 
    vd = number - counter;
  }
  
  int vdValue = int.tryParse(value[(value.length - 1)]);  // Pega o digito verificador do código informado
  if((vdValue == null) || (vd != vdValue)){
    return 'Código Inválido';
  }

  return null;

} 