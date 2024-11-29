import 'package:flutter/material.dart';
import 'package:pizza_api_lukman/httphelper.dart';
import 'package:pizza_api_lukman/pizza.dart';
import 'package:pizza_api_lukman/pizza_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Pizza>> callPizzas() async {
    HttpHelper httpHelper = HttpHelper();
    List<Pizza> pizzas = await httpHelper.getPizzaList();
    return pizzas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON'),
      ),
      body: FutureBuilder(
        future: callPizzas(),
        builder: (BuildContext context, AsyncSnapshot<List<Pizza>> snapshot) {
          if (snapshot.hasError) {
            print('Error snapshot: ${snapshot.error}');
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            print('data ${snapshot.data}');
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: (snapshot.data == null) ? 0 : snapshot.data!.length,
            itemBuilder: (BuildContext context, int position) {
              return Dismissible(
                key: Key(position.toString()),
                onDismissed: (item) {
                  HttpHelper helper = HttpHelper();
                  snapshot.data!.removeWhere((element) => element.id == snapshot.data![position].id);
                },
                child: ListTile(
                  title: Text(snapshot.data![position].pizzaName),
                  subtitle: Text(snapshot.data![position].description + ' - € ' + snapshot.data![position].price.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PizzaDetailScreen(pizza: snapshot.data![position], isNew: false,)),
                    );
                  },
                ),
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PizzaDetailScreen(pizza: Pizza(id: 0, pizzaName: '', description: '', price: 0.0, imageUrl: ''), isNew: true,)),
          );
        },
      ),
    );
  }
}
