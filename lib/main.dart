import 'package:flutter/material.dart';

void main() { runApp( ByteBankApp() ); }


class ByteBankApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: FormularioTransferencia(),
    );
  }
}

class FormularioTransferencia extends StatelessWidget{

  final TextEditingController _contrCampoConta = TextEditingController();
  final TextEditingController _contrCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text("Criar transferencia"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: ,
                style: TextStyle(
                  fontSize: 24.0,
                ),
                decoration:  InputDecoration(
                  labelText: "Insira a sua conta",
                  hintText: "000-0"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(
                  fontSize: 24.0,
                ),
                decoration:  InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  labelText: "Insira o valor",
                  hintText: "0.00"
                ),
              ),
            ),
            RaisedButton(
              onPressed: (){
                  final String _conta = _contrCampoConta.text;
                  final String _valor = Double.parse(_contrCampoValor);

                  final Transferencia _transferencia = Transferencia(_valor, _conta);
              },
              child: Text("Cadastrar")
            )
          ]
        )
     );
  }
}



class ListaTransferencias extends StatelessWidget{
    
@override
Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text("Transferências"),
        ),
        body: Column(
            children: <Widget>[
               ItemTransferencia(Transferencia(100.00 ,"000-5")),
               ItemTransferencia(Transferencia(450.00 ,"000-6")),
               ItemTransferencia(Transferencia(50.00 ,"000-7")),
            ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),  
      );
   }
}

class ItemTransferencia extends StatelessWidget{

  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia); 

  @override
  Widget build(BuildContext context) {
      return Card(
            child: ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(_transferencia._valor.toString()),
              subtitle: Text("conta: "+ _transferencia._conta.toString()),
            ),
      );
   }
  
  }

class Transferencia {
   final double _valor;
   final String _conta;

   Transferencia(this._valor, this._conta);
}