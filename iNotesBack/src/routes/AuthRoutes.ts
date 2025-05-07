import {Router} from "express"
import {register, login} from '../controllers/AuthController'
import Validate, {AuthValidate} from '../middlewares/Validate'

const router = Router()

router.post('/register', AuthValidate.register, Validate, register)
router.post('/login', AuthValidate.login, Validate, login)

export default router
