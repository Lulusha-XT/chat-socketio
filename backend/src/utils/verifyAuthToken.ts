import jwt from "jsonwebtoken";
import express, { Request, Response } from "express";
import dotenv from "dotenv";

dotenv.config();

const tokenS: any = process.env.TOKEN_SECRET;
export const verifyToken = async (
  req: Request,
  res: Response,
  next: Function
) => {
  try {
    const authHeader: any = req.headers.authorization;
    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, tokenS);
    next();
  } catch (error) {
    res.status(401);
    res.json("Access denied, invalid token");
    return;
  }
};
