import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Message {
  @Id(assignable: true)
  int id = 0;
  final String content;
  final String role;
  final String modelName;
  final chat=ToOne<Chat>();

  Message({
    required this.content,
    required this.role,
    required this.modelName,
  });
}


@Entity()
class Chat {

  @Id(assignable: true)
  int id = 0;
  
  final String name;
  final DateTime lastMessageTime;

  @Backlink('chat')
  final Messages =ToMany<Message>();

  Chat({
    required this.name,
    required this.lastMessageTime,
  });
  
}
