import jwt from 'jsonwebtoken';
import { signToken, verifyToken } from '../../utils/jwt';

jest.mock('jsonwebtoken', () => ({
  sign: jest.fn(() => 'test-token'),
  verify: jest.fn(() => ({ userId: 1 })),
}));

const originalEnv = process.env;
beforeEach(() => {
  jest.resetModules();
  process.env = { ...originalEnv };
  process.env.JWT_SECRET = 'test-secret';
});

afterEach(() => {
  process.env = originalEnv;
});

describe('JWT Utils', () => {
  describe('signToken', () => {
    it('should sign a token with the user ID', () => {
      const token = signToken(1);
      
      expect(token).toBe('test-token');
      expect(jwt.sign).toHaveBeenCalledWith({ userId: 1 }, 'test-secret', { expiresIn: '1d' });
    });

    it('should throw an error if JWT_SECRET is not defined', () => {
      delete process.env.JWT_SECRET;
      
      expect(() => signToken(1)).toThrow('JWT_SECRET must be defined');
      expect(jwt.sign).not.toHaveBeenCalled();
    });
  });

  describe('verifyToken', () => {
    it('should verify a token and return the payload', () => {
      const payload = verifyToken('test-token');
      
      expect(payload).toEqual({ userId: 1 });
      expect(jwt.verify).toHaveBeenCalledWith('test-token', 'test-secret');
    });

    it('should throw an error if JWT_SECRET is not defined', () => {
      delete process.env.JWT_SECRET;
      
      expect(() => verifyToken('test-token')).toThrow('JWT_SECRET must be defined');
      expect(jwt.verify).not.toHaveBeenCalled();
    });

    it('should throw an error if token verification fails', () => {
      (jwt.verify as jest.Mock).mockImplementationOnce(() => {
        throw new Error('Invalid token');
      });
      
      expect(() => verifyToken('invalid-token')).toThrow('Invalid token');
    });
  });
});