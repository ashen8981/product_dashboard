import 'package:flutter/material.dart';
import '../../../viewModel/item_viewmodel.dart';

Widget buildItemsList(ItemViewModel viewModel) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Item Name',style: TextStyle(fontSize: 14),)),
          DataColumn(label: Text('Price',style: TextStyle(fontSize: 14),)),
        ],
        rows: viewModel.items.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item.itemName,style: const TextStyle(fontSize: 14),)),
              DataCell(Text('${item.price}',style: const TextStyle(fontSize: 14),)),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
