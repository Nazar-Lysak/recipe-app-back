--
-- PostgreSQL database dump
--

\restrict ZGR8fnITYJEoavDEef1LEwIRi1HmkOxOl3n6vvVrx3G2MXfIUrICrbj31bmRPmT

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
-- Name: recipes; Type: TABLE; Schema: public; Owner: nestuser
--

CREATE TABLE public.recipes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    category character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    "time" integer NOT NULL,
    image character varying,
    video character varying,
    rating double precision DEFAULT '0'::double precision NOT NULL,
    "favouriteCount" integer DEFAULT 0 NOT NULL,
    ingredients text[] NOT NULL,
    steps text[] NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "authorId" uuid NOT NULL
);


ALTER TABLE public.recipes OWNER TO nestuser;

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
    rating double precision DEFAULT '0'::double precision NOT NULL,
    is_private boolean DEFAULT false NOT NULL,
    language character varying DEFAULT 'en'::character varying NOT NULL,
    theme character varying DEFAULT 'light'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id uuid,
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL
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
d9b0b1f3-f3f4-490b-aaab-3c42eeaecd20	Сніданки	
857acab9-1dae-4a3f-be1c-ad8de84d20e9	Обіди	
5400ad8c-2702-4693-87d8-b25ef1dede3a	Вечері	
1e5ced6c-45eb-4d09-991e-f1d8fb23e3f3	Перекуси	
d338de3a-c502-42ca-9d99-d9cbb948d4b0	Перші страви	
6e7ef643-f1ac-4ea0-80c1-fffc88b534b4	Основні страви	
d3c601fe-da84-445e-a77d-090a24006909	Закуски	
97006906-2b2a-4903-9a5f-671d90b452d8	Гарніри	
f4f9ea71-a649-4f75-bfab-ba99922edb92	Салати	
861aa6a2-7a4c-4ea0-a876-1c7571e92ab1	Десерти	
431fd6d6-82b0-4c0d-a5cd-b2d76d06e501	Випічка	
ca4496d1-02ba-4851-9b88-7f21ea0b0692	Напої	
4fb74c45-963a-4442-9fe8-2fad1400067d	Святкові страви	
193d83ca-25dd-45a6-8c19-3ec2ea042e3b	Для дітей	
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.recipes (id, name, category, description, "time", image, video, rating, "favouriteCount", ingredients, steps, "createdAt", "updatedAt", "authorId") FROM stdin;
c62f6c86-e840-4e18-aec7-f84241c73fa9	Борщ український класичний	Перші страви	Традиційний український борщ із насиченим смаком буряка, овочів та м’яса.	90			0	0	{"500 г свинини","2 буряки","1 морква","1 цибулина","3 картоплини","200 г білокачанної капусти","2 ст. л. томатної пасти",Часник,Сіль,Перець,"Лавровий лист"}	{"Зваріть бульйон зі свинини.","Натріть буряк і обсмажте з томатною пастою.","Наріжте овочі.","Додайте картоплю та капусту в бульйон.","Додайте бурякову засмажку.","Приправте спеціями та варіть до готовності."}	2025-12-13 14:23:01.529938	2025-12-13 14:23:01.529938	9c609877-b2d1-4b90-a21e-44412565a444
32d20942-9776-4fd6-ac1c-a7eb8442f12e	Омлет із сиром та зеленню	Сніданок	Легкий та поживний омлет із твердим сиром і свіжою зеленню.	15			0	0	{"3 яйця","50 г твердого сиру",Молоко,Кріп,Петрушка,Сіль,"Вершкове масло"}	{"Збийте яйця з молоком і сіллю.","Натріть сир на тертці.","Розігрійте сковорідку з маслом.","Вилийте яєчну суміш.","Додайте сир і зелень.","Готуйте до повної готовності."}	2025-12-13 14:23:25.641756	2025-12-13 14:23:25.641756	9c609877-b2d1-4b90-a21e-44412565a444
60928c7e-fc48-4c29-a883-8425c41887be	Салат з тунцем та квасолею	Салати	Корисний салат із консервованого тунця, квасолі та свіжих овочів.	20			0	0	{"1 банка тунця у власному соку","1 банка білої квасолі","1 помідор","1 огірок","Листя салату","Оливкова олія","Лимонний сік",Сіль}	{"Злийте рідину з тунця та квасолі.","Наріжте овочі.","Змішайте всі інгредієнти.","Заправте оливковою олією та лимонним соком.","Додайте сіль за смаком."}	2025-12-13 14:23:34.836302	2025-12-13 14:23:34.836302	9c609877-b2d1-4b90-a21e-44412565a444
19957c90-a8cf-45f9-a743-405b87348765	Курячі котлети на пару	Основні страви	Дієтичні курячі котлети, приготовані на пару.	40			0	0	{"500 г курячого фаршу","1 яйце","1 цибулина","Вівсяні пластівці",Сіль,Перець}	{"Дрібно наріжте або натріть цибулю.","Змішайте фарш з яйцем та спеціями.","Додайте вівсяні пластівці.","Сформуйте котлети.","Готуйте на пару 25–30 хвилин."}	2025-12-13 14:23:42.246649	2025-12-13 14:23:42.246649	9c609877-b2d1-4b90-a21e-44412565a444
53be579b-efeb-48d1-86f7-5a5862c56c66	Картопляне пюре з вершковим маслом	Гарніри	Ніжне та кремове картопляне пюре — ідеальний гарнір до будь-якої страви.	30			0	0	{"1 кг картоплі","50 г вершкового масла","100 мл молока",Сіль}	{"Очистіть та наріжте картоплю.","Відваріть у підсоленій воді до готовності.","Злийте воду.","Додайте масло та молоко.","Розімніть до однорідної консистенції."}	2025-12-13 16:34:17.991627	2025-12-13 16:34:17.991627	9c609877-b2d1-4b90-a21e-44412565a444
94472a5a-4aad-4a6a-80c0-50faca9d9483	Грецький салат	Салати	Класичний салат з овочів, фети та оливок у середземноморському стилі.	15			0	0	{Помідори,Огірки,"Солодкий перець","Сир фета",Оливки,"Оливкова олія",Орегано,Сіль}	{"Наріжте овочі великими шматками.","Додайте фету та оливки.","Заправте оливковою олією.","Посипте орегано та сіллю."}	2025-12-13 16:34:26.188769	2025-12-13 16:34:26.188769	9c609877-b2d1-4b90-a21e-44412565a444
6be38b02-4d2b-47bb-be96-728e116cc0d8	Вівсяна каша з ягодами	Сніданок	Корисна вівсянка з ягодами для енергійного початку дня.	10			0	0	{"Вівсяні пластівці","Молоко або вода","Свіжі ягоди",Мед}	{"Залийте вівсяні пластівці молоком або водою.","Варіть на слабкому вогні 5–7 хвилин.","Додайте ягоди.","Полийте медом перед подачею."}	2025-12-13 16:34:38.196449	2025-12-13 16:34:38.196449	9c609877-b2d1-4b90-a21e-44412565a444
13d6337d-e3ea-4970-aa6f-a1dec3d30318	Паста з куркою та вершковим соусом	Основна страва	Смачна та швидка у приготуванні паста з ніжною куркою у вершковому соусі.	25			0	0	{"250 г пасти","350 г курячого філе","250 мл вершків","3 зубчики часнику",Сіль,Перець,"Оливкова олія"}	{"Відваріть пасту у підсоленій воді до стану аль денте.","Наріжте куряче філе невеликими шматочками.","Обсмажте курку на оливковій олії до золотистої скоринки.","Додайте подрібнений часник і смажте ще 1 хвилину.","Влийте вершки, посоліть, поперчіть та тушіть 5 хвилин.","Змішайте пасту з соусом і подавайте гарячою."}	2025-12-13 14:23:49.066794	2025-12-13 18:26:21.273	9c609877-b2d1-4b90-a21e-44412565a444
97c2d658-e49c-4db7-ab80-b14241430384	Сирники зі сметаною	Десерти	Домашні сирники з хрумкою скоринкою та ніжною серединкою.	25			0	0	{"500 г кисломолочного сиру","1 яйце","3 ст. л. борошна",Цукор,"Ванільний цукор",Олія}	{"Змішайте сир, яйце та цукор.","Додайте борошно.","Сформуйте сирники.","Обсмажте на сковорідці до золотистої скоринки."}	2025-12-13 16:34:47.275985	2025-12-13 16:34:47.275985	9c609877-b2d1-4b90-a21e-44412565a444
0f4c6ddb-2cdb-40b2-9dd5-b067fd35a19e	Рис з овочами	Основні страви	Легка вегетаріанська страва з рису та свіжих овочів.	35			0	0	{Рис,Морква,"Болгарський перець",Цибуля,Горошок,"Оливкова олія",Сіль}	{"Відваріть рис до готовності.","Обсмажте овочі на оливковій олії.","Додайте рис до овочів.","Перемішайте та прогрійте кілька хвилин."}	2025-12-13 16:34:54.472702	2025-12-13 16:34:54.472702	9c609877-b2d1-4b90-a21e-44412565a444
f1f9d117-4715-455e-9fb7-1112016fc331	Курячий суп з локшиною	Перші страви	Легкий та поживний курячий суп для всієї родини.	60			0	0	{"Куряче філе",Вода,Локшина,Морква,Цибуля,Сіль,Перець}	{"Зваріть бульйон з курки.","Додайте нарізані овочі.","Всипте локшину.","Варіть до готовності."}	2025-12-13 16:35:01.748359	2025-12-13 16:35:01.748359	9c609877-b2d1-4b90-a21e-44412565a444
9bc5ecea-e960-438d-9ed8-4f3cd635b6c7	Запечені овочі в духовці	Гарніри	Ароматні овочі, запечені з оливковою олією та спеціями.	45			0	0	{Кабачок,Баклажан,Перець,Помідори,"Оливкова олія",Сіль,Трави}	{"Наріжте овочі.","Викладіть на деко.","Полийте оливковою олією та посоліть.","Запікайте 40 хвилин при 180°C."}	2025-12-13 16:35:08.376018	2025-12-13 16:35:08.376018	9c609877-b2d1-4b90-a21e-44412565a444
1005bff1-27a8-4854-a14a-efd6c78ae110	Панкейки з кленовим сиропом	Сніданок	Пухкі панкейки для солодкого ранку.	20			0	0	{Борошно,Молоко,Яйце,Цукор,Розпушувач,"Кленовий сироп"}	{"Змішайте сухі інгредієнти.","Додайте молоко та яйце.","Випікайте панкейки на сковорідці.","Полийте сиропом перед подачею."}	2025-12-13 16:35:14.601187	2025-12-13 16:35:14.601187	9c609877-b2d1-4b90-a21e-44412565a444
b21f40c0-1edc-41cc-9e6c-fc2bd27bdf44	Суп-пюре з гарбуза	Перші страви	Ніжний крем-суп із солодкуватим смаком гарбуза.	40			0	0	{Гарбуз,Картопля,Цибуля,Вершки,Сіль,Перець}	{"Наріжте овочі.","Відваріть до м’якості.","Збийте блендером.","Додайте вершки та спеції."}	2025-12-13 16:35:20.998278	2025-12-13 16:35:20.998278	9c609877-b2d1-4b90-a21e-44412565a444
26a90758-3507-4e1d-bb23-e173ed238bbb	Домашній лимонад	Напої	Освіжаючий напій з натурального лимонного соку.	10			0	0	{Лимони,Вода,Цукор,М’ята}	{"Вичавіть сік з лимонів.","Змішайте з водою та цукром.","Додайте листя м’яти.","Охолодіть перед подачею."}	2025-12-13 16:35:27.410928	2025-12-13 16:35:27.410928	9c609877-b2d1-4b90-a21e-44412565a444
e8f7490c-33dd-44e8-870d-4668853c65de	Полуничний смузі	Напої	Освіжаючий та корисний смузі зі свіжої полуниці та йогурту.	5			0	0	{Полуниця,"Натуральний йогурт",Мед,Лід}	{"Помийте та очистіть полуницю.","Помістіть усі інгредієнти в блендер.","Збийте до однорідної консистенції.","Подавайте охолодженим."}	2025-12-13 17:39:10.999251	2025-12-13 17:39:10.999251	b5d166c0-8d8b-44ed-8d07-f7759a7f426b
04b03110-0f9f-451e-842d-367a523d6679	Холодний чай з лимоном	Напої	Домашній холодний чай з лимоном — ідеальний напій у спекотний день.	15			0	0	{"Чорний чай",Вода,Лимон,"Цукор або мед",Лід}	{"Заваріть чорний чай.","Дайте йому охолонути.","Додайте сік лимона та підсолоджувач.","Подавайте з льодом."}	2025-12-13 17:39:19.537373	2025-12-13 17:39:19.537373	b5d166c0-8d8b-44ed-8d07-f7759a7f426b
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: nestuser
--

COPY public.user_profiles (first_name, last_name, bio, avatar_url, banner_url, location, website, instagram, tiktok, facebook, youtube, followers_count, following_count, recipes_count, likes_received, rating, is_private, language, theme, created_at, updated_at, user_id, id) FROM stdin;
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-09 21:07:41.440492	2025-12-09 21:07:41.440492	b5d166c0-8d8b-44ed-8d07-f7759a7f426b	e8081c44-d6b8-441e-907d-2cfb1f0ef73d
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-09 21:07:51.864922	2025-12-09 21:07:51.864922	583b4d78-a2ba-4792-bef7-7f6caf42e913	adafc4ce-cf06-497c-92c6-213eaccb49f0
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-09 21:08:00.909056	2025-12-09 21:08:00.909056	6d5c01a0-c599-4c73-aada-ccfa8dd6155b	206bf333-b6dc-4cb8-a531-8ba42a91e9c7
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-09 21:08:09.216338	2025-12-09 21:08:09.216338	385a93e2-b6f4-4eea-9aaa-e2fb5162c1ae	69163239-4cbd-4e1f-a755-816b49bba643
Maria	Koval	Food lover & home chef. Sharing my favorite recipes.	https://example.com/avatars/maria.jpg	https://example.com/banners/maria.jpg	Lviv, Ukraine	https://maria-koval.com	https://www.instagram.com/maria.cooks/	https://www.tiktok.com/@maria_kitchen	https://www.facebook.com/maria.koval	https://www.youtube.com/@MariaCooks	0	0	0	0	0	t	en	dark	2025-12-09 21:07:26.414738	2025-12-09 21:07:26.414738	9c609877-b2d1-4b90-a21e-44412565a444	f06293a8-4159-40d5-a103-cfd146f07d95
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	dark	2025-12-09 22:01:08.895802	2025-12-09 22:01:08.895802	a172f6b8-46f6-47a5-999f-c0181db58bca	ecc13c45-c1e7-490a-8155-647052c2dd8a
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-12 13:10:29.497024	2025-12-12 13:10:29.497024	6ba456f1-97c1-4a61-ac79-e4afdbad3b19	9b8bacf9-423d-4739-8a07-61bdcd9ce652
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-12 13:20:06.116672	2025-12-12 13:20:06.116672	6fdb3cf5-bbe1-40f4-b98b-65dc7f6375f5	fef0a02e-d7b4-45ac-91f9-9c2102422685
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	0	0	0	0	f	en	light	2025-12-12 13:36:10.446354	2025-12-12 13:36:10.446354	da40a9cd-f2cb-44ea-a257-3f9d1b6453f9	5d839e0f-8776-481b-8367-ffa141bb811e
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
\.


--
-- Name: user_profiles PK_1ec6662219f4605723f1e41b6cb; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "PK_1ec6662219f4605723f1e41b6cb" PRIMARY KEY (id);


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
-- Name: users UQ_fe0bb3f6520ee0469504521e710; Type: CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_fe0bb3f6520ee0469504521e710" UNIQUE (username);


--
-- Name: user_profiles FK_6ca9503d77ae39b4b5a6cc3ba88; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "FK_6ca9503d77ae39b4b5a6cc3ba88" FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: recipes FK_afd4f74f8df44df574253a7f37b; Type: FK CONSTRAINT; Schema: public; Owner: nestuser
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT "FK_afd4f74f8df44df574253a7f37b" FOREIGN KEY ("authorId") REFERENCES public.users(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: nestuser
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict ZGR8fnITYJEoavDEef1LEwIRi1HmkOxOl3n6vvVrx3G2MXfIUrICrbj31bmRPmT

