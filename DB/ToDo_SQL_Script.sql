/*CREATE TABLE "User" (
	id_user INT PRIMARY KEY,
	login VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL
);
CREATE TABLE "Task" (
	id_task SERIAL PRIMARY KEY,
	user_id INT REFERENCES "User" (id_user) ON DELETE CASCADE,
	title TEXT NOT NULL,
	"text" TEXT NOT NULL,
	created_at date,
	updated_at date
);
CREATE TABLE "Permission" (
	id_permission SERIAL PRIMARY KEY,
	task_id INT REFERENCES "Task" (id_task) ON DELETE CASCADE,
	user_id INT REFERENCES "User" (id_user) ON DELETE CASCADE,
	permission_type INT
	/*0 = read,change,delete,give permission;1 = read;2 = read,change,delete*/
);*/