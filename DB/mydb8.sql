--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Permission" (
    id_permission integer NOT NULL,
    task_id integer,
    user_id integer,
    permission_type integer
);


ALTER TABLE public."Permission" OWNER TO postgres;

--
-- Name: Permission_id_permission_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Permission_id_permission_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Permission_id_permission_seq" OWNER TO postgres;

--
-- Name: Permission_id_permission_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Permission_id_permission_seq" OWNED BY public."Permission".id_permission;


--
-- Name: Task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Task" (
    id_task integer NOT NULL,
    user_id integer,
    title text NOT NULL,
    text text NOT NULL,
    created_at date,
    updated_at date
);


ALTER TABLE public."Task" OWNER TO postgres;

--
-- Name: Task_id_task_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Task_id_task_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Task_id_task_seq" OWNER TO postgres;

--
-- Name: Task_id_task_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Task_id_task_seq" OWNED BY public."Task".id_task;


--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id_user integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(50) NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_user_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_user_seq" OWNER TO postgres;

--
-- Name: User_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_user_seq" OWNED BY public."User".id_user;


--
-- Name: Permission id_permission; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Permission" ALTER COLUMN id_permission SET DEFAULT nextval('public."Permission_id_permission_seq"'::regclass);


--
-- Name: Task id_task; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task" ALTER COLUMN id_task SET DEFAULT nextval('public."Task_id_task_seq"'::regclass);


--
-- Name: User id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id_user SET DEFAULT nextval('public."User_id_user_seq"'::regclass);


--
-- Data for Name: Permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Permission" (id_permission, task_id, user_id, permission_type) FROM stdin;
1	5	1	1
3	1	12	2
4	5	13	2
5	1	13	2
7	7	13	1
8	7	1	2
9	7	7	2
10	7	9	2
11	7	12	2
2	5	12	3
\.


--
-- Data for Name: Task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Task" (id_task, user_id, title, text, created_at, updated_at) FROM stdin;
5	1	test with permission	string	\N	\N
1	1	superSTRING	string_TEST_STROKA_text	\N	2024-08-03
7	13	CREATETEST	string	2024-08-03	\N
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id_user, login, password) FROM stdin;
1	string	test
7	string1	string
9	string3	string
12	string4	string
13	string5	string
\.


--
-- Name: Permission_id_permission_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Permission_id_permission_seq"', 11, true);


--
-- Name: Task_id_task_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Task_id_task_seq"', 7, true);


--
-- Name: User_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_user_seq"', 13, true);


--
-- Name: Permission Permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Permission"
    ADD CONSTRAINT "Permission_pkey" PRIMARY KEY (id_permission);


--
-- Name: Task Task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task"
    ADD CONSTRAINT "Task_pkey" PRIMARY KEY (id_task);


--
-- Name: User User_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_login_key" UNIQUE (login);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id_user);


--
-- Name: Permission Permission_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Permission"
    ADD CONSTRAINT "Permission_task_id_fkey" FOREIGN KEY (task_id) REFERENCES public."Task"(id_task) ON DELETE CASCADE;


--
-- Name: Permission Permission_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Permission"
    ADD CONSTRAINT "Permission_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id_user) ON DELETE CASCADE;


--
-- Name: Task Task_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Task"
    ADD CONSTRAINT "Task_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public."User"(id_user) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

