import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../app/bloc/app_bloc.dart';
import '../repository/message_repository.dart';
import 'bloc/message_bloc.dart';
import 'map/main_map.dart';
import 'message/message_section.dart';

const _animationDuration = Duration(milliseconds: 200);

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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Stack(
                              children: const [
                                Positioned.fill(child: MainMap()),
                                MessageContainer(
                                    animationDuration: _animationDuration),
                              ],
                            ),
                            state.hasPermission
                                ? const SizedBox.shrink()
                                : const RequestLocation(),
                          ],
                        ),
                      ),
                    ],
                  ),
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
  bool mapGesture = true;

  void toggleMessage() {
    showMessage = !showMessage;
    notifyListeners();
  }

  void enableMapGesture() {
    mapGesture = true;
    notifyListeners();
  }

  void disableMapGesture() {
    mapGesture = false;
    notifyListeners();
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key? key,
    required Duration animationDuration,
  })  : _animationDuration = animationDuration,
        super(key: key);

  final Duration _animationDuration;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeState, _) {
        const _desktopCardMargin = 32.0;
        const _mobileCardMargin = 12.0;
        final _deviceType = getDeviceType(MediaQuery.of(context).size);
        final _isMobile = _deviceType == DeviceScreenType.mobile ||
            _deviceType == DeviceScreenType.tablet;

        final _bottom = _isMobile ? _mobileCardMargin : _desktopCardMargin;
        final _right = _isMobile ? _mobileCardMargin : null;
        final _left = _isMobile ? null : _desktopCardMargin;

        final _screenWidth = MediaQuery.of(context).size.width;
        final _screenHeight = MediaQuery.of(context).size.height;

        final _desktopHeight = _screenHeight - (_desktopCardMargin * 2);
        final _mobileHeight = _screenHeight * 0.6;

        const _desktopWidth = 320.0;
        final _mobileWidth = _screenWidth - (_mobileCardMargin * 2);

        final _height = getValueForScreenType<double?>(
          context: context,
          mobile: _mobileHeight,
          desktop: _desktopHeight,
        );
        final _width = getValueForScreenType<double?>(
          context: context,
          mobile: _mobileWidth,
          desktop: _desktopWidth,
        );

        return Positioned(
          bottom: _bottom,
          right: _right,
          left: _left,
          child: MouseRegion(
            onEnter: (_) => homeState.disableMapGesture(),
            onExit: (_) => homeState.enableMapGesture(),
            child: AnimatedContainer(
              duration: _animationDuration,
              decoration: const BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              height: homeState.showMessage ? _height : 64,
              width: homeState.showMessage ? _width : 64,
              child: AnimatedCrossFade(
                duration: _animationDuration,
                crossFadeState: homeState.showMessage
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: const MessageSection(),
                secondChild: Center(
                  child: IconButton(
                    onPressed: () =>
                        context.read<HomeProvider>().toggleMessage(),
                    icon: Icon(
                      Icons.message,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RequestLocation extends StatefulWidget {
  const RequestLocation({Key? key}) : super(key: key);

  @override
  State<RequestLocation> createState() => _RequestLocationState();
}

class _RequestLocationState extends State<RequestLocation> {
  int _requestCount = 0;
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
                      _requestCount++;
                      if (_requestCount > 3) {
                        BlocProvider.of<AppBloc>(context)
                            .add(AppBypassPermission());
                      } else {
                        BlocProvider.of<AppBloc>(context)
                            .add(AppCheckLocationPermission());
                      }
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
