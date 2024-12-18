import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/vendor.dart';
import 'package:vania/src/exception/validation_exception.dart';

class VendorController extends Controller {

     Future<Response> index() async {
          return Response.json({'message':'Hello World'});
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
      try {
        // Validasi input
        request.validate({
          'vend_id': 'required|string|max_length:5',
          'vend_name': 'required|string|max_length:50',
          'vend_address': 'required|string',
          'vend_kota': 'required|string',
          'vend_state': 'required|string|max_length:5',
          'vend_zip': 'required|string|max_length:7',
          'vend_country': 'required|string|max_length:25',
        }, {
          'vend_id.required': 'ID vendor wajib diisi.',
          'vend_id.string': 'ID vendor harus berupa teks.',
          'vend_id.max_length': 'ID vendor maksimal 5 karakter.',
          'vend_name.required': 'Nama vendor wajib diisi.',
          'vend_name.string': 'Nama vendor harus berupa teks.',
          'vend_name.max_length': 'Nama vendor maksimal 50 karakter.',
          'vend_address.required': 'Alamat vendor wajib diisi.',
          'vend_kota.required': 'Kota vendor wajib diisi.',
          'vend_state.required': 'Provinsi vendor wajib diisi.',
          'vend_state.max_length': 'Provinsi vendor maksimal 5 karakter.',
          'vend_zip.required': 'Kode pos vendor wajib diisi.',
          'vend_zip.max_length': 'Kode pos vendor maksimal 7 karakter.',
          'vend_country.required': 'Negara vendor wajib diisi.',
          'vend_country.max_length': 'Negara vendor maksimal 25 karakter.',
        });

        // Ambil data input
        final vendorData = request.input();

        // Cek apakah ID vendor sudah ada
        final existingVendor = await Vendor()
            .query()
            .where('vend_id', '=', vendorData['vend_id'])
            .first();

        if (existingVendor != null) {
          return Response.json({
            'message': 'Vendor dengan ID ini sudah ada.',
          }, 409);
        }

        print('Validasi berhasil, data: $vendorData');

        await Vendor().query().insert(vendorData);

        print('Data berhasil disimpan ke database');

        return Response.json({
          'message': 'Vendor berhasil ditambahkan.',
          'data': vendorData,
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
            'error': e.toString(), // Tambahkan detail error
          }, 500);
        }
      }
    }

     

    // Fungsi untuk mengambil semua data vendor
    Future<Response> show() async {
      try {
        // Mengambil semua data vendor
        final listVendors = await Vendor().query().get();

        return Response.json({
          'message': 'Daftar vendor.',
          'data': listVendors,
        }, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan saat mengambil data vendor.',
          'error': e.toString(),
        }, 500);
      }
    }

    // Fungsi untuk memperbarui data vendor
    Future<Response> update(Request request, String id) async {
      try {
        // Validasi input
        request.validate({
          'vend_name': 'required|string|max_length:50',
          'vend_address': 'required|string',
          'vend_kota': 'required|string',
          'vend_state': 'required|string|max_length:5',
          'vend_zip': 'required|string|max_length:7',
          'vend_country': 'required|string|max_length:25',
        });

        // Ambil data input
        final vendorData = request.input();

        // Cari vendor berdasarkan ID
        final vendor = await Vendor().query().where('vend_id', '=', id).first();

        if (vendor == null) {
          return Response.json({
            'message': 'Vendor dengan ID $id tidak ditemukan.',
          }, 404);
        }

        // Perbarui data vendor
        vendorData.remove('vend_id');
        await Vendor().query().where('vend_id', '=', id).update(vendorData);

        return Response.json({
          'message': 'Vendor berhasil diperbarui.',
          'data': vendorData,
        }, 200);
      } catch (e) {
        if (e is ValidationException) {
          return Response.json({
            'errors': e.message,
          }, 400);
        }
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          'error': e.toString(),
        }, 500);
      }
    }

    Future<Response> destroy(Request request, String id) async {
      try {
        final vendor = await Vendor().query().where('vend_id', '=', id).first();

        if (vendor == null) {
          return Response.json({
            'message': 'Vendor dengan ID $id tidak ditemukan.',
          }, 404);
        }

        await Vendor().query().where('vend_id', '=', id).delete();

        return Response.json({
          'message': 'Vendor berhasil dihapus.',
        }, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
          'error': e.toString(),
        }, 500);
      }
    }
}

final VendorController vendorController = VendorController();
