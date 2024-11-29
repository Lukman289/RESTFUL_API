# Nama  : Lukman Eka Septiawan
# Kelas : TI-3C

# Praktikum 1, Designing an HTTP client and getting data 
> Sebagian besar aplikasi seluler mengandalkan data yang berasal dari sumber eksternal. Pikirkan aplikasi untuk membaca buku, menonton film, berbagi gambar dengan teman, membaca berita, atau menulis email: semua aplikasi ini menggunakan data yang diambil dari sumber eksternal. Ketika sebuah aplikasi menggunakan data eksternal, biasanya, ada layanan backend yang menyediakan data tersebut untuk aplikasi: layanan web atau API web. Yang terjadi adalah aplikasi Anda (frontend atau klien) terhubung ke layanan web melalui HTTP dan meminta sejumlah data. Layanan backend kemudian merespons dengan mengirimkan data ke aplikasi, biasanya dalam format JSON atau XML. Untuk praktikum kali ini, kita akan membuat aplikasi yang membaca dan menulis data dari layanan web. Karena membuat API web berada di luar cakupan buku ini, kita akan menggunakan layanan yang tersedia, yang disebut Wire Mock Cloud, yang akan mensimulasikan perilaku layanan web yang sebenarnya, tetapi akan sangat mudah disiapkan dan digunakan.  
## 1. Mendaftarlah ke layanan Lab Mock di https://app.wiremock.cloud/. Bisa anda gunakan akun google untuk mendaftar. Jika berhasil bendaftar dan login, akan muncul seperti gambar berikut. 

![image for practicum 1 step 1](images/p1-1.png)

## 2. Di halaman dahsboard, klik menu Stubs, kemudian klik entri pertama yaitu “GET a JSON resource”. Anda akan melihat layar yang mirip dengan berikut.

![image for practicum 1 step 2](images/p1-2.png)

## 3. Klik “Create new stub”. Di kolom sebelah kanan, lengkapi data berikut. Namanya adalah “Pizza List”, kemudian pilih GET dan isi dengan “/pizzalist”. Kemudian, pada bagian Response, untuk status 200, kemudian pada Body pilih JSON sebagai formatnya dan isi konten JSON dari https://bit.ly/pizzalist. Perhatikan gambar berikut. 

![image for practicum 1 step 3](images/p1-3.png)

## 4. Tekan tombol SAVE di bagian bawah halaman untuk menyimpan Mock ini. Jika berhasil tersimpan, maka Mock API sudah siap digunakan. 

> Mock berhasil disimpan
![image for practicum 1 step 4](images/p1-4.png)

## 5. Buatlah project flutter baru dengan nama pizza_api_nama_anda, tambahkan depedensi “http” melalui terminal. 

> Project baru

![image for practicum 1 step 5](images/p1-51.png)

> Penambahan depedensi http

![image for practicum 1 step 5](images/p1-52.png)

## 6. DI folder “lib” project anda, tambahkan file dengan nama “httphelper.dart”. 

![image for practicum 1 step 6](images/p1-6.png)

## 7. Isi httphelper.dart dengan kode berikut. Ubah “02z2g.mocklab.io” dengan URL Mock API anda. 

```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pizza.dart';

class HttpHelper {
  final String authority = '02z2g.mocklab.io';
  final String path = '/pizzalist';
  
  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<Pizza> pizzas = jsonResponse.map<Pizza>((i) => Pizza.fromJson(i)).toList();
      return pizzas;
    } else {
      return [];
    }
  }
}
```

## 8. Di file “main.dart”, di class _ MyHomePageState, tambahkan metode bernama “callPizzas”. Metode ini mengembalikan sebuah Future dari daftar objek Pizza dengan memanggil metode getPizzaList dari kelas HttpHelper, dengan kode sebagai berikut: 

```dart
Future<List<Pizza>> callPizzas() async {
    HttpHelper httpHelper = HttpHelper();
    List<Pizza> pizzas = await httpHelper.getPizzaList();
    return pizzas;
}
```

## 9. Pada metode build di class _MyHomePageState, di dalam body Scaffold, tambahkan FutureBuilder yang membuat ListView dari widget ListTile yang berisi objek Pizza:

```dart
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
              return ListTile(
                title: Text(snapshot.data![position].pizzaName),
                subtitle: Text(snapshot.data![position].description + ' - € ' + snapshot.data![position].price.toString()),
              );
            }
          );
        },
      ),
    );
}
```

## 10. Jalankan aplikasi. Anda akan melihat layar yang mirip dengan berikut ini: 

![image for practicum 1 step 10](images/p1-10.png)
