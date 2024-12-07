import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../viewModel/item_viewmodel.dart';
import '../../common_widget/common_text.dart';

Widget buildDataTable(BuildContext context, ItemViewModel viewModel) {
  final screenWidth = MediaQuery.of(context).size.width;

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Allow horizontal scrolling
    child: SizedBox(
      width: screenWidth, // Set the container width to the screen width
      child: Table(
        border: TableBorder.all(
          color: AppColors.customGrey, // Set border color for the table
          width: 1.0, // Set border thickness
        ),
        columnWidths: {
          0: const IntrinsicColumnWidth(),
          1: FixedColumnWidth(screenWidth * 0.2),
          2: FixedColumnWidth(screenWidth * 0.1),
          3: FixedColumnWidth(screenWidth * 0.15),
          4: FixedColumnWidth(screenWidth * 0.2),
        },
        children: [
          // Header Row
          TableRow(
            decoration: const BoxDecoration(color: AppColors.customGrey),
            children: [
              _buildTableRCell('Item'),
              _buildTableRCell('Price'),
              _buildTableRCell('Qty'),
              _buildTableRCell('Discount'),
              _buildTableRCell('Amount'),
            ],
          ),
          // Data Rows
          for (var sale in viewModel.sales)
            TableRow(
              children: [
                _buildTableCell(sale.itemName),
                _buildTableCell(sale.price.toString()),
                _buildTableCell(sale.qty.toString()),
                _buildTableCell('${sale.discount}%'),
                _buildTableCell(sale.amount.toStringAsFixed(2)),
              ],
            ),
        ],
      ),
    ),
  );
}

Widget _buildTableCell(String text) {
  return TableCell(
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: CommonText(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ),
  );
}

Widget _buildTableRCell(String text) {
  return TableCell(
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: CommonText(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
