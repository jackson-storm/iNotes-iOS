afterEach(() => {
  jest.clearAllMocks();
});

process.env.JWT_SECRET = 'test-secret-for-tests';
process.env.PORT = '4200';

global.console = {
  ...console,
  log: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  info: jest.fn(),
};