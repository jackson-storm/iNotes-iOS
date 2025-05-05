import {Request, Response} from 'express'
import bcrypt from 'bcrypt'
import {PrismaClient} from "../generated/prisma";
import {RegisterRequest} from "../dto/input/RegisterRequest";
import {signToken} from "../utils/jwt";
import {AuthResponse} from "../dto/output/AuthResponse";
import {LoginRequest} from "../dto/input/LoginRequest";

const prisma = new PrismaClient()

export const register = async (req: Request, res: Response) => {
    const {username, email, password} = req.body as RegisterRequest
    const existingUser = await prisma.user.findFirst({where: {OR: [{email}, {username}]}})
    if (existingUser) {
        res.status(400).json({message: 'User exists'});
        return;
    }
    const hashed = await bcrypt.hash(password, 10)
    const user = await prisma.user.create({
        data: {
            username,
            email,
            password: hashed
        }
    })
    const token = signToken(user.id)
    const response: AuthResponse = {token, user}
    res.status(201).json(response);
}

export const login = async (req: Request, res: Response) => {
    const {login, password} = req.body as LoginRequest
    const user = await prisma.user.findFirst({where: {OR: [{email: login}, {username: login}]}})
    if (!user) {
        res.status(401).json({message: 'Invalid credentials'});
        return;
    }
    const valid = await bcrypt.compare(password, user.password)
    if (!valid) {
        res.status(401).json({message: 'Invalid credentials'});
        return;
    }
    const token = signToken(user.id)
    const response: AuthResponse = {token, user}
    res.json(response);
}
