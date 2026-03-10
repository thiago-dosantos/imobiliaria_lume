import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/imovel_dao.dart';
import '../models/imovel.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  String _tipoImovel = 'Casa';
  String _tipoNegocio = 'Venda';

  File? _fotoSelecionada;

  final ImagePicker _picker = ImagePicker();

  Future<void> _escolherFoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _fotoSelecionada = File(image.path);
      });
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _escolherFoto(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _escolherFoto(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _salvarImovel() async {
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um título.')),
      );
      return;
    }

    try {
      final novoImovel = Imovel(
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        valor: double.tryParse(_valorController.text) ?? 0.0,
        tipo: _tipoImovel,
        negocio: _tipoNegocio,
        fotoPath: _fotoSelecionada?.path,
      );

      await ImovelDao().salvar(novoImovel);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Imóvel', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8E402A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.only(top: 16),
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: 'Título do Imóvel',
                hintText: 'Ex: Apartamento no Centro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Tipo de Imóvel:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField2<String>(
              value: _tipoImovel,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              items: ['Casa', 'Apartamento', 'Terreno'].map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
              onChanged: (novoValor) {
                setState(() {
                  _tipoImovel = novoValor!;
                });
              },
            ),
            const SizedBox(height: 16),

            const Text(
              'Finalidade:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField2<String>(
              value: _tipoNegocio,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              items: ['Venda', 'Aluguel'].map((String valor) {
                return DropdownMenuItem<String>(
                  value: valor,
                  child: Text(valor),
                );
              }).toList(),
              onChanged: (novoValor) {
                setState(() {
                  _tipoNegocio = novoValor!;
                });
              },
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                prefixText: 'R\$',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceOptions(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _fotoSelecionada == null
                          ? const Icon(
                              Icons.photo_camera,
                              size: 80,
                              color: Colors.grey,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _fotoSelecionada!,
                                fit: BoxFit.cover,
                              ),
                            ),
                      ),
                    ),
                  ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _salvarImovel,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Salvar Imóvel', 
                style: TextStyle(
                  color: Color(0xFF8E402A), 
                  fontWeight: FontWeight.w600),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
