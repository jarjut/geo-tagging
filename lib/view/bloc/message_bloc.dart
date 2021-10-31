import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geo_tagging/models/message.dart';
import 'package:geo_tagging/repository/message_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc({required MessageRepository messageRepository})
      : _messageRepository = messageRepository,
        super(MessageInitial()) {
    on<LoadMessage>((event, emit) {
      return emit.onEach<List<Message>>(
        _messageRepository.streamMessages(),
        onData: (message) => add(MessageUpdated(message)),
      );
    });

    on<MessageUpdated>((event, emit) {
      emit(MessageLoaded(event.messages));
    });
  }

  final MessageRepository _messageRepository;
}
