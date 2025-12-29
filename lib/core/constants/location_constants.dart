/// Location Constants for Address Selection
/// Countries, States, and Cities

const List<Map<String, String>> COUNTRY_OPTIONS = [
  {"label": "Nigeria", "value": "Nigeria", "code": "NG"},
  {"label": "Ghana", "value": "Ghana", "code": "GH"},
  {"label": "Kenya", "value": "Kenya", "code": "KE"},
  {"label": "South Africa", "value": "South Africa", "code": "ZA"},
];

// Nigerian States - Using the OPERATING_REGIONS_OPTIONS from form_constants.dart
// These are the 37 states + FCT

final Map<String, List<String>> STATES_BY_COUNTRY = {
  'Nigeria': [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'FCT',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',
  ],
  'Ghana': [
    'Ashanti',
    'Brong Ahafo',
    'Central',
    'Eastern',
    'Greater Accra',
    'Northern',
    'Volta',
    'Western',
  ],
  'Kenya': [
    'Baringo',
    'Bomet',
    'Bungoma',
    'Busia',
    'Elgeyo-Marakwet',
    'Embu',
    'Garissa',
    'Homabay',
    'Isiolo',
    'Kajiado',
    'Kakamega',
    'Kericho',
    'Kiambu',
    'Kilifi',
    'Kirinyaga',
    'Kisii',
    'Kisumu',
    'Kitui',
    'Kwale',
    'Laikipia',
    'Lamu',
    'Machakos',
    'Makueni',
    'Mandera',
    'Marsabit',
    'Meru',
    'Migori',
    'Mombasa',
    'Murang\'a',
    'Nairobi',
    'Nakuru',
    'Nandi',
    'Narok',
    'Nyamira',
    'Nyeri',
    'Samburu',
    'Siaya',
    'Taita-Taveta',
    'Tana River',
    'Tharaka-Nithi',
    'Trans Nzoia',
    'Turkana',
    'Uasin Gishu',
    'Vihiga',
    'Wajir',
    'West Pokot',
  ],
  'South Africa': [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape',
  ],
};

// Cities by State (expanded for major cities)
final Map<String, List<String>> CITIES_BY_STATE = {
  // Nigeria - Lagos
  'Lagos': [
    'Lagos',
    'Ikeja',
    'Victoria Island',
    'Lekki',
    'Ajah',
    'Ikoyi',
    'Surulere',
  ],
  // Nigeria - FCT
  'FCT': ['Abuja', 'Garki', 'Wuse', 'Maitama', 'Jabi', 'Lekki', 'Asokoro'],
  // Nigeria - Kaduna
  'Kaduna': ['Kaduna', 'Zaria', 'Kafanchan', 'Barnawa', 'Chikun'],
  // Nigeria - Kano
  'Kano': ['Kano', 'Dawamatsu', 'Nassarawa'],
  // Nigeria - Rivers
  'Rivers': ['Port Harcourt', 'Obio-Akpor', 'Eleme', 'Ikwerre'],
  // Nigeria - Oyo
  'Oyo': ['Ibadan', 'Oyo', 'Ogbomosho', 'Iseyin', 'Ilesa'],
  // Nigeria - Edo
  'Edo': ['Benin City', 'Auchi', 'Ekpoma', 'Uromi'],
  // Nigeria - Delta
  'Delta': ['Warri', 'Asaba', 'Sapele', 'Effurun', 'Ughelli'],
  // Nigeria - Anambra
  'Anambra': ['Onitsha', 'Awka', 'Nnewi', 'Ekwulobia'],
  // Nigeria - Imo
  'Imo': ['Owerri', 'Orlu', 'Okigwe', 'Mbaise'],
  // Nigeria - Enugu
  'Enugu': ['Enugu', 'Nsukka', 'Agbani', 'Udi'],
  // Nigeria - Abia
  'Abia': ['Aba', 'Umuahia', 'Ohafia', 'Arochukwu'],
  // Nigeria - Benue
  'Benue': ['Makurdi', 'Otukpo', 'Gboko', 'Oju'],
  // Nigeria - Akwa Ibom
  'Akwa Ibom': ['Uyo', 'Eket', 'Abak', 'Ikot Ekpene'],
  // Nigeria - Cross River
  'Cross River': ['Calabar', 'Ogoja', 'Ikom', 'Obudu'],
  // Nigeria - Bayelsa
  'Bayelsa': ['Yenagoa', 'Nembe', 'Brass'],
  // Nigeria - Osun
  'Osun': ['Osogbo', 'Oshogbo', 'Ife', 'Ijebu Ode'],
  // Nigeria - Ondo
  'Ondo': ['Akure', 'Ondo', 'Owo', 'Ilesa'],
  // Nigeria - Kwara
  'Kwara': ['Ilorin', 'Offa', 'Kwara', 'Lafiagi'],
  // Nigeria - Kogi
  'Kogi': ['Lokoja', 'Idah', 'Okene', 'Kabba'],
  // Nigeria - Kebbi
  'Kebbi': ['Birnin Kebbi', 'Argungu', 'Yauri'],
  // Nigeria - Sokoto
  'Sokoto': ['Sokoto', 'Gusau', 'Argungu'],
  // Nigeria - Zamfara
  'Zamfara': ['Gusau', 'Zaria', 'Kaura Namoda'],
  // Nigeria - Katsina
  'Katsina': ['Katsina', 'Kastina', 'Kankia'],
  // Nigeria - Jigawa
  'Jigawa': ['Dutse', 'Hadejia', 'Kazaure'],
  // Nigeria - Yobe
  'Yobe': ['Damaturu', 'Potiskum', 'Gashua'],
  // Nigeria - Borno
  'Borno': ['Maiduguri', 'Biu', 'Potiskum'],
  // Nigeria - Adamawa
  'Adamawa': ['Yola', 'Mubi', 'Jimeta', 'Gombe'],
  // Nigeria - Taraba
  'Taraba': ['Jalingo', 'Wukari', 'Takum'],
  // Nigeria - Plateau
  'Plateau': ['Jos', 'Pankshin', 'Bokkos'],
  // Nigeria - Nasarawa
  'Nasarawa': ['Lafia', 'Keffi', 'Nasarawa'],
  // Nigeria - Niger
  'Niger': ['Minna', 'Suleja', 'Bida'],
  // Nigeria - Ogun
  'Ogun': ['Abeokuta', 'Ijebu Ode', 'Sagamu'],
  // Nigeria - Bauchi
  'Bauchi': ['Bauchi', 'Azare', 'Dass'],
  // Nigeria - Gombe
  'Gombe': ['Gombe', 'Kumo', 'Deba'],
  // Nigeria - Ebonyi
  'Ebonyi': ['Abakaliki', 'Onueke', 'Ezza'],
  // Nigeria - Ekiti
  'Ekiti': ['Ado-Ekiti', 'Ikere', 'Ijero'],

  // Ghana Cities
  'Greater Accra': ['Accra', 'Tema', 'Kaneshie', 'Osu'],
  'Ashanti': ['Kumasi', 'Sekondi', 'Takoradi', 'Obuasi'],
  'Central': ['Cape Coast', 'Sekondi', 'Takoradi'],
  'Eastern': ['Koforidua', 'Akim Oda'],
  'Northern': ['Tamale', 'Bolgatanga'],
  'Volta': ['Ho', 'Keta'],
  'Western': ['Sekondi-Takoradi', 'Tarkwa'],
  'Brong Ahafo': ['Sunyani', 'Techiman'],

  // Kenya Cities
  'Nairobi': ['Nairobi', 'Westlands', 'Karen', 'Kilimani'],
  'Mombasa': ['Mombasa', 'Likoni', 'Diani'],
  'Kisumu': ['Kisumu', 'Ahero'],
  'Nakuru': ['Nakuru', 'Naivasha', 'Gilgil'],
  'Eldoret': ['Eldoret', 'Iten'],
  'Kericho': ['Kericho', 'Kitui'],

  // South Africa Cities
  'Gauteng': ['Johannesburg', 'Pretoria', 'Soweto', 'Centurion'],
  'Western Cape': ['Cape Town', 'Stellenbosch', 'Paarl'],
  'KwaZulu-Natal': ['Durban', 'Pietermaritzburg', 'Newcastle'],
  'Limpopo': ['Polokwane', 'Musina', 'Louis Trichardt'],
  'Mpumalanga': ['Nelspruit', 'Middleburg', 'Secunda'],
  'Free State': ['Bloemfontein', 'Welkom', 'Qwa-Qwa'],
  'Eastern Cape': ['Gqeberha', 'East London', 'Mthatha'],
  'Northern Cape': ['Kimberley', 'De Aar'],
  'North West': ['Mafikeng', 'Rustenburg', 'Potchefstroom'],
};
