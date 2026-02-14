import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Start seeding...');

  // Seed sample questions for different grades
  const questions = [
    // Grade 1 - Basic addition
    {
      grade: 1,
      topic: 'penjumlahan',
      type: 'multiple_choice',
      question: 'Berapakah 2 + 3?',
      options: ['4', '5', '6', '7'],
      correctAnswer: 1,
      difficulty: 1,
    },
    {
      grade: 1,
      topic: 'penjumlahan',
      type: 'multiple_choice',
      question: '5 + 4 = ?',
      options: ['8', '9', '10', '11'],
      correctAnswer: 1,
      difficulty: 1,
    },
    // Grade 2 - Subtraction
    {
      grade: 2,
      topic: 'pengurangan',
      type: 'multiple_choice',
      question: '10 - 6 = ?',
      options: ['3', '4', '5', '6'],
      correctAnswer: 1,
      difficulty: 1,
    },
    // Grade 3 - Multiplication
    {
      grade: 3,
      topic: 'perkalian',
      type: 'multiple_choice',
      question: '4 × 5 = ?',
      options: ['18', '19', '20', '21'],
      correctAnswer: 2,
      difficulty: 1,
    },
    // Grade 4 - Division
    {
      grade: 4,
      topic: 'pembagian',
      type: 'multiple_choice',
      question: '36 ÷ 6 = ?',
      options: ['5', '6', '7', '8'],
      correctAnswer: 1,
      difficulty: 1,
    },
    // Grade 5 - Fractions
    {
      grade: 5,
      topic: 'pecahan',
      type: 'multiple_choice',
      question: '1/2 + 1/4 = ?',
      options: ['1/4', '2/4', '3/4', '1'],
      correctAnswer: 2,
      difficulty: 2,
    },
  ];

  for (const question of questions) {
    await prisma.question.upsert({
      where: { id: 'seed-' + question.grade + '-' + question.topic + '-' + question.question.slice(0, 10) },
      update: {},
      create: {
        ...question,
        id: 'seed-' + question.grade + '-' + question.topic + '-' + question.question.slice(0, 10),
      },
    });
  }

  console.log('Seeding finished.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
