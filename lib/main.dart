import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Stateful Clicker Counter',
      theme: ThemeData(
        // Application theme data, you can set the colors for the application as
        // you want
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Cadastro de clientes.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _nome = TextEditingController();
  TextEditingController _cep = TextEditingController();
  TextEditingController _rua = TextEditingController();
  TextEditingController _complemento = TextEditingController();
  TextEditingController _bairro = TextEditingController();
  TextEditingController _cidade = TextEditingController();
  TextEditingController _estado = TextEditingController();
  TextEditingController _rendaMensal = TextEditingController();
  TextEditingController _limiteCredito = TextEditingController();

  void _buscaCEP() async {
    if (_cep.text.trim().length == 8) {
      String urlAPI = "https://viacep.com.br/ws/" + _cep.text + "/json/";
      http.Response response;
      response = await http.get(urlAPI);
      Map<String, dynamic> retorno = json.decode(response.body);

      print(retorno["logradouro"].toString());
      print(retorno["bairro"].toString());
      print(retorno["localidade"].toString());
      print(retorno["uf"].toString());
      print(retorno["complemento"].toString());

      setState(() {
        _rua.text = retorno["logradouro"].toString();
        _bairro.text = retorno["bairro"].toString();
        _cidade.text = retorno["localidade"].toString();
        _estado.text = retorno["uf"].toString();
        _complemento.text = retorno["complemento"].toString();
      });
    }
  }

  void _gravar() {
    _buscaCEP();
    setState(() {});
  }

  void _limpar() {
// É necessário se alterar o Estado da aplicação para poder exibir o resultado por isso o setState
    setState(() {
      _nome.text = "";
      _cep.text = "";
      _rua.text = "";
      _complemento.text = "";
      _bairro.text = "";
      _cidade.text = "";
      _estado.text = "";
      _rendaMensal.text = "";
      _limiteCredito.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                    autofocus: true,
                    maxLength: 50,
                    controller: _nome,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_add),
                      border: OutlineInputBorder(),
                      labelText: "Digite seu nome",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 8,
                    controller: _cep,
                    // Conforme inserção do cep, os campos subsequentes serão automaticamente preeenchidos.
                    onChanged: (inputValue) {
                      int? cep = int.tryParse(_cep.text);

                      String rua = _rua.text.toString();
                      String complemento = _complemento.text.toString();
                      String bairro = _bairro.text.toString();
                      String cidade = _cidade.text.toString();
                      String estado = _estado.text.toString();

                      if (cep != 0) {
                        _rua.text = rua;
                        _bairro.text = bairro;
                        _cidade.text = cidade;
                        _estado.text = estado;
                        _complemento.text = complemento;
                      }
                      ;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.add_location_alt_rounded),
                      border: OutlineInputBorder(),
                      labelText: "Digite o CEP",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 11,
                    controller: _rendaMensal,
                    // Conforme a renda mensal for mudando o limite de crédito(30%) acompanha.
                    onChanged: (inputValue) {
                      double? limite = double.tryParse(_rendaMensal.text);
                      if (limite != null) _limiteCredito.text = (limite * 0.3).toString();
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.money),
                      border: OutlineInputBorder(),
                      labelText: "Digite a Renda Mensal",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 11,
                    enabled: false,
                    controller: _limiteCredito,
                    decoration: InputDecoration(
                      icon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                      labelText: "Limite de crédito",
                    )),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 5, 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      primary: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      textStyle: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      _gravar();
                    },
                    child: Text('Procurar'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      primary: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      textStyle: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      _limpar();
                    },
                    child: Text("Limpar"),
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 50,
                    enabled: false,
                    controller: _rua,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Rua",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 50,
                    enabled: false,
                    controller: _bairro,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Bairro",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 50,
                    enabled: false,
                    controller: _cidade,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Cidade",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 2,
                    enabled: false,
                    controller: _estado,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Estado",
                    )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextField(
                    maxLength: 50,
                    enabled: false,
                    controller: _complemento,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Complemento",
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
