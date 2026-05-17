class SupplementModel {
  final String title;
  final String color;
  final List<Link> links;

  SupplementModel({
    required this.title,
    required this.color,
    required this.links,
  });

  factory SupplementModel.fromJson(Map<String, dynamic> json) {
    return SupplementModel(
      title: json["title"],
      color: json["color"],
      links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "color": color,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
      };
}

class Link {
  final String title;
  final String link;

  Link({
    required this.title,
    required this.link,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        title: json["title"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "link": link,
      };
}

class Supplement {
  final String id;
  final String title;
  final String subheading;
  final String type;
  final String description;
  final String dosage;
  final List<String> ingredients;
  final String imageUrl;
  final List<String> links; // New field for links

  Supplement({
    required this.id,
    required this.title,
    required this.subheading,
    required this.type,
    required this.description,
    required this.dosage,
    required this.ingredients,
    required this.imageUrl,
    required this.links, // Initialize in constructor
  });

  factory Supplement.fromJson(Map<String, dynamic> json) {
    return Supplement(
      id: json['id'] as String,
      title: json['title'] as String,
      subheading: json['subheading'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      dosage: json['dosage'] as String,
      ingredients: List<String>.from(json['ingredients']),
      imageUrl: json['imageUrl'] as String,
      links: List<String>.from(json['links']), // Deserialize links
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subheading': subheading,
      'type': type,
      'description': description,
      'dosage': dosage,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'links': links, // Serialize links
    };
  }
}

List<Supplement> dummySupplements = [
  Supplement(
    id: '001',
    title: 'Vitamin C',
    subheading: 'Immune Support',
    type: 'Vitamin',
    description: 'Helps support the immune system and promotes healthy skin.',
    dosage: '500mg daily',
    ingredients: ['Vitamin C', 'Citrus Bioflavonoids'],
    imageUrl:
        'https://domf5oio6qrcr.cloudfront.net/medialibrary/12476/4a8249f2-8997-4a4e-97f1-b9ff4cca08c3.jpg',
    links: [
      'https://www.healthline.com/nutrition/vitamin-c-benefits',
      'https://www.webmd.com/vitamins/ai/ingredientmono-1001/vitamin-c',
      'https://www.healthline.com/nutrition/vitamin-c-benefits',
    ],
  ),
  Supplement(
    id: '002',
    title: 'Omega-3 Fish Oil',
    subheading: 'Heart Health',
    type: 'Oil',
    description: 'Supports heart health and brain function.',
    dosage: '1000mg daily',
    ingredients: ['Fish Oil', 'EPA', 'DHA'],
    imageUrl:
        'https://d2jx2rerrg6sh3.cloudfront.net/image-handler/picture/2019/4/shutterstock_210587053.jpg',
    links: [
      'https://www.healthline.com/nutrition/omega-3-fish-oil',
      'https://www.webmd.com/diet/guide/omega-3-fatty-acids-fact-sheet',
    ],
  ),
  Supplement(
    id: '003',
    title: 'Calcium + Vitamin D',
    subheading: 'Bone Strength',
    type: 'Mineral',
    description: 'Promotes bone density and strength.',
    dosage: '600mg Calcium, 800IU Vitamin D daily',
    ingredients: ['Calcium Carbonate', 'Vitamin D3'],
    imageUrl:
        'https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2021/04/bigstock-Dietary-Supplement-17285192.jpg?fit=1600%2C1067&ssl=1',
    links: [
      'https://www.healthline.com/nutrition/calcium-and-vitamin-d',
      'https://www.webmd.com/osteoporosis/features/the-truth-about-calcium-and-vitamin-d',
    ],
  ),
  Supplement(
    id: '004',
    title: 'Probiotic',
    subheading: 'Digestive Health',
    type: 'Probiotic',
    description: 'Supports a healthy digestive system and immune function.',
    dosage: '1 capsule daily',
    ingredients: ['Lactobacillus', 'Bifidobacterium'],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeVxVJe5KtyWuCoajk3DGlUwWd-rUx_A_t2Q&s',
    links: [
      'https://www.healthline.com/nutrition/probiotics-101',
      'https://www.webmd.com/digestive-disorders/features/what-are-probiotics',
    ],
  ),
  Supplement(
    id: '005',
    title: 'Multivitamin',
    subheading: 'Daily Nutritional Support',
    type: 'Vitamin',
    description: 'Provides essential vitamins and minerals for overall health.',
    dosage: '1 tablet daily',
    ingredients: ['Vitamin A', 'Vitamin B Complex', 'Vitamin C', 'Iron'],
    imageUrl:
        'https://d2jx2rerrg6sh3.cloudfront.net/image-handler/picture/2019/4/shutterstock_210587053.jpg',
    links: [
      'https://www.healthline.com/nutrition/multivitamins',
      'https://www.webmd.com/vitamins/ai/ingredientmono-990/multivitamins',
    ],
  ),
  Supplement(
    id: '006',
    title: 'Magnesium',
    subheading: 'Muscle Relaxation',
    type: 'Mineral',
    description: 'Helps relax muscles and supports nervous system health.',
    dosage: '400mg daily',
    ingredients: ['Magnesium Citrate'],
    imageUrl:
        'https://i0.wp.com/www.strengthlog.com/wp-content/uploads/2021/04/bigstock-Dietary-Supplement-17285192.jpg?fit=1600%2C1067&ssl=1',
    links: [
      'https://www.healthline.com/nutrition/magnesium-benefits',
      'https://www.webmd.com/diet/supplement-guide-magnesium',
    ],
  ),
];
