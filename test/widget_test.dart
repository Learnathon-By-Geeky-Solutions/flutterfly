import 'package:QuickDeal/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() 
{
  testWidgets('test', (WidgetTester tester) async 
  {
    await tester.pumpWidget(const App());
  });
}