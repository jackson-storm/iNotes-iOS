import {UserResponse} from "./UserResponse";

export interface AuthResponse {
    token: String;
    user: UserResponse;
}