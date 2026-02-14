import {
  IsOptional,
  IsString,
  MinLength,
  IsDateString,
  IsInt,
  Min,
  Max,
} from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString({ message: 'Nama harus berupa string' })
  @MinLength(2, { message: 'Nama minimal 2 karakter' })
  name?: string;

  @IsOptional()
  @IsDateString({}, { message: 'Format tanggal lahir tidak valid' })
  birthDate?: string;

  @IsOptional()
  @IsInt({ message: 'Kelas harus berupa angka' })
  @Min(1, { message: 'Kelas minimal 1' })
  @Max(12, { message: 'Kelas maksimal 12' })
  currentGrade?: number;
}
