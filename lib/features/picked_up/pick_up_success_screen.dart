import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:be_right_bark/styles/spacers.dart';
import 'package:be_right_bark/widgets/titles/title_large.dart';
import 'package:be_right_bark/widgets/buttons/button_medium.dart';
import 'package:be_right_bark/widgets/animations/picked_up_animation.dart';
import 'package:be_right_bark/services/picked_up_service.dart';
import 'package:be_right_bark/features/picked_up/constants.dart';

class PickUpSuccessScreen extends StatefulWidget {
  const PickUpSuccessScreen({super.key});

  @override
  State<PickUpSuccessScreen> createState() => _PickUpSuccessScreenState();
}

class _PickUpSuccessScreenState extends State<PickUpSuccessScreen> {
  int? _count;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final count = await getPickedUpCount();
    setState(() => _count = count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(BrbSpacers.xl),
        child: Column(
          children: [
            const TitleLarge(text: successTitle),
            const SizedBox(height: BrbSpacers.md),
            const PickedUpAnimation(size: 350),
            const SizedBox(height: BrbSpacers.xs),
            Text(
              successMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: BrbSpacers.xl),
            if (_count != null)
              Text(
                '$_count ${_count == 1 ? countLabelSingular : countLabelPlural}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(height: BrbSpacers.xxl),
            ButtonMedium(
              buttonText: doneButtonLabel,
              onPressed: () => context.go('/active-spots'),
            ),
          ],
        ),
      ),
    );
  }
}
