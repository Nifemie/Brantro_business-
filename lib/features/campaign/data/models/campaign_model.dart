import 'package:intl/intl.dart';

class CampaignModel {
  final int id;
  final int advertiserId;
  final String method;
  final String currency;
  final String amount;
  final String paymentRef;
  final String reference;
  final ChargeBreakdown chargeBreakdown;
  final String status;
  final String remark;
  final bool settled;
  final dynamic updateHistory;
  final DateTime? completedAt;
  final DateTime? pausedAt;
  final String? pauseReason;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PlacementModel> placements;

  CampaignModel({
    required this.id,
    required this.advertiserId,
    required this.method,
    required this.currency,
    required this.amount,
    required this.paymentRef,
    required this.reference,
    required this.chargeBreakdown,
    required this.status,
    required this.remark,
    required this.settled,
    this.updateHistory,
    this.completedAt,
    this.pausedAt,
    this.pauseReason,
    this.cancelledAt,
    this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
    required this.placements,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as int,
      advertiserId: json['advertiserId'] as int,
      method: json['method'] as String,
      currency: json['currency'] as String,
      amount: json['amount'] as String,
      paymentRef: json['paymentRef'] as String,
      reference: json['reference'] as String,
      chargeBreakdown: ChargeBreakdown.fromJson(json['chargeBreakdown']),
      status: json['status'] as String,
      remark: json['remark'] as String,
      settled: json['settled'] as bool,
      updateHistory: json['updateHistory'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      pausedAt: json['pausedAt'] != null ? DateTime.parse(json['pausedAt']) : null,
      pauseReason: json['pauseReason'] as String?,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      cancelReason: json['cancelReason'] as String?,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      placements: (json['placements'] as List<dynamic>)
          .map((p) => PlacementModel.fromJson(p))
          .toList(),
    );
  }

  String get formattedAmount {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '₦${formatter.format(double.parse(amount))}';
  }
  
  String get statusDisplay {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Requested';
      case 'ACCEPTED':
        return 'Accepted';
      case 'IN_PROGRESS':
      case 'ACTIVE':
        return 'In Progress';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      case 'PAUSED':
        return 'Paused';
      default:
        return status;
    }
  }
}

class ChargeBreakdown {
  final double subtotal;
  final double vatAmount;
  final double platformFee;
  final double totalPayable;
  final double serviceCharge;
  final double sellerNetAmount;

  ChargeBreakdown({
    required this.subtotal,
    required this.vatAmount,
    required this.platformFee,
    required this.totalPayable,
    required this.serviceCharge,
    required this.sellerNetAmount,
  });

  factory ChargeBreakdown.fromJson(Map<String, dynamic> json) {
    return ChargeBreakdown(
      subtotal: (json['subtotal'] as num).toDouble(),
      vatAmount: (json['vatAmount'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      totalPayable: (json['totalPayable'] as num).toDouble(),
      serviceCharge: (json['serviceCharge'] as num).toDouble(),
      sellerNetAmount: (json['sellerNetAmount'] as num).toDouble(),
    );
  }
}

class PlacementModel {
  final int id;
  final int advertiserId;
  final int campaignId;
  final int adSlotId;
  final DateTime? scheduledDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? acceptedAt;
  final DateTime? inProgressAt;
  final DateTime? slaBreachedAt;
  final String? slaReason;
  final bool slaBreached;
  final String amount;
  final String status;
  final String description;
  final List<AttachmentModel> attachments;
  final List<dynamic> updateHistory;
  final int createdById;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlacementModel({
    required this.id,
    required this.advertiserId,
    required this.campaignId,
    required this.adSlotId,
    this.scheduledDate,
    this.startDate,
    this.endDate,
    this.acceptedAt,
    this.inProgressAt,
    this.slaBreachedAt,
    this.slaReason,
    required this.slaBreached,
    required this.amount,
    required this.status,
    required this.description,
    required this.attachments,
    required this.updateHistory,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlacementModel.fromJson(Map<String, dynamic> json) {
    return PlacementModel(
      id: json['id'] as int,
      advertiserId: json['advertiserId'] as int,
      campaignId: json['campaignId'] as int,
      adSlotId: json['adSlotId'] as int,
      scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate']) : null,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      inProgressAt: json['inProgressAt'] != null ? DateTime.parse(json['inProgressAt']) : null,
      slaBreachedAt: json['slaBreachedAt'] != null ? DateTime.parse(json['slaBreachedAt']) : null,
      slaReason: json['slaReason'] as String?,
      slaBreached: json['slaBreached'] as bool,
      amount: json['amount'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      attachments: (json['attachments'] as List<dynamic>)
          .map((a) => AttachmentModel.fromJson(a))
          .toList(),
      updateHistory: json['updateHistory'] as List<dynamic>,
      createdById: json['createdById'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class AttachmentModel {
  final String id;
  final String name;
  final int size;
  final String status;
  final String mimeType;
  final String description;

  AttachmentModel({
    required this.id,
    required this.name,
    required this.size,
    required this.status,
    required this.mimeType,
    required this.description,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as int,
      status: json['status'] as String,
      mimeType: json['mimeType'] as String,
      description: json['description'] as String,
    );
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');
}
