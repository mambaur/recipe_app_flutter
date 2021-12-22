import 'package:flutter/material.dart';
import 'package:recipe_app/recipes/recipe_detail.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    print('Refresing...');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: SizedBox(
              width: 80, child: Image.asset('assets/images/icon_recipe.png')),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
          leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: SafeArea(
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerHeader(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Resep Masakan Indo",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "Coba rasakan nikmatnya",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                decoration: const BoxDecoration(color: Colors.orange),
              ),
              ListTile(onTap: () {}, title: const Text("Beranda")),
              ListTile(onTap: () {}, title: const Text("Kategori")),
              ListTile(onTap: () {}, title: const Text("Tentang Aplikasi")),
              ListTile(onTap: () {}, title: const Text("Versi 1.0.0")),
            ]),
          ),
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.orangeAccent.shade700,
          displacement: 20,
          onRefresh: () => _refresh(),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RecipeDetail();
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Wrap(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height * 0.3,
                          child: CustomCachedImage.build(context,
                              imgUrl:
                                  'https://www.masakapahariini.com/wp-content/uploads/2021/06/resep-iga-bakar-siap-400x240.jpg'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.timer),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('2 Jam'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.contact_support),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('Cukup Rumit'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.ramen_dining),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text('5 Porsi'),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'Resep Iga Bakar Makassar, Menu Mewah Untuk Ide Idul Adha',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
