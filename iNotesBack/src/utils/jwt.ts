import jwt from 'jsonwebtoken';

export const signToken = (userId: number) => {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET must be defined');
  }
  return jwt.sign({userId}, process.env.JWT_SECRET, {expiresIn: '1d'});
}

export const verifyToken = (token: string) => {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET must be defined');
  }
  return jwt.verify(token, process.env.JWT_SECRET) as {
    userId: number
  };
}
