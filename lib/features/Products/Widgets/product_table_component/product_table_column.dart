import 'package:flutter/material.dart';

class ProductTableColumns extends StatelessWidget {
  const ProductTableColumns({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Quantity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Brand',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
        SizedBox(width: 16),
        Text(
          'Action',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ],
    );
  }

  List<DataColumn> getColumns(BuildContext context) {
    return [
      DataColumn(
        label: Text(
          'Title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Quantity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Brand',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Image',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Action',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.012,
          ),
        ),
      ),
    ];
  }
}
