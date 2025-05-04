import jwt from 'jsonwebtoken';

const secret = process.env.JWT_SECRET!;

export const signToken = (userId: number) => jwt.sign({userId}, secret, {expiresIn: '1h'})
export const verifyToken = (token: string) => jwt.verify(token, secret) as {
    userId: number
}
