part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessage extends MessageEvent {}

class MessageUpdated extends MessageEvent {
  final List<Message> messages;

  const MessageUpdated(this.messages);

  @override
  // TODO: implement props
  List<Object> get props => [messages];
}
