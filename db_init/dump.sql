--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-09-15 23:28:23 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 902 (class 1247 OID 16525)
-- Name: binding; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.binding AS ENUM (
    'HARD',
    'SOFT'
);


ALTER TYPE public.binding OWNER TO postgres;

--
-- TOC entry 932 (class 1247 OID 16824)
-- Name: deliverytype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.deliverytype AS ENUM (
    'COURIER',
    'PICKUP'
);


ALTER TYPE public.deliverytype OWNER TO postgres;

--
-- TOC entry 920 (class 1247 OID 16645)
-- Name: paymethod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.paymethod AS ENUM (
    'SBP',
    'CARD',
    'RECEIPT'
);


ALTER TYPE public.paymethod OWNER TO postgres;

--
-- TOC entry 905 (class 1247 OID 16531)
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'PROCESSING',
    'WORK',
    'DONE'
);


ALTER TYPE public.status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 241 (class 1259 OID 16652)
-- Name: additions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.additions (
    id integer NOT NULL,
    office character varying(10),
    entrance character varying(10),
    intercom character varying(10),
    floor character varying(10),
    phone character varying(15),
    first_name character varying(80),
    last_name character varying(80),
    address_id integer
);


ALTER TABLE public.additions OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16651)
-- Name: additions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.additions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.additions_id_seq OWNER TO postgres;

--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 240
-- Name: additions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.additions_id_seq OWNED BY public.additions.id;


--
-- TOC entry 233 (class 1259 OID 16538)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    city character varying(250),
    street character varying(250),
    house character varying(10),
    country character varying(80)
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16537)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_id_seq OWNER TO postgres;

--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 232
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- TOC entry 217 (class 1259 OID 16421)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16454)
-- Name: authors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authors (
    id integer NOT NULL,
    name character varying(150)
);


ALTER TABLE public.authors OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16453)
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authors_id_seq OWNER TO postgres;

--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 220
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- TOC entry 231 (class 1259 OID 16506)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id integer NOT NULL,
    author_id integer,
    genre_id integer,
    title character varying(300),
    price double precision,
    book_cover character varying(200),
    description character varying,
    publishing character varying,
    year integer,
    binding character varying(50)
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16505)
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 230
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- TOC entry 237 (class 1259 OID 16564)
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    id integer NOT NULL,
    book_id integer,
    count integer,
    cart_id integer,
    selected boolean
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16563)
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO postgres;

--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 236
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- TOC entry 249 (class 1259 OID 16852)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    session_id character varying,
    user_id integer
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16851)
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carts_id_seq OWNER TO postgres;

--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 248
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- TOC entry 247 (class 1259 OID 16830)
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    id integer NOT NULL,
    order_id integer,
    delivery_type public.deliverytype,
    address_id integer,
    price double precision
);


ALTER TABLE public.deliveries OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16829)
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliveries_id_seq OWNER TO postgres;

--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 246
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveries_id_seq OWNED BY public.deliveries.id;


--
-- TOC entry 227 (class 1259 OID 16477)
-- Name: genres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.genres (
    id integer NOT NULL,
    name character varying(250),
    section_id integer
);


ALTER TABLE public.genres OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16476)
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.genres_id_seq OWNER TO postgres;

--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 226
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- TOC entry 239 (class 1259 OID 16581)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    book_id integer,
    count integer,
    order_id integer
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16580)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 238
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 235 (class 1259 OID 16552)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    date date,
    status public.status,
    pay_method public.paymethod,
    amount double precision
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16551)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 234
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- TOC entry 223 (class 1259 OID 16461)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    text character varying,
    book_id integer,
    rate integer
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16460)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 222
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 225 (class 1259 OID 16470)
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    name character varying(250)
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16469)
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sections_id_seq OWNER TO postgres;

--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 224
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- TOC entry 243 (class 1259 OID 16795)
-- Name: shops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shops (
    id integer NOT NULL,
    work_time character varying(30),
    lat double precision,
    lon double precision,
    address_id integer
);


ALTER TABLE public.shops OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16794)
-- Name: shops_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shops_id_seq OWNER TO postgres;

--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 242
-- Name: shops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shops_id_seq OWNED BY public.shops.id;


--
-- TOC entry 245 (class 1259 OID 16807)
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_addresses (
    id integer NOT NULL,
    address_id integer,
    user_id integer
);


ALTER TABLE public.user_addresses OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16806)
-- Name: user_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_addresses_id_seq OWNER TO postgres;

--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 244
-- Name: user_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_addresses_id_seq OWNED BY public.user_addresses.id;


--
-- TOC entry 229 (class 1259 OID 16489)
-- Name: user_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_review (
    id integer NOT NULL,
    user_id integer,
    review_id integer
);


ALTER TABLE public.user_review OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16488)
-- Name: user_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_review_id_seq OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_review_id_seq OWNED BY public.user_review.id;


--
-- TOC entry 219 (class 1259 OID 16443)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    first_name character varying(80),
    last_name character varying(80),
    email character varying(120),
    phone character varying NOT NULL,
    password_hash character varying(256),
    is_verified boolean
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16442)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 218
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3552 (class 2604 OID 16655)
-- Name: additions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additions ALTER COLUMN id SET DEFAULT nextval('public.additions_id_seq'::regclass);


--
-- TOC entry 3548 (class 2604 OID 16541)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- TOC entry 3542 (class 2604 OID 16457)
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- TOC entry 3547 (class 2604 OID 16509)
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- TOC entry 3550 (class 2604 OID 16567)
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- TOC entry 3556 (class 2604 OID 16855)
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- TOC entry 3555 (class 2604 OID 16833)
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN id SET DEFAULT nextval('public.deliveries_id_seq'::regclass);


--
-- TOC entry 3545 (class 2604 OID 16480)
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- TOC entry 3551 (class 2604 OID 16584)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 3549 (class 2604 OID 16555)
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- TOC entry 3543 (class 2604 OID 16464)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 3544 (class 2604 OID 16473)
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- TOC entry 3553 (class 2604 OID 16798)
-- Name: shops id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops ALTER COLUMN id SET DEFAULT nextval('public.shops_id_seq'::regclass);


--
-- TOC entry 3554 (class 2604 OID 16810)
-- Name: user_addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_addresses_id_seq'::regclass);


--
-- TOC entry 3546 (class 2604 OID 16492)
-- Name: user_review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_review ALTER COLUMN id SET DEFAULT nextval('public.user_review_id_seq'::regclass);


--
-- TOC entry 3541 (class 2604 OID 16446)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3782 (class 0 OID 16652)
-- Dependencies: 241
-- Data for Name: additions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.additions (id, office, entrance, intercom, floor, phone, first_name, last_name, address_id) FROM stdin;
9	1	1	1	1	+79216536763	Лиза	Балыкова	8
10	1	1	1	1	+79213564433	Иван	Иванов	10
11	1	1	1	1	+79093242323	Иван	Иванов	10
\.


--
-- TOC entry 3774 (class 0 OID 16538)
-- Dependencies: 233
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (id, city, street, house, country) FROM stdin;
2	Санкт-Петербург	Литейный пр-т	д 35	Россия
3	Москва	Цветной б-р	д 2	Россия
4	Москва	ул. Тверская	д 12	Россия
6	Казань	ул. Кремлевская	д 21	Россия
8	г Санкт-Петербург	ул Учительская	д 9	Россия
10	г Санкт-Петербург	ул Учительская	д 9	Россия
11	Санкт-Петербург	Невский пр-т	д 50	Россия
12	г Санкт-Петербург	ул Учительская	д 9 к 1	Россия
\.


--
-- TOC entry 3758 (class 0 OID 16421)
-- Dependencies: 217
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
e89066181f68
\.


--
-- TOC entry 3762 (class 0 OID 16454)
-- Dependencies: 221
-- Data for Name: authors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authors (id, name) FROM stdin;
1	Богомолов Владимир Осипович
2	Цвейг Стефани, Цвейг Стефан
3	Достоевский Федор Михайлович
4	Некрасов Андрей Сергеевич
5	
6	Булгаков Михаил Афанасьевич
7	Гончаров Иван Александрович
8	Пушкин Александр Сергеевич
9	Гоголь Николай Васильевич
10	Толкин Джон Рональд Руэл
11	Кристи Агата
12	Джейн Остин
13	Стивен Хокинг
14	Айн Рэнд
15	Роберт Мартин
16	Волков Александр Мелентьевич
17	Кови Стивен Р.
18	Исаяма Хадзимэ
19	Быков Василь Владимирович
20	Оливер Джейми
21	Цветкова Татьяна КонстантиновнаЦветкова Татьяна Константиновна
22	Малкова Анна Георгиевна
23	Хворостенко Александр
24	Цеплаков Георгий
25	Любенко Иван Иванович
26	Ангер Лиза
27	Данмор Хелен
28	Клайн Эмма
29	Иоанна Хмелевская
30	Кристина Сандберг
31	Леена Лехтолайнен
32	Уиллоу Роуз
33	Теодор Драйзер
34	Роберт Ирвин Говард
35	Уилки Коллинз
36	Уилки Коллинз
37	Жюль Верн
38	Шумахер Генрих Фольрат
39	Аксенов Василий Павлович
40	Токарева Виктория Самойловна
41	Артемьева Галина Марковна
42	Грачёва Татьяна Александровна
43	Малиновская Маша
44	Сапаров Ариф Васильевич
45	Карамзин Николай Михайлович
46	Толстой Лев Николаевич
47	Оруэлл Джордж
48	Блэйлок Джеймс
49	Топфер Сарториус
50	Лысов Игорь Владимирович
51	Буданцева Дарья
52	Замятин Евгений Иванович
53	Колотилина Октавия
54	Саида С. С.
55	Фрик Кит
56	Вульф Лесли
57	Шекли Роберт
58	Спейн Джо
59	Де Винтер Леон
60	Дойл Артур Конан
61	Метлицкая Мария
62	Хоуп Ава
63	Дуглас Пенелопа
64	Гамильтон Сергей
65	Твин Клэр
66	Марч Меган
67	Короткевич Владимир Семенович
68	Алексиевич Светлана Александровна
69	Капельян Семен Наумович,
70	Холоднова Елена Владимировна
71	Оганесян Эдуард Тоникович
72	Половкова Марина Вадимовна,
73	Баринова Оксана Алексеевна
74	Соловьев Николай Алексеевич
75	Перри Мэттью
76	Форд Генри
77	Аппероль Лукас
78	Карнеги Эндрю
79	Каптарь Дионис Леонидович
80	Рассадин Станислав Борисович
81	Верхуф Берри
82	Андерсон Роберт Тьюсли
83	Шульга Наталья
84	Ивенская Ольга Семеновна
85	Клемент Джеймс
86	Экселл Бекки
87	Арсеньев Борис Вячеславович
88	Simmons Naomi
89	Nixon Caroline
90	Holcombe Garan
91	Skinner Carol
92	Holcombe Garan
93	Макрей Ян
94	Вивар Педро
95	Хонен Беттина
96	Додонов Николай
97	Хилтон Билл
98	Котова Анна Игоревна
99	Гонсалес Рафаэл С.
100	Пантелеев Евгений Рафаилович
101	Маргулец Влад
102	Кайл Дэвид
103	Исаковиц Раэль
104	Хартл Майкл
105	Найденская Наталия Георгиевна
106	Хорошилова Ольга Андреевна
107	Гоббетти Клаудио
108	Толмачева Мария Львовна
109	Железников Владимир Карпович
110	Уайброу Иан
111	Ройал Брэндон
112	Фридман-Даймонд Паула
113	Маркова Надежда Дмитриевна
114	Леонович Николай Алексеевич
115	Райан Джефф
116	Несютина Ксения
117	Льюис Кэтрин Рейнольдс
118	Перри Филиппа
119	Зотов Владимир Борисович
120	Трейси Брайан
121	Хилл Наполеон
122	Руденко Андрей Михайлович
123	Ливермор Дэвид
124	Кириёк Евгений
125	Маттар Ясир
126	Владимирский Александр Владимирович
127	Фредрикссон Мари
128	Маккей Харви
129	Юрьева Татьяна Сергеевна
130	Егоров Александр Сергеевич
131	Врублевский Александр Иванович
132	Степанова Людмила Сергеевна
133	Теремкова Наталья Эрнестовна
134	Белякова Валентина Ивановна
135	Канакина Валентина Павловна
136	Маркин Сергей Александрович
137	Шекспир Уильям, Вордсворт Уильям, Китс Джон
138	Шекспир Уильям, Уайетт Томас, Марло Кристофер, Говард Генри
139	Denisot Hugues
140	Gregoire Fabian
141	Specht Franz, Evans Sandra, Pude Angela
142	Перумов Ник Даниилович, Старостин Григорий
143	Кадилов Арсений, Елецкий Дмитрий
144	Хино Хидеши
\.


--
-- TOC entry 3772 (class 0 OID 16506)
-- Dependencies: 231
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.books (id, author_id, genre_id, title, price, book_cover, description, publishing, year, binding) FROM stdin;
1	1	4	Момент истины. В августе сорок четвертого…	1642	covers/book_1.webp	Остросюжетный, почти детективный роман Владимира Богомолова посвящен одной из самых закрытых военных тем - работе Управления контрразведки СМЕРШ. В 1944 году на 3-м Белорусском фронте группа разведчиков мастерски выслеживает и обезвреживает фашистских шпионов. Но суть романа гораздо шире сюжета. Константин Симонов писал: "Это роман не о военной контрразведке. Это роман о советской государственной и военной машине сорок четвертого года и типичных людях того времени".\nТонкие штрихи иллюстраций Андрея Николаева схватывают и горячие моменты боя, и напряженную аналитическую работу разведчиков.	Речь	2018	Твердая, обтянутая тканью
2	2	2	Письмо незнакомки	701	covers/book_2.webp	Новеллы австрийского писателя Стефана Цвейга (1881-1942) - это тончайшее психологическое исследование внутреннего состояния героев, их душевных порывов. Каждое произведение вызывает глубокие чувства и понимание, насколько беззащитно человеческое сердце, как превратны людские судьбы, на какие свершения, а порой преступления, может толкнуть страсть...Прекрасен и неподражаем язык Цвейга: элегантный, изысканный, преисполненный достоинства. Изысканные черно-белые иллюстрации подчеркивают дух новелл Цвейга.	Аркадия	2020	Твердая
3	3	4	Преступление и наказание	443	covers/book_3.webp	История бедного студента-убийцы из Санкт-Петербурга, ставшая одним из самых ярких символом русской культуры во всем мире. Родион Раскольников, обедневший студент, измученный внутренней борьбой добра со злом, считает себя выше закона и совершает страшное преступление, оправдываясь своей философией: "Убить такую вредную старуху - воспротивиться злу и восстановить справедливость!". Однако все идет не по плану и, охваченный чувством вины и ужаса, Раскольников начинает проваливаться в пучину безумия. Достоевский мастерски вплетает сложные нравственно-мировоззренческие вопросы в мрачную тягучую атмосферу холодного Петербурга.	Яуза	2025	Твердая
25	23	24	Менеджмент	900	covers/book_25.jpg	Данное издание предлагает читателю краткое и структурированное изложение основного материала по менеджменту. Благодаря чётким определениям основных понятий, читатель сможет за короткий срок усвоить и переработать важную часть научной информации.	Научная книга	2017	Твердая
4	4	17	Приключения капитана Врунгеля	1023	covers/book_4.webp	Морское дело писатель Андрей Некрасов знал не понаслышке: совсем юным он поступил матросом на рыболовецкое судно в Мурманске, а позже попал на Тихоокеанское побережье и исходил его от Чукотки до Посьета. Он был кочегаром, зверобоем, штурманом и даже занимался организацией китобойной промышленности. В те же годы он начал писать и публиковаться в детских журналах и газетах, причём многие сюжеты своих рассказов брал из жизни. Капитан Врунгель тоже имел реального прототипа - это капитан Андрей Вронский, который возглавлял первый китобойный трест на Дальнем Востоке, а на досуге любил рассказывать захватывающие небылицы из морской жизни.	Качели	2022	Твердая
5	6	4	Белая гвардия	1309	covers/book_5.webp	"Белая гвардия" - первый роман Михаила Афанасьевича Булгакова (1891-1940). В центре повествования - семья Турбиных и их друзья. Через восприятие этих героев читатель погружается в атмосферу тектонических сдвигов, ужасов событий 1918-1919 годов. Но это не столько историческое описание, сколько художественный образ, сотканный из раздумий писа­теля о конце времен.\nИллюстрации к роману созданы выдающимся художником Андреем Владимировичем Николаевым, автором многочисленных графических циклов к "Войне и миру" Л. Н. Толстого.	Галерея классики	2022	Твердая
6	7	4	Обломов	1853	covers/book_6.webp	Роман Ивана Александровича Гончарова (1812-1891) "Обломов" с момента своей публикации вошел в число лучших образцов прозы. Это размышление о русском характере со всеми его достоинствами и недостатками, об устроенности и неустроенности человека в обществе, о выборе пути и результатах такого предпочтения. При этом автор не стремится к разоблачению, порицанию, наставлению. Философский смысл романа, лирическая интонация повествования позволила мастеру книжной иллюстрации Герману Алексеевичу Мазурину написать свой цикл рисунков. Их отличает необыкновенная точность деталей, внимание к психологическому жесту и почти волшебная легкость композиции.	Галерея классики	2022	Твердая
7	8	4	Повести покойного Ивана Петровича Белкина	630	covers/book_7.webp	Знаменитые "Повести Белкина" (1830) появились на свет в Болдинскую осень Александра Пушкина, самый продуктивный период его творческой биографии.\nСоздавая свои произведения, великий русский писатель не любил придерживаться каких-либо строгих рамок. Им двигала жажда эксперимента, желание совмещать различные направления. В пяти "Повестях Белкина" их четыре: реализм ("Выстрел"), сентиментализм ("Метель", "Станционный смотритель"), водевиль ("Барышня-крестьянка"), готика ("Гробовщик").\nВ каждой повести судьба ставит героев в необычайные, чаще всего трагические положения или, наоборот, приводит их к неожиданной и "счастливой" развязке.	Аркадия	2019	Твердая
8	1	9	Вечера на хуторе близ Диканьки	227	covers/book_8.webp	"Вечера на хуторе близ Диканьки" - одно из лучших произведений Николая Гоголя, которое одинаково сильно любят и взрослые, и дети.\nСборник мистических повестей почти две сотни лет погружает читателей в мир, где реальность переплетается с фантастикой, а народные легенды и предания оживают на страницах книги.\nДля среднего школьного возраста.	Проспект	2025	Мягкая
9	5	28	Физика в формулах и схемах	101	covers/book_9.webp	Серия "В формулах и схемах" включает дидактические материалы, тестовые задания и шпаргалки для школьников и абитуриентов. Предлагаемое пособие - краткий справочник по основным разделам курса физики, изучаемым в средней школе. В наглядной и доступной форме изложены основные законы физики. Текст сопровождается необходимыми иллюстрациями.\nПособие может быть рекомендовано школьникам, в том числе для подготовки к ОГЭ и ЕГЭ и абитуриентам.\n4-е издание, исправленное и дополненное.	Виктория Плюс	2019	Мягкая
26	24	25	Дикий маркетинг? Ручной маркетинг! Как заставить слушаться инструменты продвижения. Монография	690	covers/book_26.jpg	Введение в философию: основные школы, идеи и мыслители в удобном формате ежедневного чтения.	Good Business	2012	Твердая
10	6	4	Собачье сердце	374	covers/book_10.webp	Повесть "Собачье сердце" написана М. А. Булгаковым в январе-марте 1925 года, в СССР впервые опубликована в журнале "Знамя" в 1987 году, но до публикации широко ходила в самиздате. История введения "Собачьего сердца" в "официальный оборот" подробно описана в статье М. О. Чудаковой, завершающей эту книгу. Огромная популярность пришла к булгаковским героям после чрезвычайно удачной экранизации книги в 1989 году. Шарик-Шариков, профессор Преображенский, доктор Борменталь, председатель домкома Швондер стали нарицательными персонажами. А история о бездомной собаке, принявшей после хирургической операции человеческий облик, но затем под влиянием идей о классовой вражде пролетариата и буржуазии вновь утратившей его, обрела почти фольклорную известность. Сегодня обращенное к человеку определение "Шариков" - синоним глупости, жадности и неблагодарности. Пес Шарик, между прочим, таким не был - это чисто людские свойства.	Время	2017	Мягкая
11	10	5	Властелин колец	2150	covers/book_11.webp	Эпическая трилогия Дж. Р. Р. Толкина, положившая начало современному фэнтези. Война Кольца и судьба Средиземья в завораживающей истории дружбы, мужества и борьбы добра со злом.	АСТ	2023	Твердая
12	11	6	Убийство в Восточном экспрессе	890	covers/book_12.webp	Классический детектив Агаты Кристи с участием знаменитого сыщика Эркюля Пуаро. Загадочное убийство в поезде, закрытое пространство и множество подозреваемых.	Эксмо	2022	Твердая
13	12	7	Гордость и предубеждение	357	covers/book_13.webp	Роман Джейн Остин, в котором остроумие, любовь и социальные предрассудки переплетаются в истории семьи Беннет и мистера Дарси.	Азбука	2021	Твердая
14	13	10	Краткая история времени	950	covers/book_14.webp	Книга Стивена Хокинга, которая открывает перед читателем тайны космоса, черных дыр и происхождения Вселенной простым и увлекательным языком.	АСТ	2020	Мягкая
15	14	14	Атлант расправил плечи	1680	covers/book_15.webp	Философский роман Айн Рэнд о роли личности, разуме и созидательной энергии в обществе. Книга, ставшая манифестом рационализма и индивидуализма.	Альпина	2019	Твердая
16	15	15	Чистый код	2100	covers/book_16.webp	Классическая книга Роберта Мартина для программистов, стремящихся писать чистый, поддерживаемый и эффективный код.	Питер	2021	Мягкая
17	16	17	Волшебник Изумрудного города	971	covers/book_17.webp	Классическая детская книга Александра Волкова о приключениях Элли и её друзей в волшебной стране.	Качели	2021	Твердая
18	17	23	7 навыков высокоэффективных людей	1096	covers/book_18.webp	Знаковая книга Стивена Кови о том, как развивать личную и профессиональную эффективность через системный подход.	Попурри	2018	Мягкая
19	18	33	Атака титанов. Том 1	890	covers/book_19.webp	Первая часть культовой манги Хадзимэ Исаямы о борьбе человечества за выживание в мире, где царят титаны.	Азбука	2023	Мягкая
20	19	8	Знак беды	640	covers/book_20.webp	Роман белорусского писателя Василя Быкова о трагических страницах Великой Отечественной войны и судьбах простых людей.	Т8	2018	Твердая
21	20	18	Секреты итальянской кухни	950	covers/book_21.webp	Если что-то в Италии и остается неизменным, так это повсеместная страсть к еде. Она в сердце каждого итальянца, о ней известно всем. Что интересно, независимо от уровня доходов у большинства итальянцев на столе хорошая еда: вкусная, яркая, простая. Итальянцы помешаны на сезонных продуктах, бережливы, стараются не усложнять себе жизнь, в том числе на кухне, и подходят к готовке с большой любовью. Если вы возьмете с них пример, то сможете приготовить потрясающие блюда, которые соберут за одним столом друзей и родных.	Кукбукс,	2018	Твердая
22	5	19	Футбол. Полная энциклопедия	3180	covers/book_22.webp	Энциклопедия о футболе: история чемпионатов, биографии легендарных игроков, тактика и рекорды.	РОСМЭН	2019	Твердая
23	21	21	Грамматика английского языка	245	covers/book_23.jpg	Подробный разбор грамматики английского языка с примерами и упражнениями для всех уровней.	Проспект	2024	Мягкая
24	22	28	Математика. Полный курс подготовки к ЕГЭ	530	covers/book_24.jpg	Учебник для подготовки к ЕГЭ по математике: теория, задания и разбор типовых ошибок.	Феникс	2019	Мягкая
27	30	1	Одинокое место	690	covers/book_27.webp	"Одинокое место" - автобиографический роман шведской писательницы Кристины Сандберг. Действие происходит в 2016 году.\nПосле получения Августовской премии за роман "Жизнь любой ценой" к автору приходит слава, ее приглашают на многочисленные лекции и встречи с читателями. Она понимает, что это очень важный период в жизни, открывающий новые возможности. Вместе с тем героиня чувствует, что силы ее на исходе, беспокойство вызывает и странная боль в груди. Кристина долго откладывает визит к врачу, но в конце концов ей сообщают страшный диагноз - агрессивная форма рака груди. Вся привычная жизнь рушится.\nВ этой книге - и больничный дневник, и воспоминания о детстве в 1970-х годах, и мучительные размышления о хрупкости человеческого тела, о настоящем и будущем, и страх за своих близких. Но прежде всего это книга о том, что страшная болезнь делает человека бесконечно одиноким.	Городец	2023	Твердая
28	25	3	Кровь на палубе	530	covers/book_28.webp	Август 1910 года. В газете «Ставропольские губернские ведомости» опубликована криптограмма. За разгадку обещано 25 рублей. Вскоре выясняется, что человек, сделавший это объявление, убит. Тем временем на остров Мадагаскар отправляется экспедиция для поиска целакантуса – рыбы ровесницы динозавров. Супруги Ардашевы оказываются на том же самом пароходе и путешествуют по Средиземноморью по местам, где в XVIII веке ещё рыскали пиратские шхуны.	Яуза	2025	Твердая
29	26	1	Экспресс на 19:45	590	covers/book_27.webp	Международный бестселлер.\nБудущий хит Netflix с Джессикой Альбой\n\nВерите ли вы в совпадения?..\n\nВсего одна случайная встреча в поезде. Селена Мерфи подсаживается к незнакомке и вскоре понимает, что делится с этой неизвестной женщиной своими самыми темными секретами.… Например, что ее муж спит с их няней, и что она мечтает, чтобы та исчезла раз и навсегда.\n\nПоезд прибывает, и девушки расходятся, чтобы никогда больше не встретиться. Но неужели Селена только что открыла ящик Пандоры? Сначала таинственно исчезает няня. А потом.… Потом на смартфон приходит это: "Кстати, это Марта. Из поезда"\n\nРазве она давала той женщине свой номер? Нет. Но странные сообщения продолжают поступать... И вот уже жизнь Селены летит кувырком. Всего за несколько дней череда невероятных событий обращает в прах привычный ей мир и все, что она знала…	Inspiria	2022	Твердая
30	27	1	И тогда я солгал	494	covers/book_30.webp	Закончилась Первая мировая война, и рядовой Дэниел Бранвелл вернулся в родной Корнуолл. Парню повезло - он остался в живых, в то время как его лучший друг Фредерик встретил свою смерть на изрытом снарядами поле.\nНо Бранвел не чувствует себя счастливым. Пока он воевал, мать умерла, а их дом забрали за долги. До бывшего солдата никому нет дела, кроме больной старухи Мэри Паско, которая делится с ним едой и кровом. И каждую ночь призрак погибшего друга встает в ногах его постели, лишая покоя и усугубляя чувство вины.\nА когда старушка Мэри тоже умирает, Дэниел остается один на один с враждебным ему миром, где легче солгать, чем открыться людям, не испытавшим ужасы войны.\n"Тихая" трагедия знаменитой английской писательницы Хелен Данмор - это сага человеческой души, история, шокирующая своей беспощадной и искренней правдой.	Аркадия	2019	Твердая
31	28	1	Гостья	866	covers/book_31.webp	Жизнь Алекс катится под откос, когда она встречает Саймона - немолодого богатого мужчину, который думает, что она только что окончила университет, а не девушка по вызову. И теперь Алекс живет в его летнем доме, мечтая о будущем, в котором она будет чувствовать безопасность - как и все в этом избранном обществе. Но она не одна из них, и достаточно совершить лишь один неверный шаг - и мечта Алекс обращается в прах. В течение недели Алекс перемещается из одного дома в другой - повсюду гостья, повсюду чужая - с единственной эфемерной целью: уцепиться за эту безоблачную жизнь, задержаться в ней, превратиться из гостьи в хозяйку, хозяйку собственной судьбы. Алекс призраком дрейфует по пляжам Лонг-Айленда, проулкам между виллами, подъездным дорожкам, ведущим к роскошным особнякам, по раскаленным летним дюнам, и за ней тянется шлейф отчаяния и разрушения. Напряженный, динамичный, гипнотический роман об одиночестве и мечтах. Эмма Клайн, автор знаменитых "Девочек", сотворила камерный шедевр о же...	Фантом Пресс	2025	Твердая
32	29	1	Что сказал покойник	738	covers/book_32.webp	Иоанна, по специальности архитектор, решила подзаработать по контракту в Дании, где живет после замужества ее лучшая подруга Алиция. Однако близкие знают - дерзкая пани словно напрашивается на сомнительные приключения. Вот и в этот раз азартная Иоанна, решив пощекотать нервы рулеткой после успеха на бегах, становится свидетельницей перестрелки в нелегальном копенгагенском казино, и смертельно раненный человек доверяет ей таинственный шифр… Сообщники покойного готовы на все, лишь бы услышать заветные слова, и похищают девушку. Опасность ей грозит нешуточная, но пани - крепкий орешек и так просто сдаваться не намерена.	Аркадия	2025	Твердая
33	29	1	Красное	738	covers/book_33.webp	В доме Алиции Хансен, подруги неуемной пани Иоанны, которая давно проживает в Дании, неожиданно собралась большая компания. Близкие друзья и хорошие знакомые хозяйки съехались со всей Европы и попали на вечеринку случайно... из-за нового садового светильника. Празднество выдалось шумным и веселым, но когда пришла пора расходиться, один из гостей оказался... мертв. Его убили ударом кинжала в спину. Но кто это сделал, ведь в доме были исключительно свои? Разрешить эту загадку под силу только пани Иоанне...	Аркадия	2025	Твердая
34	31	1	Отступники	601	covers/book_34.webp	Живущая в глуши смотрительница заповедника Айно обнаруживает на берегу озера едва живого мужчину. Лингвист Томас только что прилетел в Финляндию, его похитили прямо из аэропорта, накачали парализующим веществом, раздели и бросили в воду.\nАйно выхаживает Томаса, и вместе они начинают выяснять, кто и почему пытался его убить. Становится понятно, что Томаса преследуют байкеры, которые мстят ему за то, чего он не совершал.\n\nЛеена Лехтолайнен (р. 1964) - одна из самых популярных финских писательниц детективного жанра, ее книги переведены на десятки языков и завоевали признание читателей по всему миру. В Финляндии криминальные романы Лехтолайнен стали бестселлерами, были удостоены литературных премий и экранизированы.	Городец	2022	Твердая
35	32	1	Вспомни, что ты сделала. Детективная история Евы Рэй Томас. Книга 2	628	covers/book_35.webp	\nПриключения Евы Рэй Томас продолжаются...\nБывший профайлер ФБР Ева Рэй Томас сталкивается, наверное, с самым личным делом в своей карьере. Три подруги исчезают после выпускного вечера в школе. Одна из них - королева бала.\nЕва Рэй только что нашла сестру, похищенную еще в детстве, и в этот момент детектив Мэтт Миллер просит ее присоединиться к расследованию исчезновения трех девушек.\nКогда на заднем дворе дома Ева Рэй обнаруживает закованную в цепи четвертую подругу пропавших девушек, она понимает, что больше не может наблюдать за этой историей со стороны. Она не только вовлечена в расследование, но и является мишенью маньяка.	Феникс	2025	Твердая
36	33	2	Финансист. Титан. Стоик. Полное издание в одном томе	1484	covers/book_36.webp	В одном томе публикуется знаменитая "Трилогия желания" известного американского писателя Теодора Драйзера (1871-1945) - "Финансист" (1912), "Титан" (1914) и "Стоик" (1947).	Альфа-книга	2019	Твердая
37	44	2	Мифы Ктулху	831	covers/book_37.webp	Роберт Ирвин Говард вошел в историю прежде всего как основоположник жанра "героическое фэнтези", однако его перу с равным успехом поддавалось все: фантастика, приключения, вестерны, историческая и даже спортивная проза. При этом подлинной страстью Говарда, по свидетельствам современников и выводам исследователей, были истории о пугающем и сверхъестественном. Говард - один из родоначальников жанра "южной готики", ярчайший автор в плеяде тех, кто создавал Вселенную "Мифов Ктулху" Г. Ф. Лавкрафта, с которым его связывала прочная и долгая дружба. Если вы вновь жаждете прикоснуться к запретным тайнам Древних - возьмите эту книгу, и вам станет по-настоящему страшно!\nБессмертные произведения Говарда гармонично дополняют пугающие и загадочные иллюстрации Виталия Ильина, а также комментарии и примечания переводчика и литературоведа Григория Шокина.	Феникс	2023	Твердая
38	35	2	Женщина в белом	1518	covers/book_38.webp	Современники считали "Женщину в белом" Уилки Коллинза самым популярным романом XIX века. Он был написан в 1860 году и сразу сделал автора известным писателем. Поклонники с нетерпением ждали выпусков диккенсовского журнала "Круглый год", где книга выходила по частям. Идею своей романтической драмы Коллинз почерпнул в "Справочнике знаменитых судебных дел" Мориса Межана, где рассказывалась история французской маркизы, брат которой завладел ее состоянием, поместив сестру в дом умалишенных под вымышленным именем. Роман Коллинза начинается как раз с эпизода встречи главного героя Уильяма Хартрайта с таинственной женщиной в белом, сбежавшей из сумасшедшего дома. Разгадка тайны этой загадочной героини - одна из главных сюжетных линий романа, тесно переплетенная с другой - с историей любви бедного художника Уильяма Хартрайта и богатой наследницы Лоры Ферли. Неприятие общества, социальные условности встанут на пути этой любви. Однако гораздо более страшным препятствием окажутся беспринципные люди, готовые ради денег и сохранения тайн своего прошлого пойти на любые преступления.	Качели	2022	Твердая
39	36	2	Призраки острова Марион	589	covers/book_39.webp	В очередной том Г.Р. Хаггарда (1856-1925) включены две остросюжетные истории из Викторианской эпохи. Роман с элементами робинзонады "Призраки острова Марион", опубликованный через четыре года после смерти автора, был задуман Хаггардом еще в 1916 году, во время долго плавания к берегам Австралии. Сюжет "Призраков" принес на своих крыльях альбатрос, день и ночь круживший рядом с кораблем писателя.\nДраматическая повесть "Доктор Терн" представлена нашим читателям в полном переводе. По сравнению со старым архаичным переводом начала прошлого века эта история увеличилась вдвое и обрела дополнительные краски, оттенки и эпизоды, которые в очередной раз подчеркивают силу и многогранность таланта настоящего рассказчика.	Вече	2025	Обл. с клапанами
40	37	2	Удивительные приключения дядюшки Антифера	589	covers/book_40.webp	Осень 1831 года. Неизвестный корабль с неизвестным капитаном бороздит неизвестное море в поисках неизвестного острова. Судно уже столько раз меняло курс, что вконец запутало как шпионов, болтавшихся где-то на хвосте, так и саму команду. Где же этот остров? Кто или что там ждет? И что находится в трех окованных железом бочках, которые хозяин шхуны то и дело помышляет швырнуть за борт? И еще интересный вопрос: какое отношение ко всему этому могут иметь два эксцентричных французских провинциала - вспыльчивый, как динамит, дядюшка Антифер и его антипод-приятель Жильдас Трегомен, всегда пожимающий протянутую руку только большим и указательным пальцами?\nЭта авантюрная история рассказывает о простых и удивительных вещах: крепкой дружбе, "с трудом поддающейся объяснению", и алчности, которая в комплекте с ненавистью порой передается по наследству, если передать больше нечего. По словам внука Жюля Верна, этот поздний роман - "своего рода притча, в которой автор обретает хорошее настроение". Именно такое настроение он и дарит своим читателям.	Вече	2025	Обл. с клапанами 
41	38	2	Последняя любовь Нельсона	589	covers/book_41.webp	1793 год. Леди Эмма помогает своему мужу, сэру Уильяму Гамильтону, заботиться об интересах Англии при дворе неаполитанского короля. Сэр Уильям - посол, а его жена, хоть и не занимает никакой официальной должности, участвует во всех политических интригах наравне с мужем. Положение обязывает ее поддерживать фальшивую дружбу с неаполитанской королевой Марией-Каролиной, лгать и притворяться каждый день. Но многое меняется, когда в Неаполь прибывает английский корабль "Агамемнон" под командованием капитана Горацио Нельсона. Эмма проникается чувством к открытому и честному моряку. Она больше не хочет лгать, но изменить привычную жизнь мешают обстоятельства и темное прошлое Эммы, которое постоянно напоминает о себе.	Вече	2025	Обл. с клапанами 
42	39	3	Жаль, что вас не было с нами. Повести и рассказы	480	covers/book_42.webp	Василий Аксенов - один из самых любимых русских писателей, кумир шестидесятников, лауреат премии "Русский букер". Его рассказы и повести стали символом "оттепели". В шестидесятые-семидесятые годы прошлого столетия люди читали и перечитывали, передавали друг другу журналы с новыми произведениями Василия Аксенова. Особенно популярна была "Затоваренная бочкотара". Пусть и нынешний читатель оценит эту мудрую и озорную повесть. А также "Зеницу ока", "Жаль, что вас не было с нами", "Прошу климатического убежища!" и другие легендарные рассказы.	Текст	2023	Твердая
48	8	4	Дубровский	1269	covers/book_48.webp	Владимир Дубровский - молодой и беспечный корнет. Он служит в гвардии и не заботится о будущем: играет в карты, "входит в долги" и устраивает шумные застолья. Но однажды он получает письмо от своей старой няни: отец Владимира при смерти, а их поместье отнимает богатый самодур Троекуров.\nДубровский спешит в деревню на помощь отцу, но здесь его ожидают участь разбойника и дочь заклятого врага.\nИздание выполнено с тиснением на обложке, содержит ляссе (ленточку-закладку). В блоке тонированная бумага.\nДля среднего школьного возраста.\nКнига издана в серии "101 книга" с иллюстрациями Владимира Милашевского, классика книжной иллюстрации.	Издательский дом Мещерякова	2017	Твердая
43	40	3	Самый счастливый день	565	covers/book_43.webp	Виктория Токарева - известный писатель и сценарист; ее имя знакомо российским читателям и зрителям по любимым с детства фильмам: "Джентльмены удачи", "Мимино", "Шла собака по роялю", "Шляпа"... Особое место в творчестве Виктории Токаревой занимают рассказы. Теплые, живые, с мягким, добрым юмором, написанные неподражаемым, легким, "токаревским" языком. С симпатичными героями, которые так напоминают нас самих. И таким необходимым всем нам лейтмотивом: жизнь не испытание, а благо. А счастье в самом ее течении.\nВ настоящее издание вошли рассказы Виктории Токаревой, написанные в разные годы жизни, среди них "День без вранья", "Один кубик надежды", "Самый счастливый день", "Почем килограмм славы" и др.	Азбука	2023	Твердая
44	41	3	Тайны нашего дома	720	covers/book_44.webp	На пляже пансионата происходит убийство. Владу вызывает следователь. Он расспрашивает ее формально - она вне подозрений. Юная девушка. И даже ее домашнее имя - Цыпа - вызывает улыбку. Но для того, чтобы рассказать о взаимоотношениях с убитой, Владе приходится вспомнить обстоятельства своего появления в "Луговых далях", вытащить на белый свет скелеты из семейного шкафа, раскрыть тайны дома. А их накопилось немало...	Феникс	2025	Твердая
45	39	3	Новый сладостный стиль	559	covers/book_45.webp	Василий Аксенов написал роман «Новый сладостный стиль» в 1996 году. Герой романа одаренный театральный режиссер, актер и бард Александр Корбах вынужден эмигрировать в Америку. Там он становится университетским профессором, находит состоятельного родственника, влюбляется в девушку-археолога, работает в Голливуде.\nСтремится в Россию, снова и снова возвращается в Москву девяностых годов, живет «между двумя странами». Блестящая словесная игра украшает речь героев романа, а поэтические фрагменты в конце каждой главы поднимают повествование до философского обобщения. Это книга о России и Америке, о переплетении человеческих судеб. О свободе, о которой Аксенов пишет: «…это крылатое существо, это новый сладостный стиль!» И конечно же — о любви.	Текст	2022	Твердая
46	42	3	Кисло-сладкое	885	covers/book_46.webp	В юности нам кажется, что мы бессмертны, нас непременно ждет незаурядное будущее и великие дела. Верится, что впереди уйма свободного времени на любовь, глупые мелкие обиды и на то, чтобы исправить бездумно совершенные ошибки. Но проходит время... все меняется. И вот уже кажется, что в прошлом деревья были выше, трава зеленее. А еще... тоска чернее и боль пронзительнее. Соня убежала от прошлого, но оно вернулось и потребовало дать ответ. Что же такое настоящая любовь - великая трагедия или великое счастье? От автора романов "Дневник рыжего", "Анасейма" и "Босиком за ветром".	Дримбук	2025	Твердая
47	43	3	Сахар со стеклом	586	covers/book_47.webp	"Сахар со стеклом" - молодежный роман о горькой любви и ненависти между сводными братом и сестрой от Маши Малиновской, автора, которая пишет эмоциональные и чувственные истории.\nМаша Малиновская – популярная писательница в жанре современного любовного романа, молодежной прозы и эротического романа.\nЯна Фомина живёт с тётей в маленьком городке и готовится к поступлению в вуз. Она давно привыкла, что мама приезжает из большого города только на праздники. Но однажды мать шокирует её новостью: она вышла замуж и забирает дочь. Яна воодушевлена, ведь теперь у неё будет не только отчим, но и сводный брат. Она всегда хотела иметь старшего брата.\nНо Алексей встречает её ледяным взглядом и открытым презрением. И он не собирается скрывать, что Яна для него — чужая. Алексей готов сделать всё, чтобы девчонка поняла — ей тут не место.\nСможет ли Яна стать частью новой семьи? И что же скрывается за льдом в глазах сводного брата?	Яуза	2025	Твердая
49	9	4	Тарас Бульба	1171	covers/book_49.webp	\nПовесть "Тарас Бульба" рассказывает, прежде всего, о братстве, чести, верности товарищам и отчизне. На этих принципах держалось Запорожское братство, к которому принадлежат главные герои. В основу сюжета легла история восстания запорожских казаков 1637-1638 годов.\nЯркие, сочные иллюстрации Дементия Шмаринова сочетают в себе и полноту жизни героев, и трагедию ее окончания.	Речь	2017	Твердая
51	45	4	Бедная Лиза. Подробный иллюстрированный комментарий	433	covers/book_51.webp	В издании представлена повесть Н. М. Карамзина "Бедная Лиза".\nПодробный иллюстрированный комментарий к повести, выполненный с использованием технологии "книга в книге", поможет читателю погрузиться в эпоху России конца XVIII века, лучше понять произведение великого писателя и узнать много интересного о событиях и традициях, бытовавших в то время.\nДля всех интересующихся историей, русской литературой и творчеством Николая Михайловича Карамзина.	Проспект	2024	Твердая
52	8	4	Стихи и проза. Собрание сочинений в одном томе	1324	covers/book_52.webp	В издании представлены сочинения Александра Сергеевича Пушкина – стихи, проза, драматургия, эссеистика, а также автобиографические заметки, дневники, анекдоты. Ко всем произведениям даны научные комментарии. Книга дополнена интересным визуальным материалом, словарем терминов и алфавитным указателем. Для широкого круга читателей.	Проспект	2024	Твердая
53	46	4	Детство. Отрочество. Юность	1447	covers/book_53.webp			2025	Твердая
54	47	5	Полное собрание романов в одном томе	1669	covers/book_57.webp	\nВ одном томе публикуются все романы известного британского писателя Джорджа Оруэлла (1903-1950) - "Дни в Бирме", "Дочь священника", "Да здравствует фикус!", "Глотнуть воздуха", "1984" и сатирическая повесть "Скотный двор".	Альфа-книга	2022	Твердая
55	48	5	Земля мечты. Последний сребреник	1091	covers/book_55.webp	\nОт лауреата Всемирной премии фэнтези и премии Филипа К. Дика.\n\nНи один писатель со времен Рэя Брэдбери не создавал столь волшебный и реальный мир.\n\nДобро пожаловать в волшебную Калифорнию!\n\nКогда на берег выбрасывает ботинок размером с лодку и гигантские очки, трое городских сирот - Джек, Скизикс и Хелен - понимают, что происходит что-то неладное, да и старый призрак на чердаке приюта склонен с ними согласиться. В город приезжает зловещий карнавал, которым руководит мрачный джентльмен, имеющий способность превращаться в ворона. Человек размером с мышь, прячущийся в лесу, оставляет Джеку эликсир, который, возможно, позволит ему перейти во время Солнцестояния в другой мир, в таинственные Земли мечты, где хранится ключ к прошлому Джека и где начнутся их приключения.	fanzon	2024	Твердая
56	49	5	Призраки Иеронима Босха. Уникальная книга ужасов	1081	covers/book_56.webp	Из мрачных глубин Средневековья пришла к нам эта история. Веками почитатели искусства восхищались картинами Босха и ужасались запечатленным на них образам. Но никто из них не пытался заглянуть в Бездну, что скрыта за всем известными полотнами. Лишь один не в меру любознательный автор осмелился заглянуть за Грань... и этот поиск завел его куда дальше, чем можно представить в самых страшных кошмарах. Прочтите эту книгу - и вы никогда не сможете смотреть на картины Босха прежним взглядом.\nДорогой Читатель, ты держишь в своих руках не просто переиздание, а специальное коллекционное издание, которое несомненно придется по душе всем эстетам. Ибо мы решили, что наш прекрасный роман того достоин. Закрашенный обрез, в три раза возросшее количество цветных иллюстраций и другие атмосферные элементы оформления сделают эту книгу украшением твоей книжной коллекции. С нами Босх!	Феникс	2024	Твердая
57	50	5	Рейтинг Асури	250	covers/book_57.webp	Жизнь в Байхапуре, идеальном городе-государстве, зависит от показателя рейтинга, который контролирует система искусственного интеллекта. Нулевой уровень преступности. Потенциально опасные элементы, чей рейтинг опустился ниже определенной отметки, изолируются от общества и перемещаются за стену без возможности возврата.\nПрофессор Афа Асури, создатель системы, получает всемирное признание и Нобелевскую премию. Внезапно его личный рейтинг начинает стремительно падать, рискуя опуститься до той самой границы. Он считает, что это всего лишь сбой программы.	Городец	2022	Твердая
58	51	5	Кошмар на Полынной улице. Сборник рассказов	679	covers/book_58.webp	Хэллоуин - это время колдовства, загадок и страшилок. Авторы издательства "Полынь" написали девять рассказов, после которых вы не уснете. Похищенные дети, отрезанные уши, родовые проклятия и прочие леденящие душу истории. Проведите страшно интересный и до жути пугающий праздник на Полынной улице!\nАвторы сборника: Риган Хэйс, Дарья Буданцева, Мария Соловьёва, Анна Чайка, Мария Тович, Екатерина Ландер, Роннат, Анастасия Евлахова, Мэй\n\nРиган Хэйс "Игра в кости"\n\nБенни Фрауд и трое его друзей в канун Самайна ввязываются в авантюру в надежде озолотиться: подозрительный незнакомец обещает им награду за разграбление могилы старого колдуна. Однако нечистая сила не дремлет и не готова уступить сокровища просто так.	Полынь	2025	Твердая
59	52	5	Мы	187	covers/book_59.webp	В настоящем издании публикуется знаменитый роман-антиутопия "Мы", написанный Евгением Замятиным в 1920 году.\nЭто произведение оказало большое влияние не только на русскую, но и на мировую литературу, в частности на творчество Олдоса Хаксли и Джорджа Оруэлла.\nДля широкого круга читателей.	Проспект	2025	Обл. с клапанами 
60	53	5	Терранавты. Роман о разумных осьминогах	770	covers/book_60.webp	Динамичное действие романа происходит в 2043 году. Школьница Мира приезжает на Сахалин в гости к родственнице, известному гидробиологу. Однако тётя Рина исчезла. Мире придётся самой разбираться, почему и куда пропадают люди. Новый учитель плавания предлагает помощь. Но кто он на самом деле?! "Терранавты" - дебютный роман Октавии Колотилиной, успевший получить несколько престижных наград (победитель Литературной мастерской Сергея Лукьяненко, шорт-лист премии патриотической фантастики "Пересвет"). Увлекательный сюжет, тщательно продуманные персонажи и описания подводного мира никого не оставят равнодушным. Особенно книга понравится любителям научной фантастики. Погружайтесь за острыми ощущениями!	ИД Комсомольская правда	2024	Твердая
61	54	5	Руки солнца	286	covers/book_61.webp	Необычное рядом с нами. В этом предстоит убедиться Даниэлю, жизнь которого изменится после перенесенной комы. Теперь он может видеть духов и разговаривать с ангелами, быть одновременно в двух мирах. Что это: игры разума, воспаленная фантазия или другая реальность все-таки существует? В поисках ответов на эти вопросы Даниэль побывает в далекой Индии и мистической Праге, откроет для себя много нового и поймет, что мир устроен гораздо сложнее, чем он думал, что добро и зло, как инь и ян, неразделимы и даже чистые и непорочные ангелы бывают жестокими.	Четыре	2024	Твердая
62	42	5	Босиком за ветром	770	covers/book_62.webp	Славку не мучают кошмары, наоборот. Она сама плетет их жуткий узор. Дочь ведьмы, наделенная особой способностью - проникать в чужие сны и подсматривать самые сокровенные желания. Но даже она не в силах повлиять на чувства того, кого сама нарекла именем ветра. Когда-то она не смогла его простить. Вытравила из памяти, присыпала пылью забвения. Но горькая обида и жгучая любовь поднялись ураганом и вырвались на свободу, грозя разрушить всё, что ей дорого. И всё же за свою любовь Славка готова бороться, даже с тем, кого любит, - бежать босиком за ветром и лететь за ним в пропасть. Не можешь лететь - падай. От автора романов "Дневник рыжего" и "Анасейма".	Дримбук	2024	Твердая
63	55	6	У смерти два лица	716	covers/book_63.webp	Семнадцатилетняя Анна Чиккони устраивается на лето няней в богатый дом на Атлантическом побережье неподалеку от Нью-Йорка. Все идет хорошо, но с каждым днем пребывания в живописном Херрон-Миллс она начинает замечать все больше странностей: окружающие весьма необычно реагируют на встречу с ней, проявляя удивление и даже испуг. Оказывается, полгода назад в поселке бесследно исчезла молодая девушка Зоуи Спанос, очень похожая на нее. А саму Анну все чаще посещают смутные образы и воспоминания: ей начинает казаться, что она уже бывала раньше в этих местах. В какой-то момент перед ее мысленным взором предстают обстоятельства смерти Зоуи. И - о ужас! - в этой трагедии, похоже, виновата она сама. Что это - дежавю, причуды памяти или за этим кроется что-то гораздо более страшное?	Аркадия	2022	Твердая
64	56	6	Лицом к солнцу	452	covers/book_64.webp	Ранним утром двое подростков обнаруживают на пляже в Майами мертвую красавицу - преступник установил тело в молитвенной позе лицом к восходящему солнцу. Спешно вызванные полицейские подозревают, что это дело рук серийного убийцы. Для раскрытия чудовищного преступления необходимо найти и других жертв, и здесь требуется помощь ФБР. Агент Тесс Уиннет - блестящий профессионал-одиночка с уникальной интуицией, но чтобы выследить именно этого убийцу, одной интуиции недостаточно - Тесс придется столкнуться с призраками далекого прошлого и одолеть собственный страх.	Аркадия	2020	Твердая
65	57	6	Детективное агентство "Альтернатива"	794	covers/book_65.webp	Большинству читателей Роберт Шекли (1928-2005) хорошо известен как замечательный писатель-фантаст, однако здесь он представлен произведениями другого жанра. Три романа, включенных в эту книгу, объединены общим главным героем - частным детективом, который расследует преступления, связанные с торговлей наркотиками и совершаемые на испанском острове Ибица, а также в Лондоне, Нью-Йорке и Париже. Попадая в казалось бы безнадежное положение, Хоб Драконян (так зовут этого героя) неизменно сохраняет самообладание и чувство юмора, и эти качества, а также помощь друзей помогают ему не только уцелеть, но и добиться успеха.	Текст	2021	Твердая
66	58	6	Шесть убийственных причин	581	covers/book_66.webp	В живописном уголке Ирландии, над белопенной бухтой, в прекрасном доме на холме, жили-были отец с матерью и шестеро детей: три сына и три дочери. Жили богато и счастливо, пока не исчез средний сын - будто сквозь землю провалился. Мать горя не пережила и до срока ушла в мир иной, а дети разъехались по миру. Но через десять лет пропавший сын вернулся в родное гнездо…\nИстория, рассказанная признанным мастером Джо Спейн, звучит словно волшебная сказка. Только описанная в ней реальность окажется куда страшнее любого вымысла, ведь "возвращение блудного сына" ознаменовано убийством его отца!	Аркадия	2021	Твердая
67	59	6	Небо Голливуда	691	covers/book_67.webp	В остросюжетном романе знаменитого нидерландского писателя Леона де Винтера (р.1954 г.) «Небо Голливуда» трое блестящих в прошлом, но сейчас оказавшихся не у дел актеров начинают собственное следствие об ограблении казино и, в надежде завладеть деньгами, предстают перед гангстерами, ограбившими казино на миллионы долларов, под видом детективов.\nПостепенно выясняется, что события развиваются по сценарию, который один из них написал много лет назад.\nРоман построен по законам голливудского психологического триллера.	Текст	2020	Твердая
68	56	6	Похититель жизней	452	covers/book_68.webp	Фотомодель Кристина Бартлетт знаменита, богата и счастлива. У нее замечательные родители и любящий молодой человек, за которого она вскоре выйдет замуж. Но внезапно эта молодая особа кончает с собой. Прибывшие на место преступления полицейские уверены - это типичный суицид. Однако у специального агента ФБР Тесс Уиннет возникают сомнения.\nА вскоре она понимает, что ей предстоит вычислить и изловить очередного маньяка. Проблема только в том, что злодей не оставляет следов...	Аркадия	2021	Твердая
69	56	6	Послание смерти	632	covers/book_69.webp	Полицейские обнаруживают тело молодой женщины на заднем дворе ее собственного дома через неделю после ее исчезновения. Собранные улики неопровержимо свидетельствуют: она - жертва неизвестного серийного изувера-убийцы.\nСпециалист по подобного рода преступлениям, агент ФБР Тесс Уиннет, восстанавливается после серьезной операции в больнице, но она готова прийти на помощь коллегам. Появление следующей жертвы дает следователям зацепку - перед тем как похитить женщину, маньяк демонстрирует ей веревку, которая в недалеком мрачном будущем оборвет ее жизнь. Этого недостаточно, чтобы вычислить и изловить убийцу, но Тесс, используя достижения современной науки, подбирается к нему все ближе и ближе...	Аркадия	2020	Твердая
70	60	6	Сэр Найджел. Белый отряд. Подвиги бригадира Жерара. Приключения бригадира Жерара	1891	covers/book_70.webp	В одном томе публикуются самые известные исторические произведения знаменитого английского писателя Артура Конан Дойла - "Сэр Найджел", "Белый отряд", "Подвиги бригадира Жерара" и "Приключения бригадира Жерара" с 282 иллюстрациями известных художников У.Уоллена, С.Пэйджета. А.Твидла и других.	Альфа-книга	2022	Твердая
71	60	6	Приключения Шерлока Холмса	323	covers/book_71.webp	Более 100 лет мир читает произведения о Шерлоке Холмсе. Слава этого героя затмила всех знаменитых персонажей мировой литературы.\nШерлок Холмс - наблюдательный, проницательный и находчивый человек. Его острый глаз замечает в окружающем мельчайшие детали, а тонкий ум легко и изобретательно связывает их воедино, приходя к неожиданным порою, но всегда правильным выводам. Шерлок Холмс - сыщик, расследование преступлений он стремится превратить в точную науку. Он хорошо знает людей, и это помогает ему распутывать самые запутанные преступления. Второй герой произведений Конан Дойла, посвященных Шерлоку Холмсу,- доктор Уотсон, неизменный спутник, а часто и помощник Шерлока Холмса. От его имени ведется повествование о тех сложных и загадочных преступлениях, выяснять причины и разыскивать виновников которых приходится Шерлоку Холмсу.	Альфа-книга	2019	Твердая
72	60	6	Этюд в багровых тонах. Знак четырех	507	covers/book_72.webp	Более 100 лет мир читает рассказы о Шерлоке Холмсе. Слава этого героя затмила всех литературных персонажей мировой литературы.\nВ настоящее издание вошли две повести о знаменитом сыщике - "Этюд в багровых тонах" и "Знак четырех".\nКомплект из 61 иллюстрации, выполненный Йозефом Фридрихом, Фредериком Таунсендом и Рихардом Гутшмидтом, прекрасно иллюстрирует все произведения.\nДля среднего школьного возраста.	Альфа-книга	2022	Твердая
73	61	7	С видом на Нескучный	510	covers/book_73.webp	Помните, героиня культового советского фильма говорит, что, когда всего добьешься, больше всего хочется выть волком.\nВера, как и героиня фильма, добилась всего сама. И ей точно так же хочется выть волком.\nНеожиданно судьба, словно подслушав ее мысли, делает крутой поворот - отправляет ее в Энск, убогий, нищий городишко, где прошли ее детство и юность и откуда она сбежала, оставив все: сытую жизнь, тряпки, украшения и - мужа. Красавца Геру Солдата, местного криминального авторитета.\nНо прошлое не дает о себе забыть. Спустя годы Вера приезжает в Энск по делам, и неожиданно здесь, в этом ненавистном городке, судьба подкидывает ей шанс не только круто изменить жизнь, но и наполнить ее смыслом.	Эксмо	2023	Твердая
74	62	7	Сэйв	487	covers/book_74.webp	Книги Авы Хоуп - это чувственные истории о любви, в которой нет места токсичности и предательству, ее герои настолько легкие и веселые, что счастливый финал им непременно гарантирован.\n\nЭмили. Каждая романтическая история любви начинается с чуда. Так считала я до знакомства с Мэттью Дэвисом. Но этот парень перевернул все мои представления о прекрасном, уверяя, что любовь переоценили. Он оказался самым настоящим циником и нахалом, а проклятый Купидон взял и вручил ему мое сердце. Теперь только от него зависит, какой финал ждет нашу историю. Но вдруг чудеса все-таки случаются и главное - верить?	Эксмо	2023	Твердая
75	63	7	Доверие	1029	covers/book_75.webp	В последнее время Тирнан де Хаас все стало безразлично. Единственная дочь кинопродюсера и его жены-старлетки выросла в богатой, привилегированной семье, однако не получила от родных ни любви, ни наставлений. С ранних лет девушку отправляли в школы-пансионы, и все же ей не удалось избежать одиночества. Она не смогла найти свой жизненный путь, ведь тень родительской славы всюду преследовала ее.\nПосле внезапной смерти родителей Тирнан понимает: ей положено горевать. Но разве что-то изменилось? Она и так всегда была одна.\nДжейк Ван дер Берг, сводный брат ее отца и единственный живой родственник, берет девушку, которой осталась пара месяцев до восемнадцатилетия, под свою опеку. Отправившись жить с ним и его двумя сыновьями, Калебом и Ноем, в горы Колорадо, Тирнан вскоре обнаруживает, что теперь эти мужчины решают, о чем ей беспокоиться. Под их покровительством она учится работать, выживать в глухом лесу и постепенно находит свое место среди них.	АСТ	2023	Твердая
76	64	7	Люб и Овь	857	covers/book_76.webp	Это история про влюбленного парня по имени Люб и неприступную девушку по имени Овь. Половинки одного целого, которых разделяет ненавистная "И" - интернет. Влюбленный Люб покоряет Овь через интернет. "И", конечно, не простая, современная, и, возможно, вы узнаете себя в этой истории.	Четыре	2024	Твердая
77	42	7	Анасейма	575	covers/book_77.webp	Они повстречались, будучи детьми. За возможность называть выросшую на берегу Чёрного моря Марину звучным прозвищем Анасейма Илья поплатился зубом и душевным покоем. Но приручить морскую волну - задача невыполнимая... А Марина была с морем единым целым, жила им, дышала. Верила в волшебство, здоровалась с прибоем и загадывала желание каждый раз, как находила особенную ракушку.\nОдна из трёх дочерей Счастливчика, трёх "русалочек", она не представляла, как это - жить вдали от моря, не ощущать его в каждом вдохе. Но сможет ли любовь к человеку победить страсть к стихии? Смогут ли Илья и Марина, пережив череду испытаний и ошибок, простить друг друга и быть вместе, несмотря на боль и обиды?	Дримбук	2024	Твердая
78	65	7	Лунный шторм. Время взрослеть	831	covers/book_78.webp	Рэйчел всегда была ранимой девушкой, но после неудачной первой любви она решила измениться. Посвятив себя учебе и работе, Рэй не желает отвлекаться на посторонние вещи. Но жизнь снова приготовила ей испытания. Прошлое настигает и переплетается с настоящим, от которого теперь зависит ее будущее. Если раньше она не верила в любовь, то теперь же просто пытается принять собственные чувства. Однако судьба к ней неблагосклонна, и девушка оказывается в тупике.	Феникс	2024	Твердая
79	66	7	Порочная трилогия	570	covers/book_79.webp	Порочная трилогия от Меган Марч в одном томе! Входят книги: "Порочный миллиардер", "Порочные удовольствия", "Порочная связь".\n\nПо контракту с музыкальной студией Холли вынуждена играть на публике роль невесты известного певца Джесси, который, по ее мнению, полнейший разгильдяй. Холли мечтает обойти контракт, но это не так просто.\nУ Крейтона Караса много плюсов: обалденная внешность, острый ум, банковский счет. Но, как следствие, есть и минус - непомерное эго, а еще у него скандальная репутация. Правда, после их случайной встречи в баре все думают, что они с Холли теперь пара.\nКажется, что это спасение от контракта. Но красивые и самоуверенные миллиардеры, как правило, надолго не влюбляются. Холли мечтает выпутаться из этого клубка страстей, но Крейтон не даст ей уйти так просто.	Inspiria	2024	Твердая
80	67	8	Дикая охота короля Стаха	757	covers/book_80.webp	Исторический детектив "Дикая охота короля Стаха" - одно из самых популярных произведений классика белорусской литературы Владимира Короткевича. Созданная по классическим канонам приключенческого романа, эта повесть завораживает и чем-то своим, особенным, некой присущей ей тайной-загадкой, которую трудно объяснить словами, а можно только почувствовать.	Попурри	2025	Твердая
81	67	8	Собрание сочинений. В 6 томах. Том 5. Леониды не вернутся к земле	1638	covers/book_81.webp	Прозаические произведения Владимира Короткевича средней жанровой формы затрагивают сложные общественно-политические коллизии белорусской истории XVI-XIX веков. Сложные хитросплетения сюжетов, талантливо выписанные характеры, реальные и фантастические события, открытый авторский голос заставляют читателя задуматься над непрерывностью человеческого существования на земле и своим местом на ней, над пониманием добра и зла, милосердия и коварства, любви и ненависти.\nВ этот том вошли роман "Леониды не вернутся к Земле", поветь "Оружие" и два рассказа.	Престиж БУК	2024	Твердая
82	68	8	Время секонд хэнд	1050	covers/book_82.webp	Завершающая, пятая книга знаменитого художественно-документального цикла «Голоса Утопии» Светланы Алексиевич, лауреата Нобелевской премии по литературе 2015 года «за многоголосное творчество — памятник страданию и мужеству в наше время».\n«У коммунизма был безумный план, — рассказывает автор, — переделать "старого” человека, ветхого Адама. И это получилось… Может быть, единственное, что получилось. За семьдесят с лишним лет в лаборатории марксизма-ленинизма вывели отдельный человеческий тип — homo soveticus. Одни считают, что это трагический персонаж, другие называют его "совком”. Мне кажется, я знаю этого человека, он мне хорошо знаком, я рядом с ним, бок о бок прожила много лет. Он — это я. Это мои знакомые, друзья, родители».\nМонологи, вошедшие в книгу, десять лет записывались в поездках по всему бывшему Советскому Союзу.\n9-е издание.	Время	2020	Твердая
83	68	8	У войны не женское лицо	1250	covers/book_83.webp	Одна из самых известных в мире книг о войне, положившая начало знаменитому художественно-документальному циклу Светланы Алексиевич "Голоса Утопии". Переведена более чем на двадцать языков, включена в школьные и вузовские программы во многих странах. Последняя авторская редакция: писательница, в соответствии со своим творческим методом, постоянно дорабатывает книгу, убирая цензурную правку, вставляя новые эпизоды, дополняя записанные женские исповеди страницами собственного дневника, который она вела в течение семи лет работы над книгой. "У войны не женское лицо" - опыт уникального проникновения в духовный мир женщины, выживающей в нечеловеческих условиях войны.\n11-е издание, стереотипное.	Время	2021	Твердая
84	69	9	Физика. Основные понятия, формулы, законы	574	covers/book_84.webp	В пособии конспективно изложен основной материал курса физики в соответствии с содержанием действующей учебной программы для учреждений общего среднего образования и учебников. Книга поможет восстановить в памяти, конкретизировать и систематизировать ранее изученное.\nАдресуется старшеклассникам и абитуриентам для работы на уроках и подготовки к централизованному тестированию.\n11-е издание.	Аверсэв	2022	обл - мягкий переплет
85	70	9	Требования к оформлению пояснительных записок к курсовой работе и выпускной квалификационной работе	223	covers/book_85.jpg	Требования к оформлению пояснительных записок к курсовой работе и выпускной квалификационной работе бакалавра по направлению «Декоративно-прикладное искусство и народные промыслы»\nУчебно-методическое пособие предназначено для студентов кафедры церковного шитья факультета церковных художеств Православного Свято-Тихоновского гуманитарного университета. В нем указаны основные правила оформления к написанию пояснительных записок к курсовым работам и выпускной квалификационной работе бакалавра по направлению 54.03.02 «Декоративно- прикладное искусство и народные промыслы» и требования к ним, соответствующие действующим стандартам РФ и программам кафедры.	ПСТГУ	2024	Твердая
86	71	9	Общая и неорганическая химия	451	covers/book_86.webp	Учебное пособие состоит из двух разделов. В первом разделе на современном теоретическом уровне изложены основы общей и неорганической химии, а во втором – материал, посвященный описательной химии элементов. Для выпускников средних школ, абитуриентов колледжей и школьных преподавателей химии.	Феникс	2024	обл - мягкий переплет
87	72	9	Индивидуальный проект. Шаг в профессию. Учебник для СПО	987	covers/book_87.webp	Данный учебник разработан в соответствии с требованиями Федерального государственного образовательного стандарта среднего общего образования в редакции Приказа Министерства просвещения Российской Федерации № 732 от 12.08.2022 г., требованиями Федеральной образовательной программы среднего общего образования, утверждённой Приказом Министерства просвещения Российской Федерации № 371 от 18.05.2023 г., и предназначен для реализации образовательных программ среднего профессионального образования, реализуемых на базе основного общего образования или интегрированных с образовательными программами основного общего и среднего общего образования, при освоении учебных предметов, курсов, дисциплин (модулей) основного общего образования и (или) среднего общего образования.\nВ учебнике рассмотрены этапы проектирования (выдвижение идеи, разработка замысла, реализация и защита проекта). Также разбираются примеры проектов, как современных, так и разработанных в прошлом.	Просвещение	2025	обл - мягкий переплет
88	73	9	История России. Конспект лекций с иллюстрациями. Учебное пособие	187	covers/book_88.webp	Учебное пособие подготовлено в виде кратких вопросов и ответов и охватывает все основные темы учебного курса "История России", включаемые в билеты для экзаменов, зачетов, семинаров.	Проспект	2024	обл - мягкий переплет
89	74	9	Выпускная квалификационная работа бакалавра. Методические указания. Учебное пособие	1000	covers/book_89.webp	Методические указания содержат единые требования по подготовке к защите выпускных квалификационных работ студентов, обучающихся по программам бакалавриатуры направлений высшего профессионального образования "Информатика и вычислительная техника" и "Программная инженерия".	Лань	2019	Твердая
91	76	10	Моя жизнь, мои достижения	475	covers/book_91.webp	В 1911 году Генри Форд изменил мир. Он вошел в историю как изобретатель конвейера и один из самых честных миллионеров. Форд ошибался, терял состояние и богател, судился за патенты, выигрывал и проигрывал тяжбы, он вытащил Америку из экономической депрессии и стал символом самой мощной экономики в истории человечества. Идеи и методы организации производства, описанные в этой знаменитой книге, внедрены в деятельность тысяч предприятий и заслуживают внимания каждого, кто создает свой бизнес.	Попурри	2020	Инт
92	77	10	Мы были людьми	665	covers/book_92.webp	Книга, которая пробирает до костей! Это взгляд на СВО изнутри, глазами русского солдата. Повествование от первого лица моментально погружает в атмосферу боевых действий. Автор - непосредственный участник событий - делится личным опытом, заставляя сопереживать каждому герою. Книгу дополняют авторские графические зарисовки, которые усиливают эмоциональное воздействие на читателя. Будто ты сам идешь с бойцами в промокших ботинках, ешь снег, падаешь без сил от усталости и вновь поднимаешься, вступаешь в бой с противником. Главный вопрос на который отвечает автор этой книги: "Как остаться человеком в самом пекле войны?"	Яуза	2025	Твердая
93	78	10	Автобиография. Евангелие богатства	757	covers/book_93.webp	Близкий друг Карнеги, Марк Твен, окрестил его «Сент-Эндрю». А премьер-министр Уильям Гладстон называл его примером для богатых. К мультимиллионерам редко применяют такие слова. Но Эндрю Карнеги стал магнатом сталелитейной промышленности не просто так. Мечтательным 13-летним мальчишкой он отправился из своего родного города Данфермлина (в Шотландии) в Америку. История его успеха началась с работы на фабрике катушек за один доллар и двадцать центов в неделю. К концу своей жизни он накопил несметные богатства и отдал более девяноста процентов этого капитала на благо человечества. Здесь представлен впервые собранный в одном томе материал, включающий две действительно впечатляющие работы Эндрю Карнеги — «Автобиография» и «Евангелие богатства». Это потрясающий манифест о том долге, который должен выполнить каждый богатый человек — отдать свои материальные блага обществу.	Попурри	2025	обл - мягкий переплет
94	79	10	Запрещённая экономика. Что сделало Запад богатым, а Россию бедной	753	covers/book_94.webp	Опираясь на широкий круг источников, автор показывает, в чем заключается реальный "рецепт" экономического успеха. Целый ряд всемирно известных экономических чудес достигнуты не на основе господства принципов "невидимой руки" рынка. В разных странах - США и Японии, Франции и Южной Корее, Италии и Австралии, Китае, Швеции, Российской империи и многих других - блестящие результаты достигались благодаря иному подходу. Протекционизм, планирование, высокая роль государства в регулировании экономикой - вот что позволило осуществить мощный промышленный и научно-технический рывок. Напротив, "невидимая рука" нередко приводила страны к разорению и становилась преградой на пути развития экономики. Тем не менее в мировом масштабе уже много лет ведется кампания по дискредитации протекционистского подхода.	Тион	2024	Твердая
95	80	10	Книга прощаний. Воспоминания о друзьях и не только о них	606	covers/book_95.webp	Мемуарная проза известного писателя и литературоведа Станислава Борисовича Рассадина (1935-2012). Автор знаменитой статьи "Шестидесятники", по заглавию которой впоследствии был назван целый период интеллектуальной жизни России, рассказывает о своих друзьях, замечательных людях, составивших цвет русской культуры второй половины XX столетия, - Окуджаве, Слуцком, Искандере, Самойлове, Галиче, Евтушенко, Козакове и многих других.\n\nСтанислав Рассадин внешне - интеллигент-очкарик, а физически весьма силен; грозный ругатель, отчасти пурист в отношениях дружеских и деловых, - он притом настолько добр, что тратит немало усилий на сокрытие этой слабости… За все берется - и с успехом, ибо интересуется, в сущности, лишь одним: хорошее ли? настоящее ли? И конечно же такому человеку очень трудно жить.\nНатан Эйдельман	Текст	2022	Твердая
96	81	11	Пиво	1530	covers/book_96.webp	Пиво - один из древнейших напитков. Оно завоевало множество поклонников во всем мире. Пиво варят на старых фермах и в мини-пивоварнях при пабах: пиво варят монахи в аббатствах и огромные международные компании. Энциклопедия "Пиво" содержит сведения о разных типах этого восхитительного напитка, о методах производства, о всевозможных ингредиентах и тонкостях пивоваренного дела. Прекрасные фотографии демонстрируют бесконечное разнообразие сортов пива из различных стран и регионов.\nЭто книга для настоящих знатоков, коллекционеров и любителей пива.	Лабиринт	2005	Твердая
97	82	11	Рецепты Средиземья. Кулинарная книга по миру Толкина	2444	covers/book_97.webp	Погружаясь в миры Толкина, вы наверняка задумывались, какой же на вкус эльфийский хлеб Лембас, медовые лепешки Беорна или крам. Или что ели хоббиты, эльфы или гномы в течение дня?\nУ Толкина еда ассоциируется с дружбой, товариществом, любовью, надеждой и (возможно, это главное) с домом. И в "Хоббите", и во "Властелине колец" воины и герои, большие и маленькие, люди, гномы, волшебники и хоббиты (но особенно хоббиты) - большие любители поесть и почаевничать. Десятки раз упоминаются завтраки, вторые завтраки, обеды, ужины, пиршества, множество закусок, блюд, чудодейственных напитков.\nОкунитесь в волшебный мир сказочных существ и гастрономического наслаждения вместе с книгой, вдохновленной Средиземьем и вашими любимыми персонажами. Здесь вы найдете 75 рецептов, которые разделены по шести приемам пищи в течение дня, принятыми у хоббитов. Устройте пиршество, которое понравится не только оркам или эльфам, но и людям.	ХлебСоль	2022	Твердая
98	83	11	Еда не беда. Как перестать разочаровываться	640	covers/book_98.webp	Наконец-то в одном месте собраны самые важные знания о том, что мы упускаем в питании. Информативная, вдохновляющая на результат и простая в понимании книга. Не просто о еде, а об интересных возможностях организма. Она станет для вас практическим руководством к оздоровлению. В ней детально раскрывается техническая сторона процессов, происходящих в теле, когда в него попадает та или иная пища. Понимая эти процессы, вы больше не будете страдать из-за еды. Вы сможете сбрасывать лишний вес без голода и стрессов. Вы научитесь самостоятельно менять состав своего тела, уменьшая жировую прослойку, увеличивая мышечную составляющую, избавляясь от отеков. Здесь вся правда о диетах и пищевых стереотипах. Оставьте разочарования позади. Эта книга ответит на ваши вопросы о еде, здоровье и красоте. Прочитайте ее и сами сможете организовать себе подлинно полезное питание, как настоящий нутрициолог. Экспериментируйте с едой безопасно!	Тион	2023	Твердая
99	84	11	Смузи и коктейли для похудения	570	covers/book_99.webp	ХлебСоль	Книга "Смузи и коктейли для похудения" - ваш проводник на пути к полезному питанию. У современного человека, при его быстром темпе жизни, не всегда есть возможность питаться правильно и сбалансированно, поэтому смузи и полезные коктейли помогут вам питаться вкусно, не портить фигуру, а быстрое приготовление и доступные ингредиенты позволят не тратить часы на кухне.\nВ книге собрано более 55 рецептов, подходящих для вегетарианцев и веганов, для тех, кто придерживается низкоуглеводной диеты или просто сократил потребление сахара, варианты на основе молочных и кисломолочных продуктов, а также на растительном молоке. Сделайте свою жизнь комфортнее с книгой "Смузи и коктейли для похудения".	2023	Обл. с клапанами
100	85	11	Переключатель. Ускорение метаболизма с помощью интервального голодания, протеиновых циклов и кето	632	covers/book_100.webp	Как вы можете похудеть, облегчить хронические заболевания и дольше оставаться здоровыми? Перезапустите свой метаболизм с помощью нескольких простых шагов!\n\nТело каждого человека от природы наделено древним механизмом, уничтожающим токсины, запускающим сжигание жира и не позволяющим клетке "сломаться" или стать раковой. Этот механизм называется аутофагией - при его нормальной работе сложная цепочка биологических реакций способна не только замедлить процессы старения, но и оптимизировать функционирование организма в целом, помогая предотвращать всевозможные заболевания и обеспечивая нам долгую здоровую жизнь. Это своего рода переключатель, переводящий организм в режим долголетия.	Попурри	2021	Твердая
101	86	11	Как готовить вкусно без глютена. От спагетти и пиццы до тортов и французских багетов	1774	covers/book_101.webp	Вы избегаете глютена, но скучаете по свежеиспеченному хлебу, вашей любимой выпечке или пицце? Или Вы сладкоежка и любите пончики с джемом, печенье и классические торты?\n\n"Как готовить вкусно без глютена" - это первая кулинарная книга, в которой показано, как "разблокировать" для себя все те блюда, по которым вы так скучаете, и при этом приготовить их так, что они не будут выглядеть безглютеновыми заменителями настоящих.\n\nБекки Экселл уже много лет готовит без глютена и делится своими рецептами с подписчиками в соцсетях. Её миссия - показать, что готовить без глютена не значит ограничивать себя в выборе блюд и питаться очевидными супами, салатами и фруктами. Она научит Вас готовить те блюда, которые вы считали недоступными для себя. От настоящего куриного чоу-мейна до пад-тай, от пончиков до лимонного пирога, от чизкейка до профитролей, от французских багетов до пиццы. А ещё в этой книге - безмолочные веганские и вегетарианские варианты приготовления блюд и множество проверенных советов о том, как любое блюдо сделать безглютеновым.	Манн, Иванов и Фербер	2022	Твердая
102	5	12	3 в 1. Все для экзамена в ГИБДД. ПДД, билеты, вождение. Обновленное издание. С новейшими изменениями	388	covers/book_102.webp	Перед вами уникальное издание — самое полное и полезное пособие для сдающих экзамены в ГИБДД. Под одной обложкой собраны актуальные Правила дорожного движения, последняя редакция билетов к экзамену с ответами и комментариями, а также основы вождения для начинающих.	Питер	2024	обл - мягкий переплет
103	5	12	Настенная карта "Мир. Физическая карта полушарий", в тубусе	453	covers/book_103.webp	Настенная карта "Мир. Физическая карта полушарий" дает общее представление о расположении материков и океанов, о сложном рельефе нашей планеты, о морских течениях в разных частях Земли.\nНа карте изображены Восточное и Западное полушария, а также карты-врезки Северного и Южного полюсов (масштаб 1:50 000 000).\nСодержание карты дополнено основными справочными данными о материках и Мировом океане.\nЛаминированная.\nФормат: 101х69 см.\nМасштаб: 1:37 млн.\nСделано в России.	Геодом	2020	Box
104	87	12		728	covers/book_104.jpg	Путеводитель знакомит читателя с Москвой и её достопримечательностями с борта теплохода, проплывающего через центр столицы от Киевского вокзала до Новоспасского монастыря. Путешественника ждёт интересная экскурсия в прошлое города, увлекательные рассказы о мостах, исторических набережных, храмах и монастырях, старинных палатах и особняках, жилых домах, памятниках природы. Книга хорошо иллюстрирована старыми и новыми фотографиями, схемами.\nИздание предназначено для широкого круга читателей, тех, кто собирается путешествовать по исторической Москве-реке или гулять по её набережным.	ИЦ Москвоведение	2014	Твердая
105	88	13	Family and Friends. Level 2. 2nd Edition. Workbook	649	covers/book_105.webp	Новое издание Family and Friends сочетает в себе обучение совершенно новым навыкам владения языком, культуру, систему оценки и цифровые ресурсы с функциями, которые понравились учителям из первого издания: быстрый темп изучения языка, тренировка сильных навыков, уникальная программа акустики, гражданское воспитание и всестороннее тестирование.\nСодержание рабочей тетради полностью соответствует учебнику. Издание содержит упражнения для повторения и закрепления изученного материала.	Oxford	2022	обл - мягкий переплет
106	89	13	Kid's Box New Generation. Level 3. Activity Book with Digital Pack	1086	covers/book_106.webp	Kid's Box New Generation - это семиуровневый курс общего английского языка, который позволяет учащимся достичь уровня A2 к концу курса. Это также официально утвержденный материал для подготовки к экзаменам, программа которого соответствует требованиям Кембриджской программы подготовки к английскому языку для учеников младших классов.\nЦветная рабочая тетрадь охватывает изучаемый материал из учебника. Одно экзаменационное практическое занятие в каждом разделе знакомит детей с форматом Cambridge English Qualification для младших школьников.\nУникальный код доступа на лицевой стороне обложки открывает доступ к цифровым ресурсам, включающим в себя Practice Extra и материалы для учащегося. Practice Extra предоставляет ученикам уникальные домашние задания, дополняющие материал, изученный на занятиях, а также игры, мотивирующую программу обучения и легкий доступ ко всем аудио- и видеоматериалам курса.	Cambridge	2023	обл - мягкий переплет
107	90	13	Super Minds. 2nd Edition. Level 3. Super Practice Book	1196	covers/book_107.webp	Учебник содержит тематические юниты, приоритетная задача которых - подготовка к международным экзаменам.\nСодержание учебника дополнено материалами для изучения других предметов, например, арифметики и биологии, посредством английского языка.\nМежпредметные связи и развитие учебных и языковых навыков позволят расширить кругозор учеников, а увлекательный материал, предлагающий множество весёлых песен, игр, увлекательных рассказов и творческих заданий, развивающих смекалку и креативность, повысят интерес к изучению языка.\nВ учебнике представлены материалы, концентрирующиеся на моральных ценностях, которые помогут воспитать в детях ответственное отношение к окружающим людям и миру.\n	Cambridge	2022	обл - мягкий переплет
108	89	12	Kid's Box. Level 6. Updated Second Edition. Pupil's Book	1345	covers/book_108.webp	Учебник содержит тематические юниты, приоритетная задача которых - подготовка к международным экзаменам.\nСодержание учебника дополнено материалами для изучения других предметов, например, арифметики и биологии, посредством английского языка.\nМежпредметные связи и развитие учебных и языковых навыков позволят расширить кругозор учеников, а увлекательный материал, предлагающий множество весёлых песен, игр, увлекательных рассказов и творческих заданий, развивающих смекалку и креативность, повысят интерес к изучению языка.\nВ учебнике представлены материалы, концентрирующиеся на моральных ценностях, которые помогут воспитать в детях ответственное отношение к окружающим людям и миру.\n	Cambridge	2017	обл - мягкий переплет
109	91	13	Friends. Starter Level. Students' Book	2365	covers/book_109.webp	Учебник поделен на модули, каждый из которых имеет четкую структуру из серии уроков, понятную ученикам. Первые четыре модуля - введение и отработка нового материала. После каждого четвертого урока следует урок повторения языкового материала юнита. Задания этого урока включают лексические, грамматические, задания на произношение и исполнение песни. После урока повторения всегда будет урок по чтению Reading Corner или интегрированный урок Culture Corner, где идет работа над всеми четырьмя навыками. В конце книги ученики найдут сценарий пьесы (мини-спектакля), список слов, список неправильных глаголов и фонетическую таблицу.	Pearson	2002	обл - мягкий переплет
110	92	13	Own it! Level 3. Student's Book with Digital Pack	1454	covers/book_110.webp	Own It! это четырехуровневый курс для учеников средних классов, обеспечивающий уверенность учащихся и их готовность к будущему благодаря изучению глобальных тем, выполнению совместных проектов и стратегиям развития самостоятельности учащихся.\nС помощью Own It! подростки развивают уверенность в своих силах и навыки, необходимые им для того, чтобы проложить свой собственный путь в нашем постоянно меняющемся мире. От развития навыков критического и творческого мышления и социальных/эмоциональных предрасположенностей до эффективной работы в группе - Own It! помогает сформировать уверенных в себе, готовых к будущему студентов, способных решать стоящие перед ними задачи.\nУчебник включает в себя полный доступ ко всем цифровым ресурсам для учащихся, включая программу для мобильных устройств Practice Extra (содержит дополнительные тренировочные задания и игры для каждого раздела) и доступ к цифровой среде для совместной работы.	Cambridge	2020	обл - мягкий переплет
111	93	14	"Можно уйти пораньше?". Мифы, стереотипы и предубеждения, которые вредят работодателям	880	covers/book_111.webp	Мы думаем, что покупка стола для настольного тенниса сделает персонал счастливее, а работа по восемь часов в день пять дней в неделю обеспечит максимальную производительность. Считаем, что высокая зарплата всегда приводит к повышению мотивации. Но так ли это на самом деле?\nСуществует огромное количество мифов, стереотипов и устаревших правил, которые связаны с отношениями между работником и работодателем. Они могут мешать вам и вашей команде получить максимальную отдачу от приложенных усилий. Ян Макрей - карьерный психолог, разработчик уникальной методики ассесмента, применяемой более 50 000 специалистов по всему миру. Адриан Фернхем - профессор психологии, автор более 70 книг. В своей книге они рассматривают 27 заблуждений, связанных с организацией наемной работы, от которых пришла пора избавиться!	Феникс	2024	Твердая
112	94	14	Суперсапиенс. Как познать человеческий разум и развить в себе сверхспособности	811	covers/book_112.webp	Нерешительность - самая распространенная причина неудач.\n\nСобираться порвать отношения с партнером и никак не находить в себе сил сделать это.\n\nРазмышлять о поисках лучшей жизни в другой стране и изучении языка, но раз за разом придумывать отговорки.\n\nХотеть уйти с работы, на которой у тебя, по твоим ощущениям, нет будущего, но оставаться на ней из страха, что не найдешь ничего лучшего.\n\nМечтать об идеальной физической форме и постоянно переносить занятия на "следующий понедельник".\n\nОткрыть свой бизнес и планировать совершить прорыв, который принесет тебе финансовую свободу, но продолжать двигаться по прежней траектории.\n\nВсе это - следствия прокрастинации, или привычки откладывать на потом.	Попурри	2024	Твердая
113	95	14	Невероятный мозг подростка. Инструкция по примирению, расшифровке и раскрытию потенциала	812	covers/book_113.webp	Подростковый мозг уникален и обладает невероятными возможностями, что доказывают новейшие исследования нейробиологов. Родители, педагоги и специалисты найдут в этой книге разумные и полезные рекомендации, как обращаться с подростками, а также ответы на самые главные вопросы:\n- Возможен ли баланс между доверием и контролем в отношениях с подростком?\n- Почему сверстники для подростка важнее родителей и так ли это на самом деле?\n- Нужно ли волноваться, если подросток зависает в социальных сетях?\n- Как поддержать и защитить подростка, когда это необходимо?\n- Можно ли научить подростка регулировать эмоции и противостоять вызовам?\n- Что делать, если у подростка повышенная тревожность или депрессия?\n- Как в этот турбулентный период мотивировать подростка к обучению и творчеству?\nСледуя подробным инструкциям команды опытных клинических психологов, вы поможете подросткам решить их проблемы, наладите общение и раскроете огромный потенциал их мозга.	Портал	2023	Твердая
114	96	14	Майндхакинг. Как мозг принимает решения и заставляет нас действовать в режиме НЕ-ТВОЯ-ЖИЗНЬ	780	covers/book_114.webp	Перед вами инструкция по самопознанию - ваш ключ к самому себе. Опираясь на новейшие научные исследования, автор объясняет, почему мы поступаем так, как поступаем, какие эмоции нами управляют и как это изменить.\nВ книге вы найдете специальные упражнения, которые можно выполнять прямо во время чтения и сразу видеть, как меняются ваши переживания, восприятие себя и какой эффект производят ваши действия.\nМы вполне можем влиять на то, что с нами происходит. У нас достаточно ресурсов для того, чтобы прекратить жить в режиме НЕ-ТВОЯ-ЖИЗНЬ и меняться к лучшему без насилия над собой!	Портал	2024	Твердая
115	97	19	Работы по дереву. Лучшие проекты мебели для двора и сада	1276	covers/book_115.webp	ОБУСТРОЙТЕ СВОЙ УЧАСТОК НАИЛУЧШИМ ОБРАЗОМ\nУкрасьте ваш двор или сад мебелью, сделанной собственными руками! Здесь вы найдете 20 полезных и привлекающих внимание проектов различных уровней сложности, – от простейших до изысканных. Осуществить проекты вам помогут, как всегда актуальные и практичные советы, рекомендации, комментарии и пошаговые инструкции автора – из-вестного мастера и популяризатора столярного дела. От подбора инструмента и приемов его использования до современных методов и хитростей работ по дереву – всеми этими знаниями автор щедро делится с читателем. Тут каждый выберет для себя проекты по вкусу, а также найдет чему поучиться и в чем совершенствоваться.	АСТ	2022	Твердая
116	98	19	Модельное вязание по швейным выкройкам. Инновационное практическое руководство	1731	covers/book_116.webp	Вяжите то, что вы хотите, а не то, что вы умеете!\nОткрытие для всех, кто терпеть не может сшивать детали вязаного изделия!\nКнига замечательного мастера и самого известного автора вязальных бестселлеров Анны Котовой, которая и сама терпеть не могла это делать, по-настоящему рушит границы и заставляет прочувствовать все преимущества вязания с использованием швейных выкроек.\nЗачем вязать со швами?\nВаши возможности расширяются невероятно! Теперь любая сшитая вещь с подиума или из журнала может быть вами связана!	Эксмо	2022	Твердая
117	99	15	Цифровая обработка изображений	1372	covers/book_117.webp	Настоящее издание является результатом значительной переработки книги "Цифровая обработка изображений" (Гонсалес и Уинтц, 1977 г. и 1978 г.; Гонсалес и Вудс, 1992 г. и 2002 г.) Одна из важнейших причин популярности книги, которая уже более 30 лет является мировым лидером в своей области - высокая степень внимания авторов к изменению образовательных потребностей читателя. Нынешнее издание базируется на самом обширном из когда-либо проводившихся исследований читательского мнения.\nКак и прежде, основные цели книги - служить введением в основные понятия и методы цифровой обработки изображений, а также создать основу для последующего изучения и проведения самостоятельных исследований в этой области. Все разделы сопровождаются большим количеством примеров и иллюстраций.	Техносфера	2019	Твердая
118	100	15	Алгоритмы сжатия данных без потерь. Учебное пособие для вузов	1804	covers/book_118.webp	Учебное пособие содержит описание алгоритмов сжатия данных без потерь, включающее классификацию этих алгоритмов, их обсуждение на концептуальном уровне и на уровне программной реализации, сравнительный анализ результатов их практического применения, рекомендации по выполнению курсового проекта по данной теме. Также обсуждаются смежные вопросы: особенности работы с двоичными данными, формирования заголовочной части сжатого файла, применение вспомогательных алгоритмов, повышающих эффективность сжатия, и объектно ориентированного подхода к реализации алгоритмов сжатия.\nПособие предназначено для бакалавров направления "Программная инженерия".\n3-е издание, стереотипное.	Лань	2023	Твердая
119	101	15	Основы создания успешных инди-игр от идеи до публикации. Советы начинающим разработчикам	943	covers/book_119.webp	Если вы ничего не смыслите в разработке игр, но хотите зарабатывать этим на жизнь, эта книга специально для вас!\n\nОна предназначена для начинающих и не ждет от читателя никаких знаний в области гейм-дизайна. Автор Влад Маргулец проведет вас через непростой пошаговый процесс разработки игр и расскажет, как создаются инди-игры — как с творческой, так и с деловой точек зрения.	Бомбора	2020	Твердая
120	102	16	Рокет-йога. Руководство по прогрессивной аштанга-виньяса-йоге	1270	covers/book_120.webp	Выйдите за рамки классической йоги с помощью прогрессивной и динамичной практики рокет-йоги. Этот стиль, основанный на традиционной аштанга-йоге, дает больше свободы движений и помогает черпать силу в своей практике посредством творчества, выносливости и ритма.\nРуководство начинается с безопасных упражнений для подготовки к практике, после чего вашему вниманию представлена целая библиотека асан с потрясающими фотографиями и подробными инструкциями для более чем 90 поз. Каждая поза сопровождается вариантами выполнения, позволяющими адаптировать движения к возможностям вашего тела, что поможет в составлении индивидуального плана занятий.	Попурри	2025	обл - мягкий переплет
121	103	16	Анатомия пилатеса. Иллюстрированное руководство	1405	covers/book_121.webp	Попурри	Таким пилатес вы еще не видели! Подробные описания, пошаговые инструкции и полноцветные анатомические иллюстрации позволяют вам в буквальном смысле слова заглянуть внутрь каждого упражнения, чтобы повысить мышечный тонус, улучшить гибкость тела и стабилизировать центр тяжести. Это пособие поможет вам понять, какие мышцы используются в упражнениях и как даже самые мелкие нововведения и вариации могут повлиять на их эффективность. Вы также узнаете, как осуществляется взаимосвязь дыхания, осанки, положения и движений вашего тела.	2025	обл - мягкий переплет
122	104	16	Анатомия силовых тренировок с гирями	1315	covers/book_122.webp	Попурри	Иллюстрированное руководство по развитию силы, подвижности и техники\nИспользуйте все преимущества занятий с гирями с помощью этой книги. В отличие от гантели или штанги, где вес равномерно распределяется на обоих концах ручки или грифа, гиря имеет асимметричную конструкцию и смещенный центр тяжести. Чтобы компенсировать неравномерность нагрузки, вам придется прилагать дополнительные усилия при выполнении упражнения, тем самым увеличивая силу, подвижность и устойчивость.\nКнига познакомит вас с 50 упражнениями, каждое из которых сопровождается полноцветными анатомическими иллюстрациями, изображающими задействованные мышцы и связки.	2025	обл - мягкий переплет
123	105	16	Библия стиля. Дресс-код успешной женщины	1998	covers/book_123.webp	В этой красивой книге собрано все, что должна знать деловая женщина о дресс-коде. Ведущие эксперты в области моды и стиля дают практичные рекомендации по выбору костюма для переговоров, встреч с клиентами, презентаций, деловых ужинов, светских мероприятий, отдыха и путешествий. Рассказывают о том, как правильно подобрать аксессуары - сумку, туфли, украшения - в зависимости от ситуации и статуса. В книге много полезных советов на все случаи жизни: начиная с того, как необычно завязать платок, кончая выбором правильной цветовой палитры для делового стиля.	Эксмо	2019	Твердая
124	106	16	Костюм и мода Российской империи. Эпоха Николая II	4270	covers/book_124.webp	Альбом посвящен одному из наиболее интересных и драматичных периодов в истории костюма и моды Российской империи - эпохе Николая II. Практически все в Российской империи носили униформу и имели право на мундир - гимназисты и кадеты, чиновники и купцы, священнослужители и даже дворники. Во время правления Николая II мода была наполнена разнообразными стилями и противоречивыми тенденциями: царили ориентализм и неорюс, модерн и ампир, рококо и парижский авангард. В книге показано влияние политических событий, литературы, искусства, локальных конфликтов и войн на стиль жизни и костюмы в период с 1890-1917 гг.\nКнига, основанная на архивных документах, дневниках и воспоминаниях, распоряжениях императора и министерств, правилах ношения мундиров, табели имуществ, дает изумительно точный визуальный портрет эпохи. Практически все фотографии, рисунки и карикатуры, вошедшие в альбом, публикуются впервые.	Этерна	2024	Твердая
125	107	17	Садовник Снов	676	covers/book_125.webp	Это прекрасная история о книгах и чтении. Дань уважения первым прочитанным в жизни страницам и бесконечным приключениям, которые распахивают перед нами двери в мир фантазий.\nДля дошкольного и младшего школьного возраста.	Попурри	2025	Твердая
126	108	17	Как жила Тася	647	covers/book_126.webp	Активно писать Мария Толмачёва начала уже в зрелом возрасте, когда переехала из Нижнего Новгорода в Петербург и стала посещать литературные вечера, устраиваемые издателями детского журнала "Тропинка". Там она подружилась с матерью Александра Блока, а позже стала общаться и с ним самим. Повесть "Как жила Тася", опубликованная в 1913 году, сразу привлекла к Марии Толмачёвой внимание читающей публики. После революции она продолжала писать для детей, одновременно работая в дошкольных учреждениях. Умерла писательница в блокадном Ленинграде, оставив многим поколениям читателей трогательные истории про маленьких героев.	Качели	2022	Твердая
127	109	17	Чучело	946	covers/book_127.webp	Одна из тех книг, которые обязательно нужно прочесть подростку - непростая, волнующая и очень честная история о детской жестокости, но и о милосердии, сострадании и внутренней силе. Двенадцатилетнюю Ленку Бессольцеву сразу невзлюбили одноклассники, её прозвали Чучелом, сделали изгоем, ей объявили бойкот, травили всем классом, а тот, кого она считала другом, струсил и предал. Но несмотря ни на что она сумела остаться собой и стать девочкой, которая победила.\nПовесть Владимира Железникова, по которой был снят замечательный одноимённый фильм, выходит с новыми, светлыми и тонкими иллюстрациями Марии Спеховой.\nДля детей 9-12 лет.	Лабиринт	2020	Твердая
128	110	17	Книга Безобразий Малютки Волка	473	covers/book_128.webp	Все, чего хотел Малютка Волк, - это остаться дома. Но нет, его посылают в Колледж Хитрюг, чтобы он наконец-то научился плохо себя вести, стал настоящим зверем и получил Злую медаль. Тогда родители смогут им гордиться!\nДля детей 7-10 лет.	Лабиринт	2020	Твердая
129	111	18	50 мощных принципов для ясного и эффективного мышления, или Как рассуждать логически	435	covers/book_129.webp	Что общего у древнегреческого философа и человека, получившего страховку за выкуренные им же самим сигары? И тот и другой задействовали мышление — с разной мотивацией, но с одинаковой изобретательностью. Эта книга приглашает вас в увлекательное путешествие по лабиринтам логики, анализа и здравого смысла. Автор с легкостью соединяет анекдоты, философские идеи и практические советы, чтобы показать, как развить по-настоящему ясное мышление.	Весь	2025	обл - мягкий переплет
130	112	18	Почему культура постоянной занятости и заботы о себе делает нас тревожными, напряженными	522	covers/book_130.webp	Почему культура постоянной занятости и заботы о себе делает нас тревожными, напряженными и выгоревшими — и как освободиться\n\nСегодня успех измеряется не только достижениями в профессиональной сфере, но и тем, как мы выглядим. Мы должны быть не просто продуктивными и эффективными, а осознанными, стройными, подтянутыми, дисциплинированными — пить теплую воду с лимоном по утрам, читать по книге в неделю, уделять время себе: бегать, йога или ходить в зал, стильно выглядеть, посещать психолога или заниматься духовными практиками. Но при этом не понятно — как все успевать. Мир будто шепчет нам: «Ты должен стараться еще больше. Бери себя в руки. Все зависит только от тебя». А если не получается — значит, с тобой что-то не так.	Весь	2025	обл - мягкий переплет
131	113	18	В плену чужой судьбы. Практика системных расстановок	350	covers/book_131.webp	Судьба. Что это такое? Мы принимаем свою судьбу или боремся с нею, сопротивляемся ей или благодарим ее, отрекаемся от своей судьбы или смиряемся с нею. Но что делать тем, кто попадает в ловушку чужой судьбы?\nМне жаль таких людей, они плывут по извилистым путям своих предков. Но более всего меня трогают немыслимые истории невинных, оказавшихся в плену чужой судьбы, попавших в ловушку семейных переплетений или ставших приютом для неприкаянных сущностей. И не важно, как они попали в этот водоворот: отказавшись от своего предназначения или движимые порывами слепой любви или потребностью быть причастными к своей семейной системе.	Весь	2025	обл - мягкий переплет
132	114	18	Введение в "Таро лунных дней"	522	covers/book_114.webp	Книга сопровождает уникальную колоду "Таро лунных дней". Человек рождается в определенные лунные сутки, энергия которых накладывает отпечаток на всю его жизнь. Мы ежемесячно проходим все 30 лунных ритмов, которые несут в себе невидимое излучение и особую информацию. Дни Луны имеют собственные оттенок цвета, символ и ритм. Они связаны с определенной чакрой, тонким планом и, наконец, с арканами "Таро лунных дней", которых в данной колоде 86 (вместо привычных 78), плюс Белая и Черная карты.\nПодобно Луне, персонажи карт проходят череду символических метаморфоз. Они представляют богов и героев древних мифов разных народов, включают в себя образы мистических озарений автора и магических миров фэнтези. Архетипы карт также повествуют о путешествиях человеческой души. Их подробное описание с отсылками к истории, мифологии и искусству и составляет большую часть книги, которая понравится всем, кто хочет глубже понять Таро и использовать его как инструмент самопознания, предсказания и магической практики.	Весь	2025	обл - мягкий переплет
133	115	21	Super Mario. Как Nintendo покорила мир	801	covers/book_133.webp	В 1981 году Nintendo of America находилась на грани краха, когда Сигэру Миямото разработал знаменитую Donkey Kong, которая положила начало карьере пухлого водопроводчика по имени Марио. С тех пор Марио получил собственную франшизу, появился более чем в двух сотнях игр, принес компании миллиардную прибыль и стал более узнаваемым, чем Микки Маус.\nЧитайте невероятную историю Марио и узнайте, как он стал лицом компании Nintendo и помог ей покорить Америку и весь мир!	Бомбора	2023	Твердая
134	5	21	Harry Potter. Мастерская Магии Гарри Поттера. Официальная книга творческих проектов	4564	covers/book_134.webp	Перед вами официальная книга по волшебному миру Гарри Поттера. Более 25 проектов с иллюстрированными пошаговыми инструкциями, чтобы погрузиться в мир магии и волшебства. Ты узнаешь как сделать свою собственную Бузинную палочку и футляр для нее из магазина Олливандера, Маховик времени, выпрыгивающую из коробки шоколадную лягушку, Кубок огня из бумаги и многое другое! Внутри ты найдешь знаковые цитаты, кадры из фильмов и красивые концепт-арты о Гарри Поттере, а забавные факты и закулисные моменты помогут глубже погрузиться в волшебный мир и еще больше вдохновят на творчество. Приготовься, пришло время для волшебства!	Бомбора	2022	Твердая
135	116	22	Баланс мамы и ребенка. Как понять, что ничего не упускаешь в развитии ребенка	650	covers/book_135.webp	Когда рождается ребёнок, самым важным для женщины становится умение находить баланс - между самореализацией и материнством, заботой о ребёнке и супружеской жизнью, любовью к ребёнку и строгостью в воспитании, интеллектуальным и эмоциональным развитием ребёнка.\nВ этой книге вы познакомитесь с обычной работающей мамой, которая мечется между крайностями в поисках баланса. Постепенно главная героиня осваивает премудрости материнства и день за днём стремится достичь желанной "золотой середины" в воспитании и развитии. Вместе с ней вы сможете разобраться, как воспитывать ребёнка, чтобы он овладел всеми важными качествами для будущей жизни, научитесь расставлять приоритеты в общении с ребёнком, а также составите список активностей и занятий (индивидуальный план развития), который действительно подходит вам и вашему ребёнку.\nКнига поможет сохранить баланс в жизни мамы и всей семьи.	Феникс	2022	Твердая
136	117	22	Хорошие новости о плохом поведении. Самые непослушные дети за всю историю человечеств	555	covers/book_136.webp	Наши методы и представления о том, как приучить детей к порядку, дисциплине, внимательности не работают. Видимо, они устарели так же, как устарели стационарные телефоны с дисковым номеронабирателем. Родители повсеместно жалуются на неорганизованность своих детей и на то, что традиционные методы воспитания не работают. И это не фантазии родителей. Данные исследований говорят о том, что да, у современных детей меньше самоконтроля, чем десятилетия назад у их ровесников.\nКэтрин Льюис провела блестящий анализ современных методов воспитания и рассказывает о тех, которые помогают изменить привычное (и нежелательное) поведение. Прочитав эту книгу, родитель будет смотреть на поведение своего ребенка не с тревогой, а с интересом, как на возможность выстроить прекрасные отношения с детьми. Вы будете уважать в своих детях личность и при этом спасете свою семью от хаоса.	Карьера Пресс	2019	Твердая
137	118	22	Как жаль, что мои родители об этом не знали (и как повезло моим детям, что теперь об этом знаю я)	718	covers/book_137.webp	Одна из самых цитируемых книг по воспитанию.\nБестселлер Великобритании.\n\nВсе мы когда-то были детьми. Ссорились и спорили с родителями, врали, чтобы избежать наказания, не понимали их и обижались, что они не понимают нас...\nСами став мамами и папами, мы стремимся дать своим детям самое лучшее и сделать их счастливыми. Но, оказывается, все не так просто...\n\nВ этой мудрой, теплой и невероятно искренней книге родители найдут ответы на самые важные вопросы:\n- как не позволить травмам прошлого испортить ваши отношения с ребенком;\n- почему важно разделять любые чувства ребенка, а не отмахиваться от них;\n- как наладить связь с малышом с первых дней жизни;\n- почему в семейных отношениях нет места для манипуляций и шантажа;\n- как выстраивать границы с детьми постарше и подростками;\n- почему важно научиться видеть в ребенке человека, а не объект воспитания.	Бомбора	2020	Твердая
163	144	33	Ужасная Макико	835	covers/book_163.webp	Юной демонице Макико не повезло родиться дурнушкой. Но мириться с этим прискорбным обстоятельством она не собирается, тем более что у нее есть способ изменить судьбу - для того, чтобы стать самой прекрасной обитательницей ада, ей всего лишь нужно затащить в преисподнюю несколько невинных человеческих душ. Сумеет ли она осуществить свое заветное желание или неожиданно обнаружившаяся в ней доброта обречет ее на вечные страдания? Эти и другие истории о демонах - в сборнике классических произведений Хидеши Хино.	Фабрика комиксов	2023	Твердая
138	119	23	Как построить карьеру руководителя. Золотые секреты министра	606	covers/book_138.webp	Автор книги, проработавший около 25 лет в ранге министра Правительства г. Москвы - префектом ЮВАО, в популярной форме раскрывает секреты успешной карьеры руководителя и рассказывает о собственном опыте, весьма интересном и поучительном. Под его началом выросли более 140 руководителей самого высокого ранга.\nЗа годы, отданные сначала оборонной промышленности нашей Родины, а затем управленческой деятельности самого высокого ранга, Владимир Борисович сформулировал и отточил алгоритм построения систем и элементов управления, ориентированных на высокие результаты. Его опыт - практический. Стремясь поделиться накопленными знаниями и навыками, он перечисляет конкретные шаги, которые помогут руководителям создать свой стиль и системный подход к трудовой и поведенческой деятельности, чтобы быть эффективными и продвинуться по карьерной лестнице.\nТакже в книге приводятся реальные случаи из управленческой практики с конкретными и емкими по содержанию выводами в виде резюме. Это отличное подспорье любому руководителю в самых разных жизненных ситуациях.\nКнига рассчитана на широкий круг читателей. Изложенные в ней рекомендации являются универсальными и будут полезны для руководителей разных уровней, государственных служащих, аспирантов и студентов управленческих вузов, старшеклассников, а также для тех, кто занимается вопросами управления в бизнесе.\n2-е издание.	Феникс	2024	Твердая
139	120	23	Привычки на миллион. Проверенные способы удвоить и утроить свой доход	739	covers/book_139.webp	Наши мысли, наши чувства и наши поступки на 95 процентов предопределяются нашими привычками. Привычки имеют глубокие корни, но мы способны их изменить: отжившие свое и ставшие вредными привычки можно заменить новыми, полезными — и это сразу же принесет свои плоды.\nВ этой книге знаменитый Брайан Трейси учит читателей развивать привычки, присущие успешным людям, чтобы они могли принимать более разумные решения и в конечном счете удвоили, а то и утроили свои доходы.\n\nВы узнаете:\n• как оптимально распоряжаться своими финансами\n• как укрепить здоровье и улучшить самочувствие\n• как научиться жить в ладу с другими людьми\n• как достичь финансовой независимости\n• как стать настоящим лидером, который свои мечты претворяет в реальность	Попурри	2025	Твердая
140	121	23	Думай и богатей. Для современного читателя	235	covers/book_140.webp	Человек может достичь всего, что способен постичь и принять разумом.\nВ этом высказывании выведена формула успеха - настолько простая, что ее может применить любой, и в то же время настолько сложная, что лишь единицы из нас когда-либо полностью ее реализуют. Именно на ней построена философия успеха, объясняющая, каким образом человеческие желания могут воплотиться в материальную реальность. Именно благодаря ей самые богатые люди в мире - богатые в самых разных смыслах: деньгами, отношениями, властью, душевным спокойствием и социальным статусом, - выстраивали и поддерживали свое благосостояние. Именно она лежит в основе науки успеха - философии достижений, которая помогла покончить с Великой депрессией и с тех пор создала больше миллионеров, культовых личностей и лидеров мнений, чем любая другая.\nКнига представляет собой краткое изложение оригинального текста шедевра Наполеона Хилла 1937 года. В ней собраны ключевые принципы, рекомендации и примеры, чтобы современный профессионал тоже мог извлечь пользу из актуальной во все времена мудрости Хилла, открыв для себя путь к стремительному личностному росту и придав импульс воплощению своей мечты.	Попурри	2025	обл - мягкий переплет
141	122	24	Управление человеческими ресурсами. Учебное пособие	133	covers/book_141.jpg	В учебном пособии, написанном в соответствии с требованиями Федерального государственного образовательного стандарта, рассматриваются все необходимые для изучения вопросы и проблемы в рамках одноименной дисциплины. Доступно и в увлекательной форме раскрываются основы и технология управления человеческими ресурсами, особенности планирования, привлечения, отбора, адаптации и обучения, оценки и аттестации трудовых ресурсов, а также вопросы управления карьерой. Большое внимание уделяется вопросам организации, нормирования, оплаты труда и управления мотивацией персонала. Подробно раскрыты особенности управления конфликтами, кадровой политики и формировании стабильного персонала, роль организационной культуры, психологической и этической культуры руководителя и многое другое.\nОт других книг это издание выгодно отличает ряд особенностей, связанных с организацией и подачей материала, что облегчает студентам освоение данной дисциплины, Часть материала представлена в виде удобочитаемых схем и таблиц, сопровождающихся комментариями, Материал книги легко усваивается и быстро запоминается. Каждая глава заканчивается тестами для самоконтроля.\nДля бакалавров, аудитов и преподавателей высших учебных заведений, менеджеров, руководителей различных уровней управления, руководителей служб управления персоналом, консультантов, организаторов внутрифирменного обучения, психологов, а также всех интересующихся вопросами управления человеческими ресурсами.	Феникс	2015	обл - мягкий переплет
142	123	24	Культурный интеллект. Почему он важен для успешности и как его развить	804	covers/book_142.webp	Если вы хотите развивать бизнес и эффективно управлять командой в современной мультикультурной среде, то вам не обойтись без развитого культурного интеллекта. Высокий CQ позволяет налаживать контакты по всему миру и сотрудничать с самыми разными людьми.\n\nДэвид Ливермор, президент Центра культурного интеллекта в США, опирается на результаты научных исследований и предлагает собственную модель для развития CQ. Автор не загружает информацией о конкретных особенностях наций или этносов, которую невозможно вместить ни в одну книгу. Но он учит глобально мыслить и адаптироваться к разным культурным контекстам, в том числе и отдельных организаций.\n\nЭта книга призвана помочь вам повысить CQ и научить использовать его осознанно и эффективно, чтобы культурный барьер не смог встать между вашей командой и успехом.	Манн, Иванов и Фербер	2023	Твердая
143	124	24	HR-аналитика. Путеводитель по анализу персонала	876	covers/book_143.webp	В книге раскрывается многогранная роль HR-анализа в бизнесе. Евгений Кириёк как практикующий HR-аналитик предлагает инструменты, необходимые специалистам по управлению персоналом, а также освещает проблемы, связанные с внедрением аналитики на предприятии.\nВ центре внимания автора - работа с данными, в том числе применение профессиональных приложений и метрик. Автор подробно описывает количественные и качественные методы исследований, обеспечение качества данных и правовые аспекты манипуляций с ними. Отдельно он рассматривает основы прогнозирования и опыт использования нейросетей.\nИздание адресовано тем HR-специалистам, которых привлекают к анализу и интерпретации данных. Оно станет незаменимым помощником и узким специалистам - профессиональным аналитикам, работающим в сфере HR.	Олимп-Бизнес	2024	обл - мягкий переплет
144	125	25	Аутентичный персональный ребренд. Новая история, новая карьера	593	covers/book_144.webp	Почему нельзя просто «быть самим собой».\nКак личный бренд сделает вас успешнее, богаче и счастливее.\nКогда стоит проводить ребрендинг.\nПочему разделяют собственный бренд и бренд компании.\nКаким образом 12 архетипов Юнга помогают выстраивать личный бренд.\n\nВ этой книге аккумулирован весь комплекс знаний о выстраивании профессионального имиджа и о том, как, когда и почему необходимо заняться ребрендингом. Ясир Маттар ведет живой диалог с читателем, давая ему пошаговую инструкцию создания и модификации личного бренда в эпоху быстрых трансформаций — от первых опытов до создания портфолио.\nЗначительное место уделяется методу сторителлинга и инструкциям, «как надо» и «как не надо» излагать факты.\nЭта информирующая, обучающая, вдохновляющая и мотивирующая книга предназначена для начинающих и опытных маркетологов, для специалистов разных областей и для самого широкого круга читателей, которые ищут свой образ и стремятся быть в тренде.	Олимп-Бизнес	2024	обл - мягкий переплет
145	126	26	Мустафа Кемаль Ататюрк — основатель новой Турции	736	covers/book_145.webp	Кемаль Ататюрк - самый известный в мире турецкий политик. Уинстон Черчилль называл Мустафу Кемаля "человеком судьбы". Именно он создал современную Турцию. Кемаль был выдающимся полководцем. С его именем прежде всего связана турецкая победа в битве за Дарданеллы. Кемаль-паша был одним из немногих турецких полководцев, кто успешно сражался против всех противников Турции в Первой мировой войне - против англичан и французов на Галлиполийском полуострове, в Палестине и Сирии, против русских на Кавказе. Его военная карьера знала заметные взлеты, обычно тогда, когда Турция оказывалась в критическом положении, но нередко после взлета он бывал оттеснен на маргинальные позиции, чтобы потом вновь возвыситься. После капитуляции Турции он оказался одним из немногих, кто не сдался. Кемаль блестяще выиграл казавшуюся безнадежно проигранной войну с Грецией, обеспечил сохранение независимости Турции и заложил основу того подъема, который эта страна испытывает в последние десятилетия. Он совершил то, что казалось невозможным, - сделал из средневековой, азиатской Оттоманской империи современную европейскую Турцию (хотя географически основная часть страны остается в Азии). Он заставил турок одеть шляпы вместо фесок, принять латиницу вместо арабского, жить по европейским судебным кодексам, заниматься промышленностью и торговлей. Ататюрку нравилась тяжелая солдатская жизнь. Он был умен и бесстрашен. Он был патриотом, хотел модернизировать свою страну и привнести в нее европейские культурные ценности, сделать ее светским государством. Но на пути к своей цели он порой применял азиатские средства, расправляясь со своими противниками. Также и европейский образ жизни, которому Кемаль следовал, он принял со всеми излишествами, что значительно укоротило его жизнь. Но в памяти потомков он остался благодаря тому, что построил новую Турцию.	Вече	2025	Твердая
146	127	26	Любовь к жизни	740	covers/book_146.webp	Мари Фредрикссон (1958–2019) — шведская певица, композитор, солистка знаменитой группы Roxette, прославившейся благодаря таким хитам, как «Joyride», «The Look», «It Must Have Been Love» и «Listen to Your Heart». В 2002 году у неё обнаружили опухоль головного мозга. Несмотря на тяжёлые последствия лучевой терапии, Мари продолжила музыкальную карьеру и даже вернулась на сцену.\n\n«Я лишь хочу рассказать о том, как всё было. Без прикрас. Чистую правду». Именно так Мари Фредрикссон описала идею этой книги журналистке и писательнице Хелене фон Цвейгберг.\n\nВ этой книге слово предоставлено Мари Фредрикссон, её родным и близким. На этих страницах — рассказ о большой любви, бездонной печали, невероятном успехе и реванше, взятом вопреки всем превратностям судьбы. И всё это лишь благодаря огромной любви к жизни.	Городец	2022	Твердая
147	128	27	Как плавать среди акул.Как обойти конкурентов в торговле, управлении, мотивации, ведении переговоров	505	covers/book_147.webp	Успех принадлежит вам!\n\nИзвестный миллионер Харви Маккей правдиво и доступно расскажет вам о том, как обойти своих конкурентов в:\n• ТОРГОВЛЕ — добиваясь деловых встреч с людьми, которые поначалу вообще не хотят вас видеть, а затем с радостью отвечают «да!» на ваше предложение\n• УПРАВЛЕНИИ — вооружившись такой информацией о своих клиентах и конкурентах, которой позавидовало бы даже ЦРУ\n• МОТИВАЦИИ — используя идеи, которые помогут вам и вашим детям влиться в ряды миллионеров\n• ВЕДЕНИИ ПЕРЕГОВОРОВ — зная, когда следует улыбаться и говорить «нет», а когда «подсылать двойников»	Попурри	2025	обл - мягкий переплет
148	129	27	Малый бизнес на языке цифр. Берем финансовые показатели под контроль	867	covers/book_148.webp	Из книги вы узнаете:\n- Зачем нужны управленческий учет и "оцифровка" бизнеса\n- Как за цифрами отчетов увидеть бизнес-процессы, деньги, риски и возможности\n- Почему важно регулярно собирать данные, необходимые для развития бизнеса\n- Откуда и куда течет ваш денежный поток: прибыль, налоги, активы, обязательства\n- Как повысить точность планирования прибыли\n\nКнига содержит теорию и примеры, отчеты и графики с данными.\nОна поможет избежать ошибок, сбережет нервы и время и научит анализировать ключевые показатели бизнеса.\nИз первой главы вы узнаете о важности управленческого учета и принципах сбора данных.\nВо второй главе мы разберем, как описать бизнес "языком цифр": поймем, какие данные нужны именно вам.\nВ третьей главе рассмотрим главные управленческие отчеты и проанализируем работу компании, опираясь на цифры.\nВ четвертой главе изучим, как зарабатывать больше, управляя "оцифрованным" бизнесом: контролировать движение денег и привлекать инвесторов.\nАнализируйте финансовые отчеты, экономические показатели и аналитику и развивайте бизнес!	Олимп-Бизнес	2025	обл - мягкий переплет
149	130	28	Репетитор по химии	739	covers/book_149.webp	Пособие содержит подробное изложение основ общей, неорганической и органической химии в объеме, соответствующем программам углубленного изучения химии в средней школе и программам для поступающих в вузы. В пособии представлены все типы расчетных задач с решениями и типовые упражнения с эталонами ответов. К каждой изучаемой теме предлагается разнообразный дидактический материал для контроля (вопросы, упражнения, задачи разной степени сложности, тесты с выбором ответа).\nРекомендуется учащимся школ, гимназий и лицеев, слушателям факультетов довузовской подготовки, готовящимся к сдаче выпускного экзамена или конкурсного экзамена по химии при поступлении в вузы химического и медико-биологического профиля.\n65-е издание.	Феникс	2022	Твердая
150	131	28	Химия элементов. Книга тестов	388	covers/book_150.webp	Практическое пособие для подготовки к поступлению.\nКнига содержит огромное количество разнообразных тестов по химии элементов, адресована в первую очередь абитуриентам и репетиторам. Пособие окажет существенную помощь при подготовке к вступительным испытаниям по химии, в какой бы форме они ни проводились.\n* Тысячи тематических тестовых заданий с правильными ответами\n* Тщательно продуманная система тестов с учетом типичных ошибок абитуриентов\n* Задания на основе действующей программы вступительных испытаний по химии\n* Уровень сложности тестовых вопросов, соответствующий школьному курсу химии\n* Изложение учебного материала на высоком научном уровне, но в то же время простым и доступным для учащихся языком	Попурри	2018	Твердая
151	132	28	ОГЭ. Русский язык. Подготовка к итоговому собеседованию перед основным государственным экзаменом	221	covers/book_151.webp	Цель пособия - помочь учащимся 9 классов подготовиться к итоговому собеседованию, являющемуся допуском к основному государственному экзамену.\nКнига содержит 15 вариантов собеседования учащегося с преподавателем, которые по своему содержанию точно соответствуют экзаменационным материалам и позволяют полностью подготовиться к предстоящему испытанию. Каждый вариант включает четыре типа заданий: выразительное чтение вслух текста о выдающихся людях России, пересказ текста с привлечением дополнительной информации, тематическое монологическое высказывание и диалог, а также иллюстрированные карточки участника собеседования и карточки собеседника-экзаменатора.\nВ книге даны рекомендации по выполнению каждого задания экзаменационной работы и критерии оценивания их выполнения, что позволяет составить представление о требованиях к полноте и правильности развёрнутых ответов в устной форме.\nСборник будет полезен и учителям, которые найдут в нём необходимый материал для работы на уроках.	АСТ	2019	обл - мягкий переплет
152	133	29	Логопедические домашние задания для детей 5-7 лет с ОНР. Альбом 2. ФГОС ДО	115	covers/book_152.webp	Альбом 2 предназначен для работы с детьми 5-7 лет с ОНР. Он является составной частью комплекта из трех альбомов с логопедическими домашними заданиями по различным лексическим темам.\nЦель данного пособия - помочь логопеду спланировать коррекционную работу и привлечь родителей и воспитателей к выполнению несложных домашних заданий с детьми.\nПреимущество этих альбомов состоит в том, что родителям не нужно по заданию логопеда переписывать домашние задания, подбирать картинки, рисовать или наклеивать их в тетрадь. Красочные иллюстрации помогают поддержать интерес ребенка к занятиям.\nПособие адресовано логопедам, воспитателям логопедических групп и родителям детей с речевыми нарушениями.	Гном	2023	обл - мягкий переплет
153	134	29	Русский язык. 5 класс. Проверочные работы к учебнику Т. Ладыженской и др. ФГОС	148	covers/book_153.webp	Данное пособие полностью соответствует федеральному государственному образовательному стандарту.\nИздание предназначено для промежуточного контроля знаний учащихся по орфографии, пунктуации, лексике и фонетике.\nПособие содержит небольшие (выполнение займёт не более пяти-десяти минут) проверочные работы по всем темам курса русского языка 5 класса.\nИздание поможет проверить уровень усвоения учениками изученных тем, повторить и закрепить материал. После каждой работы предлагается выполнить работу над ошибками.\nИздание предназначено учителям, методистам, учащимся 5 классов.\nДопущено Министерством образования и науки РФ.	Экзамен	2023	обл - мягкий переплет
154	135	29	Русский язык. 2 класс. Рабочая тетрадь. В 2-х частях. Часть 2. ФГОС	343	covers/book_154.webp	Рабочая тетрадь подготовлена к учебнику "Русский язык. 2 класс" (авт. В. П. Канакина, В. Г. Горецкий), доработанному в соответствии с требованиями Федерального государственного образовательного стандарта начального общего образования (Приказ Министерства просвещения РФ № 286 от 31.05.2021 г.).\nВ пособии содержатся упражнения, которые повышают интерес к учебному процессу, направлены на формирование навыков учебной деятельности, текстовых умений, речевого и логического мышления.\nЗадания тетради помогут развить функциональную грамотность, коммуникативную компетентность, информационную культуру, исследовательское поведение учащихся.\nСистема упражнений позволяет расширять словарный запас младших школьников, формировать умение наблюдать и анализировать языковые явления.\n14-е издание, переработанное.	Просвещение	2024	обл - мягкий переплет
155	136	29	История. 5 класс. Готовимся к ВПР. Учебно-тренировочная тетрадь	150	covers/book_155.webp	В пособии представлены рекомендации для успешного выполнения заданий Всероссийской проверочной работы по истории и варианты заданий по всем элементам содержания курса истории Древнего мира, которые с максимальной долей вероятности могут быть включены в текст BПP. Материал пособия изложен в соответствии со структурой содержания курса истории Древнего мира.\nПособие предназначено как для учащихся 5 классов общеобразовательных школ, так и для преподавателей истории при организации изучения курса истории Древнего мира, его повторении и обобщении при подготовке к ВПР.	Феникс	2010	обл - мягкий переплет
156	137	30	Английский сонет	407	covers/book_156.webp	В двуязычный сборник английского сонета вошли образцы этой поэтической формы за четыре века - с XVI до начала XX. Среди представленных в сборнике тридцати трех имен Уильям Шекспир, Джон Донн, Джон Мильтон, Уильям Вордсворт, Перси Биши Шелли, Джон Китс, Альфред Теннисон, Данте Габриэль Россетти, Оскар Уайльд, Уильям Батлер Йейтс и другие прославленные поэты, а также стихотворцы, менее известные в России. Составитель - известный поэт, переводчик и исследователь англоязычной поэзии Г. М. Кружков, ему же принадлежат переводы всех сонетов, включенных в сборник. В книгу также вошло эссе Г. М. Кружкова о сонетах Уильяма Шекспира.\nСоставитель: Кружков Григорий.	Текст	2022	Твердая
157	138	30	Избранные страницы английской поэзии	647	covers/book_157.webp	\nВ эту двуязычную книгу вошли лучшие образцы английской поэзии от эпохи Возрождения до начала XX века.\nВ числе сорока восьми представленных здесь имен Филип Сидни, Джон Донн, Уильям Шекспир, Эндрю Марвелл, Уильям Блейк, Джон Китс, Альфред Теннисон, Редьярд Киплинг и другие прославленные поэты, а также поэты, ранее почти неизвестные в России.\nНесмотря на скромный объем сборника, по широте охвата и разнообразию жанров и стилей это издание приближается к формату антологии.\nСоставитель - известный поэт, переводчик и исследователя англоязычной поэзии Г.М. Кружков, ему же принадлежат все переводы, вошедшие в сборник.	Текст	2022	Твердая
158	139	31	Sésame 2. A1. Livre de l'élève	1812	covers/book_158.webp	Курс Sesame ориентирован на практическое применение французского языка в реальной жизни, поэтому подростки будут изучать полезные фразы, выражения и лексику для базовых тем, таких как путешествия, общение, работа и т.д.\nВесь курс Sesame представлен в простой и понятной форме, чтобы даже начинающие ученики могли легко понять материал и быть успешными в изучении французского языка. Учебник состоит из 6 блоков, которые построены на веселых и мотивирующих темах. Каждый из блоков включает 3 вводных урока, страницы с разделом "Je decouvre/Mes projets" (Я открываю/Мои проекты) и совместную квест-игру, которая помогает ученикам взглянуть внутрь себя и позволяет им мобилизовать и оценить свои знания.	Hachette FLE	2022	обл - мягкий переплет
159	140	31	Les Perce-Temps du Mont-Saint-Michel	1512	covers/book_159.webp	En visite scolaire au Mont-Saint-Michel, la jeune Alice est victime d'une chute temporelle. Séparée de sa classe mais guidée par les Veilleurs des Siècles, l'intrépide voyageuse va devoir affronter le dragon qui sommeille sous l'abbaye. Au fil de ses sauts à travers le temps, elle va ainsi observer la construction (et les effondrements) de l'abbatiale romane, croiser les anglais qui assiègent le Mont durant la guerre de Cent Ans ou encore apercevoir au loin le bombardement d'Avranches durant le débarquement de Normandie.\nMais c'est aussi l'environnement particulier du Mont-Saint-Michel qu'Alice va découvrir: cette baie où les sables mouvants et une marée extraordinaire re-dessinent sans cesse un paysage hostile de sable et d'eau... Heureusement, la curieuse licorne capturée sur les Iles Chausey va s'avérer être une monture courageuse et téméraire ; face aux éléments mais aussi pour combattre la monstrueuse créature dont il faudrait percer le coeur.\nEntre album illustré et bande dessinée, ce récit emmène les jeunes lecteurs dans le mille-feuille architectural et historique qu'est le Mont-Saint-Michel. S'appuyant sur les travaux des chercheurs, historiens et archéologues, il tente de donner à voir les états successifs de l'abbatiale, dont la construction débuta en 1023.	Editions du Patrimoine	2023	Твердая
160	141	32	Menschen A1.1. Kursbuch	506	covers/book_160.webp	Учебник Menschen A1.1 - это первая часть уровня A1 трехуровневого курса для взрослых по немецкому языку. Учебник имеет модульную структуру: каждый модуль состоит из трех коротких уроков и четырех дополнительных модулей (Modul-Plus). Материал каждого урока расположен на четырех страницах и имеет четкую повторяющуюся структуру. Каждый урок начинается с интересной вводной ситуации, которая обычно сопровождается аудиозаписью. Ситуация знакомит с темой урока и вызывает эмоции и интерес к теме. На следующем развороте, начиная с повторения исходной ситуации, вводятся и отрабатываются новые лексические структуры и идиомы с использованием аутентичных текстов для чтения и прослушивания. Новая лексика урока наглядно представлена в заголовке и легко запоминается с помощью мини-словаря с картинками. Заключительная страница модуля посвящена обучению письму, обучению устной речи или предлагает мини-проект, который основываются на материале урока, где основные лексические структуры еще раз повторяются. Четыре добавочные страницы Module Plus предлагают интересную информацию: журнал для чтения с различными дополнительными текстами для чтения, раздел “Film-stationen” (в нем содержатся задания, связанные с эпизодами фильма), проект по страноведению и заключение с советами по творческому использованию песен в классе. В конце учебника находятся страницы с дополнительными упражнениями на говорение и письмо, а также задания для парной и групповой работы и список слов.	Hueber Verlag	2022	обл - мягкий переплет
161	142	33	Кольцо Тьмы. Эльфийский клинок. Том 1	928	covers/book_161.webp	"Эльфийский клинок. Часть 1" - это первый комикс в серии "Кольцо Тьмы", знаменитом отечественном продолжении "Властелина колец" от мастера фэнтези Ника Перумова. В первой части "Эльфийского Клинка" начнётся долгое странствие по Средиземью. Хоббит Фолко вместе с гномом Торином отправляются в Аннуминас, чтобы доложить наместнику Арнора тревожные вести о вновь появившейся угрозе орков и захваченной подземным ужасом Мории.\nАвтор оригинального произведения Ник Перумов.	Alpaca	2022	Твердая
162	143	33	Психопанорама. Александр Андрианов	192	covers/book_162.webp	"Психопанорама" - это окно... Нет, это дыра... Черная глубокая дыра, ведущая в мир странных и пугающих фантазий, воплощенных на бумаге лучшими отечественными художниками и сценаристами. И сегодня мы погрузимся в мир... Александра Андрианова	Alpaca	2023	обл - мягкий переплет
90	75	10	Друзья, любимые и одна большая ужасная вещь. Автобиография Мэттью Перри	1089	covers/book_90.webp	Я знала, что он пережил невероятные страдания, но понятия не имела о том, сколько раз он стоял на грани жизни и смерти. Я рада, что ты с нами, Мэтти. Желаю тебе добра. Я тебя люблю. - Лиза Кудроу. Смешной, добрый, уморительный, остроумный. Именно таким знает весь мир Мэттью Перри и его героя из сериала Друзья Чендлера Бинга. Своими шутками он может довести до слез, одной фразой он может разрядить обстановку или нелепо, но эффектно грохнуться на пол. Шутник, комик и балагур. Но мало кто знает другого Мэттью. Того, кто много лет страдал от алкогольной и наркотической зависимостей, того, кто корчился и выл от боли, рыдал навзрыд и стыдился взглянуть в глаза своим близким. Месяцы, проведенные на больничной койке, кома, тяжелая реабилитация, годы в забытьи и борьбе с самим собой…	Бомбора	2022	Твердая
\.


--
-- TOC entry 3778 (class 0 OID 16564)
-- Dependencies: 237
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (id, book_id, count, cart_id, selected) FROM stdin;
110	82	1	20	f
111	61	1	20	f
112	62	1	20	f
\.


--
-- TOC entry 3790 (class 0 OID 16852)
-- Dependencies: 249
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, session_id, user_id) FROM stdin;
20	\N	19
21	\N	20
22	\N	22
\.


--
-- TOC entry 3788 (class 0 OID 16830)
-- Dependencies: 247
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveries (id, order_id, delivery_type, address_id, price) FROM stdin;
13	22	PICKUP	2	0
14	23	PICKUP	2	0
15	24	PICKUP	11	0
16	25	PICKUP	11	0
\.


--
-- TOC entry 3768 (class 0 OID 16477)
-- Dependencies: 227
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.genres (id, name, section_id) FROM stdin;
1	Зарубежная современная литература;	1
2	Зарубежная классическая литература	1
3	Русская современная литература	1
4	Русская классическая литература	1
5	Фантастика, фентези	1
6	Детектив	1
7	Любовный роман	1
8	Белорусская литература	1
9	Научная и специальная литература	2
10	Научно-популярная литература	2
11	Домашний мир, кулинария	2
12	Путеводители, карты, ПДД	2
13	Иностранные языки	2
14	Творчество, саморазвитие	2
15	ИТ-литература	2
16	Красота, спорт, питание	2
17	Художественная литература для детей	3
18	Развивающая литература	3
19	Досуг, творчество	3
20	Энциклопедии	3
21	Интерактивные, игровые книги	3
22	Книги для родителей\n	3
23	Саморазвитие, карьера	4
24	Менеджмент, управление	4
25	Маркетинг, реклама	4
26	Истории успеха	4
27	Предпринимательство	4
28	Подготовка к экзаменам и ЦТ	5
29	Рабочие тетради для школьников	5
30	Английский	6
31	Французский	6
32	Немецкий	6
33	Комиксы, манга, артбуки	7
\.


--
-- TOC entry 3780 (class 0 OID 16581)
-- Dependencies: 239
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, book_id, count, order_id) FROM stdin;
40	92	1	22
41	128	2	23
43	92	1	24
44	90	1	25
\.


--
-- TOC entry 3776 (class 0 OID 16552)
-- Dependencies: 235
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, date, status, pay_method, amount) FROM stdin;
22	20	2025-09-14	PROCESSING	RECEIPT	4497
23	20	2025-09-15	PROCESSING	RECEIPT	1654
24	22	2025-09-15	PROCESSING	RECEIPT	665
25	22	2025-09-15	PROCESSING	RECEIPT	1089
\.


--
-- TOC entry 3764 (class 0 OID 16461)
-- Dependencies: 223
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, text, book_id, rate) FROM stdin;
10		20	8
11		49	8
6		\N	10
7	Отличная книга!	\N	9
8	Очень понравилась история!	\N	10
15	Прочла книгу за 2 дня, на одном дыхании.. Вы знаете, для меня книга оказалось настолько эмоционально сильной, но вместе с тем, оставляющей такое сильное послевкусие грусти.. Обязательно прочтите все эту замечательную книгу о жизни одно потрясающего актера..	90	10
16		128	6
9	Норм	92	6
17	Любимый сериал!	90	10
18		92	10
19		128	6
\.


--
-- TOC entry 3766 (class 0 OID 16470)
-- Dependencies: 225
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (id, name) FROM stdin;
1	Художественная литература
2	Нехудожественная литература
3	Детская литература
4	Бизнес-литература
5	Учебная литература
6	Книги на иностранном языке
7	Комиксы, манга, артбуки
\.


--
-- TOC entry 3784 (class 0 OID 16795)
-- Dependencies: 243
-- Data for Name: shops; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shops (id, work_time, lat, lon, address_id) FROM stdin;
2	10:00 - 22:00	59.940776	30.347983	2
3	10:00 - 22:00	55.768025	37.623483	3
4	10:00 - 22:00	55.763761	37.607448	4
6	10:00 - 22:00	55.793627	49.116394	6
1	10:00 - 22:00	59.9343	30.3351	11
\.


--
-- TOC entry 3786 (class 0 OID 16807)
-- Dependencies: 245
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_addresses (id, address_id, user_id) FROM stdin;
14	11	19
15	2	20
16	12	20
17	4	20
18	11	22
\.


--
-- TOC entry 3770 (class 0 OID 16489)
-- Dependencies: 229
-- Data for Name: user_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_review (id, user_id, review_id) FROM stdin;
6	20	6
7	22	7
8	22	8
9	22	9
10	22	10
11	22	11
15	22	15
16	22	16
17	20	17
18	20	18
19	20	19
\.


--
-- TOC entry 3760 (class 0 OID 16443)
-- Dependencies: 219
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, first_name, last_name, email, phone, password_hash, is_verified) FROM stdin;
22	Мария	Марова	mary@gmail.com	+79096574534	scrypt:32768:8:1$hOgIkV45wEMeJiHg$29a0bfbe84edd93b7cf2dd950d58c38c941cef75471634a5751c8e7a8690ba621d8e9066c57c88bcc94e83ebb878c2da5ee1453f1ac93ded127a1ff028cfa850	t
17	Юзер	Юзеров	user@gmail.com	+79219991111	scrypt:32768:8:1$xN3vmY5Ps4fY1yal$d4f88fc8badd3a33d4a85f9b9188eef9aba89b3efc4156cdbce5722928224670da4665f70a3d84cb98b7072f8bb643a2c06dbbf457aedc31a08aeb0975640667	t
18	Юзер	Юзеров	user1@gmail.com	+79219991112	scrypt:32768:8:1$HZY9Hi5MJ6x73GcR$9db0875e8f63304a0cd65663b5506059565100078bf97621f348ce134611b3a0a07ea997ef7e26dc19ab8d6f2b2077f66c945f80abc45dd5f79cb5c21a568ad7	t
19	Юзер	Юзеров	user2@gmail.com	+79219991113	scrypt:32768:8:1$6A7DkIqCFbvYy0F9$b1320b22394847aa6a4a0e99df06fefe53f2711f1b7c62e4ffae08f1008b2cbd71477524b1291ea3505e8d08e193d180302666b7bf61b47a949605675ef747fb	t
20	Лиза	Булка	lisabulka@gmail.com	+79095835724	scrypt:32768:8:1$xOCjOIMJpjLHP6zn$2974a4d61bd83e358b7724e84ebb856d977c46f9a084c0b7126fe13313f557085a23ee5eee15992a7713f2a7248ccf0a4b058960b5873ce3c32495cdefcc0a9b	t
\.


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 240
-- Name: additions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.additions_id_seq', 11, true);


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 232
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_id_seq', 12, true);


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 220
-- Name: authors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authors_id_seq', 1, false);


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 230
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 1, false);


--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 236
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 121, true);


--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 248
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_id_seq', 22, true);


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 246
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveries_id_seq', 16, true);


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 226
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.genres_id_seq', 1, false);


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 238
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 44, true);


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 234
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 25, true);


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 222
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 19, true);


--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 224
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sections_id_seq', 1, false);


--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 242
-- Name: shops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shops_id_seq', 1, true);


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 244
-- Name: user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_addresses_id_seq', 18, true);


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_review_id_seq', 19, true);


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 218
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 22, true);


--
-- TOC entry 3584 (class 2606 OID 16657)
-- Name: additions additions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additions
    ADD CONSTRAINT additions_pkey PRIMARY KEY (id);


--
-- TOC entry 3576 (class 2606 OID 16545)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 3558 (class 2606 OID 16425)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3564 (class 2606 OID 16459)
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- TOC entry 3574 (class 2606 OID 16513)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- TOC entry 3580 (class 2606 OID 16569)
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3592 (class 2606 OID 16859)
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- TOC entry 3594 (class 2606 OID 16871)
-- Name: carts carts_session_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_session_id_key UNIQUE (session_id);


--
-- TOC entry 3590 (class 2606 OID 16835)
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- TOC entry 3570 (class 2606 OID 16482)
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- TOC entry 3582 (class 2606 OID 16586)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3578 (class 2606 OID 16557)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3566 (class 2606 OID 16468)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 3568 (class 2606 OID 16475)
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3586 (class 2606 OID 16800)
-- Name: shops shops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_pkey PRIMARY KEY (id);


--
-- TOC entry 3588 (class 2606 OID 16812)
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 3572 (class 2606 OID 16494)
-- Name: user_review user_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_review
    ADD CONSTRAINT user_review_pkey PRIMARY KEY (id);


--
-- TOC entry 3560 (class 2606 OID 16452)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3562 (class 2606 OID 16450)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3606 (class 2606 OID 16846)
-- Name: additions additions_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.additions
    ADD CONSTRAINT additions_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 3599 (class 2606 OID 16514)
-- Name: books books_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- TOC entry 3600 (class 2606 OID 16519)
-- Name: books books_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- TOC entry 3602 (class 2606 OID 16575)
-- Name: cart_items cart_items_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 3603 (class 2606 OID 16865)
-- Name: cart_items cart_items_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- TOC entry 3612 (class 2606 OID 16860)
-- Name: carts carts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3610 (class 2606 OID 16836)
-- Name: deliveries deliveries_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 3611 (class 2606 OID 16841)
-- Name: deliveries deliveries_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- TOC entry 3596 (class 2606 OID 16483)
-- Name: genres genres_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- TOC entry 3604 (class 2606 OID 16587)
-- Name: order_items order_items_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 3605 (class 2606 OID 16592)
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- TOC entry 3601 (class 2606 OID 16558)
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3595 (class 2606 OID 16872)
-- Name: reviews reviews_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 3607 (class 2606 OID 16801)
-- Name: shops shops_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shops
    ADD CONSTRAINT shops_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 3608 (class 2606 OID 16813)
-- Name: user_addresses user_addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 3609 (class 2606 OID 16818)
-- Name: user_addresses user_addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3597 (class 2606 OID 16495)
-- Name: user_review user_review_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_review
    ADD CONSTRAINT user_review_review_id_fkey FOREIGN KEY (review_id) REFERENCES public.reviews(id);


--
-- TOC entry 3598 (class 2606 OID 16500)
-- Name: user_review user_review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_review
    ADD CONSTRAINT user_review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


-- Completed on 2025-09-15 23:28:23 MSK

--
-- PostgreSQL database dump complete
--

