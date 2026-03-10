import 'dart:io';
import 'package:flutter/material.dart';
import '../models/imovel.dart';

class DetalhesScreen extends StatelessWidget{
  final Imovel imovel;

  const DetalhesScreen({super.key, required this.imovel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imovel.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF8E402A),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imovel.fotoPath != null ?
                Image.file(
                  File(imovel.fotoPath!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ) :
                Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100, color: Colors.grey)
                ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${imovel.valor.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent,
                        ),
                      ),
                      Chip(
                        label: Text(imovel.negocio),
                        backgroundColor: imovel.negocio == 'Venda' ? Colors.orange[100] : Colors.green[100],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    imovel.tipo,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),

                  const Divider(height: 30, thickness: 1),

                  const Text(
                    'Descrição',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    imovel.descricao.isEmpty ? 'Sem descrição informada' : imovel.descricao,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}