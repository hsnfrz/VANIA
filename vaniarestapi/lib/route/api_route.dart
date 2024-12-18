import 'package:vania/vania.dart';
import 'package:vaniarestapi/app/http/controllers/auth_controller.dart';
import 'package:vaniarestapi/app/http/controllers/customer_controller.dart';
import 'package:vaniarestapi/app/http/controllers/order_controller.dart';
import 'package:vaniarestapi/app/http/controllers/product_controller.dart';
import 'package:vaniarestapi/app/http/controllers/product_note_controller.dart';
import 'package:vaniarestapi/app/http/controllers/todo_controller.dart';
import 'package:vaniarestapi/app/http/controllers/user_controller.dart';
import 'package:vaniarestapi/app/http/controllers/vendor_controller.dart';
import 'package:vaniarestapi/app/http/middleware/authenticate.dart';


class ApiRoute implements Route {
  @override
  void register() {
    // Route for CustomerController
    Router.post('/create-customer', customerController.store);
    Router.get('/show-customer', customerController.show);
    Router.put('/update-customer/{id}', customerController.update); 
    Router.delete('/delete-customer/{id}', customerController.destroy);



    // // // Route for ProductController
    Router.post('/create-product', productController.store);
    Router.get('/show-product', productController.show);
    Router.put('/update-product/{id}', productController.update); 
    Router.delete('/delete-product/{id}', productController.destroy);

    // // Route for ProductNotesController
    Router.post('/create-productnote', productNoteController.store);
    Router.get('/show-productnote', productNoteController.show);
    Router.put('/update-productnote/{id}', productNoteController.update); 
    Router.delete('/delete-productnote/{id}', productNoteController.destroy);


    // // Route for OrdersController
    Router.post('/create-order', orderController.store);
    Router.get('/show-order', orderController.show);
    Router.put('/update-order/{id}', orderController.update); 
    Router.delete('/delete-order/{id}', orderController.destroy);


    // // Route for OrderItemsController
    Router.post('/create-orderitem', orderController.store);
    Router.get('/show-orderitem', orderController.show);
    Router.put('/update-orderitem/{id}', orderController.update); 
    Router.delete('/delete-orderitem/{id}', orderController.destroy);


    // // Route for VendorsController
    Router.post('/create-vendor', vendorController.store);
    Router.get('/show-vendor', vendorController.show);
    Router.put('/update-vendor/{id}', vendorController.update); 
    Router.delete('/delete-vendor/{id}', vendorController.destroy);

    Router.basePrefix('api');
    Router.group(() {
      Router.post('register',authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.group(() {
      Router.patch('update-password', userController.updatePassword);
      Router.get('', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

    Router.group(() {
      Router.post('todo', todoController.store);
    }, prefix: 'todo', middleware: [AuthenticateMiddleware()]);
  }
}

