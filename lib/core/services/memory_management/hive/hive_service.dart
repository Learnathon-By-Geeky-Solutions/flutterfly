import 'package:hive_flutter/adapters.dart';

/*
    This will keep a local copy of RFQs or attachments so clients can see
    “pending” requests offline.
 */
class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  /*
    This code uses generics to make the function type-safe and reusable.
    A generic function called box that returns a Box<T> object.

    T is a type parameter (You can specify the type of data the box holds)
    box<T> is a generic function

    Box<T> : a Hive box of type T
    String name : the name of the box

    Usage:
      var myBox = box<String>('myStrings');
      myBox.put('key1', 'value1');
   */

  Box<T> box<T>(String name) =>
      Hive.box<T>(name);
}