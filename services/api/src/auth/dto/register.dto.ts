import { IsEmail, IsString, MinLength, IsInt, Min, Max, IsOptional, IsDateString } from 'class-validator';

export class RegisterDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  @MinLength(2)
  name: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @IsInt()
  @Min(1)
  @Max(12)
  currentGrade: number;
}
