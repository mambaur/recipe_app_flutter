import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeDetail extends StatefulWidget {
  const RecipeDetail({Key? key}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        minHeight: size.height * 0.5,
        maxHeight: size.height,
        boxShadow: const [
          BoxShadow(blurRadius: 8.0, color: Color.fromRGBO(0, 0, 0, 0.1))
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        panelBuilder: (controller) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  controller: controller,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "5 Resep Bakwan Enak dan Praktis untuk Camilan Sore Ini",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: const [
                            Icon(Icons.account_circle_rounded,
                                color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text('Wina', style: TextStyle(color: Colors.grey)),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.date_range, color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text('April 20, 2021',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      const ReadMoreText(
                        'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase. Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase, Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase',
                        trimLines: 5,
                        style: TextStyle(color: Colors.black),
                        // colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Lihat Selengkapnya',
                        trimExpandedText: 'Sembunyikan',
                        delimiter: '\n',
                        lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.timer, color: Colors.orange),
                          SizedBox(
                            width: 3,
                          ),
                          Text('3 Jam', style: TextStyle(color: Colors.orange)),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.contact_support, color: Colors.orange),
                          SizedBox(
                            width: 3,
                          ),
                          Text('Cukup Rumit',
                              style: TextStyle(color: Colors.orange)),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.ramen_dining, color: Colors.orange),
                          SizedBox(
                            width: 3,
                          ),
                          Text('2 Porsi',
                              style: TextStyle(color: Colors.orange)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Bahan",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const [
                          Icon(Icons.radio_button_unchecked),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text('2 sdm mentega, lelehkan'),
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.radio_button_unchecked),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text('100 gr biskuit marie'),
                          )
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.radio_button_unchecked),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text('2 buah pisang, potong miring'),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Langkah - langkah",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.orange),
                          child: const Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        title: const Text(
                            'Tuang potongan pisang dan saus karamel'),
                      ),
                      ListTile(
                        leading: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.orange),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        title: const Text(
                            'Beri coklat parut sebagai topping. Simpan dalam freezer lalu sajikan.'),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 7,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        body: Stack(
          children: [
            Container(
              color: Colors.grey.shade300,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.55,
                  child: CustomCachedImage.build(context,
                      imgUrl:
                          'https://www.masakapahariini.com/wp-content/uploads/2021/06/resep-iga-bakar-siap-400x240.jpg'),
                ),
              ),
            ),
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  const Text(
                    "Detail Resep",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
