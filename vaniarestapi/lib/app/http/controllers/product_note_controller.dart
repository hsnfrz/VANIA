import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/product_note.dart';
import 'package:vania/src/exception/validation_exception.dart';

class ProductNoteController extends Controller {
  // Fungsi untuk menambahkan catatan produk baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'note_id': 'required|string|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      }, {
        'note_id.required': 'ID catatan wajib diisi.',
        'note_id.string': 'ID catatan harus berupa teks.',
        'note_id.max_length': 'ID catatan maksimal 5 karakter.',
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_date.date': 'Tanggal catatan harus berupa tanggal yang valid.',
        'note_text.required': 'Teks catatan wajib diisi.',
        'note_text.string': 'Teks catatan harus berupa teks.',
      });

      // Ambil data input
      final productNoteData = request.input();

      // Simpan data ke database
      await ProductNote().query().insert(productNoteData);

      return Response.json({
        'message': 'Catatan produk berhasil ditambahkan.',
        'data': productNoteData,
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

  // Fungsi untuk mengambil semua data catatan produk
  Future<Response> show() async {
    try {
      // Mengambil semua data catatan produk
      final listProductNotes = await ProductNote().query().get();

      return Response.json({
        'message': 'Daftar catatan produk.',
        'data': listProductNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data catatan produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Fungsi untuk memperbarui catatan produk
  Future<Response> update(Request request, String id) async {
    try {
      // Validasi input
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'note_date.required': 'Tanggal catatan wajib diisi.',
        'note_date.date': 'Tanggal catatan harus berupa tanggal yang valid.',
        'note_text.required': 'Teks catatan wajib diisi.',
        'note_text.string': 'Teks catatan harus berupa teks.',
      });

      // Ambil data input
      final productNoteData = request.input();

      // Cari catatan produk berdasarkan ID
      final productNote = await ProductNote().query().where('note_id', '=', id).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Perbarui data catatan produk
      productNoteData.remove('note_id');
      await ProductNote().query().where('note_id', '=', id).update(productNoteData);

      return Response.json({
        'message': 'Catatan produk berhasil diperbarui.',
        'data': productNoteData,
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

  // Fungsi untuk menghapus catatan produk
  Future<Response> destroy(Request request, dynamic id) async {
    try {
      final String noteId = id.toString();
      final productNote = await ProductNote().query().where('note_id', '=', noteId).first();

      if (productNote == null) {
        return Response.json({
          'message': 'Catatan produk dengan ID $noteId tidak ditemukan.',
        }, 404);
      }

      await ProductNote().query().where('note_id', '=', noteId).delete();

      return Response.json({
        'message': 'Catatan produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductNoteController productNoteController = ProductNoteController();
