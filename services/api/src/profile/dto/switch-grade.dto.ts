import { IsInt, Min, Max } from 'class-validator';

export class SwitchGradeDto {
  @IsInt()
  @Min(1)
  @Max(12)
  grade: number;
}
