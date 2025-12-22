--
-- PostgreSQL database dump
--

\restrict ykfjrJzzet5v0Ltcuff7vCRKBKf5vbjdLeQIiSf3f3XPbiWe3iiBB3VDvZ3P1g3

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: nestuser
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO nestuser;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: nestuser
--

COMMENT ON SCHEMA public IS '';


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
    name character varying NOT NULL,
    image character varying DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.categories OWNER TO nestuser;

--
-- Name: follow_profiles; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.follow_profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "followerId" uuid NOT NULL,
    "followingId" uuid NOT NULL
);


ALTER TABLE public.follow_profiles OWNER TO nestuser;

--
-- Name: recipes; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.recipes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    "time" integer NOT NULL,
    image character varying,
    video character varying,
    "favouriteCount" integer DEFAULT 0 NOT NULL,
    ingredients text[] NOT NULL,
    steps text[] NOT NULL,
    "authorId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "categoryId" uuid,
    "likedByUserIds" text[] DEFAULT '{}'::text[] NOT NULL,
    "averageRating" double precision DEFAULT '0'::double precision NOT NULL,
    "reviewsCount" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.recipes OWNER TO nestuser;

--
-- Name: reset_passwords; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.reset_passwords (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    token character varying NOT NULL,
    "userId" uuid NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "usedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reset_passwords OWNER TO nestuser;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.reviews (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "recipeId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    rating integer NOT NULL,
    image character varying,
    comment text,
    "isBlocked" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reviews OWNER TO nestuser;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.user_profiles (
    first_name character varying,
    last_name character varying,
    bio text,
    avatar_url character varying,
    banner_url character varying,
    location character varying,
    website character varying,
    instagram character varying,
    tiktok character varying,
    facebook character varying,
    youtube character varying,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    recipes_count integer DEFAULT 0 NOT NULL,
    likes_received integer DEFAULT 0 NOT NULL,
    is_private boolean DEFAULT false NOT NULL,
    language character varying DEFAULT 'en'::character varying NOT NULL,
    theme character varying DEFAULT 'light'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id uuid,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    liked_recipes text[] DEFAULT '{}'::text[] NOT NULL
);


ALTER TABLE public.user_profiles OWNER TO nestuser;

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

COPY public.categories (id, name, image) FROM stdin;
d338de3a-c502-42ca-9d99-d9cbb948d4b0	Перші страви	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745634/11-soups_ysuwmw.png
4fb74c45-963a-4442-9fe8-2fad1400067d	Святкові страви	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745633/8-%D1%81%D0%B2%D1%8F%D1%82%D0%BA%D0%BE%D0%B2%D1%96-%D1%81%D1%82%D1%80%D0%B0%D0%B2%D0%B8_t4ayjs.png
97006906-2b2a-4903-9a5f-671d90b452d8	Гарніри	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745632/12-garnir_cc6jea.png
4f8a1d6e-2b8c-4c4f-9c91-6e2f9a7c1b42	Веган	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745631/13-vegan_hjxuhv.png
6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	Основні страви	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745629/10-main_o4kqgw.png
f4f9ea71-a649-4f75-bfab-ba99922edb92	Салати	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745628/7-%D1%81%D0%B0%D0%BB%D0%B0%D1%82_dwpyo9.png
431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	Випічка	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745627/6-%D0%B2%D0%B8%D0%BF%D1%96%D1%87%D0%BA%D0%B0_dqpvfz.png
861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	Десерти	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745625/4-%D0%B4%D0%B5%D1%81%D0%B5%D1%80%D1%82%D0%B8_iyuaoy.png
193d83ca-25dd-45a6-8c19-3ec2ea042e3b	Для дітей	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745624/3-%D0%B4%D0%BB%D1%8F-%D0%B4%D1%96%D1%82%D0%B5%D0%B8%CC%86_hz2xrc.png
d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	Сніданки	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745624/1-%D1%81%D0%BD%D1%96%D0%B4%D0%B0%D0%BD%D0%BE%D0%BA_meubys.png
d3c601fe-da84-445e-a77d-090a24006909	Закуски	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765745623/2-%D0%B7%D0%B0%D0%BA%D1%83%D1%81%D0%BA%D0%B8_t5vt1g.png
1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	Перекуси	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765747672/%D0%B7%D0%B0%D0%BA%D1%83%D1%81%D0%BA%D0%B8_fwa7vz.png
ca4496d1-02ba-4851-9b88-7f21ea0b0692	Напої	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765747670/%D0%BD%D0%B0%D0%BF%D0%BE%D1%96%CC%88_k6qku8.png
5400ad8c-2702-4693-87d8-b25ef1dede3a	Вечері	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765747670/%D0%B2%D0%B5%D1%87%D0%B5%D1%80%D1%8F_alqwhi.png
857acab9-1dae-4a3f-be1c-ad8de84d20e9	Обіди	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765747669/%D0%BE%D0%B1%D1%96%D0%B4%D0%B8_p7hppm.png
\.


--
-- Data for Name: follow_profiles; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.follow_profiles (id, "followerId", "followingId") FROM stdin;
32d252bf-3e9e-4b97-8a49-9ed9d61924fc	4f053667-43c6-4d17-9ff2-69457e2c1fe3	6d5c01a0-c599-4c73-aada-ccfa8dd6155b
1af9f35c-ded0-4f50-b9f5-180bb912142f	4f053667-43c6-4d17-9ff2-69457e2c1fe3	583b4d78-a2ba-4792-bef7-7f6caf42e913
84856aed-ed7c-4dbb-bed3-6faf2f48972d	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	9c609877-b2d1-4b90-a21e-44412565a444
f39c7125-5d09-482f-87a0-6ecbd460dde4	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	6d5c01a0-c599-4c73-aada-ccfa8dd6155b
a124034d-e5e0-4f92-b023-b66b95ff7ac7	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	583b4d78-a2ba-4792-bef7-7f6caf42e913
bd0c9048-3a9e-4904-a6ec-91df4f2c0a63	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	4f053667-43c6-4d17-9ff2-69457e2c1fe3
88139521-903b-4f89-a710-eaddb9da461d	fdc5399f-cadb-4f54-a91b-50ad67c91142	9c609877-b2d1-4b90-a21e-44412565a444
79421aa4-7dd0-4296-88e0-ee9be0a33f24	fdc5399f-cadb-4f54-a91b-50ad67c91142	4f053667-43c6-4d17-9ff2-69457e2c1fe3
abe734a5-b304-4bd1-b2ef-0ffe40f88d51	fdc5399f-cadb-4f54-a91b-50ad67c91142	583b4d78-a2ba-4792-bef7-7f6caf42e913
1d5ab822-ad08-4d1f-8a18-3b7ba114a109	4f053667-43c6-4d17-9ff2-69457e2c1fe3	9c609877-b2d1-4b90-a21e-44412565a444
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.recipes (id, name, description, "time", image, video, "favouriteCount", ingredients, steps, "authorId", "createdAt", "updatedAt", "categoryId", "likedByUserIds", "averageRating", "reviewsCount") FROM stdin;
3dcb3863-d2d0-425c-b2c8-9a5ff1484511	Запечене куряче філе з овочами	Легка та корисна вечеря з курячого філе та запечених овочів.	35	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%97%D0%B0%D0%BF%D0%B5%D1%87%D0%B5%D0%BD%D0%B5-%D0%BA%D1%83%D1%80%D1%8F%D1%87%D0%B5-%D1%84%D1%96%D0%BB%D0%B5_%D0%B7-%D0%BE%D0%B2%D0%BE%D1%87%D0%B0%D0%BC%D0%B8_c9lkwe.png		0	{"Куряче філе",Кабачок,Перець,"Оливкова олія",Сіль,Перець}	{"Розігрійте духовку до 180°C.","Наріжте овочі та куряче філе.","Змішайте інгредієнти з оливковою олією та спеціями.","Запікайте 30–35 хвилин до готовності."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:53:58.29371	2025-12-16 14:46:17.666	5400ad8c-2702-4693-87d8-b25ef1dede3a	{}	0	0
d8dfa19d-977a-4b6b-95d5-7c3f3f804282	Рис з овочами та соєвим соусом	Швидкий азійський обід з рисом та овочами.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884740/%D0%A0%D0%B8%D1%81-%D0%B7-%D0%BE%D0%B2%D0%BE%D1%87%D0%B0%D0%BC%D0%B8-%D1%82%D0%B0-%D1%81%D0%BE%D1%94%D0%B2%D0%B8%D0%BC-%D1%81%D0%BE%D1%83%D1%81%D0%BE%D0%BC_q7pccb.png		0	{Рис,Морква,Перець,Броколі,"Соєвий соус",Олія}	{"Відваріть рис.","Обсмажте овочі на сильному вогні.","Додайте рис та соєвий соус.","Перемішайте та прогрійте перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:53:31.29876	2025-12-16 14:46:57.841	857acab9-1dae-4a3f-be1c-ad8de84d20e9	{}	0	0
24653c18-392d-434a-884f-6771943b5c33	Гречка з грибами	Поживна гречка з ароматними грибами.	30	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%93%D1%80%D0%B5%D1%87%D0%BA%D0%B0-%D0%B7-%D0%B3%D1%80%D0%B8%D0%B1%D0%B0%D0%BC%D0%B8_xe7fb6.png		0	{Гречка,Печериці,Цибуля,Олія,Сіль,Перець}	{"Відваріть гречку до готовності.","Обсмажте цибулю та гриби.","Змішайте гречку з грибами.","Додайте сіль та перець за смаком."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:53:24.795413	2025-12-16 14:47:31.374	857acab9-1dae-4a3f-be1c-ad8de84d20e9	{}	0	0
e8ae7767-565f-4c23-95ff-8fef6bc27632	Курячий суп з локшиною	Легкий та поживний курячий суп, ідеальний для обіду.	40	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884734/%D0%9A%D1%83%D1%80%D1%8F%D1%87%D0%B8%D0%B8%CC%86-%D1%81%D1%83%D0%BF-%D0%B7-%D0%BB%D0%BE%D0%BA%D1%88%D0%B8%D0%BD%D0%BE%D1%8E_dzgfuj.png		0	{"Куряче філе",Локшина,Морква,Цибуля,Сіль,Перець}	{"Відваріть куряче філе до готовності.","Наріжте овочі.","Додайте овочі до бульйону та варіть 10 хвилин.","Додайте локшину та варіть ще 5–7 хвилин."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:53:02.880637	2025-12-16 14:48:30.532	857acab9-1dae-4a3f-be1c-ad8de84d20e9	{}	0	0
909ca982-cd49-49f2-bf72-787cd24dac8b	Йогурт з гранолою та фруктами	Швидкий сніданок без готування — йогурт з хрумкою гранолою та фруктами.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885533/%D0%98%CC%86%D0%BE%D0%B3%D1%83%D1%80%D1%82-%D0%B7-%D0%B3%D1%80%D0%B0%D0%BD%D0%BE%D0%BB%D0%BE%D1%8E-%D1%82%D0%B0-%D1%84%D1%80%D1%83%D0%BA%D1%82%D0%B0%D0%BC%D0%B8_fekkxz.png		0	{Йогурт,Гранола,Банан,Яблуко,Мед}	{"Наріжте фрукти шматочками.","Викладіть йогурт у миску.","Додайте гранолу та фрукти.","Полийте медом перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:52:29.783089	2025-12-16 14:49:02.785	d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	{}	0	0
46d862b2-232a-4a2e-9adc-6dddaea25cb6	Сирники зі сметаною	Класичні сирники для солодкого сніданку.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884742/%D0%A1%D0%B8%D1%80%D0%BD%D0%B8%D0%BA%D0%B8-%D0%B7%D1%96-%D1%81%D0%BC%D0%B5%D1%82%D0%B0%D0%BD%D0%BE%D1%8E_mjtdmw.png		0	{Творог,Яйце,Цукор,Борошно,Сметана,Олія}	{"Змішайте творог, яйце та цукор.","Додайте борошно та сформуйте сирники.","Обсмажте на розігрітій сковороді до золотистості.","Подавайте зі сметаною."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:52:23.22089	2025-12-16 14:49:46.302	d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	{}	0	0
01fa8a54-8825-442c-9130-68ba804ec94b	Вівсянка з ягодами	Корисна вівсяна каша з ягодами для енергійного початку дня.	8	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%92%D1%96%D0%B2%D1%81%D1%8F%D0%BD%D0%BA%D0%B0-%D0%B7-%D1%8F%D0%B3%D0%BE%D0%B4%D0%B0%D0%BC%D0%B8_i7m4il.png		0	{"Вівсяні пластівці",Молоко,Мед,Ягоди,Сіль}	{"Закип’ятіть молоко з дрібкою солі.","Додайте вівсяні пластівці.","Варіть 5–7 хвилин, помішуючи.","Додайте мед та ягоди перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:51:48.888099	2025-12-16 14:50:59.551	d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	{}	0	0
c6950267-7aff-4c73-b04f-a626be710531	М’ясні котлети з картоплею	Класичні м’ясні котлети з гарніром з картоплі.	50	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884734/%D0%9C%D1%8F%D1%81%D0%BD%D1%96-%D0%BA%D0%BE%D1%82%D0%BB%D0%B5%D1%82%D0%B8-%D0%B7-%D0%BA%D0%B0%D1%80%D1%82%D0%BE%D0%BF%D0%BB%D0%B5%D1%8E_czr5s7.png		0	{Фарш,Цибуля,Яйце,Хліб,Картопля,Олія,Сіль,Перець}	{"Змішайте фарш з цибулею, яйцем та хлібом.","Сформуйте котлети.","Обсмажте котлети до золотистої скоринки.","Відваріть або запечіть картоплю для гарніру."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:56:34.363333	2025-12-16 14:34:22.039	6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	{}	0	0
942b9c9a-2907-45df-8476-2457f19fc254	Риба запечена з овочами	Запечена риба з ароматними овочами для ситної вечері.	35	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%97%D0%B0%D0%BF%D0%B5%D1%87%D0%B5%D0%BD%D0%B0-%D1%80%D0%B8%D0%B1%D0%B0-%D0%B7-%D0%BE%D0%B2%D0%BE%D1%87%D0%B0%D0%BC%D0%B8_gtqoy2.png		0	{"Філе риби",Кабачок,Помідор,Цибуля,"Оливкова олія",Сіль,Перець}	{"Наріжте овочі та викладіть у форму.","Посоліть та поперчіть рибу.","Викладіть рибу на овочі.","Запікайте 25–30 хвилин при 180°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:56:29.229344	2025-12-16 14:35:10.624	6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	{}	0	0
1486b94c-c337-4413-98ee-7d915c5b263f	Гарбузовий крем-суп	Ніжний крем-суп з гарбуза.	35	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%93%D0%B0%D1%80%D0%B1%D1%83%D0%B7%D0%BE%D0%B2%D0%B8%D0%B8%CC%86-%D0%BA%D1%80%D0%B5%D0%BC-%D1%81%D1%83%D0%BF_twcdtx.png		0	{Гарбуз,Картопля,Цибуля,Вершки,Олія,Сіль}	{"Наріжте гарбуз та овочі.","Обсмажте цибулю до м’якості.","Зваріть овочі до готовності.","Подрібніть блендером та додайте вершки."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:56.023216	2025-12-16 14:37:34.644	d338de3a-c502-42ca-9d99-d9cbb948d4b0	{}	0	0
1c4ecb27-628b-4da6-a73d-577dd5b8ff68	Курячий бульйон	Прозорий курячий бульйон для легкого обіду.	60	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884733/%D0%9A%D1%83%D1%80%D1%8F%D1%87%D0%B8%D0%B8%CC%86-%D0%B1%D1%83%D0%BB%D1%8C%D0%B8%CC%86%D0%BE%D0%BD_fibh3r.png		0	{Курка,Морква,Цибуля,"Лавровий лист",Сіль,Перець}	{"Залийте курку холодною водою.","Доведіть до кипіння та зніміть піну.","Додайте овочі та спеції.","Варіть на слабкому вогні 50–60 хвилин."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:49.981371	2025-12-16 14:38:09.697	d338de3a-c502-42ca-9d99-d9cbb948d4b0	{}	0	0
ed20f973-f964-422e-b237-81495a5fb1e6	Борщ український	Класичний український борщ з насиченим смаком.	90	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%91%D0%BE%D1%80%D1%89-%D1%83%D0%BA%D1%80%D0%B0%D1%96%CC%88%D0%BD%D1%81%D1%8C%D0%BA%D0%B8%D0%B8%CC%86_udcij6.png		0	{Свинина,Буряк,Капуста,Картопля,Морква,Цибуля,"Томатна паста",Сіль}	{"Зваріть м’ясний бульйон.","Наріжте та обсмажте буряк з томатною пастою.","Додайте овочі до бульйону.","Варіть до готовності та дайте настоятися."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:44.025371	2025-12-16 14:38:49.835	d338de3a-c502-42ca-9d99-d9cbb948d4b0	{}	0	0
681832f1-cbe8-4291-af9e-365f15206842	Сирні кульки	Простий білковий перекус із сиру.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884744/%D0%A1%D0%B8%D1%80%D0%BD%D1%96-%D0%BA%D1%83%D0%BB%D1%8C%D0%BA%D0%B8_rfk10e.png		0	{Творог,Сіль,Зелень}	{"Подрібніть зелень.","Змішайте творог із сіллю.","Сформуйте невеликі кульки.","Подавайте охолодженими."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:14.231191	2025-12-16 14:39:23.688	1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	{}	0	0
4d5a5036-34d2-4edc-8bea-a3ca5b317d7f	Тости з арахісовою пастою та бананом	Ситний перекус з хрумкого тосту, банану та арахісової пасти.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884748/%D0%A2%D0%BE%D1%81%D1%82%D0%B8-%D0%B7-%D0%B0%D1%80%D0%B0%D1%85%D1%96%D1%81%D0%BE%D0%B2%D0%BE%D1%8E-%D0%BF%D0%B0%D1%81%D1%82%D0%BE%D1%8E-%D1%82%D0%B0-%D0%B1%D0%B0%D0%BD%D0%B0%D0%BD%D0%BE%D0%BC_ydbq8z.png		0	{Хліб,"Арахісова паста",Банан}	{"Підсмажте хліб у тостері.","Намажте арахісову пасту.","Наріжте банан кружальцями.","Викладіть банан на тост."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:02.215728	2025-12-16 14:41:18.398	1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	{}	0	0
fbcf6cc6-bf13-478a-8d9a-ebc5c5d36c39	Цезар з куркою	Класичний салат з куркою, листям салату та соусом Цезар.	15	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885564/%D0%A6%D0%B5%D0%B7%D0%B0%D1%80-%D0%B7-%D0%BA%D1%83%D1%80%D0%BA%D0%BE%D1%8E_wdkx00.png		0	{"Куряче філе","Листя салату","Сир пармезан",Сухарики,"Соус Цезар",Сіль,Перець}	{"Обсмажте куряче філе та наріжте смужками.","Нарвіть листя салату.","Змішайте салат з куркою, сухариками та сиром.","Заправте соусом Цезар і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:58:33.483738	2025-12-16 14:22:34.871	f4f9ea71-a649-4f75-bfab-ba99922edb92	{}	0	0
a9f81b49-e07d-4f6e-90b0-163d544fd9b6	Грецький салат	Свіжий салат з овочів, оливок та фети.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885532/%D0%93%D1%80%D0%B5%D1%86%D1%8C%D0%BA%D0%B8%D0%B8%CC%86-%D1%81%D0%B0%D0%BB%D0%B0%D1%82_zr5bxo.png		0	{Помідори,Огірки,Цибуля,Оливки,"Сир фета","Оливкова олія",Сіль,Перець}	{"Наріжте овочі кубиками.","Додайте оливки та сир фета.","Заправте оливковою олією.","Посоліть, поперчіть і перемішайте перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:58:27.552048	2025-12-16 14:24:47.966	f4f9ea71-a649-4f75-bfab-ba99922edb92	{}	0	0
d07d044a-e738-4c68-8935-63e2e646314c	Картопляне пюре	Класичне ніжне картопляне пюре для будь-якої страви.	25	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884731/%D0%9A%D0%B0%D1%80%D1%82%D0%BE%D0%BF%D0%BB%D1%8F%D0%BD%D0%B5-%D0%BF%D1%8E%D1%80%D0%B5_dtgnd2.png		0	{Картопля,Молоко,Масло,Сіль}	{"Очистіть і наріжте картоплю кубиками.","Відваріть у підсоленій воді до м’якості.","Злийте воду та розімніть картоплю.","Додайте масло та молоко, перемішайте до кремової консистенції."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:41.920354	2025-12-16 14:27:03.208	97006906-2b2a-4903-9a5f-671d90b452d8	{}	0	0
b9ae061b-370f-487f-b065-5eedeb7b42d9	Фаршировані яйця	Класична закуска з варених яєць з начинкою.	15	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884748/%D0%A4%D0%B0%D1%80%D1%88%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D1%96-%D1%8F%D0%B8%CC%86%D1%86%D1%8F_gfetg8.png		0	{Яйця,Майонез,Гірчиця,Сіль,Перець,Зелень}	{"Відваріть яйця та розріжте навпіл.","Вийміть жовтки та змішайте з майонезом і гірчицею.","Наповніть білки сумішшю.","Прикрасьте зеленню і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:12.767747	2025-12-16 14:28:32.704	d3c601fe-da84-445e-a77d-090a24006909	{}	0	0
c5973a47-9de7-4a70-aa8e-0d3203304840	Брускети з томатами та базиліком	Легка та ароматна закуска на хрумкому хлібі.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884730/%D0%91%D1%80%D1%83%D1%81%D0%BA%D0%B5%D1%82%D0%B8-%D0%B7-%D1%82%D0%BE%D0%BC%D0%B0%D1%82%D0%B0%D0%BC%D0%B8_uyeoww.png		0	{Багет,Помідори,Базилік,Часник,"Оливкова олія",Сіль}	{"Поріжте багет скибочками та підсмажте у духовці.","Натріть хліб часником.","Наріжте помідори та змішайте з базиліком.","Викладіть помідори на багет, полийте олією та подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:01.086641	2025-12-16 14:32:57.021	d3c601fe-da84-445e-a77d-090a24006909	{}	0	0
f9a5c689-5d80-4554-9aa2-e8788fe7f137	Зелений детокс-смузі	Освіжаючий напій для очищення організму.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885548/%D0%9E%D1%81%D0%B2%D1%96%D0%B6%D0%B0%D1%8E%D1%87%D0%B8%D0%B8%CC%86_%D0%BD%D0%B0%D0%BF%D1%96%D0%B8%CC%86_qdd98w.png		0	{Шпинат,Огірок,Яблуко,Вода,"Лимонний сік"}	{"Наріжте овочі та яблуко.","Додайте воду та лимонний сік.","Зблендеруйте до однорідності.","Подавайте охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:53.975421	2025-12-16 14:11:38.943	ca4496d1-02ba-4851-9b88-7f21ea0b0692	{}	0	0
7198e7f2-9f55-423a-98a5-cb8b57d94120	Пісочне печиво з варенням	Хрустке пісочне печиво з фруктовою начинкою.	30	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885548/%D0%BF%D1%96%D1%81%D0%BE%D1%87%D0%BD%D0%B5-%D0%BF%D0%B5%D1%87%D0%B8%D0%B2%D0%BE_schaxj.png		0	{Борошно,Масло,Цукор,Яйце,Варення}	{"Зробіть тісто з борошна, масла, цукру та яйця.","Розкачайте тісто та виріжте форми.","На середину кожного печива покладіть трохи варення.","Випікайте 15–20 хвилин при 180°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:18.959725	2025-12-16 14:13:26.22	431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	{}	0	0
b8a9aa19-d179-4637-9426-0b2b4d6e62e5	Запечена картопля з розмарином	Ароматний гарнір з хрусткою скоринкою.	35	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885532/%D0%97%D0%B0%D0%BF%D0%B5%D1%87%D0%B5%D0%BD%D0%B0-%D0%BA%D0%B0%D1%80%D1%82%D0%BE%D0%BF%D0%BB%D1%8F-%D0%B7-%D1%80%D0%BE%D0%B7%D0%BC%D0%B0%D1%80%D0%B8%D0%BD%D0%BE%D0%BC_clfpv5.png		1	{Картопля,"Оливкова олія",Розмарин,Сіль,Перець}	{"Наріжте картоплю дольками.","Змішайте з олією, сіллю, перцем та розмарином.","Викладіть на деко та запікайте 30–35 хвилин при 200°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:53.117186	2025-12-17 20:20:36.106	97006906-2b2a-4903-9a5f-671d90b452d8	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
03aefaff-21ec-4ae1-a104-0c78581a4cca	Морозиво з банану	Простий та корисний десерт з замороженого банану.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885539/%D0%9C%D0%BE%D1%80%D0%BE%D0%B7%D0%B8%D0%B2%D0%BE-%D0%B7-%D0%B1%D0%B0%D0%BD%D0%B0%D0%BD%D1%83_q7xvre.png		0	{Банан,Мед,"Горіхи (за бажанням)"}	{"Наріжте банан шматочками і заморозьте.","Подрібніть заморожений банан у блендері до кремової консистенції.","Додайте мед і горіхи за бажанням.","Подавайте одразу."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:59:18.975075	2025-12-16 14:17:18.336	861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	{}	0	0
8194f7cb-879d-4346-b611-a43303355bda	Яблучний штрудель	Традиційна випічка з яблуками та корицею.	50	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885580/%D0%AF%D0%B1%D0%BB%D1%83%D1%87%D0%BD%D0%B8%D0%B8%CC%86-%D1%88%D1%82%D1%80%D1%83%D0%B4%D0%B5%D0%BB%D1%8C_jeo0h2.png		1	{"Листкове тісто",Яблука,Цукор,Кориця,Масло,"Цукрова пудра"}	{"Наріжте яблука та змішайте з цукром і корицею.","Розкачайте тісто та викладіть яблука.","Згорніть рулетом і змастіть маслом.","Випікайте 35–40 хвилин при 180°C. Посипте цукровою пудрою перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:08.256657	2025-12-19 14:08:19.384	431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
1bcbc119-268e-4d41-a274-4833a526ec6b	Шоколадні кекси	М’які та ароматні кекси з шоколадом.	25	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885565/%D0%A8%D0%BE%D0%BA%D0%BE%D0%BB%D0%B0%D0%B4%D0%BD%D1%96-%D0%BA%D0%B5%D0%BA%D1%81%D0%B8_qla7zy.png		1	{Борошно,Цукор,Какао-порошок,Яйця,"Вершкове масло",Молоко,Розпушувач}	{"Змішайте сухі інгредієнти.","Додайте яйця, молоко та розтоплене масло.","Перемішайте до однорідної маси.","Викладіть у формочки і випікайте 20–25 хвилин при 180°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:01.437609	2025-12-19 18:03:21.332	431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
0c775ba4-d4e7-4dbb-afd5-3166a8d4b52f	Шоколадний мус	Ніжний та повітряний шоколадний десерт.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885564/%D0%A8%D0%BE%D0%BA%D0%BE%D0%BB%D0%B0%D0%B4%D0%BD%D0%B8%D0%B8%CC%86-%D0%BC%D1%83%D1%81_qfjp0g.png		0	{"Темний шоколад",Вершки,Цукор,Яйця}	{"Розтопіть шоколад на водяній бані.","Збийте вершки до м’яких піків.","Збийте яйця з цукром і обережно змішайте з шоколадом.","Додайте вершки і акуратно перемішайте. Охолодіть перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:59:08.558358	2025-12-16 14:20:43.097	861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	{}	0	0
a3d8a86d-1b14-48b1-82e0-15aaa0e6bef0	Пудинг з чіа та ягодами	Легкий десерт без випікання з насінням чіа та ягодами.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885548/%D0%9F%D1%83%D0%B4%D0%B8%D0%BD%D0%B3-%D0%B7-%D1%87%D1%96%D0%B0_so3xai.png		1	{"Насіння чіа","Молоко або рослинне молоко",Ягоди,Мед}	{"Змішайте насіння чіа з молоком та медом.","Залиште на 3–4 години або на ніч у холодильнику.","Додайте ягоди перед подачею.","Перемішайте і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:59:23.953954	2025-12-17 18:46:06.824	861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
e6466dbd-e08f-4df6-a742-ab631acfbfc8	Міні-піци з овочами	Невеликі піци, які легко їсти дітям.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885540/%D0%9D%D0%B5%D0%B2%D0%B5%D0%BB%D0%B8%D0%BA%D1%96-%D0%BF%D1%96%D1%86%D0%B8_dnogyh.png		2	{"Тісто для піци","Томатний соус",Сир,Перець,Помідори,Кукурудза}	{"Розкачайте тісто та виріжте маленькі кружечки.","Намажте соусом та додайте овочі і сир.","Випікайте 12–15 хвилин при 180°C.","Подавайте теплими."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:39.929558	2025-12-17 18:47:52.035	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{4f053667-43c6-4d17-9ff2-69457e2c1fe3,da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	0	0
90cfcc5f-5f89-4b05-b247-3fe5d5fd3bdc	Кольорові овочеві ролли	Яскраві та здорові овочеві ролли для дітей.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885547/%D0%BE%D0%B2%D0%BE%D1%87%D0%B5%D0%B2%D1%96-%D1%80%D0%BE%D0%BB%D0%BB%D0%B8_yblt6w.png		2	{Лаваш,Морква,Огірок,Перець,"Сир вершковий",Зелень}	{"Намажте лаваш вершковим сиром.","Наріжте овочі соломкою і викладіть на лаваш.","Скрутіть рулетом і наріжте порційними шматочками.","Подавайте свіжими."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:44.502403	2025-12-17 18:56:49.328	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{4f053667-43c6-4d17-9ff2-69457e2c1fe3,da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	0	0
a1892c72-5b30-44a4-ac37-78b39adddc82	Трав’яний чай з м’ятою	Ароматний та заспокійливий напій з м’яти.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885556/%D0%A2%D1%80%D0%B0%D0%B2%D1%8F%D0%BD%D0%B8%D0%B8%CC%86-%D1%87%D0%B0%D0%B8%CC%86_bppdvj.png		1	{"Свіжа м’ята",Вода,"Мед (за бажанням)"}	{"Закип’ятіть воду.","Додайте свіжу м’яту і дайте настоятися 3–5 хвилин.","Додайте мед за бажанням.","Подавайте гарячим або охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:01:21.319057	2025-12-17 19:32:36.738	ca4496d1-02ba-4851-9b88-7f21ea0b0692	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
38add7c0-c10f-43c8-bd5f-b7b2d745f2b6	Фруктові смузі для дітей	Корисний та смачний фруктовий смузі для малюків.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885560/%D0%A4%D1%80%D1%83%D0%BA%D1%82%D0%BE%D0%B2%D1%96-%D1%81%D0%BC%D1%83%D0%B7%D1%96_drttrg.png		1	{Банан,Яблуко,Морква,Йогурт,"Мед (за бажанням)"}	{"Наріжте фрукти та моркву маленькими шматочками.","Додайте йогурт та мед.","Зблендеруйте до однорідної маси.","Подавайте охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:33.639977	2025-12-20 12:33:36.29	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
d029cefe-333e-45fa-9d2c-c5bab778d52d	Оселедець під шубою	Класичний святковий салат з оселедцем та овочами.	30	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885548/%D0%9E%D1%81%D0%B5%D0%BB%D0%B5%D0%B4%D0%B5%D1%86%D1%8C-%D0%BF%D1%96%D0%B4-%D1%88%D1%83%D0%B1%D0%BE%D1%8E_gjixvf.png		1	{Оселедець,Буряк,Картопля,Морква,Цибуля,Майонез,Сіль}	{"Відваріть овочі та натріть на крупній тертці.","Наріжте оселедець та цибулю.","Викладіть шари: картопля, оселедець, морква, буряк, майонез.","Залиште на 1–2 години для просочення перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:01:56.59695	2025-12-17 18:57:02.406	4fb74c45-963a-4442-9fe8-2fad1400067d	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	0	0
ad71ad1d-fdd7-4fda-a22a-b8c68adfef64	Запечена індичка з травами	Соковита індичка для святкового столу з ароматними травами.	180	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885532/%D0%97%D0%B0%D0%BF%D0%B5%D1%87%D0%B5%D0%BD%D0%B0-%D1%96%D0%BD%D0%B4%D0%B8%D1%87%D0%BA%D0%B0_yoejuu.png		2	{Індичка,Часник,Розмарин,Тим’ян,Олія,Сіль,Перець}	{"Натріть індичку сумішшю олії, трав, солі та перцю.","Залиште маринуватися на 1–2 години.","Запікайте в духовці при 180°C 2–3 години залежно від ваги.","Дайте відпочити 15 хвилин перед нарізанням."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:01:47.934665	2025-12-17 19:26:55.389	4fb74c45-963a-4442-9fe8-2fad1400067d	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9,4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
42d679de-15cb-481e-9cf2-2ec6546772f3	Фруктовий лимонад	Свіжий лимонад з цитрусових для спекотного дня.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885559/%D0%A4%D1%80%D1%83%D0%BA%D1%82%D0%BE%D0%B2%D0%B8%D0%B8%CC%86-%D0%BB%D0%B8%D0%BC%D0%BE%D0%BD%D0%B0%D0%B4_roq94p.png		0	{Лимон,Апельсин,Цукор,Вода,Лід}	{"Вичавіть сік з лимона та апельсина.","Додайте воду та цукор, добре розмішайте.","Додайте лід перед подачею.","Подавайте охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:01:09.33624	2025-12-16 14:09:50.763	ca4496d1-02ba-4851-9b88-7f21ea0b0692	{}	0	0
4c390ce6-d462-42eb-a190-98b8c306db93	Сирники	Ніжні сирники з сиру на сніданок або десерт.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885555/%D1%81%D0%B8%D1%80%D0%BD%D0%B8%D0%BA%D0%B8-%D0%B7-%D1%81%D0%B8%D1%80%D1%83_p3acrh.png		0	{Творог,Яйце,Борошно,Цукор,Ваніль,Олія}	{"Змішайте творог з яйцем, цукром та ваніллю.","Додайте борошно і сформуйте невеликі сирники.","Обсмажте на сковороді до золотистої скоринки з обох боків.","Подавайте гарячими з медом або сметаною."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:13.385405	2025-12-16 14:14:36.34	431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	{}	0	0
15fdbb18-3f9b-47a8-8b58-e3146f88908c	Яблучний пиріг	Смачний домашній яблучний пиріг з корицею.	60	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885565/%D0%AF%D0%B1%D0%BB%D1%83%D1%87%D0%BD%D0%B8%D0%B8%CC%86-%D0%BF%D0%B8%D1%80%D1%96%D0%B3_kqhxrz.png		0	{Яблука,Борошно,Цукор,Масло,Яйця,Кориця}	{"Приготуйте тісто з борошна, масла та цукру.","Наріжте яблука і змішайте з корицею та цукром.","Викладіть яблука на тісто та накрийте верхнім шаром тіста.","Випікайте 40–45 хвилин при 180°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:59:14.053892	2025-12-16 14:20:07.739	861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	{}	0	0
20f1c1ee-eb17-42a7-b8a4-37e4174882ee	Салат з квасолею та кукурудзою	Ситний салат з квасолею, кукурудзою та овочами.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885549/%D0%A1%D0%B0%D0%BB%D0%B0%D1%82-%D0%B7-%D0%BA%D0%B2%D0%B0%D1%81%D0%BE%D0%BB%D0%B5%D1%8E-%D1%82%D0%B0-%D0%BA%D1%83%D0%BA%D1%83%D1%80%D1%83%D0%B4%D0%B7%D0%BE%D1%8E_mbtijy.png		0	{"Консервована квасоля",Кукурудза,Помідор,Огірок,Цибуля,Олія,Сіль,Перець}	{"Злийте рідину з квасолі та кукурудзи.","Наріжте овочі кубиками.","Змішайте всі інгредієнти в мисці.","Заправте олією, посоліть та поперчіть."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:58:44.310916	2025-12-16 14:21:17.37	f4f9ea71-a649-4f75-bfab-ba99922edb92	{}	0	0
99d8623d-f8e9-4372-91ac-043e7b4ad01b	Овочевий салат з йогуртом	Легкий салат з овочів із йогуртовою заправкою.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885545/%D0%9E%D0%B2%D0%BE%D1%87%D0%B5%D0%B2%D0%B8%D0%B8%CC%86-%D1%81%D0%B0%D0%BB%D0%B0%D1%82-%D0%B7-%D0%B8%CC%86%D0%BE%D0%B3%D1%83%D1%80%D1%82%D0%BE%D0%BC_uflhsp.png		0	{Огірок,Помідор,Перець,Морква,Йогурт,Сіль,Перець}	{"Наріжте всі овочі кубиками або соломкою.","Змішайте з йогуртом.","Посоліть та поперчіть за смаком.","Подайте охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:58:38.253249	2025-12-16 14:21:55.925	f4f9ea71-a649-4f75-bfab-ba99922edb92	{}	0	0
a42f61f8-5126-47f8-9d5c-cd9c11ee9406	Канапе з сиром та огірком	Проста і швидка закуска для будь-якої вечірки.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885532/%D0%9A%D0%B0%D0%BD%D0%B0%D0%BF%D0%B5-%D0%B7-%D1%81%D0%B8%D1%80%D0%BE%D0%BC-%D1%82%D0%B0-%D0%BE%D0%B3%D1%96%D1%80%D0%BA%D0%BE%D0%BC_kyeaok.png		0	{Багет,"Твердий сир",Огірок,Оливки,Зелень}	{"Наріжте багет на маленькі скибочки.","Наріжте сир та огірок тонкими скибочками.","Накладіть сир, огірок та оливку на багет.","Прикрасьте зеленню і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:06.369172	2025-12-16 14:32:11.64	d3c601fe-da84-445e-a77d-090a24006909	{}	0	0
2e4b72c3-89ba-4a93-b31b-3912429245aa	Паста з куркою та грибами	Насичена паста з куркою та грибами для ситного обіду.	30	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884738/%D0%9F%D0%B0%D1%81%D1%82%D0%B0-%D0%B7-%D0%BA%D1%83%D1%80%D0%BA%D0%BE%D1%8E-%D1%82%D0%B0-%D0%B3%D1%80%D0%B8%D0%B1%D0%B0%D0%BC%D0%B8_ovnnwr.png		0	{Паста,"Куряче філе",Гриби,Цибуля,Вершки,Сіль,Перець}	{"Відваріть пасту до стану al dente.","Обсмажте цибулю та гриби.","Додайте курку та обсмажте до готовності.","Додайте вершки, змішайте з пастою та прогрійте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:56:40.330982	2025-12-16 14:33:43.359	6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	{}	0	0
549ea564-20ef-4349-84e9-eb912ab25e7d	Йогурт з медом та горіхами	Корисний перекус з йогурту, меду та горіхів.	3	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884731/%D0%98%CC%86%D0%BE%D0%B3%D1%83%D1%80%D1%82-%D0%B7-%D0%BC%D0%B5%D0%B4%D0%BE%D0%BC-%D1%82%D0%B0-%D0%B3%D0%BE%D1%80%D1%96%D1%85%D0%B0%D0%BC%D0%B8_xkyqvv.png		0	{Йогурт,Мед,Горіхи}	{"Викладіть йогурт у миску.","Додайте мед.","Посипте подрібненими горіхами.","Подавайте одразу."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:55:07.980391	2025-12-16 14:40:14.203	1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	{}	0	0
8db97621-631a-4127-94a5-073a935fbbaa	Омлет з сиром та зеленню	Швидка білкова вечеря з сиром та свіжою зеленню.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884738/%D0%9E%D0%BC%D0%BB%D0%B5%D1%82-%D0%B7-%D1%81%D0%B8%D1%80%D0%BE%D0%BC-%D1%82%D0%B0-%D0%B7%D0%B5%D0%BB%D0%B5%D0%BD%D0%BD%D1%8E_oq6vx3.png		0	{Яйця,"Твердий сир",Зелень,Сіль,Олія}	{"Збийте яйця з сіллю.","Натріть сир та подрібніть зелень.","Вилийте яйця на сковороду.","Додайте сир і зелень та готуйте до готовності."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:54:25.755675	2025-12-16 14:44:17.557	5400ad8c-2702-4693-87d8-b25ef1dede3a	{}	0	0
5b11bdcb-2b22-424b-97f8-04ffeff2dd7a	Лосось на сковороді з лимоном	Швидка вечеря з ніжного лосося з лимонним ароматом.	15	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884734/%D0%9B%D0%BE%D1%81%D0%BE%D1%81%D1%8C-%D0%BD%D0%B0-%D1%81%D0%BA%D0%BE%D0%B2%D0%BE%D1%80%D0%BE%D0%B4%D1%96_pud2gf.png		0	{"Філе лосося",Лимон,"Оливкова олія",Сіль,Перець}	{"Розігрійте сковороду з олією.","Посоліть та поперчіть лосось.","Обсмажте з обох сторін по 3–4 хвилини.","Збризніть лимонним соком перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:54:04.334625	2025-12-16 14:45:39.345	5400ad8c-2702-4693-87d8-b25ef1dede3a	{}	0	0
323ffca6-d4a9-4473-8019-95282bdff43e	Паста з томатним соусом	Класична паста з насиченим томатним соусом.	25	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884739/%D0%9F%D0%B0%D1%81%D1%82%D0%B0-%D0%B7-%D1%82%D0%BE%D0%BC%D0%B0%D1%82%D0%BD%D0%B8%D0%BC-%D1%81%D0%BE%D1%83%D1%81%D0%BE%D0%BC_tvqugv.png		0	{Паста,Помідори,Часник,"Оливкова олія",Сіль,Базилік}	{"Відваріть пасту до стану al dente.","Обсмажте часник на оливковій олії.","Додайте подрібнені помідори та тушіть 10 хвилин.","Змішайте пасту з соусом і подавайте з базиліком."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:53:13.393289	2025-12-16 14:48:03.5	857acab9-1dae-4a3f-be1c-ad8de84d20e9	{}	0	0
2e5ecbb5-ff90-4adb-b7f4-bb77d490267f	Тости з авокадо та яйцем	Поживні тости з кремовим авокадо та яйцем.	12	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884747/%D0%A2%D0%BE%D1%81%D1%82%D0%B8-%D0%B7-%D0%B0%D0%B2%D0%BE%D0%BA%D0%B0%D0%B4%D0%BE-%D1%82%D0%B0-%D1%8F%D0%B8%CC%86%D1%86%D0%B5%D0%BC_gvbumu.png		0	{Хліб,Авокадо,Яйце,Сіль,Перець,"Лимонний сік"}	{"Підсмажте хліб у тостері.","Розімніть авокадо з сіллю та лимонним соком.","Приготуйте яйце (пашот або смажене).","Викладіть авокадо та яйце на тости."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:52:16.542992	2025-12-16 14:50:14.555	d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	{}	0	0
2d274146-719f-4950-abd1-96f9028e89f0	Суп з сочевиці	Поживний та ароматний суп із сочевиці.	40	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884747/%D1%81%D1%83%D0%BF-%D1%96%D0%B7-%D1%81%D0%BE%D1%87%D0%B5%D0%B2%D0%B8%D1%86%D1%96_t3xwyt.png		1	{Сочевиця,Морква,Цибуля,Часник,Олія,Сіль,Перець}	{"Промийте сочевицю.","Обсмажте цибулю, моркву та часник.","Додайте сочевицю та воду.","Варіть до м’якості, посоліть за смаком."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:56:02.011947	2025-12-17 19:12:53.971	d338de3a-c502-42ca-9d99-d9cbb948d4b0	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	0	0
ff1eb6a6-e9c1-402f-908f-69c4baa7cdac	Овочеві рулетики з лавашу	Свіжі та хрусткі рулетики з овочів у лаваші.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884736/%D0%9E%D0%B2%D0%BE%D1%87%D0%B5%D0%B2%D1%96-%D1%80%D1%83%D0%BB%D0%B5%D1%82%D0%B8%D0%BA%D0%B8-%D0%B7-%D0%BB%D0%B0%D0%B2%D0%B0%D1%88%D1%83_pjgapr.png		1	{Лаваш,Морква,Перець,Огірок,"Сир вершковий",Зелень}	{"Намажте лаваш вершковим сиром.","Наріжте овочі соломкою та викладіть на лаваш.","Згорніть лаваш рулетом.","Наріжте порційними шматочками і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:18.843116	2025-12-17 19:23:45.448	d3c601fe-da84-445e-a77d-090a24006909	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	0	0
9d5233e0-14f2-4d35-a47b-f3ff94bb4a14	Овочеве рагу	Ароматне овочеве рагу для легкої вечері.	40	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884735/%D0%9E%D0%B2%D0%BE%D1%87%D0%B5%D0%B2%D0%B5-%D1%80%D0%B0%D0%B3%D1%83_f5ibxq.png		1	{Картопля,Морква,Кабачок,Цибуля,Олія,Сіль}	{"Наріжте всі овочі кубиками.","Обсмажте цибулю до м’якості.","Додайте інші овочі та тушіть під кришкою.","Готуйте до м’якості, посоліть за смаком."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:54:09.550336	2025-12-17 19:33:29.14	5400ad8c-2702-4693-87d8-b25ef1dede3a	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
a4ffe3b4-d442-45e9-8c9b-59ef86388082	Фруктовий салат	Легкий та освіжаючий перекус зі свіжих фруктів.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884739/%D0%BF%D0%B5%D1%80%D0%B5%D0%BA%D1%83%D1%81-%D0%B7%D1%96-%D1%81%D0%B2%D1%96%D0%B6%D0%B8%D1%85-%D1%84%D1%80%D1%83%D0%BA%D1%82%D1%96%D0%B2_na4hin.png		1	{Яблуко,Банан,Апельсин,Виноград,"Лимонний сік"}	{"Наріжте всі фрукти кубиками.","Скропіть лимонним соком.","Акуратно перемішайте.","Подавайте одразу після приготування."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:54:55.978532	2025-12-17 20:20:00.761	1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
dc2fae41-4285-4d41-afc7-0820eeb7d5a1	Курка в соєво-медовому соусі	Соковита курка з ароматним соєво-медовим соусом.	40	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884731/%D0%BA%D1%83%D1%80%D0%BA%D0%B0-%D0%B7-%D1%81%D0%BE%D1%94%D0%B2%D0%BE-%D0%BC%D0%B5%D0%B4%D0%BE%D0%B2%D0%B8%D0%BC-%D1%81%D0%BE%D1%83%D1%81%D0%BE%D0%BC_w4jmw3.png		1	{"Куряче філе","Соєвий соус",Мед,Часник,Олія,Перець}	{"Наріжте курку шматочками.","Змішайте соєвий соус, мед та подрібнений часник.","Замаринуйте курку на 15 хвилин.","Обсмажте на сковороді до золотистої скоринки."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:56:23.327141	2025-12-17 21:30:39.368	6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
88ac92f5-7eef-42fe-b780-58ef8b13746d	Овочеве соте	Легкий овочевий гарнір з ароматом часнику та трав.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885540/%D0%9E%D0%B2%D0%BE%D1%87%D0%B5%D0%B2%D0%B5-%D1%81%D0%BE%D1%82%D0%B5_mlwi40.png		1	{Цукіні,Баклажан,Перець,Цибуля,Часник,Олія,Сіль,Перець}	{"Наріжте овочі кубиками.","Обсмажте цибулю та часник на олії.","Додайте інші овочі та тушкуйте 10–15 хвилин.","Посоліть, поперчіть і подавайте."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:58.832744	2025-12-18 17:38:31.336	97006906-2b2a-4903-9a5f-671d90b452d8	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
56513ebd-af2a-40ec-848a-86c8739bf8ff	Рис з овочами	Ситний гарнір з ароматного рису та овочів.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765884742/%D0%A0%D0%B8%D1%81-%D0%B7-%D0%BE%D0%B2%D0%BE%D1%87%D0%B0%D0%BC%D0%B8_q2twtm.png		1	{Рис,Морква,Горошок,Перець,Олія,Сіль}	{"Відваріть рис до готовності.","Обсмажте овочі на олії.","Змішайте рис з овочами.","Посоліть за смаком і прогрійте перед подачею."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 09:57:47.833065	2025-12-20 11:45:39.708	97006906-2b2a-4903-9a5f-671d90b452d8	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
024d3739-be5b-4a33-b3e4-500bced133aa	Класичний смузі з бананом	Корисний та поживний банановий смузі.	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885555/%D1%81%D0%BC%D1%83%D0%B7%D1%96-%D0%B7-%D0%B1%D0%B0%D0%BD%D0%B0%D0%BD%D0%BE%D0%BC_ybosy0.png		1	{Банан,Молоко,Йогурт,Мед}	{"Наріжте банан шматочками.","Додайте молоко, йогурт та мед.","Зблендеруйте до однорідної консистенції.","Подавайте одразу охолодженим."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:00:47.364396	2025-12-19 12:27:35.072	ca4496d1-02ba-4851-9b88-7f21ea0b0692	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
05faafc9-6043-4413-8d76-d810edc49dc8	Фаршировані печериці	Апетитна закуска для святкового столу.	25	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885556/%D0%A4%D0%B0%D1%80%D1%88%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D1%96-%D0%BF%D0%B5%D1%87%D0%B5%D1%80%D0%B8%D1%86%D1%96_raohvm.png		1	{Шампіньйони,"Твердий сир",Часник,Сметана,Зелень,Сіль,Перець}	{"Вийміть ніжки з грибів та дрібно наріжте.","Змішайте їх із сиром, сметаною, часником та зеленню.","Наповніть шапочки грибів сумішшю.","Запікайте 15–20 хвилин при 180°C."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:02.030898	2025-12-19 18:01:42.685	4fb74c45-963a-4442-9fe8-2fad1400067d	{4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
503e126e-b825-4bff-a87f-a42f10a82d46	Млинці з червоною ікрою	Святкова закуска з млинців та червоної ікри.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885539/%D0%9C%D0%BB%D0%B8%D0%BD%D1%86%D1%96-%D0%B7-%D1%87%D0%B5%D1%80%D0%B2%D0%BE%D0%BD%D0%BE%D1%8E-%D1%96%D0%BA%D1%80%D0%BE%D1%8E_jj2xdy.png		2	{Борошно,Молоко,Яйця,Сіль,"Ікра червона",Сметана}	{"Приготуйте тонкі млинці з борошна, молока, яєць та солі.","Намажте млинці сметаною.","Викладіть трохи ікри на кожен млинець.","Скрутіть рулетом і наріжте порційними шматочками."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:07.06156	2025-12-20 12:03:56.339	4fb74c45-963a-4442-9fe8-2fad1400067d	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9,4f053667-43c6-4d17-9ff2-69457e2c1fe3}	0	0
6a54452f-87c6-47ed-b199-254ec9515ae0	Бананові млинці	Ніжні млинці з бананом для сніданку дітей.	15	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885533/%D0%BC%D0%BB%D0%B8%D0%BD%D1%86%D1%96-%D0%B7-%D0%B1%D0%B0%D0%BD%D0%B0%D0%BD%D0%BE%D0%BC_nuqci8.png		3	{Банан,Яйця,Борошно,Молоко,Цукор,Ваніль}	{"Розімніть банан виделкою.","Додайте яйця, молоко, борошно, цукор та ваніль.","Змішайте до однорідної маси.","Смажте млинці на сковороді з обох боків до золотистого кольору."}	9c609877-b2d1-4b90-a21e-44412565a444	2025-12-14 10:02:50.88917	2025-12-20 19:38:41.199	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{da40a9cd-f2cb-44ea-a257-3f9d1b6453f9,4f053667-43c6-4d17-9ff2-69457e2c1fe3,fdc5399f-cadb-4f54-a91b-50ad67c91142}	0	0
01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7	Омлет з овочами	Легкий та поживний омлет з ніжними овочами, підходить для дитячого сніданку або обіду.	12	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885548/%D0%9E%D0%BC%D0%BB%D0%B5%D1%82-%D0%B7-%D0%BE%D0%B2%D0%BE%D1%87%D0%B0%D0%BC%D0%B8_mwien1.png		2	{Яйця,Молоко,Морква,Броколі,Сіль,"Вершкове масло"}	{"Збийте яйця з молоком і дрібкою солі.","Натріть моркву та дрібно наріжте броколі.","Злегка обсмажте овочі на вершковому маслі.","Залийте овочі яєчною сумішшю.","Готуйте на слабкому вогні під кришкою до готовності.","Подавайте теплим."}	4f053667-43c6-4d17-9ff2-69457e2c1fe3	2025-12-15 15:59:52.285258	2025-12-18 20:54:59.229	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{9c609877-b2d1-4b90-a21e-44412565a444,fdc5399f-cadb-4f54-a91b-50ad67c91142}	4.3	4
0111302a-4715-48c2-b1ee-1894c6bd8b2e	Сирники для дітей	Мʼякі та корисні сирники без зайвого цукру, ідеальні для дитячого сніданку.	20	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885549/%D0%A1%D0%B8%D1%80%D0%BD%D0%B8%D0%BA%D0%B8-%D0%B4%D0%BB%D1%8F-%D0%B4%D1%96%D1%82%D0%B5%D0%B8%CC%86_t8rnjc.png		2	{Сир,Яйце,Борошно,Цукор,Ваніль,Сметана}	{"Перетріть сир до однорідної консистенції.","Додайте яйце, трохи цукру та ваніль.","Всипте борошно і добре перемішайте.","Сформуйте невеликі сирники.","Обсмажте на середньому вогні до золотистої скоринки.","Подавайте зі сметаною."}	4f053667-43c6-4d17-9ff2-69457e2c1fe3	2025-12-15 15:37:12.202621	2025-12-22 22:07:00.622	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{9c609877-b2d1-4b90-a21e-44412565a444,da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	5	1
d73dac0d-5080-4507-9df0-3ac72215efe6	Вівсяна каша з яблуком	Ніжна вівсяна каша з яблуком та корицею, корисна і смачна для дітей.	10	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765885531/%D0%92%D1%96%D0%B2%D1%81%D1%8F%D0%BD%D0%B0-%D0%BA%D0%B0%D1%88%D0%B0-%D0%B7-%D1%8F%D0%B1%D0%BB%D1%83%D0%BA%D0%BE%D0%BC_cthvp9.png		2	{"Вівсяні пластівці",Молоко,Яблуко,Цукор,Кориця,"Вершкове масло"}	{"Закипʼятіть молоко в каструлі.","Додайте вівсяні пластівці та варіть на слабкому вогні.","Натріть яблуко або дрібно наріжте.","Додайте яблуко, трохи цукру та кориці.","Варіть ще кілька хвилин до мʼякої консистенції.","Додайте невеликий шматочок вершкового масла перед подачею."}	4f053667-43c6-4d17-9ff2-69457e2c1fe3	2025-12-15 15:39:09.461512	2025-12-17 18:48:33.839	193d83ca-25dd-45a6-8c19-3ec2ea042e3b	{9c609877-b2d1-4b90-a21e-44412565a444,da40a9cd-f2cb-44ea-a257-3f9d1b6453f9}	3.5	2
\.


--
-- Data for Name: reset_passwords; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.reset_passwords (id, token, "userId", "expiresAt", "usedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.reviews (id, "recipeId", "userId", rating, image, comment, "isBlocked", "createdAt") FROM stdin;
1140fe49-b563-488c-80bc-150a72883543	01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7	fe45c3fb-f5e7-4c8b-8e11-88ca5bb5a234	5	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766433810/reviews/yj4eyd05rtjib3zydmor.webp	Дякую за ідею, ввийшло дуже смачно :)	f	2025-12-22 20:03:31.476801
67e950c8-3019-4515-b04d-01b3b0e4d215	0111302a-4715-48c2-b1ee-1894c6bd8b2e	0e54244e-8c08-4ee6-b7b4-24aed08f9500	5	\N	Виглядають дуже апетитно	f	2025-12-22 20:06:20.426281
2884d6f9-0be1-4fdc-b0a6-6a83092d886d	01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7	f06293a8-4159-40d5-a103-cfd146f07d95	3	\N	На жаль не вдалось Зробити як на картинці	f	2025-12-22 20:07:53.132352
eb4b7e9f-e212-44dd-9168-a96f793ad1ed	d73dac0d-5080-4507-9df0-3ac72215efe6	f06293a8-4159-40d5-a103-cfd146f07d95	5	\N	Надзвичайно корисно та смачно	f	2025-12-22 20:08:20.033713
8a5d92b5-5337-4108-8d23-186f0cec4743	01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7	5d839e0f-8776-481b-8367-ffa141bb811e	4	\N	Корисно та смачно	f	2025-12-22 20:09:41.891078
3cdf3243-7966-4ed9-af8a-af7378981360	d73dac0d-5080-4507-9df0-3ac72215efe6	5d839e0f-8776-481b-8367-ffa141bb811e	2	\N	не люблю каші	f	2025-12-22 20:10:05.194681
b5f30688-dbd5-41c7-a580-97ff057bb0f6	01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7	9b8bacf9-423d-4739-8a07-61bdcd9ce652	5	\N	Ідеально підходить на сніданок	f	2025-12-22 20:10:47.973421
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.user_profiles (first_name, last_name, bio, avatar_url, banner_url, location, website, instagram, tiktok, facebook, youtube, followers_count, following_count, recipes_count, likes_received, is_private, language, theme, created_at, updated_at, user_id, id, liked_recipes) FROM stdin;
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/dog_urgwjo.png	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	f	en	light	2025-12-09 21:07:41.440492	2025-12-09 21:07:41.440492	b5d166c0-8d8b-44ed-8d07-f7759a7f426b	e8081c44-d6b8-441e-907d-2cfb1f0ef73d	{}
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811669/koala_gk8qbb.png	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	f	en	light	2025-12-09 21:08:09.216338	2025-12-09 21:08:09.216338	385a93e2-b6f4-4eea-9aaa-e2fb5162c1ae	69163239-4cbd-4e1f-a755-816b49bba643	{}
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811670/bear_udusdj.png	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	f	en	dark	2025-12-09 22:01:08.895802	2025-12-09 22:01:08.895802	a172f6b8-46f6-47a5-999f-c0181db58bca	ecc13c45-c1e7-490a-8155-647052c2dd8a	{}
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/elephant_mtczib.png	\N	\N	\N	\N	\N	\N	\N	2	0	0	0	f	en	light	2025-12-09 21:08:00.909056	2025-12-09 21:08:00.909056	6d5c01a0-c599-4c73-aada-ccfa8dd6155b	206bf333-b6dc-4cb8-a531-8ba42a91e9c7	{}
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811672/fox_pgf15d.png	\N	\N	\N	\N	\N	\N	\N	0	4	0	0	f	en	light	2025-12-12 13:36:10.446354	2025-12-12 13:36:10.446354	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	5d839e0f-8776-481b-8367-ffa141bb811e	{e6466dbd-e08f-4df6-a742-ab631acfbfc8,d73dac0d-5080-4507-9df0-3ac72215efe6,0111302a-4715-48c2-b1ee-1894c6bd8b2e,6a54452f-87c6-47ed-b199-254ec9515ae0,90cfcc5f-5f89-4b05-b247-3fe5d5fd3bdc,503e126e-b825-4bff-a87f-a42f10a82d46,d029cefe-333e-45fa-9d2c-c5bab778d52d,ad71ad1d-fdd7-4fda-a22a-b8c68adfef64,2d274146-719f-4950-abd1-96f9028e89f0,ff1eb6a6-e9c1-402f-908f-69c4baa7cdac}
\N	\N	\N	https://res.cloudinary.com/dohg7oxwo/image/upload/v1765811668/cat_zg5tls.png	\N	\N	\N	\N	\N	\N	\N	3	0	0	0	f	en	light	2025-12-09 21:07:51.864922	2025-12-09 21:07:51.864922	583b4d78-a2ba-4792-bef7-7f6caf42e913	adafc4ce-cf06-497c-92c6-213eaccb49f0	{}
Maria	Koval	Food lover & home chef. Sharing my favorite recipes.	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766250988/avatars/fmk5tkjcwbhxihs6qcvg.webp	https://example.com/banners/maria.jpg	Lviv Ukraine	https://maria-koval.com	https://www.instagram.com/maria.cooks/	https://www.tiktok.com/@maria_kitchen	https://www.facebook.com/maria.koval	https://www.youtube.com/@MariaCooks	3	0	56	27	t	en	light	2025-12-09 21:07:26.414738	2025-12-09 21:07:26.414738	9c609877-b2d1-4b90-a21e-44412565a444	f06293a8-4159-40d5-a103-cfd146f07d95	{01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7,d73dac0d-5080-4507-9df0-3ac72215efe6,0111302a-4715-48c2-b1ee-1894c6bd8b2e}
Name	Lastname	description	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766252160/avatars/yjhlyvsbfzsc6ibnwipk.webp	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	f	en	light	2025-12-12 13:20:06.116672	2025-12-12 13:20:06.116672	6fdb3cf5-bbe1-40f4-b98b-65dc7f6375f5	fef0a02e-d7b4-45ac-91f9-9c2102422685	{}
Naz	Lysak	description	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766252293/avatars/rvzh9qypu9iq19z9jxjt.webp	\N	\N	\N	\N	\N	\N	\N	0	3	0	0	f	en	light	2025-12-18 17:01:14.705865	2025-12-18 17:01:14.705865	fdc5399f-cadb-4f54-a91b-50ad67c91142	0e54244e-8c08-4ee6-b7b4-24aed08f9500	{01ac7c33-fc2d-41e5-81d9-24f64bc4d5c7,6a54452f-87c6-47ed-b199-254ec9515ae0}
Nazarii	Lysak	Люблю готувати та експериментувати зі смаками, знаходячи натхнення у простих і смачних рецептах. Кухня для мене — це спосіб ділитися теплом, настроєм і гарним настроєм з іншими.	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766252531/avatars/enha8ylzxsgxaoggvtqi.webp	\N	Україна - Львів	https://github.com/Nazar-Lysak/	https://www.instagram.com/	\N	https://www.facebook.com/	https://www.youtube.com/	2	3	3	6	t	ua	light	2025-12-15 15:32:34.632219	2025-12-15 15:32:34.632219	4f053667-43c6-4d17-9ff2-69457e2c1fe3	fe45c3fb-f5e7-4c8b-8e11-88ca5bb5a234	{90cfcc5f-5f89-4b05-b247-3fe5d5fd3bdc,e6466dbd-e08f-4df6-a742-ab631acfbfc8,a3d8a86d-1b14-48b1-82e0-15aaa0e6bef0,ad71ad1d-fdd7-4fda-a22a-b8c68adfef64,a1892c72-5b30-44a4-ac37-78b39adddc82,9d5233e0-14f2-4d35-a47b-f3ff94bb4a14,a4ffe3b4-d442-45e9-8c9b-59ef86388082,b8a9aa19-d179-4637-9426-0b2b4d6e62e5,dc2fae41-4285-4d41-afc7-0820eeb7d5a1,88ac92f5-7eef-42fe-b780-58ef8b13746d,024d3739-be5b-4a33-b3e4-500bced133aa,8194f7cb-879d-4346-b611-a43303355bda,05faafc9-6043-4413-8d76-d810edc49dc8,1bcbc119-268e-4d41-a274-4833a526ec6b,6a54452f-87c6-47ed-b199-254ec9515ae0,56513ebd-af2a-40ec-848a-86c8739bf8ff,503e126e-b825-4bff-a87f-a42f10a82d46,38add7c0-c10f-43c8-bd5f-b7b2d745f2b6}
Nets	test	test	https://res.cloudinary.com/dohg7oxwo/image/upload/v1766434391/avatars/ykdf0jtdmfoeiaxfj5ng.webp	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	f	en	light	2025-12-12 13:10:29.497024	2025-12-12 13:10:29.497024	6ba456f1-97c1-4a61-ac79-e4afdbad3b19	9b8bacf9-423d-4739-8a07-61bdcd9ce652	{}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.users (id, email, username, password) FROM stdin;
9c609877-b2d1-4b90-a21e-44412565a444	maria.koval@gmail.com	MariaK	$2b$10$qT7UHIUZj5.rmCZxURJCCuJrBvsFWHznZIw0SuW1QGECeaP2iueKy
b5d166c0-8d8b-44ed-8d07-f7759a7f426b	andrii.petrenko@yahoo.com	AndriiP	$2b$10$N8o87wXJ.OGYq9fWLFgKbeYcVjC4vwL0uevJPgkJOFRW0qBhlqBuy
583b4d78-a2ba-4792-bef7-7f6caf42e913	sofia.kryvonos@outlook.com	SofiK	$2b$10$20jENwD1lWiWQRZcsN00CuB6DoEakvCGHABYu1bx9HNXl01tuwzOa
6d5c01a0-c599-4c73-aada-ccfa8dd6155b	oleh.melnyk@gmail.com	OlehM	$2b$10$K2vBnZB8Fh6skUkr2I.HN.rxuXJCarcIBpentYVmVpb8RNJlrPbNW
385a93e2-b6f4-4eea-9aaa-e2fb5162c1ae	daria.levchuk@gmail.com	DariaL	$2b$10$2Dv77rJEfqX4k41/8SEojuVPz2mTaHfT6G/eVObxC5IApSmz1xwfG
a172f6b8-46f6-47a5-999f-c0181db58bca	Nazar.Prokof@yahoo.com	Nazar	$2b$10$RMy6YWeLibyN/Fg58zBGj.IX2UaCE1FGf85AXMtFyU.vyBLh3TSSO
6ba456f1-97c1-4a61-ac79-e4afdbad3b19	test@test.com	test	$2b$10$IGrSCztdPqA2/xva.ES0becDgW3v6kNFZfNSPXIyZbkn1J519e/Ry
6fdb3cf5-bbe1-40f4-b98b-65dc7f6375f5	tesst@test.com	tests	$2b$10$Fysvc61YI98jvYKH0xW3UuUiNj4oIeFvIiHBZ3aOue4xrvci4mtcm
da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	sss@sss.ss	sss@sss.ss	$2b$10$pPLjtOy3v5kwX6bNSV1OLu2lmstAKgtU2eGX9VQzSoJU43mf/QeDC
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
4f053667-43c6-4d17-9ff2-69457e2c1fe3	nazarlv87@gmail.com	Nazareth	$2b$10$Bwk0uh2eYNmXxqMnKh9BR.S8XL6hMvvjjbS5GHLGT3Ng2vRDbRu8.
fdc5399f-cadb-4f54-a91b-50ad67c91142	Nazarii.Lysak@ua.nestle.com	Nazarii	$2b$10$M5I8N8k3ALHoML89NgJyeOUYVnlNltCpvWux.CEVYfniav9pfEBGa
\.


--
-- Name: follow_profiles PK_0da03f60755e8dd414f328e6c10; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.follow_profiles
    ADD CONSTRAINT "PK_0da03f60755e8dd414f328e6c10" PRIMARY KEY (id, "followerId", "followingId");


--
-- Name: user_profiles PK_1ec6662219f4605723f1e41b6cb; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "PK_1ec6662219f4605723f1e41b6cb" PRIMARY KEY (id);


--
-- Name: reviews PK_231ae565c273ee700b283f15c1d; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "PK_231ae565c273ee700b283f15c1d" PRIMARY KEY (id);


--
-- Name: categories PK_24dbc6126a28ff948da33e97d3b; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "PK_24dbc6126a28ff948da33e97d3b" PRIMARY KEY (id);


--
-- Name: recipes PK_8f09680a51bf3669c1598a21682; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT "PK_8f09680a51bf3669c1598a21682" PRIMARY KEY (id);


--
-- Name: reset_passwords PK_9460c1c9b1d85658a023ae8e87f; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reset_passwords
    ADD CONSTRAINT "PK_9460c1c9b1d85658a023ae8e87f" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: user_profiles REL_6ca9503d77ae39b4b5a6cc3ba8; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "REL_6ca9503d77ae39b4b5a6cc3ba8" UNIQUE (user_id);


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
-- Name: reset_passwords UQ_facfa65cec881e1d583b35eb617; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reset_passwords
    ADD CONSTRAINT "UQ_facfa65cec881e1d583b35eb617" UNIQUE (token);


--
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- Name: IDX_facfa65cec881e1d583b35eb61; Type: INDEX; Schema: public; Owner: nestuser
--

CREATE INDEX "IDX_facfa65cec881e1d583b35eb61" ON public.reset_passwords USING btree (token);


--
-- Name: user_profiles FK_6ca9503d77ae39b4b5a6cc3ba88; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "FK_6ca9503d77ae39b4b5a6cc3ba88" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reviews FK_7e3b53f4f1dc9c097ca33072bde; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_7e3b53f4f1dc9c097ca33072bde" FOREIGN KEY ("recipeId") REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: reviews FK_7ed5659e7139fc8bc039198cc1f; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "FK_7ed5659e7139fc8bc039198cc1f" FOREIGN KEY ("userId") REFERENCES public.user_profiles(id) ON DELETE CASCADE;


--
-- Name: reset_passwords FK_988241b96c7d3d844736cfeba89; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.reset_passwords
    ADD CONSTRAINT "FK_988241b96c7d3d844736cfeba89" FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: recipes FK_afd4f74f8df44df574253a7f37b; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT "FK_afd4f74f8df44df574253a7f37b" FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: recipes FK_d4097844785f4a027db682aa671; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT "FK_d4097844785f4a027db682aa671" FOREIGN KEY ("categoryId") REFERENCES public.categories(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: nestuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict ykfjrJzzet5v0Ltcuff7vCRKBKf5vbjdLeQIiSf3f3XPbiWe3iiBB3VDvZ3P1g3

