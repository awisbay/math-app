import { IsString, IsInt, Min, IsUUID } from 'class-validator';

export class SubmitAnswerDto {
  @IsUUID('4', { message: 'ID pertanyaan sesi tidak valid' })
  sessionQuestionId: string;

  @IsInt({ message: 'Jawaban harus berupa angka' })
  @Min(0, { message: 'Jawaban tidak valid' })
  selectedOption: number;

  @IsInt({ message: 'Waktu harus berupa angka' })
  @Min(0, { message: 'Waktu tidak valid' })
  timeSpentSeconds: number;
}
