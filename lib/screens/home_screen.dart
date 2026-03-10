import 'dart:io';
import 'package:flutter/material.dart';
import '../database/imovel_dao.dart';
import '../models/imovel.dart';
import 'cadastro_screen.dart';
import 'detalhes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Imovel> listaImoveis = [];

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista() async {
    final dados = await ImovelDao().listarTodos();
    setState(() {
      listaImoveis = dados;
    });
  }

  void _irParaCadastro() async {
    final bool? salvou = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroScreen()),
    );

    if (salvou == true) {
      _atualizarLista();
    }
  }

  void _confirmarExclusao(BuildContext context, Imovel imovel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Realmente quer excluir "${imovel.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await ImovelDao().deletar(imovel.id!);

                Navigator.pop(context);
                _atualizarLista();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Imóvel removido com sucesso')),
                );
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imobiliaria Lume',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF8E402A),
      ),
      body: listaImoveis.isEmpty
          ? const Center(child: Text('Nenhum imóvel cadastrado.'))
          : ListView.builder(
              itemCount: listaImoveis.length,
              itemBuilder: (context, index) {
                final imovel = listaImoveis[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesScreen(imovel: imovel),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: imovel.fotoPath == null
                              ? Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                )
                              : Image.file(
                                  File(imovel.fotoPath!),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                imovel.titulo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Text(
                                '${imovel.tipo} - ${imovel.negocio}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'R\$ ${imovel.valor.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _confirmarExclusao(context, imovel);
                                    },
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: imovel.negocio == 'Venda'
                                          ? Colors.orange[100]
                                          : Colors.green[100],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      imovel.negocio,
                                      style: TextStyle(
                                        color: imovel.negocio == 'Venda'
                                            ? Colors.orange[900]
                                            : Colors.green[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irParaCadastro,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
