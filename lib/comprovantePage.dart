import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ComprovantePage extends StatelessWidget {
  final String destinatario;
  final String remetente;
  final DateTime dataHora;
  final double valor;

  const ComprovantePage({
    required this.destinatario,
    required this.remetente,
    required this.dataHora,
    required this.valor,
  });

  void _compartilhar() {
    final String mensagem = '''
Comprovante de Transferência
Destinatário: $destinatario
Remetente: $remetente
Data e Hora: ${dataHora.toString()}
Valor: R\$ $valor
Instituição: UNAMA PAY
    ''';
    Share.share(mensagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 88, 41),
        title: const Text('Comprovante', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/unama_pay.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Comprovante de Pix enviado',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ $valor',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),                                                                                                      
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Data e hora',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} às ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  'Pix realizado com sucesso!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dados do recebedor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Nome: $destinatario',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Instituição: BCO DO BRASIL S.A',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dados do pagador',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Nome: $remetente',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Instituição: UNAMA PAY',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _compartilhar,
                child: const Text('Compartilhar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}