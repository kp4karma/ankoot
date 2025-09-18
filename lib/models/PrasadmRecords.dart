class PrasadmRecords {
  bool? errorStatus;
  Data? data;

  PrasadmRecords({this.errorStatus, this.data});

  PrasadmRecords.fromJson(Map<String, dynamic> json) {
    errorStatus = json['errorStatus'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorStatus'] = this.errorStatus;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? msg;
  FilterCriteria? filterCriteria;
  OverallSummary? overallSummary;
  List<PradeshWiseData>? pradeshWiseData;

  Data(
      {this.msg,
        this.filterCriteria,
        this.overallSummary,
        this.pradeshWiseData});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    filterCriteria = json['filter_criteria'] != null
        ? new FilterCriteria.fromJson(json['filter_criteria'])
        : null;
    overallSummary = json['overall_summary'] != null
        ? new OverallSummary.fromJson(json['overall_summary'])
        : null;
    if (json['pradesh_wise_data'] != null) {
      pradeshWiseData = <PradeshWiseData>[];
      json['pradesh_wise_data'].forEach((v) {
        pradeshWiseData!.add(new PradeshWiseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.filterCriteria != null) {
      data['filter_criteria'] = this.filterCriteria!.toJson();
    }
    if (this.overallSummary != null) {
      data['overall_summary'] = this.overallSummary!.toJson();
    }
    if (this.pradeshWiseData != null) {
      data['pradesh_wise_data'] =
          this.pradeshWiseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterCriteria {
  String? pradeshId;
  int? eventId;

  FilterCriteria({this.pradeshId, this.eventId});

  FilterCriteria.fromJson(Map<String, dynamic> json) {
    pradeshId = json['pradesh_id'];
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pradesh_id'] = this.pradeshId;
    data['event_id'] = this.eventId;
    return data;
  }
}

class OverallSummary {
  int? totalPradeshCount;
  int? pradeshWithData;
  int? pradeshWithZeroData;
  int? totalPrasadRecords;
  int? totalPrasadBoxQty;
  int? totalPrasadPacketQty;
  int? totalDeliverBoxQty;
  int? totalDeliverPacketQty;

  OverallSummary(
      {this.totalPradeshCount,
        this.pradeshWithData,
        this.pradeshWithZeroData,
        this.totalPrasadRecords,
        this.totalPrasadBoxQty,
        this.totalPrasadPacketQty,
        this.totalDeliverBoxQty,
        this.totalDeliverPacketQty});

  OverallSummary.fromJson(Map<String, dynamic> json) {
    totalPradeshCount = json['total_pradesh_count'];
    pradeshWithData = json['pradesh_with_data'];
    pradeshWithZeroData = json['pradesh_with_zero_data'];
    totalPrasadRecords = json['total_prasad_records'];
    totalPrasadBoxQty = json['total_prasad_box_qty'];
    totalPrasadPacketQty = json['total_prasad_packet_qty'];
    totalDeliverBoxQty = json['total_deliver_box_qty'];
    totalDeliverPacketQty = json['total_deliver_packet_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_pradesh_count'] = this.totalPradeshCount;
    data['pradesh_with_data'] = this.pradeshWithData;
    data['pradesh_with_zero_data'] = this.pradeshWithZeroData;
    data['total_prasad_records'] = this.totalPrasadRecords;
    data['total_prasad_box_qty'] = this.totalPrasadBoxQty;
    data['total_prasad_packet_qty'] = this.totalPrasadPacketQty;
    data['total_deliver_box_qty'] = this.totalDeliverBoxQty;
    data['total_deliver_packet_qty'] = this.totalDeliverPacketQty;
    return data;
  }
}

class PradeshWiseData {
  PradeshDetails? pradeshDetails;
  List<PrasadRecords>? prasadRecords;
  PradeshTotals? pradeshTotals;

  PradeshWiseData(
      {this.pradeshDetails, this.prasadRecords, this.pradeshTotals});

  PradeshWiseData.fromJson(Map<String, dynamic> json) {
    pradeshDetails = json['pradesh_details'] != null
        ? new PradeshDetails.fromJson(json['pradesh_details'])
        : null;
    if (json['prasad_records'] != null) {
      prasadRecords = <PrasadRecords>[];
      json['prasad_records'].forEach((v) {
        prasadRecords!.add(new PrasadRecords.fromJson(v));
      });
    }
    pradeshTotals = json['pradesh_totals'] != null
        ? new PradeshTotals.fromJson(json['pradesh_totals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pradeshDetails != null) {
      data['pradesh_details'] = this.pradeshDetails!.toJson();
    }
    if (this.prasadRecords != null) {
      data['prasad_records'] =
          this.prasadRecords!.map((v) => v.toJson()).toList();
    }
    if (this.pradeshTotals != null) {
      data['pradesh_totals'] = this.pradeshTotals!.toJson();
    }
    return data;
  }
}

class PradeshDetails {
  int? pradeshId;
  String? pradeshEngName;
  String? pradeshGujName;
  String? pradeshOldEngName;
  String? pradeshNewGujName;
  String? userIds;
  String? status;
  String? cdt;
  String? udt;

  PradeshDetails(
      {this.pradeshId,
        this.pradeshEngName,
        this.pradeshGujName,
        this.pradeshOldEngName,
        this.pradeshNewGujName,
        this.userIds,
        this.status,
        this.cdt,
        this.udt});

  PradeshDetails.fromJson(Map<String, dynamic> json) {
    pradeshId = json['pradesh_id'];
    pradeshEngName = json['pradesh_eng_name'];
    pradeshGujName = json['pradesh_guj_name'];
    pradeshOldEngName = json['pradesh_old_eng_name'];
    pradeshNewGujName = json['pradesh_new_guj_name'];
    userIds = json['user_ids'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pradesh_id'] = this.pradeshId;
    data['pradesh_eng_name'] = this.pradeshEngName;
    data['pradesh_guj_name'] = this.pradeshGujName;
    data['pradesh_old_eng_name'] = this.pradeshOldEngName;
    data['pradesh_new_guj_name'] = this.pradeshNewGujName;
    data['user_ids'] = this.userIds;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class PrasadRecords {
  EventDetails? eventDetails;
  int? prasadId;
  String? prasadBoxQty;
  String? prasadPacketQty;
  String? deliverBoxQty;
  String? deliverPacketQty;
  String? personMobile;
  String? personName;
  String? status;
  String? cdt;
  String? udt;

  PrasadRecords(
      {this.eventDetails,
        this.prasadId,
        this.prasadBoxQty,
        this.prasadPacketQty,
        this.deliverBoxQty,
        this.deliverPacketQty,
        this.personMobile,
        this.personName,
        this.status,
        this.cdt,
        this.udt});

  PrasadRecords.fromJson(Map<String, dynamic> json) {
    eventDetails = json['event_details'] != null
        ? new EventDetails.fromJson(json['event_details'])
        : null;
    prasadBoxQty = json['prasad_box_qty'].replaceAll(".00", "");
    prasadId = json['prasad_id'];
    prasadPacketQty = json['prasad_packet_qty'].toString().replaceAll(".00", "");
    deliverBoxQty = json['deliver_box_qty'].toString().replaceAll(".00", "");
    deliverPacketQty = json['deliver_packet_qty'].toString().replaceAll(".00", "");
    personMobile = json['person_mobile'];
    personName = json['person_name'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventDetails != null) {
      data['event_details'] = this.eventDetails!.toJson();
    }
    data['prasad_box_qty'] = this.prasadBoxQty;
    data['prasad_id'] = this.prasadId;
    data['prasad_packet_qty'] = this.prasadPacketQty;
    data['deliver_box_qty'] = this.deliverBoxQty;
    data['deliver_packet_qty'] = this.deliverPacketQty;
    data['person_mobile'] = this.personMobile;
    data['person_name'] = this.personName;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class EventDetails {
  int? eventId;
  String? eventName;
  String? eventDesc;
  String? eventLocation;
  String? eventDate;
  String? eventMaxPrasadDate;
  String? eventItemLastDate;
  bool? isPrasadActive;
  String? status;

  EventDetails(
      {this.eventId,
        this.eventName,
        this.eventDesc,
        this.eventLocation,
        this.eventDate,
        this.eventMaxPrasadDate,
        this.eventItemLastDate,
        this.isPrasadActive,
        this.status});

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventDesc = json['event_desc'];
    eventLocation = json['event_location'];
    eventDate = json['event_date'];
    eventMaxPrasadDate = json['event_max_prasad_date'];
    eventItemLastDate = json['event_item_last_date'];
    isPrasadActive = json['is_prasad_active'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_desc'] = this.eventDesc;
    data['event_location'] = this.eventLocation;
    data['event_date'] = this.eventDate;
    data['event_max_prasad_date'] = this.eventMaxPrasadDate;
    data['event_item_last_date'] = this.eventItemLastDate;
    data['is_prasad_active'] = this.isPrasadActive;
    data['status'] = this.status;
    return data;
  }
}

class PradeshTotals {
  int? totalBoxQty;
  int? totalPacketQty;
  int? totalDeliverBoxQty;
  int? totalDeliverPacketQty;
  int? totalRecords;

  PradeshTotals(
      {this.totalBoxQty,
        this.totalPacketQty,
        this.totalDeliverBoxQty,
        this.totalDeliverPacketQty,
        this.totalRecords});

  PradeshTotals.fromJson(Map<String, dynamic> json) {
    totalBoxQty = json['total_box_qty'];
    totalPacketQty = json['total_packet_qty'];
    totalDeliverBoxQty = json['total_deliver_box_qty'];
    totalDeliverPacketQty = json['total_deliver_packet_qty'];
    totalRecords = json['total_records'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_box_qty'] = this.totalBoxQty;
    data['total_packet_qty'] = this.totalPacketQty;
    data['total_deliver_box_qty'] = this.totalDeliverBoxQty;
    data['total_deliver_packet_qty'] = this.totalDeliverPacketQty;
    data['total_records'] = this.totalRecords;
    return data;
  }
}
