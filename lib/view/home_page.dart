import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../app/bloc/app_bloc.dart';
import '../repository/message_repository.dart';
import 'bloc/message_bloc.dart';
import 'main_map.dart';
import 'message/message_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageBloc(
        messageRepository: RepositoryProvider.of<MessageRepository>(context),
      )..add(LoadMessage()),
      child: Scaffold(
        body: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            if (state is AppLoaded) {
              return Stack(
                children: [
                  ScreenTypeLayout.builder(
                    mobile: (context) => Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: MediaQuery.of(context).size.height * 4 / 9,
                          child: const MainMap(),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: MediaQuery.of(context).size.height * 5 / 9,
                          child: const MessageSection(),
                        ),
                      ],
                    ),
                    desktop: (context) => Row(
                      children: const [
                        SizedBox(
                          width: 320,
                          child: MessageSection(),
                        ),
                        Expanded(child: MainMap()),
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
    );
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
