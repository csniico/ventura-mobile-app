class Optional<T> {
  final T? value;
  const Optional(this.value);
}

class BusinessProfileDraft {
  final String? email;
  final String? phone;
  final String? name;
  final String? description;
  final String? tagLine;
  final List<String>? categories;
  final String? logo;
  final String? city;
  final String? state;
  final String? country;
  final String? address;

  BusinessProfileDraft({
    this.categories,
    this.name,
    this.email,
    this.phone,
    this.description,
    this.tagLine,
    this.logo,
    this.city,
    this.state,
    this.country,
    this.address,
  });

  BusinessProfileDraft copyWith({
    String? email,
    String? phone,
    String? name,
    String? description,
    String? tagLine,
    List<String>? categories,
    Optional<String>? logo,
    String? city,
    String? state,
    String? country,
    String? address,
  }) {
    return BusinessProfileDraft(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      description: description ?? this.description,
      tagLine: tagLine ?? this.tagLine,
      categories: categories ?? this.categories,
      logo: logo != null ? logo.value : this.logo,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      address: address ?? this.address,
    );
  }
}
