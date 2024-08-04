from typing import Optional
#from fastapi import FastAPI, HTTPException
from datetime import date
#from typing import List
#import psycopg2
from pydantic import BaseModel
# from .models import User, Post

class User(BaseModel):
    id_user: Optional[int]
    login: str
    password: str

class Task(BaseModel):
    id_post: int
    user_id: int
    title: str
    text: str
    created_at: date
    updated_at: Optional[date]

class Permission(BaseModel):
    id_permission: int
    task_id: int
    user_id: int
    permission_type: int