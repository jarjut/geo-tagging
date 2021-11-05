import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../app/bloc/app_bloc.dart';
import '../repository/message_repository.dart';
import 'bloc/message_bloc.dart';
import 'map/main_map.dart';
import 'message/message_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc(
        messageRepository: RepositoryProvider.of<MessageRepository>(context),
      )..add(LoadMessage()),
      child: ChangeNotifierProvider(
        create: (_) => HomeProvider(),
        child: Scaffold(
          body: BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
              if (state is AppLoaded) {
                return Stack(
                  children: [
                    ScreenTypeLayout(
                      mobile: Stack(
                        children: [
                          const Positioned.fill(child: MainMap()),
                          Consumer<HomeProvider>(
                              builder: (context, homeState, _) {
                            return Positioned(
                              bottom: 16,
                              right: 16,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: const BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                height: homeState.showMessage
                                    ? MediaQuery.of(context).size.height *
                                        (4 / 5)
                                    : 64,
                                width: homeState.showMessage
                                    ? MediaQuery.of(context).size.width - 32
                                    : 64,
                                child: AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 250),
                                  crossFadeState: homeState.showMessage
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: const MessageSection(),
                                  secondChild: Center(
                                    child: IconButton(
                                      onPressed: () => context
                                          .read<HomeProvider>()
                                          .toggleMessage(),
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      desktop: Stack(
                        children: [
                          const Positioned.fill(child: MainMap()),
                          Consumer<HomeProvider>(
                              builder: (context, homeState, _) {
                            return Positioned(
                              bottom: 32,
                              left: 32,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: const BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                height: homeState.showMessage
                                    ? MediaQuery.of(context).size.height - 64
                                    : 64,
                                width: homeState.showMessage ? 320 : 64,
                                child: AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 250),
                                  crossFadeState: homeState.showMessage
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  firstChild: const MessageSection(),
                                  secondChild: Center(
                                    child: IconButton(
                                      onPressed: () => context
                                          .read<HomeProvider>()
                                          .toggleMessage(),
                                      icon: Icon(
                                        Icons.message,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    !state.hasPermission
                        ? const RequestLocation()
                        : const SizedBox.shrink(),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeProvider extends ChangeNotifier {
  bool showMessage = true;

  void toggleMessage() {
    showMessage = !showMessage;
    notifyListeners();
  }
}

class RequestLocation extends StatelessWidget {
  const RequestLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            width: 240,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(3, 3),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please turn on and allow location permission'),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return const Color(0xff173a90);
                      }),
                    ),
                    onPressed: () {
                      BlocProvider.of<AppBloc>(context)
                          .add(AppCheckLocationPermission());
                    },
                    child: const Text(
                      'CHECK PERMISSION',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
