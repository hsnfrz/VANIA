import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/customer.dart';
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {

     Future<Response> store(Request request) async {
      try {
        // Validasi input
        request.validate({
          'cust_id': 'required|string|max_length:5',
          'cust_name': 'required|string|max_length:50',
          'cust_address': 'required|string|max_length:50',
          'cust_city': 'required|string|max_length:20',
          'cust_state': 'required|string|max_length:5',
          'cust_zip': 'required|string|max_length:7',
          'cust_country': 'required|string|max_length:25',
          'cust_tel': 'required|string|max_length:15',
        }, {
          'cust_id.required': 'ID pelanggan wajib diisi.',
          'cust_id.string': 'ID pelanggan harus berupa teks.',
          'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
          'cust_name.required': 'Nama pelanggan wajib diisi.',
          'cust_name.string': 'Nama pelanggan harus berupa teks.',
          'cust_name.max_length': 'Nama pelanggan maksimal 50 karakter.',
          'cust_address.required': 'Alamat wajib diisi.',
          'cust_address.string': 'Alamat harus berupa teks.',
          'cust_address.max_length': 'Alamat maksimal 50 karakter.',
          'cust_city.required': 'Kota wajib diisi.',
          'cust_city.string': 'Kota harus berupa teks.',
          'cust_city.max_length': 'Kota maksimal 20 karakter.',
          'cust_state.required': 'Provinsi wajib diisi.',
          'cust_state.string': 'Provinsi harus berupa teks.',
          'cust_state.max_length': 'Provinsi maksimal 5 karakter.',
          'cust_zip.required': 'Kode pos wajib diisi.',
          'cust_zip.string': 'Kode pos harus berupa teks.',
          'cust_zip.max_length': 'Kode pos maksimal 7 karakter.',
          'cust_country.required': 'Negara wajib diisi.',
          'cust_country.string': 'Negara harus berupa teks.',
          'cust_country.max_length': 'Negara maksimal 25 karakter.',
          'cust_tel.required': 'Nomor telepon wajib diisi.',
          'cust_tel.string': 'Nomor telepon harus berupa teks.',
          'cust_tel.max_length': 'Nomor telepon maksimal 15 karakter.',
        });


        // Ambil data input
        final customerData = request.input();


        // Cek apakah pelanggan dengan ID ini sudah ada
        final existingCustomer = await Customer()
            .query()
            .where('cust_id', '=', customerData['cust_id'])
            .first();


        if (existingCustomer != null) {
          return Response.json({
            'message': 'Pelanggan dengan ID ini sudah ada.',
          }, 409);
        }


        // Simpan data ke database
        await Customer().query().insert(customerData);


        return Response.json({
          'message': 'Pelanggan berhasil ditambahkan.',
          'data': customerData,
        }, 201);
      } catch (e, stackTrace) {
        print('Error: $e');
        print('Stack Trace: $stackTrace');
        if (e is ValidationException) {
          return Response.json({
            'errors': e.message,
          }, 400);
        } else {
          return Response.json({
            'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
            'error': e.toString(), // Tambahkan untuk membantu debugging
          }, 500);
        }
      }
    }

    Future<Response> show() async {
    try {
      // Mengambil semua data pelanggan
      final listCustomers = await Customer().query().get();

      return Response.json({
        'message': 'Daftar pelanggan.',
        'data': listCustomers,
      }, 200); // HTTP Status Code 200 OK
    } catch (e) {
      // Menangani kesalahan
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data pelanggan.',
        'error': e.toString(),
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }

  // Fungsi untuk memperbarui data pelanggan
  Future<Response> update(Request request, String id) async {
    try {
      // Validasi input dari pengguna
      request.validate({
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_tel': 'required|string|max_length:15',
      }, {
        'cust_name.required': 'Nama pelanggan wajib diisi.',
        'cust_name.string': 'Nama pelanggan harus berupa teks.',
        'cust_name.max_length': 'Nama pelanggan maksimal 50 karakter.',
        'cust_address.required': 'Alamat pelanggan wajib diisi.',
        'cust_address.string': 'Alamat pelanggan harus berupa teks.',
        'cust_address.max_length': 'Alamat pelanggan maksimal 50 karakter.',
        'cust_city.required': 'Kota pelanggan wajib diisi.',
        'cust_city.string': 'Kota pelanggan harus berupa teks.',
        'cust_city.max_length': 'Kota pelanggan maksimal 20 karakter.',
        'cust_state.required': 'Provinsi pelanggan wajib diisi.',
        'cust_state.string': 'Provinsi pelanggan harus berupa teks.',
        'cust_state.max_length': 'Provinsi pelanggan maksimal 5 karakter.',
        'cust_zip.required': 'Kode pos pelanggan wajib diisi.',
        'cust_zip.string': 'Kode pos pelanggan harus berupa teks.',
        'cust_zip.max_length': 'Kode pos pelanggan maksimal 7 karakter.',
        'cust_country.required': 'Negara pelanggan wajib diisi.',
        'cust_country.string': 'Negara pelanggan harus berupa teks.',
        'cust_country.max_length': 'Negara pelanggan maksimal 25 karakter.',
        'cust_tel.required': 'Telepon pelanggan wajib diisi.',
        'cust_tel.string': 'Telepon pelanggan harus berupa teks.',
        'cust_tel.max_length': 'Telepon pelanggan maksimal 15 karakter.',
      });

      // Ambil data input pelanggan
      final customerData = request.input();

      // Cari pelanggan berdasarkan ID
      final customer =
          await Customer().query().where('cust_id', '=', id).first();
      print('ID yang diterima: $id');

      if (customer == null) {
        return Response.json({
          'message': 'Pelanggan dengan ID $id tidak ditemukan.',
        }, 404); // HTTP Status Code 404 Not Found
      }

      print(customerData); // Untuk memeriksa nilai customerData

      customerData.remove('id'); // Hapus 'id' jika 'id' adalah primary key
      await Customer().query().where('cust_id', '=', id).update(customerData);

      // Kembalikan respons sukses dengan status 200 OK
      return Response.json({
        'message': 'Pelanggan berhasil diperbarui.',
        'data': customerData,
      }, 200); // HTTP Status Code 200 OK
    } catch (e) {
      // Menangani kesalahan validasi
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'errors': errorMessages,
        }, 400); // HTTP Status Code 400 Bad Request
      }

      // Menangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
      }, 500); // HTTP Status Code 500 Internal Server Error
    }
  }

  Future<Response> destroy(Request request, dynamic id) async {
    try {
      // Konversi id ke String
      final String custId = id.toString();

      // Cari customer berdasarkan id
      final customer = await Customer()
          .query()
          .where('cust_id', '=', custId)
          .first();

      if (customer == null) {
        return Response.json({
          'message': 'Pelanggan dengan ID $custId tidak ditemukan.',
        }, 404);
      }

      // Hapus customer
      await Customer().query().where('cust_id', '=', custId).delete();

      return Response.json({
        'message': 'Pelanggan berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomerController customerController = CustomerController();


