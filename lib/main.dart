import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'cotacaoPage.dart';
import 'transferenciaPage.dart';
import 'loginPage.dart';
import 'ComprovantePage.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unama Pay',
      theme: ThemeData(
        hintColor: const Color.fromARGB(255, 0, 0, 0),
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
          '/': (context) => LoginPage(),
          '/home': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            final username = args['username'] as String;
            final balance = args['balance'] as double;
            final password = args['password'] as String;
             return MainPage(username: username, balance: balance, password: password);
          },
          '/cotacao': (context) => const CotacaoPage(),
          '/transferencia': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            final username = args['username'] as String;
            final saldoAtual = args['saldoAtual'] as double;
            final password = args['password'] as String;
            return TransferenciaPage(
              username: username,
              saldoAtual: saldoAtual,
              password: password,
              onTransferenciaRealizada: (valor) {
                final mainPageState = context.findAncestorStateOfType<_MainPageState>();
                if (mainPageState != null) {
                  mainPageState.transferenciaRealizada(valor);
                }
              },
            );
          },
          '/comprovante': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ComprovantePage(
              destinatario: args['destinatario'],
              remetente: args['remetente'],
              dataHora: args['dataHora'],
              valor: args['valor'],
            );
          },
        },
    );
  }
}

class MainPage extends StatefulWidget {
  final String username;
  final double balance;
  final String password;

  const MainPage({required this.username, required this.balance, required this.password});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double saldo = 0;

  @override
  void initState() {
    super.initState();
    saldo = widget.balance;
  }

  void transferenciaRealizada(double valorTransferencia) {
    setState(() {
      saldo -= valorTransferencia;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/1.png',
      'assets/2.png',
      'assets/3.png',
      'assets/4.png',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 88, 41),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/unama_logo.png'),
          ),
        title: Text('Olá, ${widget.username}', 
        style: const TextStyle(color: Colors.white,
        fontSize: 25)
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Saldo',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'R\$ $saldo',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'NOVIDADES PARA VOCÊ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: imgList.map((item) => Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'MOVIMENTAR A CONTA',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/cotacao');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Cotação'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferenciaPage(
                                username: widget.username,
                                saldoAtual: saldo,
                                password: widget.password,
                                onTransferenciaRealizada: transferenciaRealizada,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Transferência'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Extrato'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Pagamento'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Empréstimo'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Investimento'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Sair'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}