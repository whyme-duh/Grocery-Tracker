import 'dart:convert';

String exactPrice(String price, String quantity) {
  int Price = int.parse(price);
  int Quantity = int.parse(quantity);
  int exactPrice = Price * Quantity;
  return exactPrice.toString();
}

String jarPrice(String quantity, String price) {
  int quan = int.parse(quantity);
  int p = int.parse(price);
  int exactPrice = p * quan;
  return exactPrice.toString();
}
