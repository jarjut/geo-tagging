import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
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
              bool locationEnabled = state.locationServiceEnabled &&
                  state.locationPermissionStatus == PermissionStatus.granted;
              return Stack(
                children: [
                  ScreenTypeLayout(
                    mobile: Stack(
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
                    desktop: Row(
                      children: const [
                        SizedBox(
                          width: 300,
                          child: MessageSection(),
                        ),
                        Expanded(child: MainMap()),
                      ],
                    ),
                  ),
                  !locationEnabled
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
                const Text('Please allow location permission'),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AppBloc>(context)
                          .add(AppRequestLocationService());
                    },
                    child: const Text(
                      'REQUEST PERMISSION',
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
