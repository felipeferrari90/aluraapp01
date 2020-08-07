import 'dart:async';

import 'package:flutter/material.dart';

void main() { runApp( ByteBankApp() ); }


class ByteBankApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: ListaTransferencia(),
       theme: ThemeData(
         primaryColor: Colors.green[900],
         accentColor: Colors.blueAccent[700],    //cor secundaria
         buttonTheme: ButtonThemeData(           //thema de cor para botoes
           buttonColor: Colors.blueAccent[700],
           textTheme: ButtonTextTheme.primary    // cor branca do botao (letra)
         )
       ),
    );
  }
}

class FormularioTransferencia extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia>{
 
  final TextEditingController _contrCampoConta = TextEditingController();
  final TextEditingController _contrCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text("Criar transferencia"),
        ),
        body: SingleChildScrollView ( 
          child: Column(
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




class ListaTransferencia extends StatefulWidget{

  List<Transferencia> _transferencias = List();

  @override
  State<StatefulWidget> createState() {
     return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia>{

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Transferências"),
        ),
        body: ListView.builder(
           itemCount: widget._transferencias.length,
           itemBuilder: (context, indice){
             final transferencia = widget._transferencias[indice];
             return ItemTransferencia(transferencia);
           },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Future<Transferencia> futuro = Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                 return FormularioTransferencia();
              },
            ));

            futuro.then((transferenciaRecebida){
              if (transferenciaRecebida != null){
                  debugPrint("$transferenciaRecebida");
                  widget._transferencias.add(transferenciaRecebida);
              }
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

/*

BUG 1 - o cara vai no formulario, ate preenche um valor mais da um return, ai da erro
SULUCAO - o retorno do pop nao esta fazendo uma validacao para valor nulo, ai nessse caso é 
          nessessario criar um if no futuro.then pra tratar se o valor retornado for nulo

BUG 2 - o cara vai virar a tela pra preencher o formulario e da problemas de espaçamento.
SULUCAO - envolva o column do formulario com outro widget chamado singlechildscrollview, 

BUG 3 - em landscape ainda (tela deitada) ocorre um bug no qual se vc preenche os campos e 
        aperta o back do android  pra confirmar, antes de apertar o botao vc vê que os dados 
        digitados somem

        isso se da ao fato do TextEditingController ser uma referencia que muda o estado e
        conteudo dos widgets.

SOLUCAO - converter o formulario de transferencia de stateless para stateful e reajustar as 
          variaveis criadas la

BUG 4 - aprendemos que o build é usado sempre que fizemos algo ou atualizamos a pagina
        porem, la no future.then se a gente coloca um tempo de 1s pra adicionar a 
        transferencia, quando a gente ver o resultado verificamos que nada foi adicionado
        a lista de transferencias (esse é o risco de trabalharmos com execusoes assincronas)

        porque? simples. o build foi chamado porem a atualizacao por ter vindo 1s nao veio nesse build
        sendo nessessario vc ir na outra tela e voltar pra buildar denovo e assim aparecer
        sua transferencia ja criada

SOLUCAO - setState((){}) - que recebe um callback que dentro dele faz tudo aquilo que a 
                          gente colocar e depois atualiza a tela chamando o build denovo, que só é chamado
                          depois que toda a instrucao dentro de colchetes dentro dele seja executado
      
      agora podemos colocar até 3 minutos de delay pra add a lista que agora funcionara.
    
         





*/