import 'package:pos/features/invoice/model/order.dart';

Order createDummyOrder() {
  return Order(
    id: 'INV-DUMMY-123',
    customerName: 'Dummy Customer',
    products: [
      // {
      //   'product': Product(
      //     id: 'P001',
      //     name: 'Dummy Product 1',
      //     description: 'Description for dummy product 1',
      //     sellingPrice: 10.0,
      //     costPrice: 5.0,
      //     stockQuantity: 100,
      //     sku: 'DP001',
      //   ),
      //   'quantity': 2,
      // },
      // {
      //   'product': Product(
      //     id: 'P002',
      //     name: 'Dummy Product 2',
      //     description: 'Description for dummy product 2',
      //     sellingPrice: 25.0,
      //     costPrice: 12.0,
      //     stockQuantity: 50,
      //     sku: 'DP002',
      //   ),
      //   'quantity': 1,
      // },
    ],
    total: 45.0, // 10.0 * 2 + 25.0 * 1
    date: DateTime.now(),
  );
}
