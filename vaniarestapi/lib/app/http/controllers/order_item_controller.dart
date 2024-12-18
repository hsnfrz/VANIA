import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/order_item.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemController extends Controller {
  // Fungsi untuk menambahkan order item baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer',
        'size': 'required|integer',
      }, {
        'order_num.required': 'Nomor order wajib diisi.',
        'order_num.integer': 'Nomor order harus berupa bilangan bulat.',
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'quantity.required': 'Kuantitas wajib diisi.',
        'quantity.integer': 'Kuantitas harus berupa bilangan bulat.',
        'size.required': 'Ukuran wajib diisi.',
        'size.integer': 'Ukuran harus berupa bilangan bulat.',
      });

      // Ambil data input
      final orderItemData = request.input();

      // Simpan data ke database
      await OrderItem().query().insert(orderItemData);

      return Response.json({
        'message': 'Order item berhasil ditambahkan.',
        'data': orderItemData,
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

  // Fungsi untuk mengambil semua data order item
  Future<Response> show() async {
    try {
      // Mengambil semua data order item
      final listOrderItems = await OrderItem().query().get();

      return Response.json({
        'message': 'Daftar order item.',
        'data': listOrderItems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Fungsi untuk memperbarui data order item
  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'quantity': 'required|integer',
        'size': 'required|integer',
      }, {
        'prod_id.required': 'ID produk wajib diisi.',
        'prod_id.string': 'ID produk harus berupa teks.',
        'prod_id.max_length': 'ID produk maksimal 10 karakter.',
        'quantity.required': 'Kuantitas wajib diisi.',
        'quantity.integer': 'Kuantitas harus berupa bilangan bulat.',
        'size.required': 'Ukuran wajib diisi.',
        'size.integer': 'Ukuran harus berupa bilangan bulat.',
      });

      // Ambil data input
      final orderItemData = request.input();

      // Cari order item berdasarkan ID
      final orderItem = await OrderItem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Perbarui data order item
      await OrderItem().query().where('order_item', '=', id).update(orderItemData);

      return Response.json({
        'message': 'Order item berhasil diperbarui.',
        'data': orderItemData,
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

  // Fungsi untuk menghapus order item
  Future<Response> destroy(Request request, int id) async {
    try {
      final orderItem = await OrderItem().query().where('order_item', '=', id).first();

      if (orderItem == null) {
        return Response.json({
          'message': 'Order item dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await OrderItem().query().where('order_item', '=', id).delete();

      return Response.json({
        'message': 'Order item berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderItemController orderItemController = OrderItemController();
