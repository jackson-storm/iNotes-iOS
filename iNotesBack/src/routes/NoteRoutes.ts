import {Router} from "express"
import {createNote, deleteNote, getAllNotes, getNoteById, updateNote} from "../controllers/NoteController"
import Validate, {NoteValidate} from "../middlewares/Validate"
import {Cache} from "../middlewares/Cashe"

const router = Router()

router.get('/', Cache(900000), getAllNotes)
router.get('/:id', Cache(900000), getNoteById)
router.post('/', NoteValidate.create, Validate, createNote)
router.put('/:id', NoteValidate.update, Validate, updateNote)
router.delete('/:id', deleteNote)

export default router
