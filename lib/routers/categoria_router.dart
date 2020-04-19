import 'package:dart_week_api/config/jwt_authentication.dart';
import 'package:dart_week_api/controllers/categorias/categorias_controller.dart';
import 'package:dart_week_api/dart_week_api.dart';

class CategoriaRouter {

  static void configurar(Router router, ManagedContext context) {
    router
      .route('/categorias/:tipo') //recebe o tipo da categoria pela query
      .link(() => JwtAuthentication(context)) // executa o middleware de authentication
      .link(() => CategoriasController(context));
  }
}