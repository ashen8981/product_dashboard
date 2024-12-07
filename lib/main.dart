import 'package:flutter/material.dart';
import 'package:item_dashboard/view/item_view/item_form_view.dart';
import 'package:item_dashboard/viewModel/item_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ItemFormView(),
      ),
    );
  }
}
