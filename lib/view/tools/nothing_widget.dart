import 'package:flutter/cupertino.dart';

class NothingWidget extends StatelessWidget{
  const NothingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 0,
        height: 0,
        child: Text("",style: TextStyle(fontSize: 0))
    );
  }
}
