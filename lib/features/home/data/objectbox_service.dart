import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../objectbox.g.dart';
import 'models.dart';

class ObjectBox {
  late final Store _store;

  late final Box<Chat> _chatBox;

  ObjectBox._create(this._store) {
    _chatBox = Box<Chat>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, "GPT"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBox._create(store);
  }

  // get chats
  List<Chat> get chats => _chatBox.getAll();

  // add chat
  void addChat(Chat chat) {
    _chatBox.put(chat);
  }

  // remove chat
  void removeChat(Chat chat) {
    _chatBox.remove(chat.id);
  }

  // update chat
  void updateChat(int chat_id, Message message) {
    Chat? oldChat = _chatBox.get(chat_id);
    oldChat!.Messages.add(message);
    _chatBox.put(oldChat);
  }

  // get messages
  List<Message> getMessages(int chat_id) {
    Chat? chat = _chatBox.get(chat_id);
    return chat!.Messages.toList();
  }

  // add message
  void addMessage(Message message) {
    message.chat.target = _chatBox.get(message.chat.targetId);
    message.chat.target?.Messages.add(message);
    _store.box<Message>().put(message);
  }

  // close the store
  void close() {
    _store.close();
  }
}
