class Imovel {
  final int? id;
  final String titulo;
  final String descricao;
  final double valor;
  final String tipo;
  final String negocio;
  final String? fotoPath;

  Imovel({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.negocio,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'tipo': tipo,
      'negocio': negocio,
      'fotoPath': fotoPath,
    };
  }

  factory Imovel.fromMap(Map<String, dynamic> map) {
    return Imovel(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      valor: map['valor'],
      tipo: map['tipo'],
      negocio: map['negocio'],
      fotoPath: map['fotoPath'],
    );
  }
}
