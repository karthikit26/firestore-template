import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FormController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  var firstName = ''.obs;
  var lastName = ''.obs;
  var email = ''.obs;
  var message = ''.obs;
  var messages = <Map<String, String>>[].obs;
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFormData();
    _fetchMessages();
    ever(firstName, (_) => _saveFormData());
    ever(lastName, (_) => _saveFormData());
    ever(email, (_) => _saveFormData());
    ever(message, (_) => _saveFormData());

    // Periodic data sync
    Timer.periodic(const Duration(minutes: 1), (timer) {
      syncData();
    });

    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      isOnline.value = result != ConnectivityResult.none;
      if (isOnline.value) {
        syncData();  // Sync local data to Firestore when online
        _fetchMessages();  // Fetch messages from Firestore when online
      } else {
        _loadLocalMessages();  // Load messages from local storage when offline
      }
    });
  }

  Future<void> submitForm() async {
    final formData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),  // Unique identifier
      'firstName': firstName.value,
      'lastName': lastName.value,
      'email': email.value,
      'message': message.value,
    };

    // Save data locally first
    final drafts = _storage.read<List>('drafts') ?? [];
    drafts.add(formData);
    await _storage.write('drafts', drafts);

    // Sync data to Firestore if online
    if (await _hasInternetConnection()) {
      await _firestore.collection('messages').add(formData);
      _removeDraft(formData['id']!);
    }

    _clearFormData();
    _fetchMessages();
    Get.back();
  }


  Future<void> syncData() async {
    if (await _hasInternetConnection()) {
      final drafts = _storage.read<List>('drafts') ?? [];
      for (var message in drafts) {
        await _firestore.collection('messages').add(Map<String, dynamic>.from(message));
      }
      _storage.remove('drafts'); // Remove drafts after syncing
    }
  }

  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _saveFormData() {
    final formData = {
      'firstName': firstName.value,
      'lastName': lastName.value,
      'email': email.value,
      'message': message.value,
    };
    _storage.write('draft', formData);
  }

  void _loadFormData() {
    final formData = _storage.read<Map<String, dynamic>>('draft') ?? {};
    firstName.value = formData['firstName'] ?? '';
    lastName.value = formData['lastName'] ?? '';
    email.value = formData['email'] ?? '';
    message.value = formData['message'] ?? '';
  }

  void _clearFormData() {
    firstName.value = '';
    lastName.value = '';
    email.value = '';
    message.value = '';
    _storage.remove('draft');
  }

  void _fetchMessages() async {
    if (await _hasInternetConnection()) {
      var querySnapshot = await _firestore.collection('messages').get();
      messages.value = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return data.map((key, value) => MapEntry(key, value.toString()));
      }).toList();
    } else {
      _loadLocalMessages();
    }
  }

  void _loadLocalMessages() {
    final localMessages = _storage.read<List>('drafts') ?? [];
    messages.value = List<Map<String, String>>.from(localMessages.map((message) {
      return message.map<String, String>((key, value) => MapEntry(key.toString(), value.toString()));
    }));
  }

  void _removeDraft(String id) {
    final drafts = _storage.read<List>('drafts') ?? [];
    drafts.removeWhere((draft) => draft['id'] == id);
    _storage.write('drafts', drafts);
  }
}
