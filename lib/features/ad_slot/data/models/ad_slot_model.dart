class AdSlotModel {
  final String id;
  final String parentId; // billboard/wall/screen ID
  final String parentType; // 'billboard', 'wall', 'screen'
  final String slotNumber;
  final String duration; // e.g., "7days" or "24hrs"
  final double price;
  final String status; // 'available', 'booked', 'occupied', 'ACTIVE'
  final DateTime? startDate;
  final DateTime? endDate;
  final String? bookedBy;
  final int? maxRevisions; // Maximum number of revisions allowed
  final String? audience; // Expected audience/impressions (e.g., "100k - 500k")
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Social/Influencer/Backend API fields
  final List<String>? platforms;
  final String? title;
  final String? description;
  final String? badge;
  final int? ordersCount;
  final int? userId;
  final int? createdById;
  final String? partnerType;
  final List<String>? contentTypes;
  final String? audienceSize;
  final String? timeWindow;
  final String? adFormat;
  final List<String>? contentRequirements;
  final int? locationId;
  final List<String>? coverageAreas;
  final String? coverageArea;
  final String? playbackMode;
  final bool? isActive;

  // Punchlist additions
  final String? offeringType; // PHYSICAL_APPEARANCE, DIGITAL_ENDORSEMENT, SPONSORED_CONTENT
  final String? riderRequirements;
  final List<String>? sampleTracks;
  final List<String>? showReels;
  final String? timeBand; // MORNING_DRIVE, MID_DAY, PRIME_TIME, LATE_NIGHT
  final int? maxSlotsPerBand;
  final int? bookedSlots;
  final int? loopDurationSeconds;
  final int? spotDurationSeconds;
  final int? maxSpots;
  final String? operatingHours;
  final List<String>? features;

  AdSlotModel({
    required this.id,
    required this.parentId,
    required this.parentType,
    required this.slotNumber,
    required this.duration,
    required this.price,
    required this.status,
    this.startDate,
    this.endDate,
    this.bookedBy,
    this.maxRevisions,
    this.audience,
    required this.createdAt,
    this.updatedAt,
    this.platforms,
    this.title,
    this.description,
    this.badge,
    this.ordersCount,
    this.userId,
    this.createdById,
    this.partnerType,
    this.contentTypes,
    this.audienceSize,
    this.timeWindow,
    this.adFormat,
    this.contentRequirements,
    this.locationId,
    this.coverageAreas,
    this.coverageArea,
    this.playbackMode,
    this.isActive,
    this.offeringType,
    this.riderRequirements,
    this.sampleTracks,
    this.showReels,
    this.timeBand,
    this.maxSlotsPerBand,
    this.bookedSlots,
    this.loopDurationSeconds,
    this.spotDurationSeconds,
    this.maxSpots,
    this.operatingHours,
    this.features,
  });

  factory AdSlotModel.fromJson(Map<String, dynamic> json) {
    String parsedDuration = '0';
    if (json['duration'] != null) {
      if (json['duration'] is int) {
        parsedDuration = '${json['duration']}days';
      } else {
        parsedDuration = json['duration'].toString();
      }
    }

    return AdSlotModel(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString() ?? '',
      parentType: json['parentType']?.toString() ?? json['partnerType']?.toString() ?? '',
      slotNumber: json['slotNumber']?.toString() ?? json['title']?.toString() ?? '',
      duration: parsedDuration,
      price: json['price'] != null ? (double.tryParse(json['price'].toString()) ?? 0.0) : 0.0,
      status: json['status']?.toString() ?? 'available',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      bookedBy: json['bookedBy']?.toString(),
      maxRevisions: json['maxRevisions'] != null ? int.tryParse(json['maxRevisions'].toString()) : null,
      audience: json['audience']?.toString() ?? json['audienceSize']?.toString(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      platforms: json['platforms'] != null ? List<String>.from(json['platforms']) : null,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      badge: json['badge']?.toString() ?? json['partnerType']?.toString(),
      ordersCount: json['ordersCount'] != null ? int.tryParse(json['ordersCount'].toString()) : null,
      userId: json['userId'] != null ? int.tryParse(json['userId'].toString()) : null,
      createdById: json['createdById'] != null ? int.tryParse(json['createdById'].toString()) : null,
      partnerType: json['partnerType']?.toString(),
      contentTypes: json['contentTypes'] != null ? List<String>.from(json['contentTypes']) : null,
      audienceSize: json['audienceSize']?.toString(),
      timeWindow: json['timeWindow']?.toString(),
      adFormat: json['adFormat']?.toString(),
      contentRequirements: json['contentRequirements'] != null ? List<String>.from(json['contentRequirements']) : null,
      locationId: json['locationId'] != null ? int.tryParse(json['locationId'].toString()) : null,
      coverageAreas: json['coverageAreas'] != null ? List<String>.from(json['coverageAreas']) : null,
      coverageArea: json['coverageArea']?.toString(),
      playbackMode: json['playbackMode']?.toString(),
      isActive: json['isActive'] is bool ? json['isActive'] : null,
      offeringType: json['offeringType']?.toString(),
      riderRequirements: json['riderRequirements']?.toString(),
      sampleTracks: json['sampleTracks'] != null ? List<String>.from(json['sampleTracks']) : null,
      showReels: json['showReels'] != null ? List<String>.from(json['showReels']) : null,
      timeBand: json['timeBand']?.toString(),
      maxSlotsPerBand: json['maxSlotsPerBand'] != null ? int.tryParse(json['maxSlotsPerBand'].toString()) : null,
      bookedSlots: json['bookedSlots'] != null ? int.tryParse(json['bookedSlots'].toString()) : null,
      loopDurationSeconds: json['loopDurationSeconds'] != null ? int.tryParse(json['loopDurationSeconds'].toString()) : null,
      spotDurationSeconds: json['spotDurationSeconds'] != null ? int.tryParse(json['spotDurationSeconds'].toString()) : null,
      maxSpots: json['maxSpots'] != null ? int.tryParse(json['maxSpots'].toString()) : null,
      operatingHours: json['operatingHours']?.toString(),
      features: json['features'] != null
          ? (json['features'] is List
              ? List<String>.from(json['features'])
              : [json['features'].toString()])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'parentType': parentType,
      'slotNumber': slotNumber,
      'duration': duration,
      'price': price,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'bookedBy': bookedBy,
      'maxRevisions': maxRevisions,
      'audience': audience,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'platforms': platforms,
      'title': title,
      'description': description,
      'badge': badge,
      'ordersCount': ordersCount,
      'userId': userId,
      'createdById': createdById,
      'partnerType': partnerType,
      'contentTypes': contentTypes,
      'audienceSize': audienceSize,
      'timeWindow': timeWindow,
      'adFormat': adFormat,
      'contentRequirements': contentRequirements,
      'locationId': locationId,
      'coverageAreas': coverageAreas,
      'coverageArea': coverageArea,
      'playbackMode': playbackMode,
      'isActive': isActive,
      if (offeringType != null) 'offeringType': offeringType,
      if (riderRequirements != null) 'riderRequirements': riderRequirements,
      if (sampleTracks != null) 'sampleTracks': sampleTracks,
      if (showReels != null) 'showReels': showReels,
      if (timeBand != null) 'timeBand': timeBand,
      if (maxSlotsPerBand != null) 'maxSlotsPerBand': maxSlotsPerBand,
      if (bookedSlots != null) 'bookedSlots': bookedSlots,
      if (loopDurationSeconds != null) 'loopDurationSeconds': loopDurationSeconds,
      if (spotDurationSeconds != null) 'spotDurationSeconds': spotDurationSeconds,
      if (maxSpots != null) 'maxSpots': maxSpots,
      if (operatingHours != null) 'operatingHours': operatingHours,
      if (features != null) 'features': features,
    };
  }

  AdSlotModel copyWith({
    String? id,
    String? parentId,
    String? parentType,
    String? slotNumber,
    String? duration,
    double? price,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? bookedBy,
    int? maxRevisions,
    String? audience,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? platforms,
    String? title,
    String? description,
    String? badge,
    int? ordersCount,
    int? userId,
    int? createdById,
    String? partnerType,
    List<String>? contentTypes,
    String? audienceSize,
    String? timeWindow,
    String? adFormat,
    List<String>? contentRequirements,
    int? locationId,
    List<String>? coverageAreas,
    String? coverageArea,
    List<String>? features,
    String? playbackMode,
    bool? isActive,
    String? offeringType,
    String? riderRequirements,
    List<String>? sampleTracks,
    List<String>? showReels,
    String? timeBand,
    int? maxSlotsPerBand,
    int? bookedSlots,
    int? loopDurationSeconds,
    int? spotDurationSeconds,
    int? maxSpots,
    String? operatingHours,
  }) {
    return AdSlotModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      parentType: parentType ?? this.parentType,
      slotNumber: slotNumber ?? this.slotNumber,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      bookedBy: bookedBy ?? this.bookedBy,
      maxRevisions: maxRevisions ?? this.maxRevisions,
      audience: audience ?? this.audience,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      platforms: platforms ?? this.platforms,
      title: title ?? this.title,
      description: description ?? this.description,
      badge: badge ?? this.badge,
      ordersCount: ordersCount ?? this.ordersCount,
      userId: userId ?? this.userId,
      createdById: createdById ?? this.createdById,
      partnerType: partnerType ?? this.partnerType,
      contentTypes: contentTypes ?? this.contentTypes,
      audienceSize: audienceSize ?? this.audienceSize,
      timeWindow: timeWindow ?? this.timeWindow,
      adFormat: adFormat ?? this.adFormat,
      contentRequirements: contentRequirements ?? this.contentRequirements,
      locationId: locationId ?? this.locationId,
      coverageAreas: coverageAreas ?? this.coverageAreas,
      coverageArea: coverageArea ?? this.coverageArea,
      playbackMode: playbackMode ?? this.playbackMode,
      isActive: isActive ?? this.isActive,
      offeringType: offeringType ?? this.offeringType,
      riderRequirements: riderRequirements ?? this.riderRequirements,
      sampleTracks: sampleTracks ?? this.sampleTracks,
      showReels: showReels ?? this.showReels,
      timeBand: timeBand ?? this.timeBand,
      maxSlotsPerBand: maxSlotsPerBand ?? this.maxSlotsPerBand,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      loopDurationSeconds: loopDurationSeconds ?? this.loopDurationSeconds,
      spotDurationSeconds: spotDurationSeconds ?? this.spotDurationSeconds,
      maxSpots: maxSpots ?? this.maxSpots,
      operatingHours: operatingHours ?? this.operatingHours,
      features: features ?? this.features,
    );
  }
}
