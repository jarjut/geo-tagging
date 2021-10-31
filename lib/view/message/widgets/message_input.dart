import 'package:flutter/material.dart';
import 'package:geo_tagging/view/message/message_provider.dart';
import 'package:geo_tagging/view/message/widgets/message_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 12.0,
          desktop: 24.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo.png',
            height: getValueForScreenType<double>(
              context: context,
              mobile: 32.0,
              desktop: 64.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '17Th TBIG Anniversary',
            style: GoogleFonts.montserrat(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 16.0,
                desktop: 24.0,
              ),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Halo TBIGers! Apa harapan kalian bagi TBIG di umur ke-17 ini?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          const Expanded(
            child: MessageForm(),
          ),
          ResponsiveBuilder(builder: (context, size) {
            if (size.deviceScreenType == DeviceScreenType.desktop) {
              return const SizedBox(height: 8.0);
            }
            return const SizedBox.shrink();
          }),
          TextButton(
            onPressed: () => context.read<MessageProvider>().showChat(),
            child: const Text(
              'Lihat Harapan Mereka',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
