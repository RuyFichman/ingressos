import 'package:flutter/material.dart';

void main() {
  runApp(const TicketApp());
}

class TicketApp extends StatelessWidget {
  const TicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ingressos para o Jogo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const TicketFormScreen(),
    );
  }
}

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({super.key});

  @override
  State<TicketFormScreen> createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  final TextEditingController nameController = TextEditingController();

  String selectedGame = 'Palmeiras vs Corinthians';
  String selectedTicketType = 'Arquibancada';

  bool estacionamento = false;
  bool lanche = false;
  bool vipLounge = false;
  bool torcidaCasa = true;

  double quantidade = 1;

  double getTicketPrice(String tipo) {
    if (tipo == 'Arquibancada') return 50;
    if (tipo == 'Cadeira') return 90;
    if (tipo == 'Camarote') return 160;
    return 0;
  }

  double calculateTotal() {
    double total = 0;

    total += getTicketPrice(selectedTicketType) * quantidade;

    if (estacionamento) total += 50;
    if (lanche) total += 20;
    if (vipLounge) total += 90;

    return total;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1F7),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sports_soccer),
            SizedBox(width: 8),
            Text('Ingressos para o Jogo'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedGame,
              decoration: const InputDecoration(
                labelText: 'Jogo',
                border: UnderlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Palmeiras vs Corinthians',
                  child: Text('Palmeiras vs Corinthians'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedGame = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do torcedor',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Tipo de ingresso', style: TextStyle(fontSize: 16)),
            ),
            RadioListTile<String>(
              title: const Text('Arquibancada'),
              value: 'Arquibancada',
              groupValue: selectedTicketType,
              onChanged: (value) {
                setState(() {
                  selectedTicketType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Cadeira'),
              value: 'Cadeira',
              groupValue: selectedTicketType,
              onChanged: (value) {
                setState(() {
                  selectedTicketType = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Camarote'),
              value: 'Camarote',
              groupValue: selectedTicketType,
              onChanged: (value) {
                setState(() {
                  selectedTicketType = value!;
                });
              },
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Serviços adicionais',
                style: TextStyle(fontSize: 16),
              ),
            ),
            CheckboxListTile(
              title: const Text('Estacionamento'),
              value: estacionamento,
              onChanged: (value) {
                setState(() {
                  estacionamento = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Lanche incluso'),
              value: lanche,
              onChanged: (value) {
                setState(() {
                  lanche = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Acesso ao lounge'),
              value: vipLounge,
              onChanged: (value) {
                setState(() {
                  vipLounge = value!;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Torcer para o time da casa'),
              value: torcidaCasa,
              onChanged: (value) {
                setState(() {
                  torcidaCasa = value;
                });
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Quantidade: ${quantidade.toInt()}'),
            ),
            Slider(
              value: quantidade,
              min: 1,
              max: 10,
              divisions: 9,
              label: quantidade.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  quantidade = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  double total = calculateTotal();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        nome: nameController.text,
                        jogo: selectedGame,
                        ingresso: selectedTicketType,
                        quantidade: quantidade.toInt(),
                        torcidaCasa: torcidaCasa,
                        estacionamento: estacionamento,
                        lanche: lanche,
                        vipLounge: vipLounge,
                        total: total,
                      ),
                    ),
                  );
                },
                child: const Text('Comprar ingressos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final String nome;
  final String jogo;
  final String ingresso;
  final int quantidade;
  final bool torcidaCasa;
  final bool estacionamento;
  final bool lanche;
  final bool vipLounge;
  final double total;

  const SummaryScreen({
    super.key,
    required this.nome,
    required this.jogo,
    required this.ingresso,
    required this.quantidade,
    required this.torcidaCasa,
    required this.estacionamento,
    required this.lanche,
    required this.vipLounge,
    required this.total,
  });

  String getServicos() {
    List<String> servicos = [];

    if (estacionamento) servicos.add('Estacionamento');
    if (lanche) servicos.add('Lanche');
    if (vipLounge) servicos.add('VIP Lounge');

    if (servicos.isEmpty) {
      return 'Nenhum';
    }

    return servicos.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F1F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1F7),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sports_soccer),
            SizedBox(width: 8),
            Text('Ingressos para o Jogo'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo da compra',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'HarryP',
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/palmeiras.png', width: 70, height: 70),
                const SizedBox(width: 16),
                const Text('vs', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 16),
                Image.asset('images/corinthians.png', width: 70, height: 70),
              ],
            ),
            const SizedBox(height: 24),
            Text('Nome: $nome'),
            Text('Jogo: $jogo'),
            Text('Ingresso: $ingresso'),
            Text('Quantidade: $quantidade'),
            Text('Torcida: ${torcidaCasa ? 'Casa' : 'Visitante'}'),
            Text('Serviços: ${getServicos()}'),
            const SizedBox(height: 16),
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
