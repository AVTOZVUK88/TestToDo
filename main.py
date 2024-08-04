from typing import Optional
from fastapi import FastAPI, HTTPException
from datetime import date
from typing import List
import psycopg2
from pydantic import BaseModel
#from .models import User, Task, Permission

class User(BaseModel):
    id_user: Optional[int]
    login: str
    password: str

class Task(BaseModel):
    id_task: int
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

app = FastAPI()

# Подключение к базе данных PostgreSQL
conn = psycopg2.connect(
    dbname="ToDoDB",
    user="postgres",
    password="1234QWer",
    # host="*"
    client_encoding='UTF8'
)

cur = conn.cursor()

# API Для регистрации пользователей
@app.post("/registration/")
async def registration(userReg: User):
    query = "INSERT INTO \"User\" (login, password) VALUES (%s, %s) RETURNING id_user"
    cur.execute(query, (userReg.login, userReg.password))
    user_id = cur.fetchone()[0]
    query = "SELECT id_task FROM \"Task\""
    cur.execute(query)
    tasks = cur.fetchall()
    tasks_list = []
    for i in tasks:
        tasks_list.append(int(i[0]))
    for k in tasks_list:
        query = "INSERT INTO \"Permission\" (task_id, user_id, permission_type) VALUES (%s, %s, %s) RETURNING id_permission"
        cur.execute(query, (k, user_id, 1))  # 1 - разрешение на чтение
    id_permission = cur.fetchone()
    conn.commit()
    return id_permission

# API Для логина пользователей
@app.post("/login/")
async def login(userLog: User):
    query = "SELECT id_user FROM \"User\" WHERE login = %s AND password = %s"
    cur.execute(query, (userLog.login,userLog.password))
    #conn.commit()
    id_user_catch = cur.fetchone()[0]
    conn.commit()
    if id_user_catch is None:
        raise HTTPException(status_code=404,detail="User not found")
    return {"message": "User logged in succesfully", "id_user": id_user_catch}

# API для публикации новых задач
@app.post("/User/{user_id}/Task/")
async def create_task(user_id: int, task_create: Task):
    # Вставить новую задачу в таблицу "Task"
    query = "INSERT INTO \"Task\" (user_id, title, text, created_at) VALUES (%s, %s, %s, %s) RETURNING id_task"
    cur.execute(query, (user_id, task_create.title, task_create.text, task_create.created_at))
    id_task = cur.fetchone()[0]
    query = "INSERT INTO \"Permission\" (task_id, user_id, permission_type) VALUES (%s, %s, %s) RETURNING id_permission"
    cur.execute(query, (id_task, user_id, 1))  # 1 - разрешение на чтение, изменение, выдачу разрешений
    id_permission = cur.fetchone()[0]
    query = "SELECT id_user FROM \"User\" WHERE id_user != %s"
    cur.execute(query, (user_id,))
    all_users = cur.fetchall()
    all_users_list = []
    for i in all_users:
        all_users_list.append(int(i[0]))
    for k in all_users_list:
        query = "INSERT INTO \"Permission\" (task_id, user_id, permission_type) VALUES (%s, %s, %s) RETURNING id_permission"
        cur.execute(query, (id_task, k, 2))  # 2 - разрешение на чтение
    conn.commit()
    return {"id_task": id_task, "user_id": user_id, "title": task_create.title, "text": task_create.text,"id_permission":id_permission }

# API для редактирования задач
@app.put("/users/{user_id}/tasks/{id_task}/")
async def update_task(logged_user_permission: int, user_id: int, id_task: int, task_redact: Task):
    if logged_user_permission == 2:
        raise HTTPException(status_code=404,detail="User dont have permission")
    query = "UPDATE \"Task\" SET title = %s, text = %s, updated_at = %s WHERE id_task = %s AND user_id = %s"
    cur.execute(query, (task_redact.title, task_redact.text, task_redact.updated_at, id_task, user_id))
    conn.commit()
    return {"id_task": id_task, "user_id": user_id,"title": task_redact.title, "text": task_redact.text, "updated_at": task_redact.updated_at}

# API для удаления задач
@app.delete("/users/{user_id}/tasks/{id_task}/")
async def delete_task(logged_user_permission: int, user_id: int, id_task: int, task_delete: Task):
    if logged_user_permission == 2:
        raise HTTPException(status_code=404,detail="User dont have permission")
    query = "DELETE FROM \"Task\" WHERE id_task = %s AND user_id = %s RETURNING title"
    cur.execute(query, (id_task, user_id))
    task_delete.title = cur.fetchone()[0]
    conn.commit()
    return {"message": task_delete.title + " was deleted"}

# API для просмотра задач пользователей по их внутреннему идентификатору
@app.get("/users/{user_id}/tasks/")
async def get_user_tasks(user_id: int):
    query = "SELECT id_task, title, text, created_at, updated_at FROM \"Task\" WHERE user_id = %s"
    cur.execute(query, (user_id,))
    tasks = cur.fetchall()
    return tasks

# API для выдачи разрешений
@app.put("/users/{user_id}/permission/{id_permission}/")
async def update_permission(logged_user_id: int, user_to_change_id: int, task_id: int, permission_redact: Permission):
    query = "SELECT permission_type FROM \"Permission\" WHERE user_id = %s AND task_id = %s"
    cur.execute(query, (logged_user_id,task_id))
    logged_user_permission = cur.fetchone()[0]
    if logged_user_permission == 2 or logged_user_permission == 3:
        raise HTTPException(status_code=404,detail="User dont have permission")
    query = "UPDATE \"Permission\" SET permission_type = %s WHERE task_id = %s AND user_id = %s RETURNING permission_type"
    cur.execute(query, (permission_redact.permission_type, task_id, user_to_change_id))
    changed_permission = cur.fetchall()[0]
    conn.commit()
    return {"permission_type": changed_permission, "user_id": user_to_change_id}