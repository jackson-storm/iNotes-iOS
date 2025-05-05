import express, {Express} from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import AuthRoutes from "./routes/AuthRoutes";
dotenv.config();

const app: Express = express();
const PORT: number = parseInt(process.env.PORT || '4200', 10);

app.use(cors());
app.use(express.json());

// TODO: list implemented routes | список активных роутеров
app.use('/api/auth', AuthRoutes);

app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});