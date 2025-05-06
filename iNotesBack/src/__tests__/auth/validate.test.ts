import { Request, Response } from 'express';
import Validate from '../../middlewares/Validate';

jest.mock('express-validator', () => {
  return {
    validationResult: jest.fn(),
    body: jest.fn().mockReturnValue({
      notEmpty: jest.fn().mockReturnThis(),
      isString: jest.fn().mockReturnThis(),
      isEmail: jest.fn().mockReturnThis(),
      isLength: jest.fn().mockReturnThis(),
      optional: jest.fn().mockReturnThis(),
      withMessage: jest.fn().mockReturnThis()
    })
  };
});

import { validationResult } from 'express-validator';

describe('Validate Middleware', () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let nextFunction: jest.Mock;

  beforeEach(() => {
    mockRequest = {};
    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
    nextFunction = jest.fn();

    jest.clearAllMocks();
  });

  it('should call next() if there are no validation errors', () => {
    (validationResult as unknown as jest.Mock).mockReturnValue({
      isEmpty: () => true,
      array: () => []
    });

    Validate(mockRequest as Request, mockResponse as Response, nextFunction);

    expect(nextFunction).toHaveBeenCalled();
    expect(mockResponse.status).not.toHaveBeenCalled();
    expect(mockResponse.json).not.toHaveBeenCalled();
  });

  it('should return 400 status with errors if validation fails', () => {
    const mockErrors = [
      { param: 'username', msg: 'Username is required' },
      { param: 'email', msg: 'Email must be valid' },
    ];

    (validationResult as unknown as jest.Mock).mockReturnValue({
      isEmpty: () => false,
      array: () => mockErrors
    });

    Validate(mockRequest as Request, mockResponse as Response, nextFunction);

    expect(nextFunction).not.toHaveBeenCalled();
    expect(mockResponse.status).toHaveBeenCalledWith(400);
    expect(mockResponse.json).toHaveBeenCalledWith({
      errors: mockErrors,
    });
  });
});
