import 'package:postgres/postgres.dart';

class DatabaseManager extends PostgreSQLConnection {
  DatabaseManager()
      : super(
    'localhost',
    5432,
    'graph_app',
    queryTimeoutInSeconds: 3600,
    timeoutInSeconds: 3600,
    username: 'postgres',
    password: 'root',
  );

  Future<void> connect() async {
    await open();
    if (!isClosed) {
      print('Connected OK!');
    }
  }

  Future<PostgreSQLResult> query(String sql, {bool? allowReuse, Map<String, dynamic>? substitutionValues, int? timeoutInSeconds, bool? useSimpleQueryProtocol}) {
    return super.query(sql,
      allowReuse: allowReuse,
      substitutionValues: substitutionValues,
      timeoutInSeconds: timeoutInSeconds,
      useSimpleQueryProtocol: useSimpleQueryProtocol,
    );
  }

  Future<void> closeConnection() async {
    await close();
  }
}