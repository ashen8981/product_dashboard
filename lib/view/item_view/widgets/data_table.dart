import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../viewModel/item_viewmodel.dart';
import '../../common_widget/common_text.dart';

Widget buildDataTable(BuildContext context, ItemViewModel viewModel) {
  final screenWidth = MediaQuery.of(context).size.width;
  return DataTable(
    columnSpacing: screenWidth*0.05, // Adjust the spacing between columns
    showBottomBorder: false, // Remove the default divider at the bottom
    dividerThickness: 0, // Remove dividers between rows
    headingRowColor: WidgetStateProperty.all(AppColors.customGrey),
    border: const TableBorder(
      horizontalInside: BorderSide(
        color: AppColors.customGrey, // Color of the divider between columns
        width: 1.0, // Divider thickness
      ),
    ),
    columns: const [
      DataColumn(label: CommonText('Item',style: TextStyle(fontSize: 14),)),
      DataColumn(label: CommonText('Price',style: TextStyle(fontSize: 14),)),
      DataColumn(label: CommonText('Qty',style: TextStyle(fontSize: 14),)),
      DataColumn(label: CommonText('Discount',style: TextStyle(fontSize: 14),)),
      DataColumn(label: CommonText('Amount',style: TextStyle(fontSize: 14),)),
    ],
    rows: viewModel.sales
        .map(
          (sale) => DataRow(
            cells: [
              DataCell(CommonText(sale.itemName,style: const TextStyle(fontSize: 14),)),
              DataCell(CommonText(sale.price.toString(),style: const TextStyle(fontSize: 14),)),
              DataCell(CommonText(sale.qty.toString(),style: const TextStyle(fontSize: 14),)),
              DataCell(CommonText('${sale.discount}%',style: const TextStyle(fontSize: 14),)),
              DataCell(CommonText(sale.amount.toStringAsFixed(2),style: const TextStyle(fontSize: 14),)),
            ],
          ),
        )
        .toList(),
  );
}
