import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gpt/core/shared/get_storage.dart';
import 'package:gpt/features/home/data/ollama_service.dart';
import 'package:meta/meta.dart';

import '../../../../main.dart';
import '../../data/models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<String> models = [];
  List<Map<String, String>> messages = [];
  List<Message> messages_list = [];
  List<Chat> chats = [];
  bool is_chat = true;


  // change is_chat
  void changeChatView() {
    is_chat = !is_chat;
    emit(getModelsLoaded());
  }

  // set chat name and id
  void setChat() {
    if (get_storage.readData('chat_id') == null) {
      get_storage.writeData('chat_id', 1);
      get_storage.writeData('chat_name', "Welcome to our App!");
      addChat("Welcome to our App!");
    }
  }

  //change chat name and id
  void changeChat(int id, String name) {
    get_storage.writeData('chat_id', id);
    get_storage.writeData('chat_name', name);
    emit(getModelsLoaded());
  }

  // get chats
  void getChats() {
    try {
      emit(chatsLoading());
      chats = objectbox.chats;
      emit(chatsLoaded());
    } catch (e) {
      emit(chatsError(message: e.toString()));
    }
  }

  // update chat
  void updateChat(Message message) {
    objectbox.updateChat(get_storage.readData('chat_id'), message);
    getChats();
    emit(chatAdded());
  }

// get messages
  void getMessages() {
    try {
      emit(chatsLoading());
      messages_list = objectbox.getMessages(get_storage.readData('chat_id'));
      print(messages_list);
      emit(chatsLoaded());
    } catch (e) {
      emit(chatsError(message: e.toString()));
    }
  }

  // add chat
  void addChat(String name) {
    final chat = Chat(name: name, lastMessageTime: DateTime.now());
    objectbox.addChat(chat);
    getChats();
    emit(chatAdded());
  }

  // add message
  void add_Message(Message message) {
   // objectbox.addMessage(message);
    objectbox.updateChat(get_storage.readData("chat_id"),message);
    getChats();
    getMessages();

    emit(messegeAdded());
  }

  // add messages
  void addMessage(String role, String message) {
     //messages.add({'role': role, 'content': message});
    //print(messages);
    add_Message(Message(
        role: role,
        content: message,
        modelName: get_storage.readData("model")));
    
    emit(messegeAdded());
  }

  void getAvailableModels() async {
    emit(getModelsLoading());
    try {
      final models_in = await OllamaService().getAvailableModels();
      if (models_in.isEmpty) {
        emit(getModelsEmpty(message: 'No models available'));
      } else {
        models = models_in;
        emit(getModelsLoaded());
      }
    } catch (e) {
      emit(getModelsError(message: e.toString()));
    }
  }

  void generateResponse(String prompt) async {
    emit(getModelsLoading());
    try {
      final response = await OllamaService().generateResponse(prompt);
      // addMessage('chatbot', response['response'].toString());
      
      add_Message(Message(
          role: 'chatbot',
          content: response['response'].toString(),
          modelName: get_storage.readData("model")));

      emit(getModelsLoaded());
    } catch (e) {
      emit(getModelsError(message: e.toString()));
    }
  }
}
