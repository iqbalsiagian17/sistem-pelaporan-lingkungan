class UserInfo {
  final String? fullName;
  final String? address;
  final String? birthDate;
  final String? gender;
  final String? job;
  final String? profilePicture;

  UserInfo({
    this.fullName,
    this.address,
    this.birthDate,
    this.gender,
    this.job,
    this.profilePicture,
  });

  // ✅ Tambahkan `copyWith()` untuk memperbarui data tanpa mengganti atribut lain
  UserInfo copyWith({
    String? fullName,
    String? address,
    String? birthDate,
    String? gender,
    String? job,
    String? profilePicture,
  }) {
    return UserInfo(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      job: job ?? this.job,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  // ✅ Tambahkan `toJson()` jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "address": address,
      "birth_date": birthDate,
      "gender": gender,
      "job": job,
      "profile_picture": profilePicture,
    };
  }

  // ✅ Tambahkan `fromJson()` untuk parsing dari API
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      fullName: json["full_name"],
      address: json["address"],
      birthDate: json["birth_date"],
      gender: json["gender"],
      job: json["job"],
      profilePicture: json["profile_picture"],
    );
  }
}
