import 'package:vania/vania.dart';

class CreateTodosTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('todos', () {
      id();
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('todos');
  }
}
