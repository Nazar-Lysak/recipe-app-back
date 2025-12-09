--
-- PostgreSQL database dump
--

\restrict gTkkBpJ2CB6bWk2W9dPWnnCddirh34VMy8HHeQlaZzSjrCJQaf1eiIafySEFtSq

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

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

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.categories OWNER TO nestuser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying NOT NULL,
    username character varying NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public.users OWNER TO nestuser;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.categories (id, name) FROM stdin;
183a9921-9756-43d5-81e3-7eebd9113f81	Breakfast
377840bb-2077-4e15-988b-97eaf0f73740	Lunch
4006318b-7cc2-43e5-9021-0e45d4ea450a	Dinner
0b1a03a1-5ac8-42a4-8fb2-c872c9fd2be4	Vegan
2ce4c7f2-0818-45c2-a931-85fc8e1400d7	Dessert
83d1aed2-a407-4af6-b8a5-62e181075cf7	Drinks
c8cdc87d-ae93-44ff-bdcb-32d01795f798	Sea Food
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.users (id, email, username, password) FROM stdin;
e38b266f-1a19-40b0-abd6-f40f67fe6491	andriy.koval@gmail.com	AndriyK	$2b$10$/RQmUU9BXBXK1UqL.2UMde2HFScWUUoS/ij36VFe8/UDb6j8c9hyy
d18bd52e-76da-46c5-8625-f13a6316644e	maria.shevchenko@gmail.com	MariaS	$2b$10$zC5ouzul11VOoGUU4J9UzO3.Zpkdn6hGZR2PvwHT6KAHinij6zWO6
77e06fb5-d84e-42a5-93d9-ac564bee1f53	oleh.petrenko@gmail.com	OlehP	$2b$10$LlKdHuKKP838OIHHXYJ1K.5bbxt.OGunS3uBrKMNJkJK3tu/QhP6y
ddb4f313-9891-4bf8-8f89-ada046e04558	ivanna.melnyk@gmail.com	IvannaM	$2b$10$uZbZ9lFDp4K7/XXx31/QjetBmzhY..Pvjqf5qZvonlwoCPwdHd3UO
51190d64-a8ef-4e8d-b352-7f9e9da6cd2e	taras.havrylenko@gmail.com	TarasH	$2b$10$fkGyWsNTSrR4uv78OALoge9vlKP3/RdlHizYrjtQnxUXnxyA/MAfy
83ba122c-3440-4bd6-8e72-94e401d6d6c0	solomiya.bondar@gmail.com	SolomiyaB	$2b$10$IbM39BmsSiI.JwYXaW/2wua10FNczb4tjs9/kXoLAmAFgdJSocY4q
2d4c1c85-20df-4862-9f06-2e7bd25a051f	danylo.stasenko@gmail.com	DanyloS	$2b$10$HIPc0eH7bZSV6063ohDNIOSVRUdUF7jhSpjcQAtcpMCLpO0cIBKSC
5db4c328-5da8-49a1-a015-8dce3f812c8e	khrystyna.kucher@gmail.com	KhrystynaK	$2b$10$oIKdL82kzsqetjR2qGuq7u/pAL39EfCmMXDdwmTFCte6fTsBSMk26
af7d808b-3a17-4a91-9012-765196842d63	yaroslav.martyn@gmail.com	YaroslavM	$2b$10$RBPHUe.wIJCapCfXpMW6Yu9tDzZ9hLFscVsS.5El1hUCeBnR1.OKC
ae1dc3b6-e705-4bc4-b48c-cd43b4b6cfb0	viktoria.hrytsak@gmail.com	ViktoriaH	$2b$10$JrkJLLDhhkGIoC1w2uzJLOXe/lweLeDKHx8JSkYw0uqckmnSkqY..
\.


--
-- Name: categories PK_24dbc6126a28ff948da33e97d3b; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_24dbc6126a28ff948da33e97d3b" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: categories UQ_8b0be371d28245da6e4f4b61878; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "UQ_8b0be371d28245da6e4f4b61878" UNIQUE (name);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- PostgreSQL database dump complete
--

\unrestrict gTkkBpJ2CB6bWk2W9dPWnnCddirh34VMy8HHeQlaZzSjrCJQaf1eiIafySEFtSq

