//Invés de gerar ResoucerController, extende o Controller que é executado numa middleware e depois redirecionado pro proximo controller
import 'package:dart_week_api/services/usuario_service.dart';
import 'package:dart_week_api/utils/jwt_utils.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../dart_week_api.dart';

class JwtAuthentication extends Controller {

  //tudo que vem depois do : ele executa antes de constuir a classe
  JwtAuthentication(this.context) : usuarioService = UsuarioService(context);

  final UsuarioService usuarioService;
  final ManagedContext context;

  @override
  FutureOr<RequestOrResponse> handle(Request request) async {
    // pegando o header da requisição onde virá o token
    final authHeader = request.raw.headers['authorization'];

    //Se authorization vier nulo ou vazio, não autoriza
    if(authHeader == null || authHeader.isEmpty) {
      return Response.unauthorized();
    }
    //?. verifica se não é nulo para executar a segunda ação
    final authHeaderContent = authHeader[0]?.split(" ");

    //Validação do token
    if(authHeaderContent.length != 2 || authHeaderContent[0] != 'Bearer') {
      return Response.badRequest(body: {'message' : 'token inválido'});
    }

    try{
      //posiçao 0 = Bearer, posição 1 = token
      final token = authHeaderContent[1];
      //Validando o token do usuário
      final JwtClaim claimSet = JwtUtils.verificarToken(token);
      //claimSet é um json, e é necessário pegar o id do usuário do campo "sub"que foi informado na geração do token
      final userId = int.tryParse(claimSet.toJson()['sub'].toString());

      if(userId == null) {
        throw JwtException;
      }

      //validar se o token ainda é válido de acordo com a data
      final dataAtual = DateTime.now().toUtc();
      if(dataAtual.isAfter(claimSet.expiry)) {
        //poderia renovar o token invés de não responder como unauthorized
        return Response.unauthorized();
      }

      final usuario = await usuarioService.buscarPorId(userId);
      //adiciona o usuário na request
      request.attachments['user'] = usuario;

      return request;
    }  on JwtException catch(e) {
        print(e);
        return Response.unauthorized();
    }
  }
  
}