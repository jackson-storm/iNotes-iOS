import { Cache, cacheService } from '../../middlewares/Cashe';
import { Request, Response, NextFunction } from 'express';

const mockRequest = () => {
  return {
    method: 'GET',
    originalUrl: '/api/test',
    url: '/api/test'
  } as Partial<Request> as Request;
};

const mockResponse = () => {
  const res = {} as Partial<Response>;
  res.json = jest.fn().mockReturnValue(res);
  res.status = jest.fn().mockReturnValue(res);
  return res as Response;
};

const mockNext = jest.fn() as NextFunction;

describe('Cache Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    for (const key of Array.from((cacheService as any).cache.keys())) {
      (cacheService as any).cache.delete(key);
    }
  });

  it('should set and get cache items', () => {
    const key = 'test-key';
    const data = { test: 'data' };

    cacheService.set(key, data, 1000);

    expect(cacheService.get(key)).toEqual(data);
  });

  it('should return null for expired items', () => {
    const key = 'test-key';
    const data = { test: 'data' };

    cacheService.set(key, data, 1);

    return new Promise(resolve => {
      setTimeout(() => {
        expect(cacheService.get(key)).toBeNull();
        resolve(null);
      }, 5);
    });
  });

  it('should delete cache items', () => {
    const key = 'test-key';
    const data = { test: 'data' };
    
    cacheService.set(key, data);
    expect(cacheService.get(key)).toEqual(data);
    
    cacheService.delete(key);
    expect(cacheService.get(key)).toBeNull();
  });

  it('should generate key based on request method and URL', () => {
    const req = mockRequest();
    const key = cacheService.generateKey(req);
    
    expect(key).toBe('GET-/api/test');
  });

  it('should cleanup expired items', () => {
    const key1 = 'test-key1';
    const key2 = 'test-key2';
    const data = { test: 'data' };
    
    (cacheService as any).cache.set(key1, {
      data,
      expiry: Date.now() - 1000
    });

    (cacheService as any).cache.set(key2, {
      data,
      expiry: Date.now() + 10000
    });
    
    cacheService.cleanup();
    
    expect(cacheService.get(key1)).toBeNull();
    expect(cacheService.get(key2)).toEqual(data);
  });
});

describe('Cache Middleware', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    for (const key of Array.from((cacheService as any).cache.keys())) {
      (cacheService as any).cache.delete(key);
    }
  });

  it('should cache GET responses', () => {
    const req = mockRequest();
    const res = mockResponse();
    const testData = { test: 'data' };

    const cacheMiddleware = Cache(1000);
    
    cacheMiddleware(req, res, mockNext);
    expect(mockNext).toHaveBeenCalled();
    
    res.json(testData);

    jest.clearAllMocks();

    cacheMiddleware(req, res, mockNext);
    
    expect(mockNext).not.toHaveBeenCalled();
    expect(res.json).toHaveBeenCalledWith(testData);
  });

  it('should not cache non-GET requests', () => {
    const req = { ...mockRequest(), method: 'POST' } as Request;
    const res = mockResponse();
    
    const cacheMiddleware = Cache(1000);
    
    cacheMiddleware(req, res, mockNext);
    
    expect(mockNext).toHaveBeenCalled();
    expect((res.json as jest.Mock).mock.calls.length).toBe(0);
  });
});
