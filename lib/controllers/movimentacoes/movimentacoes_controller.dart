import 'package:dart_week_api/controllers/movimentacoes/dto/salvar_movimentacao_request.dart';
import 'package:dart_week_api/model/usuario_model.dart';
import 'package:dart_week_api/services/movimentacoes_service.dart';
import 'package:intl/intl.dart';

import '../../dart_week_api.dart';

class MovimentacoesController extends ResourceController {

  MovimentacoesController(this.context) : service = MovimentacoesService(context);
  
  final ManagedContext context;
  final MovimentacoesService service;
  @Operation.get('anoMes')
  //busca uma listagem de determinado ano e mes
  Future<Response> buscarTodasMovimentacoes() {
    final anoMes = request.path.variables['anoMes'];
    //Converter ano mes em dateTime
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    //buscar usuário
    final UsuarioModel usuario = request.attachments['user'] as UsuarioModel;
    //poderia salvar em uma variavel e usar async/await
    return service.buscarMovimentacoes(usuario, anoMes)
            //quando monta algo dentro do then, usa função anonima
            .then((data){
              return data.map((m) => {
                'id' : m.id,
                'dataMovimentacao': dateFormat.format(m.dataMovimentacao),
                'descricao' : m.descricao,
                'valor': m.valor,
                'categoria' : {'id' : m.categoria.id, 'nome' : m.categoria.nome, 'tipo' : m.categoria.tipoCategoria.toString().split('.').last}
              }).toList();
            }).then((lista) => Response.ok(lista));
  } 
  @Operation.get('totalAnoMes')
  //Realizando o bind.path diretamente, eu recupero o parametro passado na rota
  Future<Response> recuperarTotalAnoMes(@Bind.path('totalAnoMes') String mesAno) async {
    final usuario = request.attachments['user'] as UsuarioModel;
    final resultado = await service.recuperarTotalMovimentacaoPorTipo(usuario, mesAno);
    return Response.ok(resultado);
  }

  @Operation.post()
  Future<Response> salvarMovimentacao(@Bind.body() SalvarMovimentacaoRequest requestSalvar) async {
    try{
      final validate = requestSalvar.validate();
      if(validate.isNotEmpty){
        return Response.badRequest(body: validate);
      }

      final usuario = request.attachments['user'] as UsuarioModel;
      await service.salvarMovimentacao(usuario, requestSalvar);
      return Response.ok({});
    } catch(e) {
      return Response.serverError(body: {'message' : 'Erro ao salvar movimentacao'});
    }
  }

  
}