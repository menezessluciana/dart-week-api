import 'package:dart_week_api/controllers/movimentacoes/dto/salvar_movimentacao_request.dart';
import 'package:dart_week_api/dart_week_api.dart';
import 'package:dart_week_api/model/categoria_model.dart';
import 'package:dart_week_api/model/movimentacao_model.dart';
import 'package:dart_week_api/model/usuario_model.dart';
import 'package:dart_week_api/repository/categoria_repository.dart';
import 'package:intl/intl.dart';

class MovimentacoesRepository {

  MovimentacoesRepository(this.context) : categoriaRepository = CategoriaRepository(context);

  final ManagedContext context;
  final CategoriaRepository categoriaRepository;

  Future<List<MovimentacaoModel>> buscarMovimentacoes(UsuarioModel usuarioModel, String anoMes) {
    final DateFormat format = DateFormat('yyyy_MM_DD');
    final inicio = format.parse('${anoMes.substring(0,4)}_${anoMes.substring(4)}_01');
    final fim = format.parse('${anoMes.substring(0,4)}_${anoMes.substring(4)}_31');

    final query = Query<MovimentacaoModel>(context)
        ..join(object: (m) => m.categoria)
        ..where((m) => m.usuario.id).equalTo(usuarioModel.id)
        ..where((m) => m.dataMovimentacao).between(inicio, fim)
        //ordenação pela data
        ..sortBy((m) => m.dataMovimentacao, QuerySortOrder.descending)
        //ordenação pelo id
        ..sortBy((m) => m.id, QuerySortOrder.descending);
      
      return query.fetch();
  }

  //Calculando o valor total dependendo da categoria por mesAno
  Future<Map<String, dynamic>> recuperarTotalMesAno(UsuarioModel usuario, TipoCategoria tipoCategoria, String anoMes) async {
    final DateFormat format = DateFormat('yyyy_MM_DD');
    final inicio = format.parse('${anoMes.substring(0,4)}_${anoMes.substring(4)}_01');
    final fim = format.parse('${anoMes.substring(0,4)}_${anoMes.substring(4)}_31');

    final query = Query<MovimentacaoModel>(context)
        ..join(object: (m) => m.categoria)
        ..where((m) => m.usuario.id).equalTo(usuario.id)
        ..where((m) => m.dataMovimentacao).between(inicio, fim)
        ..where((m) => m.categoria.tipoCategoria).equalTo(tipoCategoria);

    final List<MovimentacaoModel> resultado = await query.fetch();
   //fold = map,reduce.
   //somatorio do valor das movimentações
   final num total = resultado.fold(0.0,(total,m) => total += m.valor);
    return {'tipo': tipoCategoria.toString(), 'total': total};
  }

  Future<void> salvarMovimentacao(SalvarMovimentacaoRequest request, UsuarioModel usuario) async {
    final categoria = await categoriaRepository.buscarPorId(request.categoria);
    final model = MovimentacaoModel();
    model.categoria = categoria;
    model.dataMovimentacao = request.dataMovimentacao;
    model.descricao = request.descricao;
    model.usuario = usuario;
    model.valor = request.valor;

    await context.insertObject(model);
  }
}