import 'dart:convert';

class QuickCheckConfig {
  final List<QuickCheckQuestion> questions;
  final List<RiskLevelConfig> riskLevels;
  final String scoringMethod;
  final double saturationK;

  const QuickCheckConfig({
    required this.questions,
    required this.riskLevels,
    this.scoringMethod = 'soft_saturation_cf',
    this.saturationK = 0.35,
  });

  factory QuickCheckConfig.fromJson(Map<String, dynamic> json) {
    return QuickCheckConfig(
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map(
                (q) => QuickCheckQuestion.fromJson(q as Map<String, dynamic>),
              )
              .toList() ??
          [],
      riskLevels:
          (json['riskLevels'] as List<dynamic>?)
              ?.map((r) => RiskLevelConfig.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      scoringMethod: json['scoringMethod'] as String? ?? 'soft_saturation_cf',
      saturationK: (json['saturationK'] as num?)?.toDouble() ?? 0.35,
    );
  }

  Map<String, dynamic> toJson() => {
    'questions': questions.map((q) => q.toJson()).toList(),
    'riskLevels': riskLevels.map((r) => r.toJson()).toList(),
    'scoringMethod': scoringMethod,
    'saturationK': saturationK,
  };

  String toJsonString() => jsonEncode(toJson());

  static QuickCheckConfig fromJsonString(String s) =>
      QuickCheckConfig.fromJson(jsonDecode(s) as Map<String, dynamic>);

  RiskLevelConfig? findRiskLevel(double totalScore, int tbTypeId) {
    return riskLevels.cast<RiskLevelConfig?>().firstWhere(
      (r) =>
          r!.tbTypeId == tbTypeId &&
          totalScore >= r.minScore &&
          totalScore <= r.maxScore,
      orElse: () => null,
    );
  }

  static QuickCheckConfig fullFallback() {
    return QuickCheckConfig(
      scoringMethod: 'soft_saturation_cf',
      saturationK: 0.35,
      questions: [
        // GENERAL SYMPTOMS (Step 1 - Pulmonary Base)
        QuickCheckQuestion(
          questionId: 1,
          symptomId: 1,
          symptomCode: 'G01',
          symptomName: 'Batuk terus-menerus dan berdahak selama tiga minggu/lebih',
          symptomDescription:
              'Batuk berdahak yang berlangsung lama dan tidak membaik dalam tiga minggu atau lebih.',
          questionText:
              'Batuk terus-menerus dan berdahak selama tiga minggu atau lebih',
          sortOrder: 1,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.8),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: 0.4),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: 0.4),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: -0.6,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 2,
          symptomId: 2,
          symptomCode: 'G02',
          symptomName: 'Dahak bercampur darah/batuk darah',
          symptomDescription:
              'Dahak terlihat bercampur darah atau keluar darah saat batuk.',
          questionText: 'Dahak bercampur darah atau batuk darah',
          sortOrder: 2,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.6),
          ],
        ),
        QuickCheckQuestion(
          questionId: 3,
          symptomId: 3,
          symptomCode: 'G03',
          symptomName: 'Demam yang berlangsung lama',
          symptomDescription:
              'Demam berulang atau menetap dalam waktu lama tanpa penyebab yang jelas.',
          questionText: 'Demam yang berlangsung lama',
          sortOrder: 3,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.6),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: 0.4),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: 0.6),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: -0.4,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 4,
          symptomId: 4,
          symptomCode: 'G04',
          symptomName: 'Sesak nafas dan nyeri dada',
          symptomDescription:
              'Napas terasa berat atau pendek, disertai rasa nyeri atau tidak nyaman di dada.',
          questionText: 'Sesak nafas dan nyeri dada',
          sortOrder: 4,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.6),
          ],
        ),
        QuickCheckQuestion(
          questionId: 5,
          symptomId: 5,
          symptomCode: 'G05',
          symptomName: 'Penurunan nafsu makan',
          symptomDescription: 'Keinginan makan menurun dibandingkan kondisi biasanya.',
          questionText: 'Penurunan nafsu makan',
          sortOrder: 5,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.8),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: 0.6),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: 0.4),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: 0.6,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 6,
          symptomId: 6,
          symptomCode: 'G06',
          symptomName: 'Penurunan berat badan',
          symptomDescription:
              'Berat badan turun tanpa sedang menjalani program diet atau penyebab yang jelas.',
          questionText: 'Penurunan berat badan',
          sortOrder: 6,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.8),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: 0.6),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: 0.4),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: 0.8,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 7,
          symptomId: 7,
          symptomCode: 'G07',
          symptomName: 'Rasa kurang enak badan/malaise, lemah',
          symptomDescription:
              'Tubuh terasa tidak fit, lemah, lesu, atau mudah lelah dalam aktivitas harian.',
          questionText: 'Rasa kurang enak badan, malaise, atau lemah',
          sortOrder: 7,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.8),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: 1.0),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: 1.0),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: 1.0,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 8,
          symptomId: 8,
          symptomCode: 'G08',
          symptomName: 'Berkeringat di malam hari walaupun tidak melakukan apa-apa',
          symptomDescription:
              'Keringat berlebih muncul pada malam hari meskipun tidak sedang beraktivitas berat.',
          questionText:
              'Berkeringat di malam hari walaupun tidak melakukan aktivitas berat',
          sortOrder: 8,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(tbTypeId: 1, tbTypeName: 'TBC Paru', weight: 0.6),
            TbTypeWeight(tbTypeId: 2, tbTypeName: 'TBC Kelenjar', weight: -0.4),
            TbTypeWeight(tbTypeId: 3, tbTypeName: 'TBC Payudara', weight: -0.4),
            TbTypeWeight(
              tbTypeId: 4,
              tbTypeName: 'TBC Tulang Belakang',
              weight: 0.4,
            ),
          ],
        ),

        // LYMPH NODE TB SPECIFIC (Step 2)
        QuickCheckQuestion(
          questionId: 15,
          symptomId: 27,
          symptomCode: 'G09',
          symptomName: 'Munculnya benjolan pada kelenjar (leher, ketiak, sela paha)',
          symptomDescription:
              'Terdapat benjolan di area kelenjar seperti leher, ketiak, atau sela paha.',
          questionText:
              'Munculnya benjolan pada bagian yang mengalami gangguan kelenjar seperti leher, sela paha, serta ketiak',
          sortOrder: 15,
          weight: 1.0,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 16,
          symptomId: 28,
          symptomCode: 'G10',
          symptomName: 'Ada tanda-tanda radang di sekitar benjolan kelenjar',
          symptomDescription:
              'Area sekitar benjolan tampak meradang, misalnya kemerahan, hangat, nyeri, atau bengkak.',
          questionText: 'Adanya tanda radang di daerah sekitar benjolan kelenjar',
          sortOrder: 16,
          weight: 0.8,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 17,
          symptomId: 29,
          symptomCode: 'G11',
          symptomName: 'Benjolan kelenjar mudah digerakkan',
          symptomDescription:
              'Benjolan terasa dapat bergeser saat disentuh atau ditekan perlahan.',
          questionText: 'Benjolan kelenjar mudah digerakkan',
          sortOrder: 17,
          weight: 0.8,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 18,
          symptomId: 30,
          symptomCode: 'G12',
          symptomName: 'Benjolan kelenjar terasa kenyal',
          symptomDescription: 'Benjolan memiliki tekstur kenyal saat diraba.',
          questionText: 'Benjolan kelenjar terasa kenyal',
          sortOrder: 18,
          weight: 0.8,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 19,
          symptomId: 31,
          symptomCode: 'G13',
          symptomName: 'Pembesaran benjolan kelenjar yang memburuk',
          symptomDescription:
              'Ukuran benjolan bertambah besar atau keluhan terasa semakin berat dari waktu ke waktu.',
          questionText:
              'Membesarnya benjolan kelenjar yang menyebabkan hari demi hari kondisinya semakin memburuk dan merusak tubuh',
          sortOrder: 19,
          weight: 1.0,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 20,
          symptomId: 32,
          symptomCode: 'G14',
          symptomName: 'Benjolan pecah dan mengeluarkan nanah',
          symptomDescription:
              'Benjolan terbuka atau pecah and mengeluarkan cairan seperti nanah.',
          questionText:
              'Benjolan kelenjar pecah dan mengeluarkan cairan seperti nanah yang kotor',
          sortOrder: 20,
          weight: 0.8,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),
        QuickCheckQuestion(
          questionId: 21,
          symptomId: 33,
          symptomCode: 'G15',
          symptomName: 'Luka pada kulit akibat pecahnya benjolan kelenjar',
          symptomDescription:
              'Muncul luka di kulit setelah benjolan pecah atau mengeluarkan cairan.',
          questionText:
              'Terdapat luka pada jaringan kulit atau kulit yang disebabkan pecahnya benjolan kelenjar getah bening',
          sortOrder: 21,
          weight: 1.0,
          tbTypeId: 2,
          tbTypeName: 'TBC Kelenjar',
        ),

        // BREAST TB SPECIFIC (Step 3)
        QuickCheckQuestion(
          questionId: 28,
          symptomId: 34,
          symptomCode: 'G16',
          symptomName: 'Timbulnya benjolan di payudara',
          symptomDescription:
              'Terdapat benjolan pada area payudara yang sebelumnya tidak ada.',
          questionText: 'Timbulnya benjolan di payudara',
          sortOrder: 28,
          weight: 1.0,
          tbTypeId: 3,
          tbTypeName: 'TBC Payudara',
        ),
        QuickCheckQuestion(
          questionId: 29,
          symptomId: 35,
          symptomCode: 'G17',
          symptomName: 'Rasa nyeri di bagian payudara',
          symptomDescription: 'Payudara terasa nyeri, sakit, atau tidak nyaman.',
          questionText: 'Rasa nyeri di bagian payudara',
          sortOrder: 29,
          weight: 0.8,
          tbTypeId: 3,
          tbTypeName: 'TBC Payudara',
        ),
        QuickCheckQuestion(
          questionId: 30,
          symptomId: 36,
          symptomCode: 'G18',
          symptomName: 'Radang di sekitar benjolan payudara',
          symptomDescription:
              'Area sekitar benjolan payudara tampak meradang, seperti kemerahan, bengkak, hangat, atau nyeri.',
          questionText:
              'Adanya tanda radang di sekitar benjolan yang timbul di payudara',
          sortOrder: 30,
          weight: 0.8,
          tbTypeId: 3,
          tbTypeName: 'TBC Payudara',
        ),

        // SPINAL TB SPECIFIC (Step 4)
        QuickCheckQuestion(
          questionId: 37,
          symptomId: 37,
          symptomCode: 'G19',
          symptomName: 'Nyeri atau kaku pada punggung',
          symptomDescription:
              'Punggung terasa nyeri, kaku, atau sulit digerakkan dengan nyaman.',
          questionText:
              'Rasa nyeri atau sakit pada bagian punggung atau mengalami kekakuan punggung',
          sortOrder: 37,
          weight: 1.0,
          tbTypeId: 4,
          tbTypeName: 'TBC Tulang Belakang',
        ),
        QuickCheckQuestion(
          questionId: 38,
          symptomId: 38,
          symptomCode: 'G20',
          symptomName: 'Enggan menggerakkan punggung',
          symptomDescription:
              'Menghindari gerakan punggung karena terasa nyeri, kaku, atau tidak nyaman.',
          questionText: 'Penderita enggan menggerakkan punggungnya',
          sortOrder: 38,
          weight: 1.0,
          tbTypeId: 4,
          tbTypeName: 'TBC Tulang Belakang',
        ),
        QuickCheckQuestion(
          questionId: 39,
          symptomId: 39,
          symptomCode: 'G21',
          symptomName: 'Menolak membungkuk / mengangkat barang',
          symptomDescription:
              'Kesulitan atau enggan membungkuk dan mengangkat barang karena keluhan pada punggung.',
          questionText:
              'Penderita menolak untuk membungkuk atau mengangkat barang dari lantai karena akan menekuk lututnya agar punggung tetap lurus',
          sortOrder: 39,
          weight: 1.0,
          tbTypeId: 4,
          tbTypeName: 'TBC Tulang Belakang',
        ),
        QuickCheckQuestion(
          questionId: 40,
          symptomId: 40,
          symptomCode: 'G22',
          symptomName: 'Nyeri punggung berkurang saat istirahat',
          symptomDescription: 'Nyeri punggung terasa lebih ringan ketika beristirahat.',
          questionText:
              'Rasa nyeri atau sakit pada punggung berkurang ketika penderita beristirahat',
          sortOrder: 40,
          weight: 1.0,
          tbTypeId: 4,
          tbTypeName: 'TBC Tulang Belakang',
        ),
        QuickCheckQuestion(
          questionId: 41,
          symptomId: 41,
          symptomCode: 'G23',
          symptomName: 'Benjolan di tulang belakang',
          symptomDescription:
              'Terdapat benjolan atau perubahan bentuk yang terasa atau terlihat di area tulang belakang.',
          questionText: 'Timbulnya benjolan di bagian punggung atau tulang belakang',
          sortOrder: 41,
          weight: 0.6,
          tbTypeId: 4,
          tbTypeName: 'TBC Tulang Belakang',
        ),
      ],
      riskLevels: [
        // Pulmonary
        RiskLevelConfig(
          id: 1,
          tbTypeId: 1,
          code: 'low',
          title: 'Low Risk',
          minScore: 0,
          maxScore: 58.00,
          description:
              'Persentase hasil berada pada rentang risiko rendah berdasarkan perhitungan certainty factor.',
          recommendation:
              'Pantau kondisi kesehatan dan lakukan pemeriksaan ulang jika gejala menetap atau memburuk.',
        ),
        RiskLevelConfig(
          id: 2,
          tbTypeId: 1,
          code: 'medium',
          title: 'Medium Risk',
          minScore: 58.01,
          maxScore: 73.00,
          description:
              'Persentase hasil berada pada rentang risiko sedang berdasarkan perhitungan certainty factor.',
          recommendation:
              'Disarankan berkonsultasi dengan tenaga kesehatan, terutama jika batuk, demam, atau berat badan turun berlangsung lama.',
        ),
        RiskLevelConfig(
          id: 3,
          tbTypeId: 1,
          code: 'high',
          title: 'High Risk',
          minScore: 73.01,
          maxScore: 100.00,
          description:
              'Persentase hasil berada pada rentang risiko tinggi berdasarkan perhitungan certainty factor.',
          recommendation:
              'Segera lakukan pemeriksaan ke fasilitas kesehatan untuk evaluasi lebih lanjut.',
        ),
        // Lymph
        RiskLevelConfig(
          id: 4,
          tbTypeId: 2,
          code: 'low',
          title: 'Low Risk',
          minScore: 0,
          maxScore: 58.00,
          description:
              'Persentase hasil berada pada rentang risiko rendah berdasarkan perhitungan certainty factor.',
          recommendation:
              'Pantau benjolan atau keluhan lain, dan periksa jika ukuran membesar atau muncul tanda radang.',
        ),
        RiskLevelConfig(
          id: 5,
          tbTypeId: 2,
          code: 'medium',
          title: 'Medium Risk',
          minScore: 58.01,
          maxScore: 73.00,
          description:
              'Persentase hasil berada pada rentang risiko sedang berdasarkan perhitungan certainty factor.',
          recommendation:
              'Disarankan berkonsultasi dengan tenaga kesehatan jika benjolan menetap, membesar, atau terasa nyeri.',
        ),
        RiskLevelConfig(
          id: 6,
          tbTypeId: 2,
          code: 'high',
          title: 'High Risk',
          minScore: 73.01,
          maxScore: 100.00,
          description:
              'Persentase hasil berada pada rentang risiko tinggi berdasarkan perhitungan certainty factor.',
          recommendation:
              'Segera lakukan pemeriksaan medis, terutama jika benjolan pecah, bernanah, atau terus membesar.',
        ),
        // Breast
        RiskLevelConfig(
          id: 7,
          tbTypeId: 3,
          code: 'low',
          title: 'Low Risk',
          minScore: 0,
          maxScore: 58.00,
          description:
              'Persentase hasil berada pada rentang risiko rendah berdasarkan perhitungan certainty factor.',
          recommendation:
              'Pantau perubahan pada payudara dan lakukan pemeriksaan jika keluhan menetap.',
        ),
        RiskLevelConfig(
          id: 8,
          tbTypeId: 3,
          code: 'medium',
          title: 'Medium Risk',
          minScore: 58.01,
          maxScore: 73.00,
          description:
              'Persentase hasil berada pada rentang risiko sedang berdasarkan perhitungan certainty factor.',
          recommendation:
              'Disarankan berkonsultasi dengan tenaga kesehatan jika terdapat benjolan, nyeri, atau tanda radang.',
        ),
        RiskLevelConfig(
          id: 9,
          tbTypeId: 3,
          code: 'high',
          title: 'High Risk',
          minScore: 73.01,
          maxScore: 100.00,
          description:
              'Persentase hasil berada pada rentang risiko tinggi berdasarkan perhitungan certainty factor.',
          recommendation:
              'Segera lakukan pemeriksaan medis untuk evaluasi benjolan atau radang pada payudara.',
        ),
        // Spinal
        RiskLevelConfig(
          id: 10,
          tbTypeId: 4,
          code: 'low',
          title: 'Low Risk',
          minScore: 0,
          maxScore: 58.00,
          description:
              'Persentase hasil berada pada rentang risiko rendah berdasarkan perhitungan certainty factor.',
          recommendation:
              'Pantau nyeri atau kaku pada punggung dan periksa jika keluhan tidak membaik.',
        ),
        RiskLevelConfig(
          id: 11,
          tbTypeId: 4,
          code: 'medium',
          title: 'Medium Risk',
          minScore: 58.01,
          maxScore: 73.00,
          description:
              'Persentase hasil berada pada rentang risiko sedang berdasarkan perhitungan certainty factor.',
          recommendation:
              'Disarankan berkonsultasi dengan tenaga kesehatan jika nyeri punggung menetap atau mengganggu aktivitas.',
        ),
        RiskLevelConfig(
          id: 12,
          tbTypeId: 4,
          code: 'high',
          title: 'High Risk',
          minScore: 73.01,
          maxScore: 100.00,
          description:
              'Persentase hasil berada pada rentang risiko tinggi berdasarkan perhitungan certainty factor.',
          recommendation:
              'Segera lakukan pemeriksaan medis, terutama jika nyeri berat, kaku, atau ada benjolan di tulang belakang.',
        ),
      ],
    );
  }

  static QuickCheckConfig fallback() {
    return QuickCheckConfig(
      questions: [
        QuickCheckQuestion(
          questionId: 1,
          symptomId: 1,
          symptomCode: 'G01',
          symptomName: 'Batuk terus-menerus dan berdahak selama tiga minggu/lebih',
          symptomDescription:
              'Batuk berdahak yang berlangsung lama dan tidak membaik dalam tiga minggu atau lebih.',
          questionText:
              'Batuk terus-menerus dan berdahak selama tiga minggu atau lebih',
          sortOrder: 1,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.8,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 2,
          symptomId: 2,
          symptomCode: 'G02',
          symptomName: 'Dahak bercampur darah/batuk darah',
          symptomDescription:
              'Dahak terlihat bercampur darah atau keluar darah saat batuk.',
          questionText: 'Dahak bercampur darah atau batuk darah',
          sortOrder: 2,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.6,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 3,
          symptomId: 3,
          symptomCode: 'G03',
          symptomName: 'Demam yang berlangsung lama',
          symptomDescription:
              'Demam berulang atau menetap dalam waktu lama tanpa penyebab yang jelas.',
          questionText: 'Demam yang berlangsung lama',
          sortOrder: 3,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.6,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 4,
          symptomId: 4,
          symptomCode: 'G04',
          symptomName: 'Sesak nafas dan nyeri dada',
          symptomDescription:
              'Napas terasa berat or pendek, disertai rasa nyeri or tidak nyaman di dada.',
          questionText: 'Sesak nafas dan nyeri dada',
          sortOrder: 4,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.6,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 5,
          symptomId: 5,
          symptomCode: 'G05',
          symptomName: 'Penurunan nafsu makan',
          symptomDescription: 'Keinginan makan menurun dibandingkan kondisi biasanya.',
          questionText: 'Penurunan nafsu makan',
          sortOrder: 5,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.8,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 6,
          symptomId: 6,
          symptomCode: 'G06',
          symptomName: 'Penurunan berat badan',
          symptomDescription:
              'Penurunan berat badan tanpa sebab yang jelas atau sedang tidak menjalani program diet.',
          questionText: 'Penurunan berat badan',
          sortOrder: 6,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.8,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 7,
          symptomId: 7,
          symptomCode: 'G07',
          symptomName: 'Rasa kurang enak badan/malaise, lemah',
          symptomDescription:
              'Tubuh terasa tidak fit, lemah, lesu, atau mudah lelah dalam aktivitas harian.',
          questionText: 'Rasa kurang enak badan, malaise, atau lemah',
          sortOrder: 7,
          weight: 0.8,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.8,
            ),
          ],
        ),
        QuickCheckQuestion(
          questionId: 8,
          symptomId: 8,
          symptomCode: 'G08',
          symptomName: 'Berkeringat di malam hari walaupun tidak melakukan apa-apa',
          symptomDescription:
              'Keringat berlebih muncul pada malam hari meskipun tidak sedang beraktivitas berat.',
          questionText:
              'Berkeringat di malam hari walaupun tidak melakukan aktivitas berat',
          sortOrder: 8,
          weight: 0.6,
          tbTypeId: 1,
          tbTypeName: 'TBC Paru',
          applicableTbTypes: [
            TbTypeWeight(
              tbTypeId: 1,
              tbTypeName: 'TBC Paru',
              weight: 0.6,
            ),
          ],
        ),
      ],
      riskLevels: [
        RiskLevelConfig(
          id: 1,
          tbTypeId: 1,
          code: 'LOW',
          title: 'Low Risk',
          minScore: 0,
          maxScore: 58.00,
          description:
              'Persentase hasil berada pada rentang risiko rendah berdasarkan perhitungan certainty factor.',
          recommendation:
              'Pantau kondisi kesehatan dan lakukan pemeriksaan ulang jika gejala menetap atau memburuk.',
        ),
        RiskLevelConfig(
          id: 2,
          tbTypeId: 1,
          code: 'MEDIUM',
          title: 'Medium Risk',
          minScore: 58.01,
          maxScore: 73.00,
          description:
              'Persentase hasil berada pada rentang risiko sedang berdasarkan perhitungan certainty factor.',
          recommendation:
              'Disarankan berkonsultasi dengan tenaga kesehatan, terutama jika batuk, demam, atau berat badan turun berlangsung lama.',
        ),
        RiskLevelConfig(
          id: 3,
          tbTypeId: 1,
          code: 'HIGH',
          title: 'High Risk',
          minScore: 73.01,
          maxScore: 100.00,
          description:
              'Persentase hasil berada pada rentang risiko tinggi berdasarkan perhitungan certainty factor.',
          recommendation:
              'Segera lakukan pemeriksaan ke fasilitas kesehatan untuk evaluasi lebih lanjut.',
        ),
      ],
    );
  }
}

class TbTypeWeight {
  final int tbTypeId;
  final String tbTypeName;
  final double weight;

  const TbTypeWeight({
    required this.tbTypeId,
    required this.tbTypeName,
    required this.weight,
  });

  factory TbTypeWeight.fromJson(Map<String, dynamic> json) {
    return TbTypeWeight(
      tbTypeId: (json['tbTypeId'] as num).toInt(),
      tbTypeName: json['tbTypeName'] as String? ?? '',
      weight: (json['weight'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'tbTypeId': tbTypeId,
    'tbTypeName': tbTypeName,
    'weight': weight,
  };
}

class QuickCheckQuestion {
  final int questionId;
  final int symptomId;
  final String symptomCode;
  final String symptomName;
  final String? symptomDescription;
  final String questionText;
  final int sortOrder;
  final bool isRequired;
  final double weight;
  final int tbTypeId;
  final String? tbTypeName;
  final List<TbTypeWeight> applicableTbTypes;

  const QuickCheckQuestion({
    required this.questionId,
    required this.symptomId,
    required this.symptomCode,
    required this.symptomName,
    this.symptomDescription,
    required this.questionText,
    required this.sortOrder,
    this.isRequired = true,
    required this.weight,
    required this.tbTypeId,
    this.tbTypeName,
    this.applicableTbTypes = const [],
  });

  bool get isGeneral {
    if (!symptomCode.startsWith('G')) return false;
    final digits = symptomCode.replaceAll(RegExp(r'[^0-9]'), '');
    final numPart = int.tryParse(digits);
    if (numPart == null) return false;
    return numPart >= 1 &&
        numPart <= 8 &&
        !symptomCode.contains(RegExp(r'[a-z]'));
  }

  factory QuickCheckQuestion.fromJson(Map<String, dynamic> json) {
    return QuickCheckQuestion(
      questionId: (json['questionId'] as num).toInt(),
      symptomId: (json['symptomId'] as num).toInt(),
      symptomCode: json['symptomCode'] as String? ?? '',
      symptomName: json['symptomName'] as String? ?? '',
      symptomDescription: json['symptomDescription'] as String?,
      questionText: json['questionText'] as String? ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isRequired: json['isRequired'] as bool? ?? true,
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      tbTypeId: (json['tbTypeId'] as num?)?.toInt() ?? 0,
      tbTypeName: json['tbTypeName'] as String?,
      applicableTbTypes:
          (json['applicableTbTypes'] as List<dynamic>?)
              ?.map((e) => TbTypeWeight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'symptomId': symptomId,
    'symptomCode': symptomCode,
    'symptomName': symptomName,
    'symptomDescription': symptomDescription,
    'questionText': questionText,
    'sortOrder': sortOrder,
    'isRequired': isRequired,
    'weight': weight,
    'tbTypeId': tbTypeId,
    'tbTypeName': tbTypeName,
    'applicableTbTypes': applicableTbTypes.map((e) => e.toJson()).toList(),
  };
}

class RiskLevelConfig {
  final int id;
  final int tbTypeId;
  final String code;
  final String title;
  final double minScore;
  final double maxScore;
  final String? description;
  final String? recommendation;

  const RiskLevelConfig({
    required this.id,
    required this.tbTypeId,
    required this.code,
    required this.title,
    required this.minScore,
    required this.maxScore,
    this.description,
    this.recommendation,
  });

  factory RiskLevelConfig.fromJson(Map<String, dynamic> json) {
    return RiskLevelConfig(
      id: (json['id'] as num).toInt(),
      tbTypeId: (json['tbTypeId'] as num).toInt(),
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      minScore: (json['minScore'] as num).toDouble(),
      maxScore: (json['maxScore'] as num).toDouble(),
      description: json['description'] as String?,
      recommendation: json['recommendation'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tbTypeId': tbTypeId,
    'code': code,
    'title': title,
    'minScore': minScore,
    'maxScore': maxScore,
    'description': description,
    'recommendation': recommendation,
  };
}
