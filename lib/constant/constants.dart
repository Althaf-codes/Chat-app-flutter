class DummyContactUser {
  String name;
  String phoneNumber;
  DummyContactUser({
    required this.name,
    required this.phoneNumber,
  });
}

List<DummyContactUser> dummyusers = [
  DummyContactUser(name: 'Praveen', phoneNumber: "+911234567888"), //123321
  DummyContactUser(name: 'Akash', phoneNumber: "+911234567899"), // 121212
  DummyContactUser(name: 'Vasanth', phoneNumber: "+911234567890") //	123123
];
