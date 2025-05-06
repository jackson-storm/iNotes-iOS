import request from 'supertest';
import express from 'express';
import { PrismaClient } from '../../generated/prisma';
import NoteRoutes from '../../routes/NoteRoutes';

jest.mock('../../generated/prisma', () => {
  const mockPrismaClient = {
    task: {
      findMany: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
    $disconnect: jest.fn(),
  };
  return {
    PrismaClient: jest.fn(() => mockPrismaClient),
  };
});

jest.mock('../../middlewares/Cashe', () => ({
  cacheService: {
    set: jest.fn(),
    get: jest.fn(),
    delete: jest.fn(),
    generateKey: jest.fn(),
    cleanup: jest.fn(),
  },
}));

jest.mock('../../middlewares/Validate', () => {
  return {
    __esModule: true,
    default: jest.fn((req, res, next) => next()),
    NoteValidate: {
      create: jest.fn((req, res, next) => next()),
      update: jest.fn((req, res, next) => next()),
    }
  };
});

describe('Note Controller', () => {
  let app: express.Express;
  let prisma: any;
  
  const sampleNote = {
    id: 1,
    title: 'Test Note',
    description: 'Test Description',
    category: 'Test Category',
    createdAt: new Date(),
    editorAt: new Date()
  };

  beforeEach(() => {
    jest.clearAllMocks();

    app = express();
    app.use(express.json());
    app.use('/api/notes', NoteRoutes);

    prisma = new PrismaClient();
  });

  describe('GET /api/notes', () => {
    it('should return all notes', async () => {
      (prisma.task.findMany as jest.Mock).mockResolvedValue([sampleNote]);

      const response = await request(app).get('/api/notes');

      expect(response.status).toBe(200);
      expect(response.body).toEqual([sampleNote]);
      expect(prisma.task.findMany).toHaveBeenCalledWith({
        orderBy: {
          createdAt: 'desc'
        }
      });
    });

    it('should handle errors', async () => {
      (prisma.task.findMany as jest.Mock).mockRejectedValue(new Error('Database error'));

      const response = await request(app).get('/api/notes');

      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('message', 'Error getting notes');
    });
  });

  describe('GET /api/notes/:id', () => {
    it('should return a note by id', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(sampleNote);

      const response = await request(app).get('/api/notes/1');

      expect(response.status).toBe(200);
      expect(response.body).toEqual(sampleNote);
      expect(prisma.task.findUnique).toHaveBeenCalledWith({
        where: {
          id: 1
        }
      });
    });

    it('should return 404 for non-existent note', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(null);

      const response = await request(app).get('/api/notes/999');

      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('message', 'Note not found');
    });

    it('should handle errors', async () => {
      (prisma.task.findUnique as jest.Mock).mockRejectedValue(new Error('Database error'));

      const response = await request(app).get('/api/notes/1');

      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('message', 'Error getting note');
    });
  });

  describe('POST /api/notes', () => {
    it('should create a new note', async () => {
      const newNote = {
        title: 'New Note',
        description: 'New Description',
        category: 'New Category'
      };

      (prisma.task.create as jest.Mock).mockResolvedValue({
        ...newNote,
        id: 2,
        createdAt: new Date(),
        editorAt: new Date()
      });

      const response = await request(app)
        .post('/api/notes')
        .send(newNote);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('title', newNote.title);
      expect(response.body).toHaveProperty('description', newNote.description);
      expect(response.body).toHaveProperty('category', newNote.category);
      expect(response.body).toHaveProperty('createdAt');
      expect(response.body).toHaveProperty('editorAt');
      expect(prisma.task.create).toHaveBeenCalledWith({
        data: newNote
      });
    });

    it('should handle errors during creation', async () => {
      (prisma.task.create as jest.Mock).mockRejectedValue(new Error('Database error'));

      const response = await request(app)
        .post('/api/notes')
        .send({
          title: 'New Note',
          description: 'New Description',
          category: 'New Category'
        });

      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('message', 'Error creating note');
    });
  });

  describe('PUT /api/notes/:id', () => {
    it('should update an existing note', async () => {
      const updateData = {
        title: 'Updated Title',
        description: 'Updated Description',
        category: 'Updated Category'
      };

      (prisma.task.findUnique as jest.Mock).mockResolvedValue(sampleNote);

      (prisma.task.update as jest.Mock).mockResolvedValue({
        ...sampleNote,
        ...updateData,
        editorAt: new Date()
      });

      const response = await request(app)
        .put('/api/notes/1')
        .send(updateData);

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('title', updateData.title);
      expect(response.body).toHaveProperty('description', updateData.description);
      expect(response.body).toHaveProperty('category', updateData.category);
      expect(prisma.task.update).toHaveBeenCalled();
    });

    it('should return 404 when updating non-existent note', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(null);

      const response = await request(app)
        .put('/api/notes/999')
        .send({
          title: 'Updated Title'
        });

      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('message', 'Note not found');
      expect(prisma.task.update).not.toHaveBeenCalled();
    });

    it('should handle errors during update', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(sampleNote);

      (prisma.task.update as jest.Mock).mockRejectedValue(new Error('Database error'));

      const response = await request(app)
        .put('/api/notes/1')
        .send({
          title: 'Updated Title'
        });

      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('message', 'Error updating note');
    });
  });

  describe('DELETE /api/notes/:id', () => {
    it('should delete an existing note', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(sampleNote);

      (prisma.task.delete as jest.Mock).mockResolvedValue(sampleNote);

      const response = await request(app).delete('/api/notes/1');

      expect(response.status).toBe(204);
      expect(prisma.task.delete).toHaveBeenCalledWith({
        where: {
          id: 1
        }
      });
    });

    it('should return 404 when deleting non-existent note', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(null);

      const response = await request(app).delete('/api/notes/999');

      expect(response.status).toBe(404);
      expect(response.body).toHaveProperty('message', 'Note not found');
      expect(prisma.task.delete).not.toHaveBeenCalled();
    });

    it('should handle errors during deletion', async () => {
      (prisma.task.findUnique as jest.Mock).mockResolvedValue(sampleNote);

      (prisma.task.delete as jest.Mock).mockRejectedValue(new Error('Database error'));

      const response = await request(app).delete('/api/notes/1');

      expect(response.status).toBe(500);
      expect(response.body).toHaveProperty('message', 'Error deleting note');
    });
  });
});
