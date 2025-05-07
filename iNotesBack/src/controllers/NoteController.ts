import {Request, Response} from 'express'
import {PrismaClient} from "../generated/prisma"
import {CreateNoteRequest} from "../dto/input/CreateNoteRequest"
import {UpdateNoteRequest} from "../dto/input/UpdateNoteRequest"
import {NoteResponse} from "../dto/output/NoteResponse"

const prisma = new PrismaClient()

export const getAllNotes = async (_req: Request, res: Response) => {
    try {
        const notes = await prisma.task.findMany({
            orderBy: {
                createdAt: 'desc'
            }
        })
        res.json(notes)
    } catch (error) {
        res.status(500).json({message: 'Error getting notes'})
    }
}

export const getNoteById = async (req: Request, res: Response) => {
    try {
        const {id} = req.params
        const note = await prisma.task.findUnique({
            where: {
                id: Number(id)
            }
        })

        if (!note) {
            res.status(404).json({message: 'Note not found'})
            return
        }

        res.json(note)
    } catch (error) {
        res.status(500).json({message: 'Error getting note'})
    }
}

export const createNote = async (req: Request, res: Response) => {
    try {
        const {title, description, category} = req.body as CreateNoteRequest

        const note = await prisma.task.create({
            data: {
                title: title as string,
                description: description as string,
                category: category as string
            }
        })

        const response: NoteResponse = {
            ...note,
            createdAt: note.createdAt,
            editorAt: note.editorAt
        }

        res.status(201).json(response)
    } catch (error) {
        res.status(500).json({message: 'Error creating note'})
    }
}

export const updateNote = async (req: Request, res: Response) => {
    try {
        const {id} = req.params
        const {title, description, category} = req.body as UpdateNoteRequest

        const existingNote = await prisma.task.findUnique({
            where: {
                id: Number(id)
            }
        })

        if (!existingNote) {
            res.status(404).json({message: 'Note not found'})
            return
        }

        const updatedNote = await prisma.task.update({
            where: {
                id: Number(id)
            },
            data: {
                title: title as string || existingNote.title,
                description: description as string || existingNote.description,
                category: category as string || existingNote.category,
                editorAt: new Date()
            }
        })

        res.json(updatedNote)
    } catch (error) {
        res.status(500).json({message: 'Error updating note'})
    }
}

export const deleteNote = async (req: Request, res: Response) => {
    try {
        const {id} = req.params

        const existingNote = await prisma.task.findUnique({
            where: {
                id: Number(id)
            }
        })

        if (!existingNote) {
            res.status(404).json({message: 'Note not found'})
            return
        }

        await prisma.task.delete({
            where: {
                id: Number(id)
            }
        })

        res.status(204).send()
    } catch (error) {
        res.status(500).json({message: 'Error deleting note'})
    }
}
