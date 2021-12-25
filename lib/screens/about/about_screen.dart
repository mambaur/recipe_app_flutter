import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang Aplikasi',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: SizedBox(
                      width: 150,
                      child: Image.asset('assets/images/icon_recipe.png'))),
              const Text(
                  'Aplikasi Resep Masakan Indonesia Lengkap, kali ini hadir untuk memudahkan anda dalam membuat makanan lezat. Terdapat ratusan resep makanan indonesia dengan segala rasa yang menakjubkan. Dengan aplikasi ini, anda dapat membuat makanan baru dengan cepat, tanpa perlu membeli buku resep makanan. Anda dapat menggunakan aplikasi ini secara grat'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  'Didalam aplikasi ini tersedia fitur pencarian resep makanan . Sehingga anda tidak perlu khawatir jika ingin mencari makanan favorit anda dengan cepat. Banyak pilihan makanan yang tersedia di berbagai daerah, semoga anda tidak bingung ingin membuat makanan apa saja hari ini.'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  'Aplikasi Resep Makanan Indonesia ini didesain dengan tampilan yang menarik dan mudah dipahami. Sehingga anda akan merasa nyaman jika menggunakan aplikasi ini. Aplikasi ini sangat simpel, tidak ribet untuk anda yang baru menggunakan sekalipun..'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  'Kami sangat terbuka untuk mendengarkan masukan dan saran dari anda jika ada untuk pengembangan aplikasi ini menjadi lebih baik lagi. Masukan maupun saran dapat anda kirimkan langsung di email kami support@caraguna.com.'),
              const SizedBox(
                height: 15,
              ),
            ],
          )),
    );
  }
}
