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
            CampoEditor( 
              controller: _contrCampoConta,
              rotulo: "Digite uma conta",
              dica: "0.00",
            ),
            CampoEditor( 
              icone: Icons.monetization_on,
              controller: _contrCampoValor,
              rotulo: "Digite um valor",
              dica: "000-0",
            ),
            RaisedButton(
              onPressed: (){
                 _criaTransferencia();
              },
              child: Text("Cadastrar")
            )
          ]
        )
     );
  }

  void _criaTransferencia(){
      final String _conta = _contrCampoConta.text;
      final double _valor = double.tryParse(_contrCampoValor.text);

      if(_conta != null && _valor != null){
        final transferenciaCriada = Transferencia(_valor, _conta);
        debugPrint(transferenciaCriada._conta);
  }
}



}

class CampoEditor extends StatelessWidget {

  final TextEditingController controller;
  final String rotulo;
  final String dica;
  IconData icone;

  CampoEditor({this.icone,this.rotulo, this.dica, this.controller});

  @override
  Widget build(BuildContext context) {
     return Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 24.0,
                ),
                decoration:  InputDecoration(
                  icon: icone != null ? Icon(icone) : null ,
                  labelText: rotulo,
                  hintText: dica,
                ),
              ),
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

