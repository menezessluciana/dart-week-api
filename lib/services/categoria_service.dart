import 'package:dart_week_api/dart_week_api.dart';
import 'package:dart_week_api/model/categoria_model.dart';
import 'package:dart_week_api/repository/categoria_repository.dart';

class CategoriaService {
  
  CategoriaService(this.context) : repository = CategoriaRepository(context);

  final ManagedContext context;
  final CategoriaRepository repository;

  Future<List<CategoriaModel>> buscarCategoriaPorTipo(TipoCategoria tipo) {
      return repository.buscarCategoriaPorTipo(tipo);
  }
}