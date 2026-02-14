import {
  calculateAge,
  getDefaultGradeFromAge,
  getDefaultGradeFromBirthDate,
  isValidGrade,
  getEducationLevel,
  getGradeRangeForLevel,
  MIN_GRADE,
  MAX_GRADE,
} from './grade-calculator.util';

describe('GradeCalculator', () => {
  describe('calculateAge', () => {
    it('should calculate age correctly', () => {
      const today = new Date();
      const birthDate = new Date(today.getFullYear() - 10, today.getMonth(), today.getDate());
      expect(calculateAge(birthDate)).toBe(10);
    });

    it('should handle birthday not yet passed this year', () => {
      const today = new Date();
      const birthDate = new Date(today.getFullYear() - 10, today.getMonth() + 1, today.getDate());
      expect(calculateAge(birthDate)).toBe(9);
    });
  });

  describe('getDefaultGradeFromAge', () => {
    it('should return grade 1 for age 6', () => {
      expect(getDefaultGradeFromAge(6)).toBe(1);
    });

    it('should return grade 6 for age 11', () => {
      expect(getDefaultGradeFromAge(11)).toBe(6);
    });

    it('should return grade 12 for age 17', () => {
      expect(getDefaultGradeFromAge(17)).toBe(12);
    });

    it('should return MIN_GRADE for age below 6', () => {
      expect(getDefaultGradeFromAge(5)).toBe(MIN_GRADE);
    });

    it('should return MAX_GRADE for age above 18', () => {
      expect(getDefaultGradeFromAge(20)).toBe(MAX_GRADE);
    });
  });

  describe('getDefaultGradeFromBirthDate', () => {
    it('should calculate grade from birth date', () => {
      const today = new Date();
      const birthDate = new Date(today.getFullYear() - 10, today.getMonth(), today.getDate());
      expect(getDefaultGradeFromBirthDate(birthDate)).toBe(5);
    });
  });

  describe('isValidGrade', () => {
    it('should return true for valid grades', () => {
      expect(isValidGrade(1)).toBe(true);
      expect(isValidGrade(6)).toBe(true);
      expect(isValidGrade(12)).toBe(true);
    });

    it('should return false for invalid grades', () => {
      expect(isValidGrade(0)).toBe(false);
      expect(isValidGrade(13)).toBe(false);
      expect(isValidGrade(-1)).toBe(false);
      expect(isValidGrade(1.5)).toBe(false);
    });
  });

  describe('getEducationLevel', () => {
    it('should return SD for grades 1-6', () => {
      expect(getEducationLevel(1)).toBe('SD');
      expect(getEducationLevel(6)).toBe('SD');
    });

    it('should return SMP for grades 7-9', () => {
      expect(getEducationLevel(7)).toBe('SMP');
      expect(getEducationLevel(9)).toBe('SMP');
    });

    it('should return SMA for grades 10-12', () => {
      expect(getEducationLevel(10)).toBe('SMA');
      expect(getEducationLevel(12)).toBe('SMA');
    });
  });

  describe('getGradeRangeForLevel', () => {
    it('should return correct range for SD', () => {
      expect(getGradeRangeForLevel('SD')).toEqual({ min: 1, max: 6 });
    });

    it('should return correct range for SMP', () => {
      expect(getGradeRangeForLevel('SMP')).toEqual({ min: 7, max: 9 });
    });

    it('should return correct range for SMA', () => {
      expect(getGradeRangeForLevel('SMA')).toEqual({ min: 10, max: 12 });
    });
  });
});
