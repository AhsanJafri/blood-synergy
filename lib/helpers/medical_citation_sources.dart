/// Pattern-specific educational citations supplied for App Review 1.4.1.
class CitationLink {
  const CitationLink({required this.title, required this.url});

  final String title;
  final String url;

  String get host {
    try {
      return Uri.parse(url).host.replaceFirst(RegExp(r'^www\.'), '');
    } catch (_) {
      return url;
    }
  }
}

class CitationPattern {
  const CitationPattern({
    required this.number,
    required this.shortName,
    required this.sources,
    required this.accentColor,
  });

  final int number;
  final String shortName;
  final List<CitationLink> sources;
  final int accentColor; // 0xAARRGGBB

  String get name => '$shortName (Pattern $number)';
}

class MedicalCitationSources {
  MedicalCitationSources._();

  /// General lab / health foundations (shown in compact widgets).
  static const general = <CitationLink>[
    CitationLink(
      title: 'NIH / MedlinePlus — Lab Tests',
      url: 'https://medlineplus.gov/lab-tests/',
    ),
    CitationLink(
      title: 'NIH / MedlinePlus — Understanding Lab Results',
      url: 'https://medlineplus.gov/laboratorytests.html',
    ),
    CitationLink(
      title: 'CDC — Cholesterol',
      url: 'https://www.cdc.gov/cholesterol/',
    ),
    CitationLink(
      title: 'American Heart Association — Cholesterol',
      url: 'https://www.heart.org/en/health-topics/cholesterol',
    ),
    CitationLink(
      title: 'NIH / NHLBI — Blood Tests',
      url: 'https://www.nhlbi.nih.gov/health/blood-tests',
    ),
  ];

  static const patterns = <CitationPattern>[
    CitationPattern(
      number: 1,
      shortName: 'Energy',
      accentColor: 0xFFCF1B21,
      sources: [
        CitationLink(
          title: 'Oxford RDM — Energy / metabolism publication',
          url: 'https://rdm.ox.ac.uk/publications/1803725',
        ),
        CitationLink(
          title: 'PMC — Iron / metabolic energy research',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC9892593',
        ),
        CitationLink(
          title: 'Drugs.com — Irospan / pancrelipase interaction reference',
          url:
              'https://www.drugs.com/drug-interactions/irospan-24-6-with-pancrelipase-1663-15274-1787-0.html',
        ),
        CitationLink(
          title: 'PubMed — Related clinical study (23980906)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/23980906/',
        ),
      ],
    ),
    CitationPattern(
      number: 2,
      shortName: 'Digestion',
      accentColor: 0xFF2A9D8F,
      sources: [
        CitationLink(
          title: 'PubMed — Digestive health study (30108163)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/30108163/',
        ),
        CitationLink(
          title: 'DOAJ — Open-access digestion article',
          url: 'https://doaj.org/article/d1b2360358474919a2d6588593499d10',
        ),
        CitationLink(
          title: 'Holistic Primary Care — Digestive health',
          url: 'https://holisticprimarycare.net/?p=2024',
        ),
        CitationLink(
          title: 'World Journal of Gastroenterology — GI research',
          url: 'https://wjgnet.com/1007-9327/full/v10/i13/1992.htm',
        ),
        CitationLink(
          title: 'Gut Cited — Related paper',
          url: 'https://gutcited.com/papers/9888411/',
        ),
      ],
    ),
    CitationPattern(
      number: 3,
      shortName: 'Inflammation',
      accentColor: 0xFFE9C46A,
      sources: [
        CitationLink(
          title: 'PMC — Inflammation research (PMC3914936)',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3914936',
        ),
        CitationLink(
          title: 'PubMed — Inflammatory markers (31420233)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/31420233/',
        ),
        CitationLink(
          title: 'PubMed — Related study (24787907)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/24787907/',
        ),
        CitationLink(
          title: 'PubMed — Related study (26378571)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/26378571/',
        ),
        CitationLink(
          title: 'Bond University — Mediterranean diet & inflammation',
          url:
              'https://research.bond.edu.au/en/publications/mediterranean-type-diets-and-inflammatory-markers-in-patients-wit/',
        ),
      ],
    ),
    CitationPattern(
      number: 4,
      shortName: 'Blood Sugar',
      accentColor: 0xFFE76F51,
      sources: [
        CitationLink(
          title: 'Frontiers in Pharmacology — Blood glucose research',
          url:
              'https://www.frontiersin.org/articles/10.3389/fphar.2025.1572197/full',
        ),
        CitationLink(
          title: 'Springer — Cardiovascular / metabolic study',
          url: 'https://link.springer.com/10.1186/s12933-017-0590-y',
        ),
        CitationLink(
          title: 'British Journal of Sports Medicine — Activity & glucose',
          url: 'https://bjsm.bmj.com/content/50/23/1438',
        ),
        CitationLink(
          title: 'University of Adelaide thesis — Metabolic research',
          url: 'https://thesis.library.adelaide.edu.au/dspace/handle/2440/75779',
        ),
        CitationLink(
          title: 'PubMed — Related study (20578205)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/20578205/',
        ),
      ],
    ),
    CitationPattern(
      number: 5,
      shortName: 'Hypothyroid',
      accentColor: 0xFF264653,
      sources: [
        CitationLink(
          title: 'University of Bern — Thyroid research',
          url: 'https://boris.unibe.ch/191950',
        ),
        CitationLink(
          title: 'PubMed — Thyroid study (27702392)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/27702392/',
        ),
        CitationLink(
          title: 'CSUS Scholars — Iodine intake & thyroid',
          url:
              'https://scholars.csus.edu/esploro/outputs/journalArticle/Effect-of-iodine-intake-on-thyroid/99257888394901671',
        ),
        CitationLink(
          title: 'ESMED — Thyroid / endocrine article',
          url: 'https://esmed.org/MRA/mra/article/view/7478',
        ),
        CitationLink(
          title: 'DOAJ — Open-access thyroid article',
          url: 'https://doaj.org/article/da19513947e5409db8e3d2f64c0b8e4e',
        ),
        CitationLink(
          title: 'SciELO — Endocrine / thyroid publication',
          url: 'https://www.scielo.br/j/aem/a/39CVtxCxFwqt5BzYYkMmHHL/?ilang=en',
        ),
      ],
    ),
    CitationPattern(
      number: 6,
      shortName: "Hashimoto's Thyroid",
      accentColor: 0xFF7B2CBF,
      sources: [
        CitationLink(
          title: "PMC — Hashimoto's research (PMC7973118)",
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC7973118',
        ),
        CitationLink(
          title: 'Endocrine Abstracts — Clinical abstract',
          url: 'https://www.endocrine-abstracts.org/ea/0084/ea0084op-05-25',
        ),
        CitationLink(
          title: 'PMC — Related thyroid study (PMC8347530)',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8347530',
        ),
        CitationLink(
          title: 'PMC — Related thyroid study (PMC8711703)',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8711703',
        ),
        CitationLink(
          title: 'PMC — Related thyroid study (PMC11652148)',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC11652148',
        ),
      ],
    ),
    CitationPattern(
      number: 7,
      shortName: 'Brain Health',
      accentColor: 0xFF5CAE41,
      sources: [
        CitationLink(
          title:
              'Endocrine Society — Hypopituitarism hormone replacement guideline',
          url:
              'https://www.endocrine.org/guidelines-and-clinical-practice/clinical-practice-guidelines/hormone-replacement-in-hypopituitarism',
        ),
        CitationLink(
          title: 'PubMed — Related study (18415684)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/18415684/',
        ),
        CitationLink(
          title: 'DOAJ — Open-access brain / endocrine article',
          url: 'https://doaj.org/article/541bfb00edfa4beda6c9dafcda488a1c',
        ),
        CitationLink(
          title: 'PMC — Related study (PMC8002057)',
          url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8002057/',
        ),
        CitationLink(
          title: 'Endocrine Abstracts — Related abstract',
          url: 'https://www.endocrine-abstracts.org/ea/0032/ea0032p169',
        ),
        CitationLink(
          title: 'UniSR IRIS — Related research PDF',
          url:
              'https://iris.unisr.it//retrieve/handle/20.500.11768/174868/315081/unpaywall-bitstream--1632676334.pdf',
        ),
      ],
    ),
    CitationPattern(
      number: 8,
      shortName: 'Macrocytic Anemia',
      accentColor: 0xFF457B9D,
      sources: [
        CitationLink(
          title: 'AAFP — Folate / B12 deficiency overview (2006)',
          url: 'https://www.aafp.org/afp/2006/0101/p65',
        ),
        CitationLink(
          title: 'AAFP — Vitamin B12 deficiency (2011)',
          url: 'https://www.aafp.org/pubs/afp/issues/2011/0615/p1425.html',
        ),
        CitationLink(
          title: 'AAFP — Related anemia article (2009)',
          url: 'https://www.aafp.org/afp/2009/0201/p203.html',
        ),
        CitationLink(
          title: 'BMJ Best Practice — Macrocytosis aetiology',
          url: 'https://bestpractice.bmj.com/topics/en-us/822/aetiology',
        ),
        CitationLink(
          title: 'Superpower — Folate level educational guide',
          url: 'https://superpower.com/guides/folate-level-greater-than-20-means',
        ),
      ],
    ),
    CitationPattern(
      number: 9,
      shortName: 'Hepatic',
      accentColor: 0xFF9B7235,
      sources: [
        CitationLink(
          title: 'UMC Utrecht — Mediterranean diet, exercise & liver',
          url:
              'https://researchinformation.umcutrecht.nl/en/publications/effects-of-mediterranean-diet-exercise-and-their-combination-on-b/',
        ),
        CitationLink(
          title: 'Pharmacy Times — Milk thistle & liver disease',
          url:
              'https://www.pharmacytimes.com/view/the-humble-milk-thistle-an-intervention-for-liver-disease',
        ),
        CitationLink(
          title: 'PubMed — Related hepatic study (22308119)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/22308119',
        ),
        CitationLink(
          title: 'PubMed — Related hepatic study (33339155)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/33339155/',
        ),
        CitationLink(
          title: 'PMC — Liver research (PMC11940638)',
          url: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11940638/',
        ),
        CitationLink(
          title: 'PubMed — Related hepatic study (23603008)',
          url: 'https://pubmed.ncbi.nlm.nih.gov/23603008/',
        ),
      ],
    ),
  ];
}
