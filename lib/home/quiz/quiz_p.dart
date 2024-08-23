import 'package:flutter/cupertino.dart';

import '../../global/pop/d_pop.dart';
import 'dpop_level.dart';

class QuizP extends StatefulWidget {
  const QuizP({super.key});

  @override
  State<QuizP> createState() => _QuizPState();
}

class _QuizPState extends State<QuizP> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      DPopLevel(5).dPop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
