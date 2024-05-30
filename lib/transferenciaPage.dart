import 'package:flutter/material.dart';

class TransferenciaPage extends StatefulWidget {
  final String username;
  final double saldoAtual;
  final String password;
  final Function(double) onTransferenciaRealizada;

  const TransferenciaPage({
    required this.username,
    required this.saldoAtual,
    required this.password,
    required this.onTransferenciaRealizada,
  });

  @override
  _TransferenciaPageState createState() => _TransferenciaPageState();
}

class _TransferenciaPageState extends State<TransferenciaPage> {
  final TextEditingController destinatarioController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  void transferir() async {
    String destinatario = destinatarioController.text;
    String valorTexto = valorController.text;

    if (valorTexto.isEmpty) {
      _exibirErro('Por favor, insira um valor para a transferência.');
      return;
    }

    double? valor = double.tryParse(valorTexto);

    if (valor == null) {
      _exibirErro('Por favor, insira um valor numérico válido.');
      return;
    }

    if (valor <= 0) {
      _exibirErro('Por favor, insira um valor positivo para a transferência.');
      return;
    }

    if (valor > widget.saldoAtual) {
      _exibirErro('Saldo insuficiente para realizar a transferência.');
      return;
    }

    bool? senhaValida = await _solicitarSenha();
    if (senhaValida != true) {
      if (senhaValida == false) {
        _exibirErro('Senha incorreta.');
      }
      return;
    }

    widget.onTransferenciaRealizada(valor);

    DateTime dataHora = DateTime.now();
    String remetente = widget.username;

    Navigator.pushNamed(
      context,
      '/comprovante',
      arguments: {
        'destinatario': destinatario,
        'remetente': remetente,
        'dataHora': dataHora,
        'valor': valor,
      },
    );

    destinatarioController.clear();
    valorController.clear();
  }

  Future<bool?> _solicitarSenha() async {
    TextEditingController senhaController = TextEditingController();
    bool? senhaCorreta;

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insira sua senha para continuar'),
        content: TextField(
          controller: senhaController,
          decoration: const InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (senhaController.text == widget.password) {
                senhaCorreta = true;
                Navigator.pop(context, true);
              } else {
                senhaCorreta = false;
                Navigator.pop(context, false);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    return senhaCorreta;
  }

  void _exibirErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 88, 41),
        elevation: 0,
        title: const Text(
          'Transferência',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/pix.png',
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: destinatarioController,
                decoration: const InputDecoration(labelText: 'Destinatário'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: valorController,
                decoration: const InputDecoration(labelText: 'Valor da Transferência'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: transferir,
                child: const Text('Transferir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}