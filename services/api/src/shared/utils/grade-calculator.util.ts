/**
 * Calculate default grade based on age using Indonesian education system mapping.
 * 
 * Age to Grade Mapping:
 * - Age 6-7  -> Grade 1 (SD)
 * - Age 7-8  -> Grade 2 (SD)
 * - Age 8-9  -> Grade 3 (SD)
 * - Age 9-10 -> Grade 4 (SD)
 * - Age 10-11 -> Grade 5 (SD)
 * - Age 11-12 -> Grade 6 (SD)
 * - Age 12-13 -> Grade 7 (SMP)
 * - Age 13-14 -> Grade 8 (SMP)
 * - Age 14-15 -> Grade 9 (SMP)
 * - Age 15-16 -> Grade 10 (SMA)
 * - Age 16-17 -> Grade 11 (SMA)
 * - Age 17-18 -> Grade 12 (SMA)
 */

export const MIN_GRADE = 1;
export const MAX_GRADE = 12;

/**
 * Calculate age from birth date
 */
export function calculateAge(birthDate: Date): number {
  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const monthDiff = today.getMonth() - birthDate.getMonth();
  
  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }
  
  return age;
}

/**
 * Get default grade based on age
 * Returns grade 1 for ages below 6, grade 12 for ages above 18
 */
export function getDefaultGradeFromAge(age: number): number {
  if (age < 6) return MIN_GRADE;
  if (age > 18) return MAX_GRADE;
  
  // Mapping: age 6 -> grade 1, age 7 -> grade 2, etc.
  return age - 5;
}

/**
 * Get default grade from birth date
 */
export function getDefaultGradeFromBirthDate(birthDate: Date): number {
  const age = calculateAge(birthDate);
  return getDefaultGradeFromAge(age);
}

/**
 * Validate if grade is within valid range
 */
export function isValidGrade(grade: number): boolean {
  return Number.isInteger(grade) && grade >= MIN_GRADE && grade <= MAX_GRADE;
}

/**
 * Get education level label for grade
 */
export function getEducationLevel(grade: number): string {
  if (grade <= 6) return 'SD';
  if (grade <= 9) return 'SMP';
  return 'SMA';
}

/**
 * Get grade range for education level
 */
export function getGradeRangeForLevel(level: 'SD' | 'SMP' | 'SMA'): { min: number; max: number } {
  switch (level) {
    case 'SD':
      return { min: 1, max: 6 };
    case 'SMP':
      return { min: 7, max: 9 };
    case 'SMA':
      return { min: 10, max: 12 };
  }
}
