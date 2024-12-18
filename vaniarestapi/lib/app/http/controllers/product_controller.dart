import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/product.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductController extends Controller {
  // Fungsi untuk menambahkan produk baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|integer',
        'prod_desc': 'required|string',
        'vend_id': 'required|string|max_length:5',
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_name.string': 'Nama produk harus berupa teks.',
        'prod_name.max_length': 'Nama produk maksimal 50 karakter.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_price.integer': 'Harga produk harus berupa angka.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'prod_desc.string': 'Deskripsi produk harus berupa teks.',
        'vend_id.required': 'ID vendor wajib diisi.',
        'vend_id.string': 'ID vendor harus berupa teks.',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter.',
      });

      // Ambil data input
      final productData = request.input();

      // Simpan data ke database
      await Product().query().insert(productData);

      return Response.json({
        'message': 'Produk berhasil ditambahkan.',
        'data': productData,
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
          'error': e.toString(),
        }, 500);
      }
    }
  }

  // Fungsi untuk mengambil semua data produk
  Future<Response> show() async {
    try {
      // Mengambil semua data produk
      final listProducts = await Product().query().get();

      return Response.json({
        'message': 'Daftar produk.',
        'data': listProducts,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Fungsi untuk memperbarui data produk
  Future<Response> update(Request request, String id) async {
    try {
      // Validasi input
      request.validate({
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|integer',
        'prod_desc': 'required|string',
        'vend_id': 'required|string|max_length:5',
      }, {
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_name.string': 'Nama produk harus berupa teks.',
        'prod_name.max_length': 'Nama produk maksimal 50 karakter.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_price.integer': 'Harga produk harus berupa angka.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'prod_desc.string': 'Deskripsi produk harus berupa teks.',
        'vend_id.required': 'ID vendor wajib diisi.',
        'vend_id.string': 'ID vendor harus berupa teks.',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter.',
      });

      // Ambil data input
      final productData = request.input();

      // Cari produk berdasarkan ID
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Perbarui data produk
      productData.remove('prod_id');
      await Product().query().where('prod_id', '=', id).update(productData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productData,
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

  // Fungsi untuk menghapus produk
  Future<Response> destroy(Request request, dynamic id) async {
    try {
      final String prodId = id.toString();
      final product = await Product().query().where('prod_id', '=', prodId).first();

      if (product == null) {
        return Response.json({
          'message': 'Produk dengan ID $prodId tidak ditemukan.',
        }, 404);
      }

      await Product().query().where('prod_id', '=', prodId).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductController productController = ProductController();
