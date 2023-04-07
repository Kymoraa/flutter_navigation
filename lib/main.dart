import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navigator(
        // Instead of returning a screen, we return the Navigator object
        pages: [
          // to keep the screens that we have in the app e.g. the product view and the detail view as pages
          MaterialPage(
            // wrapped in a MaterialPage to be something that can be navigated from/to
            child: ProductsView(
              // the base view/page to be shown when the app is opened
              // in order to pass the selected user up to the page - value changed when a product is selected
              didSelectProduct: (product) {
                // passing this as an argument to update the _selectedProduct to the product selected.
                // Now it won't be null anymore and the second page will be shown

                setState(() => _selectedProduct =
                    product); // to show the details view, we'd need an item to be selected. create a state property to hold the selected product
              },
            ),
          ),
          if (_selectedProduct != null) // you can add control flows in the pages array/list
            MaterialPage(
              child: ProductDetailsView(
                  product: _selectedProduct!), // this page is stacked on top of the first MaterialPage based on the logic specifies
              key: ProductDetailsView.valueKey,
            ),
        ],
        onPopPage: (route, result) {
          final page = route.settings as MaterialPage; // route has property called settings. Just cast it as MaterialPage

          // check the key of the page if it is equal to the valueKey
          if (page.key == ProductDetailsView.valueKey) {
            // make the selected product string empty when we go back (through app bar/soft key)
            // but only if you are in the ProductDetailsView with the const key that you added in the details view
            _selectedProduct = " ";
          }

          return route.didPop(result);
        },
      ),
    );
  }
}

class ProductsView extends StatelessWidget {
  final _products = ["Summer dress", "Skinny jeans", "Hoodie", "Kimono", "Silk scarf"];

  final ValueChanged didSelectProduct;

  ProductsView({super.key, required this.didSelectProduct}); // Pass the value changed property through the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothing'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            child: ListTile(
              title: Text(product),
              onTap: () => didSelectProduct(product), // whenever we select a product - when tapped - pass the product up to the app state
            ),
          );
        },
      ),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  static const valueKey = ValueKey('ProductDetailsView');

  const ProductDetailsView({super.key, required this.product});
  final String product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('$product details'),
      ),
    );
  }
}

/// Navigate 2.0 to navigate app in a declarative way
/// Instead of returning a screen (home: ProductView()), we return the Navigtor object
/// The screen will be changed whenever we have a state change i.e. if we have a selected item, we are going to trigger the navigator to change to a
/// different screen - that is the detail view
///
///
///
///
