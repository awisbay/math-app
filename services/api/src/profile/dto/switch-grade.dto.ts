import { IsInt, Min, Max } from 'class-validator';

export class SwitchGradeDto {
  @IsInt({ message: 'Kelas harus berupa angka' })
  @Min(1, { message: 'Kelas minimal 1' })
  @Max(12, { message: 'Kelas maksimal 12' })
  grade: number;
}
