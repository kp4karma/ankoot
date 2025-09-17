class UserHistory {
  bool? errorStatus;
  Data? data;

  UserHistory({this.errorStatus, this.data});

  UserHistory.fromJson(Map<String, dynamic> json) {
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
  PradeshDetails? pradeshDetails;
  EventDetails? eventDetails;
  OverallSummary? overallSummary;
  List<PersonWiseData>? personWiseData;

  Data(
      {this.msg,
        this.filterCriteria,
        this.pradeshDetails,
        this.eventDetails,
        this.overallSummary,
        this.personWiseData});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    filterCriteria = json['filter_criteria'] != null
        ? new FilterCriteria.fromJson(json['filter_criteria'])
        : null;
    pradeshDetails = json['pradesh_details'] != null
        ? new PradeshDetails.fromJson(json['pradesh_details'])
        : null;
    eventDetails = json['event_details'] != null
        ? new EventDetails.fromJson(json['event_details'])
        : null;
    overallSummary = json['overall_summary'] != null
        ? new OverallSummary.fromJson(json['overall_summary'])
        : null;
    if (json['person_wise_data'] != null) {
      personWiseData = <PersonWiseData>[];
      json['person_wise_data'].forEach((v) {
        personWiseData!.add(new PersonWiseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.filterCriteria != null) {
      data['filter_criteria'] = this.filterCriteria!.toJson();
    }
    if (this.pradeshDetails != null) {
      data['pradesh_details'] = this.pradeshDetails!.toJson();
    }
    if (this.eventDetails != null) {
      data['event_details'] = this.eventDetails!.toJson();
    }
    if (this.overallSummary != null) {
      data['overall_summary'] = this.overallSummary!.toJson();
    }
    if (this.personWiseData != null) {
      data['person_wise_data'] =
          this.personWiseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterCriteria {
  int? pradeshId;
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

class EventDetails {
  int? eventId;
  String? eventName;
  String? eventDesc;
  String? eventLocation;
  String? eventDate;

  EventDetails(
      {this.eventId,
        this.eventName,
        this.eventDesc,
        this.eventLocation,
        this.eventDate});

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventDesc = json['event_desc'];
    eventLocation = json['event_location'];
    eventDate = json['event_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_desc'] = this.eventDesc;
    data['event_location'] = this.eventLocation;
    data['event_date'] = this.eventDate;
    return data;
  }
}

class OverallSummary {
  int? totalUniquePersons;
  int? totalFoodRecords;
  int? totalQuantity;
  int? totalCreditQuantity;
  int? totalDebitQuantity;
  int? netQuantity;

  OverallSummary(
      {this.totalUniquePersons,
        this.totalFoodRecords,
        this.totalQuantity,
        this.totalCreditQuantity,
        this.totalDebitQuantity,
        this.netQuantity});

  OverallSummary.fromJson(Map<String, dynamic> json) {
    totalUniquePersons = json['total_unique_persons'];
    totalFoodRecords = json['total_food_records'];
    totalQuantity = json['total_quantity'];
    totalCreditQuantity = json['total_credit_quantity'];
    totalDebitQuantity = json['total_debit_quantity'];
    netQuantity = json['net_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_unique_persons'] = this.totalUniquePersons;
    data['total_food_records'] = this.totalFoodRecords;
    data['total_quantity'] = this.totalQuantity;
    data['total_credit_quantity'] = this.totalCreditQuantity;
    data['total_debit_quantity'] = this.totalDebitQuantity;
    data['net_quantity'] = this.netQuantity;
    return data;
  }
}

class PersonWiseData {
  PersonDetails? personDetails;
  List<FoodItems>? foodItems;
  Summary? summary;

  PersonWiseData({this.personDetails, this.foodItems, this.summary});

  PersonWiseData.fromJson(Map<String, dynamic> json) {
    personDetails = json['person_details'] != null
        ? new PersonDetails.fromJson(json['person_details'])
        : null;
    if (json['food_items'] != null) {
      foodItems = <FoodItems>[];
      json['food_items'].forEach((v) {
        foodItems!.add(new FoodItems.fromJson(v));
      });
    }
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personDetails != null) {
      data['person_details'] = this.personDetails!.toJson();
    }
    if (this.foodItems != null) {
      data['food_items'] = this.foodItems!.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    return data;
  }
}

class PersonDetails {
  String? personMobile;
  String? personName;

  PersonDetails({this.personMobile, this.personName});

  PersonDetails.fromJson(Map<String, dynamic> json) {
    personMobile = json['person_mobile'];
    personName = json['person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_mobile'] = this.personMobile;
    data['person_name'] = this.personName;
    return data;
  }
}

class FoodItems {
  int? foodItemId;
  FoodItemDetails? foodItemDetails;
  String? foodQty;
  String? cdt;
  String? udt;

  FoodItems(
      {this.foodItemId,
        this.foodItemDetails,
        this.foodQty,
        this.cdt,
        this.udt});

  FoodItems.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    foodItemDetails = json['food_item_details'] != null
        ? new FoodItemDetails.fromJson(json['food_item_details'])
        : null;
    foodQty = json['food_qty'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    if (this.foodItemDetails != null) {
      data['food_item_details'] = this.foodItemDetails!.toJson();
    }
    data['food_qty'] = this.foodQty;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class FoodItemDetails {
  int? foodItemId;
  String? foodEngName;
  String? foodGujName;
  String? foodUnit;
  String? foodImageUrl;
  String? foodCategory;
  String? foodRemark;
  String? status;
  String? cdt;
  String? udt;

  FoodItemDetails(
      {this.foodItemId,
        this.foodEngName,
        this.foodGujName,
        this.foodUnit,
        this.foodImageUrl,
        this.foodCategory,
        this.foodRemark,
        this.status,
        this.cdt,
        this.udt});

  FoodItemDetails.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    foodEngName = json['food_eng_name'];
    foodGujName = json['food_guj_name'];
    foodUnit = json['food_unit'];
    foodImageUrl = json['food_image_url'];
    foodCategory = json['food_category'];
    foodRemark = json['food_remark'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    data['food_eng_name'] = this.foodEngName;
    data['food_guj_name'] = this.foodGujName;
    data['food_unit'] = this.foodUnit;
    data['food_image_url'] = this.foodImageUrl;
    data['food_category'] = this.foodCategory;
    data['food_remark'] = this.foodRemark;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class Summary {
  int? totalItems;
  int? totalQuantity;
  int? creditQuantity;
  int? debitQuantity;
  int? creditItems;
  int? debitItems;

  Summary(
      {this.totalItems,
        this.totalQuantity,
        this.creditQuantity,
        this.debitQuantity,
        this.creditItems,
        this.debitItems});

  Summary.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    totalQuantity = json['total_quantity'];
    creditQuantity = json['credit_quantity'];
    debitQuantity = json['debit_quantity'];
    creditItems = json['credit_items'];
    debitItems = json['debit_items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['total_quantity'] = this.totalQuantity;
    data['credit_quantity'] = this.creditQuantity;
    data['debit_quantity'] = this.debitQuantity;
    data['credit_items'] = this.creditItems;
    data['debit_items'] = this.debitItems;
    return data;
  }
}
