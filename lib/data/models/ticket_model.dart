class TicketModel {
    TicketModel({
        required this.id,
        required this.title,
        required this.description,
        required this.location,
        required this.date,
        required this.attachmentUrl,
        required this.userId,
    });

    final String? id;
    final String? title;
    final String? description;
    final String? location;
    final String ? date;
    final String? attachmentUrl;
    final String? userId;

    factory TicketModel.fromJson(Map<String, dynamic> json){ 
        return TicketModel(
            id: json["id"],
            title: json["title"],
            description: json["description"],
            location: json["location"],
            date: json["date"],
            attachmentUrl: json["attachmentUrl"],
            userId: json["userId"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "location": location,
        "date": date,
        "attachmentUrl": attachmentUrl,
        "userId": userId,
    };

}
