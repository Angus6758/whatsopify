import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/product/view/buttons/hidden_button.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../_widgets/_widgets.dart';

class ErrorView1 extends HookWidget {
  const ErrorView1({
    super.key,
    required this.error,
    this.stackTrace,
    this.onReload,
  });
  final Object error;
  final StackTrace? stackTrace;
  final Function()? onReload;

  @override
  Widget build(BuildContext context) {
    talk.ex(error, stackTrace, 'Error View');
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HiddenButton(
              child: Assets.lottie.somethingWentWrong.lottie(),
            ),
            if (kDebugMode)
              ExpansionTile(
                initiallyExpanded: true,
                title: const Text('Error Details'),
                controlAffinity: ListTileControlAffinity.leading,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onReload != null)
                      IconButton.outlined(
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: onReload,
                      ),
                    IconButton.outlined(
                      icon: const Icon(Icons.code_rounded),
                      onPressed: () => talk.goToLogView(context),
                    ),
                  ],
                ),
                children: [
                  Text(
                    '$error',
                    style: context.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static Widget errorMethod(error, stackTrace) =>
      ErrorView1(error: error, stackTrace: stackTrace);

  static Widget compact(error, [Function()? onReload, stackTrace]) => Column(
        children: [
          if (kDebugMode) Text('$error'),
          TextButton(
            onPressed: onReload,
            child: const Text('Retry'),
          ),
        ],
      );

  static Widget reload(e, s, Function()? onReload) => ErrorView1(
        error: e,
        onReload: onReload,
        stackTrace: s ?? StackTrace.current,
      );

  static Widget withScaffold(error, [stackTrace]) => Builder(
        builder: (context) {
          return Scaffold(
            appBar: KAppBar(
              leading: SquareButton.backButton(
                onPressed: () => context.pop(),
              ),
            ),
            body: ErrorView1(error: error, stackTrace: stackTrace),
          );
        },
      );
}

class Loader1 extends StatelessWidget {
  const Loader1({super.key, this.loader});
  final Widget? loader;

  @override
  Widget build(BuildContext context) => Center(
        child: loader ?? const SizedBox.square(dimension: 100),
      );

  static Widget loading() => const Loader();
  static Widget shimmer() {
    return Center(
      child: Loader1(
          loader: KShimmer.card(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 10),
      )),
    );
  }

  static Widget withScaffold(String appBarTitle) {
    return Loader1(
      loader: Builder(
        builder: (context) {
          return Scaffold(
            appBar: KAppBar(
              title: Text(appBarTitle),
              leading: SquareButton.backButton(
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  const LoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return KShimmer.card(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          height: 100,
        );
      },
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key})
      : isError = false,
        onReload = null;

  const EmptyWidget.onError({super.key, this.onReload}) : isError = true;

  final Function()? onReload;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: isError ? "brands" : "brands",
          style: context.textTheme.titleLarge,
          children: [
            const TextSpan(text: '\n'),
            if (onReload != null)
              WidgetSpan(
                child: SquareButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: onReload,
                  child: const Text('Reload'),
                ),
              ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class BlurredLoading extends StatelessWidget {
  const BlurredLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface.withOpacity(0.5),
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: RepaintBoundary(
            child: Image.asset(
              context.isDark
                  ? Assets.logo.logoDark.path
                  : Assets.logo.logoWhite.path,
              height: 60,
            )
                .animate(
                  onPlay: (c) => c.repeat(reverse: true),
                )
                .scaleXY(
                  end: 1,
                  begin: 0.8,
                  duration: 300.ms,
                  curve: Curves.easeInOutQuad,
                ),
          ),
        ),
      ),
    );
  }
}
