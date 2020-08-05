import 'dart:async';

import 'package:flutter/material.dart';

void main() { runApp( ByteBankApp() ); }


class ByteBankApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: ListaTransferencia(),
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
                 _criaTransferencia(context);
              },
              child: Text("Cadastrar")
            )
          ]
        )
     );
  }

  void _criaTransferencia(BuildContext context){
      final String _conta = _contrCampoConta.text;
      final double _valor = double.tryParse(_contrCampoValor.text);

      if(_conta != null && _valor != null){
        final transferenciaCriada = Transferencia(_valor, _conta);
        debugPrint(transferenciaCriada._conta);
        Navigator.pop(context, transferenciaCriada);
      } 
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
/*
     CONTROLLER - é um atributo do textfield que pega o que vc digita em um campo
                  e manda para uma variavel que tem que ser do tipo...

     TEXTEDITINGCONTROLLER.

*/
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




class ListaTransferencia extends StatelessWidget{
    
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
          onPressed: (){
            Future<Transferencia> futuro = Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                 return FormularioTransferencia();
              },
            ));

            futuro.then((transferenciaRecebida){
              debugPrint("$transferenciaRecebida");
            });
            
          },
          child: Icon(Icons.add),
        ),  
      );
   }
}

/*

  NAVIGATOR - referente a comportamentos de tela, entrar numa nova ou entrar em uma anterior

  MATERIALPAGEROUTE - nos dá acesso a efeitos de transição de tela. Essa referência implementa
                      um Route<T> que recebe um genérico e, a partir dela, conseguiremos 
                      passar alguns argumentos de modo a navegarmos para a tela esperada.

  builder - dentre os args podemos enviar um builder que faz a implementacao de um callback
            sendo esse callback recebendo um contexto e retornando a widget da pagina 
            buildada (a pagina que a gente quer).

  Future - é basicamente um callback que permite o acesso a resposta durande a navegacao
           Para fazermos esse acesso, é necessario outra função de callback que somente o receberá 
           no momento em que esse retorno acontecer

           ex: Por exemplo, quando entramos na tela de formulário, todo o código no nosso 
            FloatingActionButton já foi executado e não teremos mais acesso a ele.
            Justamente por isso, precisaremos de um comportamento para receber 
            os valores, algo que conseguiremos com o future.then(). Assim, no 
            evento do clique em "Confirmar", por exemplo, executaremos outro código 
            e devolverá os valores a esse Future.
 */


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

