import 'package:tak/Objects/Item.dart';

class SaleItem{
  Item item;
  int amount;
  
  SaleItem({this.item, this.amount});

  double calculateTotal() => this.item.price * this.amount;
}