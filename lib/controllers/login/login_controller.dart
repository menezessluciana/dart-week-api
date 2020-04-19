import 'package:dart_week_api/controllers/login/dto/login_request.dart';
import 'package:dart_week_api/services/usuario_service.dart';
import 'package:dart_week_api/dart_week_api.dart';

class LoginController extends ResourceController {
  LoginController(this.context) : usuarioService = UsuarioService(context);

  final ManagedContext context;
  final UsuarioService usuarioService;

  //METODO POST
  //para mapear a requisição que está vindo para esse objeto é usado o bind
  //definindo como async ele já entende que é um future response
  @Operation.post()
  Future<Response> login(@Bind.body() LoginRequest request) async {
    //pega o validate do dto login_request, verifica se não tá vazio(se há erro)
     final validate = request.validate();
     if(validate.isNotEmpty) {
       return Response.badRequest(body: validate);
     } 
    final token = await usuarioService.login(request);
    // print(token);
    // print(request.asMap());
    return Response.ok({'autenticado': token != null, 'token': token});
  }
}