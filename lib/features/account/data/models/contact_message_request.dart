class ContactMessageRequest {
  final String name;
  final String emailAddress;
  final String phoneNumber;
  final String subject;
  final String message;
  final String address;

  ContactMessageRequest({
    required this.name,
    required this.emailAddress,
    required this.phoneNumber,
    required this.subject,
    required this.message,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'subject': subject,
      'message': message,
      'address': address,
    };
  }
}
