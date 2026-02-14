import {
  IsEmail,
  IsString,
  MinLength,
  IsInt,
  Min,
  Max,
  IsOptional,
  IsDateString,
} from 'class-validator';

export class RegisterDto {
  @IsEmail({}, { message: 'Email tidak valid' })
  email: string;

  @IsString({ message: 'Password harus berupa string' })
  @MinLength(6, { message: 'Password minimal 6 karakter' })
  password: string;

  @IsString({ message: 'Nama harus berupa string' })
  @MinLength(2, { message: 'Nama minimal 2 karakter' })
  name: string;

  @IsOptional()
  @IsDateString({}, { message: 'Format tanggal lahir tidak valid' })
  birthDate?: string;

  @IsOptional()
  @IsInt({ message: 'Kelas harus berupa angka' })
  @Min(1, { message: 'Kelas minimal 1' })
  @Max(12, { message: 'Kelas maksimal 12' })
  currentGrade?: number;
}
