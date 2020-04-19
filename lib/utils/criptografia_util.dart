import 'dart:convert';
import 'package:crypto/crypto.dart';
class CriptografiaUtils {

  static String criptografarSenha(String senha) {
    //FAZENDO A CRIPTOGRAFIA DA SENHA
    final senhaBytes = utf8.encode(senha);
    return sha256.convert(senhaBytes).toString();
  }
}