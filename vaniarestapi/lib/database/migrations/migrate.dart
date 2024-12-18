import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_orderitems_table.dart';
import 'create_productnotes_table.dart';
import 'create_products_table.dart';
import 'create_vendors_table.dart';
import 'create_personal_access_token.dart';
import 'create_todos_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateUserTable().up();
    await CreateCustomersTable().up();
    await CreateOrdersTable().up();
    await CreateVendorsTable().up();
    await CreateProductsTable().up();
    await CreateProductnotesTable().up();
    await CreateOrderitemsTable().up();
		await CreatePersonalAccessTokenTable().up();
		 await CreateTodosTable().up();
	}


  dropTables() async {
		 await CreateTodosTable().down();
		 await CreatePersonalAccessTokenTable().down();
		 await CreateProductsTable().down();
    await CreateProductnotesTable().down();
    await CreateVendorsTable().down();
    await CreateOrdersTable().down();
    await CreateCustomersTable().down();
    await CreateUserTable().down();
    await CreateOrderitemsTable().down();
	 }
}

