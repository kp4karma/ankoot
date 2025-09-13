class EventDataModel {
  bool? errorStatus;
  List<Data>? data;

  EventDataModel({this.errorStatus, this.data});

  EventDataModel.fromJson(Map<String, dynamic> json) {
    errorStatus = json['errorStatus'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorStatus'] = this.errorStatus;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? eventId;
  String? eventName;
  String? eventDesc;
  String? eventLocation;
  String? eventMaxPrasadDate;
  String? eventDate;
  String? eventItemLastDate;
  bool? isPrasadActive;
  String? status;
  String? cdt;
  String? udt;

  Data(
      {this.eventId,
        this.eventName,
        this.eventDesc,
        this.eventLocation,
        this.eventMaxPrasadDate,
        this.eventDate,
        this.eventItemLastDate,
        this.isPrasadActive,
        this.status,
        this.cdt,
        this.udt});

  Data.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventDesc = json['event_desc'];
    eventLocation = json['event_location'];
    eventMaxPrasadDate = json['event_max_prasad_date'];
    eventDate = json['event_date'];
    eventItemLastDate = json['event_item_last_date'];
    isPrasadActive = json['is_prasad_active'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_desc'] = this.eventDesc;
    data['event_location'] = this.eventLocation;
    data['event_max_prasad_date'] = this.eventMaxPrasadDate;
    data['event_date'] = this.eventDate;
    data['event_item_last_date'] = this.eventItemLastDate;
    data['is_prasad_active'] = this.isPrasadActive;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}
