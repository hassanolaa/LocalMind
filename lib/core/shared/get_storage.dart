



import 'package:get_storage/get_storage.dart';

class get_storage{

 static final box = GetStorage();

 static void writeData(String key, dynamic value) {
    box.write(key, value);
  }

  static dynamic readData(String key) {
    return box.read(key);
  }

 static void removeData(String key) {
    box.remove(key);
  }

  

 static void clearAllData() {
    box.erase();
  }







}