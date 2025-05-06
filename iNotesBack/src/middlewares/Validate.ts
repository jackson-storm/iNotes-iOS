import {Request, Response, NextFunction} from "express";
import {body, validationResult} from "express-validator";

const Validate = (req: Request, res: Response, next: NextFunction) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        res.status(400).json({errors: errors.array()});
        return;
    }
    next();
}

export const AuthValidate = {
    register: [
        body('username').notEmpty().withMessage('Username is required').isString().withMessage('Username must be a string'),
        body('email').notEmpty().withMessage('Email is required').isEmail().withMessage('Invalid email format'),
        body('password').notEmpty().withMessage('Password is required').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
    ],
    login: [
        body('login').notEmpty().withMessage('Login is required').isString().withMessage('Login must be a string'),
        body('password').notEmpty().withMessage('Password is required')
    ]
};

export const NoteValidate = {
    create: [
        body('title').notEmpty().withMessage('Title is required').isLength({ max: 100 }).withMessage('Title should not exceed 100 characters'),
        body('description').notEmpty().withMessage('Description is required'),
        body('category').notEmpty().withMessage('Category is required')
    ],
    update: [
        body('title').optional().isLength({ max: 100 }).withMessage('Title should not exceed 100 characters'),
        body('description').optional(),
        body('category').optional()
    ]
};

export default Validate
