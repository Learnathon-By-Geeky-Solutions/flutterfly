import 'package:flutter_test/flutter_test.dart';
import 'package:quickdeal/app.dart';

void main() 
{
  testWidgets('test', (WidgetTester tester) async 
  {
    await tester.pumpWidget(const App());
  });
}