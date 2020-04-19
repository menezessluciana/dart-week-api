import 'package:dart_week_api/dart_week_api.dart';

class LoginRequest extends Serializable {

  String login;
  String senha;

  @override
  Map<String, dynamic> asMap() {
   return {
     'login': login,
     'senha': senha
   };
  }

  @override
  void readFromMap(Map<String, dynamic > object) {
    login = object['login'] as String; // tem que espeficiar o tipo pois foi definido como dynamic acima
    senha = object['senha'] as String;
  }
  //validando obrigatoriedade
  Map<String,String> validate() {
    final Map<String,String> validateResult ={};
    if(login == null  || login.isEmpty) {
      validateResult['login'] = 'Login Obrigatório';
    }

    if(senha == null  || senha.isEmpty) {
      validateResult['senha'] = 'Senha Obrigatório';
    }

    return validateResult;
  }

}