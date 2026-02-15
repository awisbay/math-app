import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export interface CurrentUserData {
  uid: string;
  email?: string;
  userId: string;
  currentGrade: number;
}

export const CurrentUser = createParamDecorator(
  (data: keyof CurrentUserData | undefined, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    const user = request.user as CurrentUserData;

    if (!user) {
      return null;
    }

    return data ? user[data] : user;
  },
);
