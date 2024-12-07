import 'package:flutter/material.dart';
import 'package:item_dashboard/view/common_widget/common_text.dart';
import '../../../utils/app_colors.dart';

class CustomToggleButton extends StatefulWidget {
  final Function(int) onToggle; // Callback to pass the selected index

  const CustomToggleButton({super.key, required this.onToggle});

  @override
  CustomToggleButtonState createState() => CustomToggleButtonState();
}

class CustomToggleButtonState extends State<CustomToggleButton> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = 0);
                widget.onToggle(0); // Notify the parent widget
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? AppColors.customBlue : AppColors.defaultWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  border: Border.all(
                    color: AppColors.customBlue,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: CommonText(
                    'General',
                    style: TextStyle(
                      color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = 1);
                widget.onToggle(1); // Notify the parent widget
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? AppColors.customBlue : AppColors.defaultWhite,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  border: Border.all(
                    color: AppColors.customBlue,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: CommonText(
                    'Items',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
