import 'package:falsifind/config/app_theme.dart';
import 'package:falsifind/services/news_feed_service.dart';
import 'package:falsifind/services/sharing_intent_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';

const _destinations = ["/news_feed", "/news_saved", "/user_settings"];

class HomeLayout extends HookConsumerWidget {
  const HomeLayout(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeModeProvider);
    final newsFeed = ref.read(newsFeedServiceProvider.notifier);

    final sharingIntent = ref.watch(sharingIntentServiceProvider);

    sharingIntent.whenData((value) {
      final data = value.last.value;
      context.go("news_details/$data");
    });

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Home layout',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'SecularOne',
                color: Colors.black,
              ),
        ),
        leading: IconButton(
          onPressed: () => ref.read(appThemeModeProvider.notifier).toggle(),
          icon: appTheme == ThemeMode.light ? const LineIcon.sun() : const LineIcon.moon(),
        ),
        shape: Border(
          bottom: BorderSide(color: AppColors.lightOutline, width: 2),
        ),
      ),
      body: child,
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //       border: Border(
      //     top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 2),
      //   )),
      //   child: NavigationBar(
      //     backgroundColor: Theme.of(context).colorScheme.background,
      //     surfaceTintColor: Colors.transparent,
      //     indicatorColor: Theme.of(context).colorScheme.outline,
      //     labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //     indicatorShape: const ContinuousRectangleBorder(),
      //     selectedIndex: _getCurrentIndex(context),
      //     onDestinationSelected: (index) => _onDestinationSelected(context, index),
      //     destinations: const [
      //       NavigationDestination(
      //           icon: LineIcon.newspaper(),
      //           selectedIcon: LineIcon.newspaper(
      //             color: Colors.white,
      //           ),
      //           label: 'Feed'),
      //       NavigationDestination(icon: LineIcon.bookmark(), label: 'Saved'),
      //       NavigationDestination(icon: LineIcon.userCog(), label: 'Settings'),
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(onPressed: () => newsFeed.loadMore()),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return _destinations.indexOf(location);
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final destination = _destinations[index];
    GoRouter.of(context).go(destination);
  }
}
