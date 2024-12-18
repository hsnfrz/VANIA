import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/models/order.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  // Fungsi untuk menambahkan order baru
  Future<Response> store(Request request) async {
    try {
      // Validasi input
      request.validate({
        'order_num': 'required|integer',
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      }, {
        'order_num.required': 'Nomor order wajib diisi.',
        'order_num.integer': 'Nomor order harus berupa bilangan bulat.',
        'order_date.required': 'Tanggal order wajib diisi.',
        'order_date.date': 'Tanggal order harus berupa tanggal yang valid.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
      });

      // Ambil data input
      final orderData = request.input();

      // Simpan data ke database
      await Order().query().insert(orderData);

      return Response.json({
        'message': 'Order berhasil ditambahkan.',
        'data': orderData,
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

  // Fungsi untuk mengambil semua data order
  Future<Response> show() async {
    try {
      // Mengambil semua data order
      final listOrders = await Order().query().get();

      return Response.json({
        'message': 'Daftar order.',
        'data': listOrders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order.',
        'error': e.toString(),
      }, 500);
    }
  }

  // Fungsi untuk memperbarui data order
  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'order_date': 'required|date',
        'cust_id': 'required|string|max_length:5',
      }, {
        'order_date.required': 'Tanggal order wajib diisi.',
        'order_date.date': 'Tanggal order harus berupa tanggal yang valid.',
        'cust_id.required': 'ID pelanggan wajib diisi.',
        'cust_id.string': 'ID pelanggan harus berupa teks.',
        'cust_id.max_length': 'ID pelanggan maksimal 5 karakter.',
      });

      // Ambil data input
      final orderData = request.input();

      // Cari order berdasarkan ID
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }

      // Perbarui data order
      await Order().query().where('order_num', '=', id).update(orderData);

      return Response.json({
        'message': 'Order berhasil diperbarui.',
        'data': orderData,
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

  // Fungsi untuk menghapus order
  Future<Response> destroy(Request request, int id) async {
    try {
      final order = await Order().query().where('order_num', '=', id).first();

      if (order == null) {
        return Response.json({
          'message': 'Order dengan ID $id tidak ditemukan.',
        }, 404);
      }

      await Order().query().where('order_num', '=', id).delete();

      return Response.json({
        'message': 'Order berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderController orderController = OrderController();
