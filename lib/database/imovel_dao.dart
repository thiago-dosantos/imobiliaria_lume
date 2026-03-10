import 'package:sqflite/sqflite.dart';
import '../models/imovel.dart';
import 'db_helper.dart';

class ImovelDao {
  Future<Database> get _db async => await DbHelper().database;

  Future<int> salvar(Imovel imovel) async {
    final dbClient = await _db;
    return await dbClient.insert('imoveis', imovel.toMap());
  }

  Future<List<Imovel>> listarTodos() async {
    final dbClient = await _db;
    final List<Map<String, dynamic>> mapas = await dbClient.query('imoveis');

    return List.generate(mapas.length, (i) {
      return Imovel.fromMap(mapas[i]);
    });
  }

  Future<int> deletar(int id) async {
    final dbClient = await _db;
    return await dbClient.delete('imoveis', where: 'id = ?', whereArgs: [id]);
  }
}
