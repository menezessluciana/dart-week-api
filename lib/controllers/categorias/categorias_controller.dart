import 'package:dart_week_api/model/categoria_model.dart';
import 'package:dart_week_api/services/categoria_service.dart';

import '../../dart_week_api.dart';

class CategoriasController extends ResourceController {
  
  CategoriasController(this.context) : service = CategoriaService(context);

  final CategoriaService service;

  final ManagedContext context;

  @Operation.get('tipo')
  Future<Response> buscarCategoriasPorTipo() async {
    try{
    //ResouceController deixa o request disponivel
    //recuperando o parametro tipo da request
    final tipo = request.path.variables['tipo'];

    //transformar o tipo em ENUM conforme está definido no model
    //TipoCategoria.values retornaria:
    //TipoCategoria.receita e TipoCategoria.despesa
    //Para encontrar apenas o tipo, faz um split com . e pega o last(ultimo) que é o tipo de fato.
    final tipoCategoria = TipoCategoria.values.firstWhere((t) => t.toString().split('.').last == tipo);
    
    //buscarCategoriaPorTipo é do tipo FUTURE então permite o uso de THEN
    return service
          .buscarCategoriaPorTipo(tipoCategoria)
          //faz a conversão da lista para o map pois o Response só aceita nesse formato. Um list de MAP.
          .then((res) => res.map((c) => {'id': c.id, 'nome' : c.nome}).toList())
          .then((data) => Response.ok(data));

    }catch (e) {
      print(e);
      return Response.serverError(body: {'message' : e.toString()});
    }

  }
}