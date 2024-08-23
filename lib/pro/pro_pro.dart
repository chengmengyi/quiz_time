import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//进度条
class ProPro extends StatefulWidget {
  final Function() call;

  const ProPro(this.call, {super.key});

  @override
  State<ProPro> createState() => _ProProState();
}

class _ProProState extends State<ProPro> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    animation = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.ease)).animate(animationController);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      animationController.duration = const Duration(seconds: 2);

      await animationController.forward(from: animationController.value);
      widget.call();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: const Color(0xFF5BA3C6),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) => FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: animation.value,
              child: child,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29.w),
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
