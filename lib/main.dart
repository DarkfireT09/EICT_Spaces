import 'package:eict_scheduling_test1/pages/SpaceDetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true
      ),
      home: const MyHomePage(title: 'EICT Spaces')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {},
            ),
          ],
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                children: List.generate(10, (index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                        onTap: () {
                          print('Room $index');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SpaceDetail(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              //width: double.infinity,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                              child: Image.network(
                                'https://picsum.photos/500',
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 24),
                              child: Column(
                                children: [
                                  Text(
                                    'Room $index',
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(
                                    'Disponible hoy ${true}',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  );
                }),
              ),
            )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
        );
  }
}
