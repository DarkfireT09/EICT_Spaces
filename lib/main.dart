import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eict_scheduling_test1/pages/login.dart';
import 'package:eict_scheduling_test1/pages/space_Detail.dart';
import 'package:eict_scheduling_test1/ui/widgets/dialogs/filter_dialog.dart';
import 'package:eict_scheduling_test1/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:eict_scheduling_test1/utils/DateController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth AuthInstance = FirebaseAuth.instance;
    var user = AuthInstance.currentUser;

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
        ),
        home: user == null ? LoginForm() : MyHomePage(title: 'EICT Spaces'));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DateController controller = Get.put(DateController());
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.aspectRatio);
    var as = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginForm(),
                ),
              );
            },
          ),
        ],
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: FutureBuilder(
            future: getSpaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List? spaces = snapshot.data?.toList();
                  return Center(
                    child: GridView.builder(
                        itemCount: spaces?.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (2/3)*(as > 0.7 ? 1 : as*1.5),
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                onTap: () {
                                  controller.setSpaceId(spaces?[index]['id']);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SpaceDetail(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      //width: double.infinity,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      child: Image.network(
                                        'https://picsum.photos/500',
                                        width: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            spaces?[index]['name'] ??
                                                'Sin nombre',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${spaces?[index]['campus']} - ${spaces?[index]['location']}' ??
                                                'Sin ubicación',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            textAlign: TextAlign.center
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.people),
                                                Text(
                                                  '${spaces?[index]['student_capacity'] ?? 'Sin capacidad'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center
                                                ),
                                                const SizedBox(
                                                  width: 24,),
                                                const Icon(Icons.computer),
                                                Text(
                                                  '${spaces?[index]['equipment_amount'] ?? 'Sin equipos'}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center
                                                ),
                                              ]),

                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No data',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => getFilterDialog(context)
        ),
        tooltip: 'Filtrar',
        icon: const Icon(Icons.tune),
        label: Text('Filtrar'),
      ),
    );
  }
}
