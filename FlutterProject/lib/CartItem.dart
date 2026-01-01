class CartItem {
  String? userId; // User ID
  String? productId;
  String? productName;
  String? productMark;
  String? productPrice;
  String? productImage;
  int quantity; // Quantity of the product in the cart

  CartItem({
    this.userId,
    this.productId,
    this.productName,
    this.productMark,
    this.productPrice,
    this.productImage,
    this.quantity = 1, // Default quantity is 1
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId,
      'productName': productName,
      'productMark': productMark,
      'productPrice': productPrice,
      'productImage': productImage,
      'quantity': quantity,
    };
  }
}
