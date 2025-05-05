import {Router} from "express";
import {register, login} from '../controllers/AuthController'
import {body} from 'express-validator'
import Validate from '../middlewares/Validate'

const router = Router()

router.post('/register', [body('username').isString(), body('email').isEmail(), body('password').isLength({ min: 6 })], Validate, register)
router.post('/login', [body('login').isString(), body('password').exists()], Validate, login)

export default router
