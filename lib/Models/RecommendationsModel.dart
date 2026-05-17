class RecommendationsModel {
  final int id;
  final String? title;
  final String? color;
  final String? remarks;
  final String? symptoms;
  final String? recommendation;
  final String? result;
  final String? patternColor;

  RecommendationsModel({
    required this.id,
    required this.title,
    required this.color,
    required this.remarks,
    required this.symptoms,
    required this.recommendation,
    required this.result,
    required this.patternColor,
  });

  factory RecommendationsModel.fromJson(Map<String, dynamic> json) =>
      RecommendationsModel(
        id: json["id"],
        title: json["title"],
        color: json["color"],
        remarks: json["remarks"],
        symptoms: json["symptoms"],
        recommendation: json["recommendation"],
        result: json["result"],
        patternColor: json["pattern_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "color": color,
        "remarks": remarks,
        "symptoms": symptoms,
        "recommendation": recommendation,
        "result": result,
        "pattern_color": patternColor,
      };
}
