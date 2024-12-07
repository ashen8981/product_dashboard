import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:item_dashboard/view/item_view/widgets/data_table.dart';
import 'package:item_dashboard/view/item_view/widgets/item_table.dart';
import 'package:item_dashboard/view/item_view/widgets/toggle_button.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../viewModel/item_viewmodel.dart';
import '../common_widget/common_text.dart';

class ItemFormView extends StatefulWidget {
  const ItemFormView({super.key});

  @override
  ItemFormViewState createState() => ItemFormViewState();
}

class ItemFormViewState extends State<ItemFormView> {
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _discountController = TextEditingController();
  final _reasonController = TextEditingController();
  final TextEditingController _selectedItemController = TextEditingController();
  bool _showItems = false; // Toggle state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<ItemViewModel>(context, listen: false);
      viewModel.fetchItems();
      viewModel.fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ItemViewModel>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.customBlue,
        leading: const Icon(Icons.sticky_note_2_outlined, size: 30, color: AppColors.defaultWhite),
        title: const CommonText(
          'Quotation',
          style: TextStyle(color: AppColors.defaultWhite),
          fontWeight: FontWeight.bold,
          fontSize: 19,
        ),
        actions: [
          const Icon(Icons.u_turn_left_rounded, size: 30, color: AppColors.defaultWhite),
          SizedBox(width:  screenWidth * 0.02),
          const Icon(Icons.check_circle, size: 30, color: AppColors.defaultWhite),
          SizedBox(width:  screenWidth * 0.04)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.005),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.07, right: screenWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    underline: const SizedBox(),
                    value: 'Auckland Offices',
                    items: ['Auckland Offices', 'Other Office']
                        .map((office) => DropdownMenuItem(
                              value: office,
                              child: CommonText(
                                office,
                                style: const TextStyle(color: AppColors.customBlue),
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // Handle office selection
                    },
                  ),
                  CommonText(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    style: const TextStyle(color: AppColors.customBlue),
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildToggleButton(),
            SizedBox(height: screenHeight * 0.009),
            // Conditionally show the items list or the main content
            _showItems
                ? buildItemsList(viewModel) // Show Items List
                : buildMainContent(context, viewModel), // Show Main Form and Data Table
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
      child: CustomToggleButton(
        onToggle: (index) {
          setState(() {
            _showItems = index == 1;
          });
        },
      ),
    );
  }

  Widget _buildNetAmount(ItemViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.customBlue,
      ),
      height: 60,
      alignment: Alignment.center,
      child: CommonText(
        'Net Amount: \$${viewModel.netAmount.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildMainContent(BuildContext context, ItemViewModel viewModel) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNetAmount(viewModel),
          SizedBox(height: screenHeight * 0.02),
          _buildForm(context, viewModel),
          SizedBox(height: screenHeight * 0.02),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: buildDataTable(context,viewModel)),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, ItemViewModel viewModel) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown to select item
        DropdownButton<String>(
          value: viewModel.selectedItem,
          underline: const SizedBox(),
          hint: const CommonText('Item'),
          items: viewModel.items
              .map((item) => DropdownMenuItem(
                    value: item.itemName,
                    child: CommonText(item.itemName),
                  ))
              .toList(),
          onChanged: (value) {
            viewModel.selectItem(value);
            if (value != null) {
              final selectedItem = viewModel.items.firstWhere((item) => item.itemName == value);
              _priceController.text = selectedItem.price.toString();
              // Set the selected item in a non-editable TextField
              _selectedItemController.text = selectedItem.itemName;
            }
          },
          isDense: true,
        ),
        // Non-editable TextField for selected item
        TextField(
          controller: _selectedItemController, // Controller for the selected item
          readOnly: true, // Make the TextField read-only
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(controller: _reasonController, decoration: const InputDecoration(labelText: 'Reason')),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Price'),
          readOnly: true,
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Quantity TextField
            Flexible(
              child: TextField(
                controller: _qtyController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Qty'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // Discount TextField with input validation
            Flexible(
              child: TextField(
                controller: _discountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Discount (%)'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow numbers and decimals
                ],
                onChanged: (value) {
                  double discount = double.tryParse(value) ?? 0.0;
                  if (discount < 0) {
                    _discountController.text = '0'; // Set to 0 if less than 0
                    _discountController.selection = const TextSelection.collapsed(offset: 1); // Keep cursor at the end
                  } else if (discount > 100) {
                    _discountController.text = '100'; // Set to 100 if greater than 100
                    _discountController.selection = const TextSelection.collapsed(offset: 3); // Keep cursor at the end
                  }
                },
              ),
            ),

            // Add Button
            Column(
              children: [
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () {
                    final qty = _qtyController.text;

                    // Validate the form using the ViewModel's validateForm method
                    if (viewModel.validateForm(qty)) {
                      final price = double.tryParse(_priceController.text) ?? 0.0;
                      final discount = double.tryParse(_discountController.text) ?? 0.0;
                      viewModel.addSale(price, int.tryParse(qty) ?? 0, discount, _reasonController.text);
                      _clearFields();
                    } else {
                      // Show an error message if validation fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in required fields.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.customBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const CommonText(
                    'ADD',
                    style: TextStyle(color: AppColors.defaultWhite),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void _clearFields() {
    _priceController.clear();
    _qtyController.clear();
    _discountController.clear();
    _reasonController.clear();
    _selectedItemController.clear();
  }
}
