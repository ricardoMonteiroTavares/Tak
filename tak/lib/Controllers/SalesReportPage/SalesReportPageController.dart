import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tak/Objects/Company.dart';
import 'package:tak/Objects/Sale.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tak/Theme/theme.dart';

class SalesReportPageController{
  final StreamController _streamController = new StreamController.broadcast();

  Sink get input => _streamController.sink;                   // Entrada de dados da SalesReportPage
  Stream get output => _streamController.stream;              // Saída de dados do Controller
  Future get close => _streamController.close();              // Fechamento da Stream

  List<Sale> _list;

  Map _states = {
    'phrases': ['Hoje', 'Semana', 'Mês', 'Trimestre', 'Tudo'],
    'index': 0
  };

  void getListByDate(){
    if(company.sales.length != 0){
      DateTime date = new DateTime.now();
      int index;
      switch(this._states['index']){
        // Vendas no dia
        case 0:
          for(index = (company.sales.length - 1); (index >= 0) && (date.difference(DateTime.parse(company.sales[index].date)).inDays == 0); index--){}
          break;
        
        // Vendas na semana
        case 1:
         // index = -1;
          int difference = date.weekday - 1;                // Vejo a quantidade de dias necessárias para retornar para segunda-feira (valor = 1)
          date = date.subtract(Duration(days: difference));
          for(index = (company.sales.length - 1); (index >= 0) && (date.difference(DateTime.parse(company.sales[index].date)).inDays <= 0) && (date.difference(DateTime.parse(company.sales[index].date)).inDays >= -6); index--){}
          break;

        // Vendas no mês
        case 2:
          for(index = (company.sales.length - 1); (index >= 0) && (date.month == DateTime.parse(company.sales[index].date).month); index--){}
          break;

        // Vendas no trimestre
        case 3:
          int referenceMonth;
          if((1 >= date.month) || (date.month <= 3)){       referenceMonth = 1;
          }else if((4 >= date.month) || (date.month <= 6)){ referenceMonth = 4;
          }else if((7 >= date.month) || (date.month <= 9)){ referenceMonth = 7;
          }else{                                            referenceMonth = 10;}

          for(index = (company.sales.length - 1); (index >= 0) && ((DateTime.parse(company.sales[index].date).month - referenceMonth) >= 0) && ((DateTime.parse(company.sales[index].date).month - referenceMonth) <= 2); index--){}
          break;

        // Vendas totais
        case 4:
          index = -1;
          break;
      }
      
      index++;
      this._list = company.sales.sublist(index, company.sales.length);
    }else{
      this._list = [];
    }
    this._streamController.add(this._list);
  }

  int get len => this._list.length;

  double get amount {
    double total = 0;
    for (Sale sale in this._list) {
      total += sale.total;
    }
    return total;
  }

  String get phrase => this._states['phrases'][this._states['index']];

  void increment(){
    int pos = this._states['index'] + 1;
    if(pos == this._states['phrases'].length){
      pos = 0;
    }
    this._states['index'] = pos;
    this.getListByDate();
    this._streamController.add(this._states);
  }

  void decrement(){
    int pos = this._states['index'] - 1;
    if(pos < 0){
      pos = this._states['phrases'].length - 1;
    }
    this._states['index'] = pos;
    this.getListByDate();
    this._streamController.add(this._states);
  }

  List<PieChartSectionData> methodSegments(){
    // Aqui vai ficar o total de cada um dos métodos de pagamento utilizados
    // Posição: 0 - Dinheiro, 1 - Cartão de Débito e 2 - Cartão de Crédito 
    List methods = [0,0,0];         
    for (Sale sale in this._list){
      switch (sale.methodPayment) {
        case 1:
          methods[0]++;
          break;
        case 2:
          methods[1]++;
          break;
        case 3:
          methods[2]++;
          break;
      }
    }

    List<PieChartSectionData> list = [
      new PieChartSectionData(
        color: success_color,
        value: double.parse(methods[0].toString()),
        title: (methods[0] != 0)? methods[0].toString(): '',
        radius: 70,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: background_color)
      ),
      new PieChartSectionData(
        color: primary_color,
        value: double.parse(methods[1].toString()),
        title: (methods[1] != 0)? methods[1].toString(): '',
        radius: 70,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: background_color)
      ),
      new PieChartSectionData(
        color: danger_color,
        value: double.parse(methods[2].toString()),
        title: (methods[2] != 0)? methods[2].toString(): '',
        radius: 70,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: background_color)
      ),
    ];
    return list;
  }
}