import { PrismaClient, QualityStatus } from '@prisma/client';

const prisma = new PrismaClient();

// ============================================
// Topic Taxonomy for Grades 1-12
// Format: G{grade}_{DOMAIN}_{NN}
// ============================================

interface TopicSeed {
  code: string;
  nameId: string;
  nameEn: string;
  description?: string;
  difficultyBaseline: number;
}

const topicTaxonomy: Record<number, TopicSeed[]> = {
  // Grade 1 (SD)
  1: [
    { code: 'G1_NUM_01', nameId: 'Mengenal Angka 1-10', nameEn: 'Numbers 1-10', difficultyBaseline: 1 },
    { code: 'G1_NUM_02', nameId: 'Mengenal Angka 11-20', nameEn: 'Numbers 11-20', difficultyBaseline: 1 },
    { code: 'G1_NUM_03', nameId: 'Penjumlahan Dasar', nameEn: 'Basic Addition', difficultyBaseline: 1 },
    { code: 'G1_NUM_04', nameId: 'Pengurangan Dasar', nameEn: 'Basic Subtraction', difficultyBaseline: 1 },
    { code: 'G1_MEA_01', nameId: 'Mengenal Waktu', nameEn: 'Introduction to Time', difficultyBaseline: 1 },
    { code: 'G1_GEO_01', nameId: 'Bentuk Dasar', nameEn: 'Basic Shapes', difficultyBaseline: 1 },
  ],
  // Grade 2 (SD)
  2: [
    { code: 'G2_NUM_01', nameId: 'Angka Sampai 100', nameEn: 'Numbers up to 100', difficultyBaseline: 1 },
    { code: 'G2_NUM_02', nameId: 'Penjumlahan Lebih Dari 10', nameEn: 'Addition beyond 10', difficultyBaseline: 2 },
    { code: 'G2_NUM_03', nameId: 'Pengurangan Lebih Dari 10', nameEn: 'Subtraction beyond 10', difficultyBaseline: 2 },
    { code: 'G2_NUM_04', nameId: 'Perkalian Dasar', nameEn: 'Basic Multiplication', difficultyBaseline: 2 },
    { code: 'G2_MEA_01', nameId: 'Satuan Panjang', nameEn: 'Length Units', difficultyBaseline: 1 },
    { code: 'G2_MEA_02', nameId: 'Satuan Berat', nameEn: 'Weight Units', difficultyBaseline: 1 },
  ],
  // Grade 3 (SD)
  3: [
    { code: 'G3_NUM_01', nameId: 'Angka Sampai 1000', nameEn: 'Numbers up to 1000', difficultyBaseline: 2 },
    { code: 'G3_NUM_02', nameId: 'Perkalian dan Pembagian', nameEn: 'Multiplication and Division', difficultyBaseline: 2 },
    { code: 'G3_NUM_03', nameId: 'Operasi Campuran', nameEn: 'Mixed Operations', difficultyBaseline: 3 },
    { code: 'G3_MEA_01', nameId: 'Satuan Waktu', nameEn: 'Time Units', difficultyBaseline: 2 },
    { code: 'G3_MEA_02', nameId: 'Satuan Uang', nameEn: 'Money Units', difficultyBaseline: 2 },
    { code: 'G3_GEO_01', nameId: 'Sudut dan Garis', nameEn: 'Angles and Lines', difficultyBaseline: 2 },
  ],
  // Grade 4 (SD)
  4: [
    { code: 'G4_NUM_01', nameId: 'Angka Sampai 10000', nameEn: 'Numbers up to 10000', difficultyBaseline: 2 },
    { code: 'G4_NUM_02', nameId: 'Perkalian Bersusun', nameEn: 'Long Multiplication', difficultyBaseline: 3 },
    { code: 'G4_NUM_03', nameId: 'Pembagian Bersusun', nameEn: 'Long Division', difficultyBaseline: 3 },
    { code: 'G4_NUM_04', nameId: 'Faktor dan Kelipatan', nameEn: 'Factors and Multiples', difficultyBaseline: 3 },
    { code: 'G4_GEO_01', nameId: 'Keliling dan Luas Persegi', nameEn: 'Perimeter and Area of Squares', difficultyBaseline: 3 },
    { code: 'G4_DAT_01', nameId: 'Pengumpulan Data', nameEn: 'Data Collection', difficultyBaseline: 2 },
  ],
  // Grade 5 (SD)
  5: [
    { code: 'G5_NUM_01', nameId: 'Bilangan Bulat', nameEn: 'Integers', difficultyBaseline: 3 },
    { code: 'G5_NUM_02', nameId: 'Perpangkatan', nameEn: 'Exponentiation', difficultyBaseline: 3 },
    { code: 'G5_NUM_03', nameId: 'Operasi Hitung Campuran', nameEn: 'Mixed Arithmetic', difficultyBaseline: 3 },
    { code: 'G5_NUM_04', nameId: 'FPB dan KPK', nameEn: 'GCD and LCM', difficultyBaseline: 3 },
    { code: 'G5_FRC_01', nameId: 'Pecahan Dasar', nameEn: 'Basic Fractions', difficultyBaseline: 3 },
    { code: 'G5_GEO_01', nameId: 'Luas Segitiga dan Jajargenjang', nameEn: 'Area of Triangles and Parallelograms', difficultyBaseline: 3 },
  ],
  // Grade 6 (SD)
  6: [
    { code: 'G6_NUM_01', nameId: 'Bilangan Bulat Positif dan Negatif', nameEn: 'Positive and Negative Integers', difficultyBaseline: 3 },
    { code: 'G6_FRC_01', nameId: 'Operasi Pecahan', nameEn: 'Fraction Operations', difficultyBaseline: 4 },
    { code: 'G6_FRC_02', nameId: 'Perbandingan', nameEn: 'Ratios', difficultyBaseline: 3 },
    { code: 'G6_FRC_03', nameId: 'Skala', nameEn: 'Scale', difficultyBaseline: 3 },
    { code: 'G6_GEO_01', nameId: 'Volume Kubus dan Balok', nameEn: 'Volume of Cubes and Blocks', difficultyBaseline: 3 },
    { code: 'G6_DAT_01', nameId: 'Diagram Lingkaran', nameEn: 'Pie Charts', difficultyBaseline: 3 },
  ],
  // Grade 7 (SMP)
  7: [
    { code: 'G7_NUM_01', nameId: 'Bilangan Bulat', nameEn: 'Integers', difficultyBaseline: 3 },
    { code: 'G7_NUM_02', nameId: 'Bilangan Pecahan', nameEn: 'Fractions', difficultyBaseline: 3 },
    { code: 'G7_ALG_01', nameId: 'Himpunan', nameEn: 'Sets', difficultyBaseline: 3 },
    { code: 'G7_ALG_02', nameId: 'Persamaan Linear Satu Variabel', nameEn: 'Linear Equations One Variable', difficultyBaseline: 4 },
    { code: 'G7_ALG_03', nameId: 'Pertidaksamaan Linear', nameEn: 'Linear Inequalities', difficultyBaseline: 4 },
    { code: 'G7_GEO_01', nameId: 'Segitiga dan Segiempat', nameEn: 'Triangles and Quadrilaterals', difficultyBaseline: 3 },
    { code: 'G7_GEO_02', nameId: 'Garis dan Sudut', nameEn: 'Lines and Angles', difficultyBaseline: 3 },
    { code: 'G7_DAT_01', nameId: 'Statistika Dasar', nameEn: 'Basic Statistics', difficultyBaseline: 3 },
  ],
  // Grade 8 (SMP)
  8: [
    { code: 'G8_ALG_01', nameId: 'Pola Bilangan', nameEn: 'Number Patterns', difficultyBaseline: 3 },
    { code: 'G8_ALG_02', nameId: 'Persamaan Linear Dua Variabel', nameEn: 'Linear Equations Two Variables', difficultyBaseline: 4 },
    { code: 'G8_ALG_03', nameId: 'SPLTV', nameEn: 'System of Linear Equations', difficultyBaseline: 4 },
    { code: 'G8_ALG_04', nameId: 'Fungsi', nameEn: 'Functions', difficultyBaseline: 4 },
    { code: 'G8_ALG_05', nameId: 'Gradien dan Persamaan Garis', nameEn: 'Gradient and Line Equations', difficultyBaseline: 4 },
    { code: 'G8_GEO_01', nameId: 'Teorema Pythagoras', nameEn: 'Pythagorean Theorem', difficultyBaseline: 4 },
    { code: 'G8_GEO_02', nameId: 'Lingkaran', nameEn: 'Circles', difficultyBaseline: 4 },
    { code: 'G8_GEO_03', nameId: 'Kongruen dan Kesebangunan', nameEn: 'Congruence and Similarity', difficultyBaseline: 4 },
  ],
  // Grade 9 (SMP)
  9: [
    { code: 'G9_ALG_01', nameId: 'Persamaan dan Fungsi Kuadrat', nameEn: 'Quadratic Equations and Functions', difficultyBaseline: 4 },
    { code: 'G9_ALG_02', nameId: 'Fungsi Eksponen', nameEn: 'Exponential Functions', difficultyBaseline: 4 },
    { code: 'G9_GEO_01', nameId: 'Tabung, Kerucut, dan Bola', nameEn: 'Cylinders, Cones, and Spheres', difficultyBaseline: 4 },
    { code: 'G9_DAT_01', nameId: 'Peluang', nameEn: 'Probability', difficultyBaseline: 3 },
    { code: 'G9_PRO_01', nameId: 'Statistika Lanjut', nameEn: 'Advanced Statistics', difficultyBaseline: 4 },
    { code: 'G9_GEO_02', nameId: 'Transformasi Geometri', nameEn: 'Geometric Transformations', difficultyBaseline: 4 },
  ],
  // Grade 10 (SMA)
  10: [
    { code: 'G10_ALG_01', nameId: 'Sistem Persamaan Linear', nameEn: 'Systems of Linear Equations', difficultyBaseline: 4 },
    { code: 'G10_ALG_02', nameId: 'Vektor', nameEn: 'Vectors', difficultyBaseline: 4 },
    { code: 'G10_ALG_03', nameId: 'Matriks', nameEn: 'Matrices', difficultyBaseline: 4 },
    { code: 'G10_ALG_04', nameId: 'Barisan dan Deret', nameEn: 'Sequences and Series', difficultyBaseline: 4 },
    { code: 'G10_ALG_05', nameId: 'Logaritma', nameEn: 'Logarithms', difficultyBaseline: 4 },
    { code: 'G10_GEO_01', nameId: 'Trigonometri Dasar', nameEn: 'Basic Trigonometry', difficultyBaseline: 4 },
    { code: 'G10_PRO_01', nameId: 'Peluang', nameEn: 'Probability', difficultyBaseline: 4 },
  ],
  // Grade 11 (SMA)
  11: [
    { code: 'G11_ALG_01', nameId: 'Fungsi Komposisi dan Invers', nameEn: 'Function Composition and Inverse', difficultyBaseline: 5 },
    { code: 'G11_ALG_02', nameId: 'Persamaan dan Pertidaksamaan Rasional', nameEn: 'Rational Equations and Inequalities', difficultyBaseline: 5 },
    { code: 'G11_ALG_03', nameId: 'Limit Fungsi', nameEn: 'Function Limits', difficultyBaseline: 5 },
    { code: 'G11_ALG_04', nameId: 'Turunan Fungsi', nameEn: 'Function Derivatives', difficultyBaseline: 5 },
    { code: 'G11_GEO_01', nameId: 'Trigonometri Lanjut', nameEn: 'Advanced Trigonometry', difficultyBaseline: 5 },
    { code: 'G11_GEO_02', nameId: 'Program Linear', nameEn: 'Linear Programming', difficultyBaseline: 4 },
    { code: 'G11_DAT_01', nameId: 'Statistika Inferensial', nameEn: 'Inferential Statistics', difficultyBaseline: 5 },
  ],
  // Grade 12 (SMA)
  12: [
    { code: 'G12_ALG_01', nameId: 'Integral', nameEn: 'Integrals', difficultyBaseline: 5 },
    { code: 'G12_ALG_02', nameId: 'Aplikasi Turunan', nameEn: 'Derivative Applications', difficultyBaseline: 5 },
    { code: 'G12_ALG_03', nameId: 'Aplikasi Integral', nameEn: 'Integral Applications', difficultyBaseline: 5 },
    { code: 'G12_GEO_01', nameId: 'Dimensi Tiga', nameEn: 'Three Dimensions', difficultyBaseline: 5 },
    { code: 'G12_PRO_01', nameId: 'Distribusi Peluang', nameEn: 'Probability Distributions', difficultyBaseline: 5 },
    { code: 'G12_PRO_02', nameId: 'Uji Hipotesis', nameEn: 'Hypothesis Testing', difficultyBaseline: 5 },
  ],
};

// ============================================
// Sample Questions
// ============================================

interface QuestionSeed {
  grade: number;
  topicCode: string;
  difficulty: number;
  question: string;
  options: string[];
  correctAnswer: number;
  explanation: string;
}

const sampleQuestions: QuestionSeed[] = [
  // Grade 1
  {
    grade: 1,
    topicCode: 'G1_NUM_01',
    difficulty: 1,
    question: 'Berapakah jumlah apel jika ada 3 apel dan ditambah 2 apel?',
    options: ['4', '5', '6', '7'],
    correctAnswer: 1,
    explanation: '3 + 2 = 5',
  },
  {
    grade: 1,
    topicCode: 'G1_NUM_02',
    difficulty: 1,
    question: 'Angka sesudah 15 adalah?',
    options: ['14', '15', '16', '17'],
    correctAnswer: 2,
    explanation: 'Urutan angka: 14, 15, 16, 17',
  },
  // Grade 5
  {
    grade: 5,
    topicCode: 'G5_NUM_04',
    difficulty: 3,
    question: 'FPB dari 12 dan 18 adalah?',
    options: ['2', '3', '6', '9'],
    correctAnswer: 2,
    explanation: 'Faktor 12: 1, 2, 3, 4, 6, 12. Faktor 18: 1, 2, 3, 6, 9, 18. FPB = 6',
  },
  {
    grade: 5,
    topicCode: 'G5_FRC_01',
    difficulty: 3,
    question: '1/2 + 1/4 = ?',
    options: ['1/4', '2/4', '3/4', '1'],
    correctAnswer: 2,
    explanation: '1/2 = 2/4, jadi 2/4 + 1/4 = 3/4',
  },
  // Grade 8
  {
    grade: 8,
    topicCode: 'G8_ALG_02',
    difficulty: 4,
    question: 'Jika x + y = 10 dan x - y = 2, maka nilai x adalah?',
    options: ['4', '5', '6', '8'],
    correctAnswer: 2,
    explanation: 'Dari kedua persamaan: 2x = 12, jadi x = 6',
  },
  // Grade 11
  {
    grade: 11,
    topicCode: 'G11_ALG_03',
    difficulty: 5,
    question: 'Limit dari (x² - 9)/(x - 3) saat x mendekati 3 adalah?',
    options: ['0', '3', '6', '9'],
    correctAnswer: 2,
    explanation: 'Faktorkan: (x-3)(x+3)/(x-3) = x+3. Saat x→3, hasil = 6',
  },
];

async function seedTopics() {
  console.log('🌱 Seeding topics...');

  for (const [grade, topics] of Object.entries(topicTaxonomy)) {
    for (let i = 0; i < topics.length; i++) {
      const topic = topics[i];
      await prisma.topic.upsert({
        where: { 
          grade_code: { 
            grade: parseInt(grade), 
            code: topic.code 
          } 
        },
        update: {
          nameId: topic.nameId,
          nameEn: topic.nameEn,
          description: topic.description,
          difficultyBaseline: topic.difficultyBaseline,
          sortOrder: i,
          isActive: true,
        },
        create: {
          grade: parseInt(grade),
          code: topic.code,
          nameId: topic.nameId,
          nameEn: topic.nameEn,
          description: topic.description,
          difficultyBaseline: topic.difficultyBaseline,
          sortOrder: i,
          isActive: true,
        },
      });
    }
  }

  console.log(`✅ Seeded ${Object.values(topicTaxonomy).flat().length} topics`);
}

async function seedQuestions() {
  console.log('🌱 Seeding sample questions...');

  for (const q of sampleQuestions) {
    // Find topic
    const topic = await prisma.topic.findUnique({
      where: {
        grade_code: {
          grade: q.grade,
          code: q.topicCode,
        },
      },
    });

    if (!topic) {
      console.warn(`⚠️ Topic not found: ${q.topicCode} for grade ${q.grade}`);
      continue;
    }

    await prisma.question.upsert({
      where: {
        id: `seed-${q.grade}-${q.topicCode}-${q.question.slice(0, 20)}`,
      },
      update: {
        question: q.question,
        options: q.options,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation,
        difficulty: q.difficulty,
        qualityStatus: QualityStatus.APPROVED,
      },
      create: {
        id: `seed-${q.grade}-${q.topicCode}-${q.question.slice(0, 20)}`,
        grade: q.grade,
        topicId: topic.id,
        question: q.question,
        options: q.options,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation,
        difficulty: q.difficulty,
        sourceType: 'CURATED',
        qualityStatus: QualityStatus.APPROVED,
        timeLimit: 90,
      },
    });
  }

  console.log(`✅ Seeded ${sampleQuestions.length} sample questions`);
}

async function seedQuestionTemplates() {
  console.log('🌱 Seeding question templates...');

  // Find a topic for templates
  const topic = await prisma.topic.findFirst({
    where: { grade: 5, code: 'G5_NUM_01' },
  });

  if (!topic) {
    console.warn('⚠️ Topic not found for templates');
    return;
  }

  const templates = [
    {
      code: 'TMPL_ADD_BASIC',
      generatorConfig: {
        type: 'addition',
        range: [1, 100],
        operands: 2,
        format: 'Berapakah {a} + {b}?',
      },
      difficulty: 2,
    },
    {
      code: 'TMPL_MUL_TABLE',
      generatorConfig: {
        type: 'multiplication',
        tables: [2, 3, 4, 5, 6, 7, 8, 9],
        format: '{a} × {b} = ?',
      },
      difficulty: 2,
    },
  ];

  for (const tmpl of templates) {
    await prisma.questionTemplate.upsert({
      where: { code: tmpl.code },
      update: {
        generatorConfig: tmpl.generatorConfig,
        difficulty: tmpl.difficulty,
      },
      create: {
        code: tmpl.code,
        topicId: topic.id,
        grade: topic.grade,
        generatorConfig: tmpl.generatorConfig,
        difficulty: tmpl.difficulty,
        qualityStatus: QualityStatus.APPROVED,
      },
    });
  }

  console.log(`✅ Seeded ${templates.length} question templates`);
}

async function main() {
  console.log('🚀 Start seeding...\n');

  try {
    await seedTopics();
    await seedQuestions();
    await seedQuestionTemplates();

    console.log('\n✨ Seeding completed successfully!');
  } catch (error) {
    console.error('\n❌ Seeding failed:', error);
    process.exit(1);
  }
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
