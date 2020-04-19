import 'package:dart_week_api/model/usuario_model.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtUtils {
  //senha de criptografia
  static const String _jwtChavePrivada = 'ioRs1M63BFbKdf6JvBVeluZze4IG7';
  static String gerarTokenJWT(UsuarioModel usuario){
  
 //todos os dados que serão utilizados para geração do token
    final claimSet = JwtClaim(
      issuer: 'http://localhost',
      subject: usuario.id.toString(),
      otherClaims: <String, dynamic>{},
      //tempo de vida do token
      maxAge: const Duration(days: 1)
    );

    final token = 'Bearer ${issueJwtHS256(claimSet,_jwtChavePrivada)}';

    return token;
  }

  static JwtClaim verificarToken(String token) {
    //verificar se o token é válido
    return verifyJwtHS256Signature(token, _jwtChavePrivada);
  }

}