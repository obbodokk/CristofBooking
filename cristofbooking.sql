--
-- PostgreSQL database dump
--

\restrict gInqAWX7VHlsqh6feb6Ap0b6dlWFVmNsMqJB020FvTa7IdYPeGUWycADSp0FYRj

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amenities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amenities (
    amenitie_id integer NOT NULL,
    name character varying(100) NOT NULL,
    icon_url character varying(500)
);


ALTER TABLE public.amenities OWNER TO postgres;

--
-- Name: amenities_amenitie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.amenities_amenitie_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.amenities_amenitie_id_seq OWNER TO postgres;

--
-- Name: amenities_amenitie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.amenities_amenitie_id_seq OWNED BY public.amenities.amenitie_id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id integer NOT NULL,
    user_id integer,
    hotel_id integer,
    room_id integer,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    number_of_guests integer NOT NULL,
    total_price numeric(10,2) NOT NULL,
    status character varying(50) DEFAULT 'pending'::character varying,
    special_requests text,
    booked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    stay daterange GENERATED ALWAYS AS (daterange(check_in_date, check_out_date, '[)'::text)) STORED,
    CONSTRAINT check_dates CHECK ((check_out_date > check_in_date)),
    CONSTRAINT check_guests_positive CHECK ((number_of_guests > 0))
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bookings_booking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_booking_id_seq OWNER TO postgres;

--
-- Name: bookings_booking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bookings_booking_id_seq OWNED BY public.bookings.booking_id;


--
-- Name: guests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guests (
    guest_id integer NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    email character varying(200) NOT NULL,
    phone character varying(30),
    date_of_birth date NOT NULL,
    country character varying(50),
    registered_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_login timestamp without time zone
);


ALTER TABLE public.guests OWNER TO postgres;

--
-- Name: guests_guest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.guests_guest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.guests_guest_id_seq OWNER TO postgres;

--
-- Name: guests_guest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.guests_guest_id_seq OWNED BY public.guests.guest_id;


--
-- Name: hotel_amenities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotel_amenities (
    hotel_id integer,
    amenity_id integer
);


ALTER TABLE public.hotel_amenities OWNER TO postgres;

--
-- Name: hotels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hotels (
    hotel_id integer NOT NULL,
    hotel_name character varying(200) NOT NULL,
    description text,
    country character varying(50),
    city character varying(170),
    address character varying(400),
    postal_code character varying(30),
    star_rating integer,
    phone character varying(20),
    email character varying(200),
    website character varying(400),
    check_in_time time without time zone,
    check_out_time time without time zone,
    amenities text[],
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    image_main_url character varying(2000),
    image_gallery_urls text[],
    CONSTRAINT hotels_star_rating_check CHECK (((star_rating >= 1) AND (star_rating <= 5)))
);


ALTER TABLE public.hotels OWNER TO postgres;

--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hotels_hotel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hotels_hotel_id_seq OWNER TO postgres;

--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hotels_hotel_id_seq OWNED BY public.hotels.hotel_id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    hotel_id integer,
    guest_id integer,
    booking_id integer,
    rating integer,
    title character varying(300),
    comment text,
    cleanliness_rating integer,
    service_rating integer,
    location_rating integer,
    value_rating integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_approved boolean DEFAULT false,
    CONSTRAINT reviews_cleanliness_rating_check CHECK (((cleanliness_rating >= 1) AND (cleanliness_rating <= 5))),
    CONSTRAINT reviews_location_rating_check CHECK (((location_rating >= 1) AND (location_rating <= 5))),
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT reviews_service_rating_check CHECK (((service_rating >= 1) AND (service_rating <= 5))),
    CONSTRAINT reviews_value_rating_check CHECK (((value_rating >= 1) AND (value_rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_review_id_seq OWNER TO postgres;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_id integer NOT NULL,
    hotel_id integer,
    room_type character varying(100),
    description text,
    max_guests integer,
    beds_count integer,
    bed_type character varying(100),
    price_per_night numeric(10,2) NOT NULL,
    amenities text[],
    is_available boolean DEFAULT true,
    image_url character varying(5000),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    size_sqm numeric(5,2),
    CONSTRAINT check_price_positive CHECK ((price_per_night > (0)::numeric))
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rooms_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_room_id_seq OWNER TO postgres;

--
-- Name: rooms_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rooms_room_id_seq OWNED BY public.rooms.room_id;


--
-- Name: amenities amenitie_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities ALTER COLUMN amenitie_id SET DEFAULT nextval('public.amenities_amenitie_id_seq'::regclass);


--
-- Name: bookings booking_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings ALTER COLUMN booking_id SET DEFAULT nextval('public.bookings_booking_id_seq'::regclass);


--
-- Name: guests guest_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guests ALTER COLUMN guest_id SET DEFAULT nextval('public.guests_guest_id_seq'::regclass);


--
-- Name: hotels hotel_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels ALTER COLUMN hotel_id SET DEFAULT nextval('public.hotels_hotel_id_seq'::regclass);


--
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- Name: rooms room_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms ALTER COLUMN room_id SET DEFAULT nextval('public.rooms_room_id_seq'::regclass);


--
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.amenities (amenitie_id, name, icon_url) FROM stdin;
1	wifi	https://cdn-icons-png.flaticon.com/128/93/93158.png
2	parking	https://cdn-icons-png.flaticon.com/128/2830/2830180.png
3	ac	https://cdn-icons-png.flaticon.com/128/1530/1530297.png
4	aquapark	https://cdn-icons-png.flaticon.com/128/5273/5273644.png
5	bar	https://cdn-icons-png.flaticon.com/128/677/677600.png
6	beach	https://cdn-icons-png.flaticon.com/128/2648/2648493.png
7	boat	https://cdn-icons-png.flaticon.com/128/7670/7670783.png
8	breakfast	https://cdn-icons-png.flaticon.com/128/3480/3480666.png
9	butler	https://cdn-icons-png.flaticon.com/128/2889/2889111.png
10	casino	https://cdn-icons-png.flaticon.com/128/16807/16807164.png
11	concierge	https://cdn-icons-png.flaticon.com/128/15748/15748874.png
12	eiffel_view	https://cdn-icons-png.flaticon.com/128/762/762841.png
13	garden	https://cdn-icons-png.flaticon.com/128/6600/6600201.png
14	gym	https://cdn-icons-png.flaticon.com/128/2198/2198245.png
15	helipad	https://cdn-icons-png.flaticon.com/128/3941/3941386.png
16	kids_club	https://cdn-icons-png.flaticon.com/128/7981/7981358.png
17	laundry	https://cdn-icons-png.flaticon.com/128/2871/2871281.png
18	lockers	https://cdn-icons-png.flaticon.com/128/765/765901.png
19	michelin	https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/MichelinStar.svg/960px-MichelinStar.svg.png
20	pool	https://cdn-icons-png.flaticon.com/128/1925/1925949.png
21	restaurant	https://cdn-icons-png.flaticon.com/128/562/562678.png
22	shared_kitchen	https://cdn-icons-png.flaticon.com/128/10630/10630101.png
23	shopping	https://cdn-icons-png.flaticon.com/128/3081/3081415.png
24	spa	https://cdn-icons-png.flaticon.com/128/5661/5661949.png
25	tennis	https://cdn-icons-png.flaticon.com/128/5023/5023365.png
26	business	https://cdn-icons-png.flaticon.com/128/9703/9703904.png
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, user_id, hotel_id, room_id, check_in_date, check_out_date, number_of_guests, total_price, status, special_requests, booked_at, updated_at) FROM stdin;
\.


--
-- Data for Name: guests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guests (guest_id, first_name, last_name, email, phone, date_of_birth, country, registered_at, last_login) FROM stdin;
1	Тимофей	Курочкин	kristofer1337@gmail.com	+7(999)777-77-77	1987-01-20	Монако	2026-04-26 22:38:25.699175	\N
2	Мария	Шмидт	maria.schmidt@gmail.com	+49(176)555-78-90	1992-07-22	Германия	2026-04-26 22:49:28.967964	\N
3	Майкл	Доун	michaeldoun@outlook.com	+1(998)873-95-80	1970-05-09	Соединённые Штаты Америки	2026-04-26 22:55:11.365453	\N
4	Радж	Патэл	raj.patel@yahoo.co.in	+91 88990 01234	1984-02-28	Индия	2026-04-26 23:07:01.698256	\N
5	Самуэль	Джексон	samuel.jackson@msn.com	+1 310 555 7890	1995-06-27	США	2026-04-26 23:18:45.080445	\N
6	М	Ванг	mei.wang@chinamobile.cn	+86 136 0000 1111	1990-06-18	Китай	2026-04-26 23:18:45.080445	\N
7	Фелипэ	Сантос	felipe.santos@bol.com.br	+55 31 97777 1122	1986-04-25	Бразилия	2026-04-26 23:18:45.080445	\N
8	Андрей	Гусев	andrei.gusev@yandex.ru	+7 925 444 55 66	1983-08-04	Россия	2026-04-26 23:18:45.080445	\N
9	Аурора	Лопэз	aurora.lopez@live.com	+54 11 5566 7788	1999-01-27	Аргентина	2026-04-26 23:18:45.080445	\N
10	Хлоя	Браун	chloe.brown@telstra.com.au	+61 412 345 678	1995-07-11	Австралия	2026-04-26 23:18:45.080445	\N
11	Елена	Попова	elena.popova2@gmail.com	+7 916 222 33 44	1998-03-27	Россия	2026-04-26 23:18:45.080445	\N
12	Юсуф	Демир	yusuf.demir@avea.com.tr	+90 542 333 4455	1991-05-07	Турция	2026-04-26 23:18:45.080445	\N
13	Виктория	Ким	victoria.kim2@daum.net	+82 10 2233 4455	1995-07-25	Южная Корея	2026-04-26 23:18:45.080445	\N
14	Стелла	Мартин	stella.martin2@sfr.fr	+33 6 55 44 33 22	1993-11-09	Франция	2026-04-26 23:18:45.080445	\N
15	Юлия	Новак	julia.novak@seznam.cz	+420 777 123 456	1995-12-01	Чехия	2026-04-26 23:18:45.080445	\N
16	Амира	Бенали	amira.benali@yahoo.fr	+212 661 234 567	1993-09-11	Марокко	2026-04-26 23:18:45.080445	\N
17	Зоя	Петрова	zoya.petrova@bk.ru	+7 926 132 66 73	1998-12-10	Россия	2026-04-26 23:18:45.080445	\N
18	Тимур	Алиев	timur.aliyev@mail.ru	+7 777 123 45 67	1997-06-30	Казахстан	2026-04-26 23:18:45.080445	\N
19	Денис	Петросян	ivan.petrov42@mail.ru	+7 916 555 01 12	1985-03-15	Россия	2026-04-26 23:18:45.080445	\N
20	Мия	Нозес	mia.johnson@rogers.com	+1 416 555 0123	1993-07-14	Канада	2026-04-26 23:18:45.080445	\N
21	Пенелопа	Харрис	penelope.harris@sympatico.ca	+1 613 555 9988	1993-12-08	Канада	2026-04-26 23:18:45.080445	\N
\.


--
-- Data for Name: hotel_amenities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotel_amenities (hotel_id, amenity_id) FROM stdin;
1	1
1	2
1	10
1	14
1	20
1	21
1	23
1	24
2	1
2	2
2	6
2	9
2	14
2	15
2	20
2	21
2	24
3	1
3	5
3	11
3	14
3	21
3	24
4	1
4	2
4	4
4	6
4	14
4	16
4	20
4	21
4	24
5	1
5	5
5	11
5	14
5	21
5	24
6	1
6	5
6	14
6	20
6	21
6	24
7	1
7	2
7	5
7	14
7	20
7	21
7	24
8	1
8	5
8	14
8	20
8	21
8	24
9	1
9	2
9	6
9	14
9	20
9	21
9	24
10	1
10	2
10	7
10	14
10	20
10	21
10	24
11	1
11	2
11	5
11	14
11	20
11	21
11	24
12	1
12	2
12	14
12	15
12	20
12	21
12	24
13	1
13	5
13	14
13	19
13	20
13	21
13	24
14	1
14	2
14	5
14	14
14	20
14	21
14	24
15	1
15	2
15	7
15	14
15	20
15	21
15	24
16	1
16	2
16	14
16	19
16	20
16	21
16	24
17	1
17	2
17	14
17	20
17	21
17	24
18	1
18	5
18	11
18	14
18	21
18	24
19	1
19	2
19	5
19	14
19	20
19	21
20	1
20	2
20	14
20	20
20	21
20	26
21	1
21	8
21	21
21	26
22	1
22	5
22	14
22	20
22	21
23	1
23	2
23	14
23	21
23	26
24	1
24	2
24	14
24	20
24	21
24	24
25	1
25	2
25	5
25	14
25	21
26	1
26	2
26	5
26	11
26	21
27	1
27	2
27	6
27	14
27	20
27	21
28	1
28	2
28	5
28	21
29	1
29	8
29	21
30	1
30	5
30	8
30	21
31	1
31	2
31	5
31	21
32	1
32	2
32	5
32	14
32	20
32	21
32	24
33	1
33	5
33	7
33	13
33	14
33	21
33	24
34	1
34	5
34	9
34	14
34	21
34	24
35	1
35	2
35	12
35	14
35	20
35	21
35	24
36	1
36	2
36	6
36	14
36	20
36	21
36	24
37	1
37	5
37	14
37	19
37	21
37	24
38	1
38	7
38	13
38	14
38	20
38	21
38	24
38	25
39	1
39	2
39	5
39	14
39	20
39	21
39	24
40	1
40	5
40	14
40	21
41	1
41	5
41	21
42	1
42	2
42	5
42	14
42	20
42	21
43	1
43	2
43	14
43	21
43	26
44	1
44	5
44	14
44	20
44	21
44	24
45	1
45	5
45	14
45	21
46	1
46	3
47	1
47	2
47	8
48	1
48	5
48	8
49	1
49	5
49	17
49	18
49	22
50	1
50	18
50	22
\.


--
-- Data for Name: hotels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hotels (hotel_id, hotel_name, description, country, city, address, postal_code, star_rating, phone, email, website, check_in_time, check_out_time, amenities, created_at, updated_at, image_main_url, image_gallery_urls) FROM stdin;
14	Raffles Singapore	Колониальный отель 1887 года, где придумали коктейль Singapore Sling	Сингапур	Сингапур	1 Beach Road	189673	5	+65 6337 1886	reservations.singapore@raffles.com	https://www.raffles.com/singapore/	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,bar}	2024-01-22 11:50:00	2026-04-24 14:05:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/763702778.jpg?k=673975b4a2a934b3bfc4bb195ec23df989ec3652f972446299c7d5fe0e01430f&o=	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/795758465.jpg?k=2613cef75efeaaf1bb402ac57824385d75684a62fde48b8f8bc40a57e1f76a59&o=,https://thevanderlust.com/img/ra/ff/raffles_singapore_2_jpg_1581957788.jpg$i$min$822$530$cc$$.jpeg,https://www.remotelands.com/travelogues/app/uploads/2019/08/Raffles-Singapore-1-1280x640.jpg}
24	Radisson Blu Hotel Berlin	Отель с известным аквадомом в центре Берлина	Германия	Берлин	Karl-Liebknecht-Str. 3	10178	4	+49 30 238238	info.radissonblu.berlin@radisson.com	https://www.radissonhotels.com/en-us/hotels/radisson-collection-berlin	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking}	2024-03-20 14:40:00	2026-04-20 16:30:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/44/c7/d2/radisson-blu-hotel-berlin.jpg?w=900&h=500&s=1	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/814790388.jpg?k=82bb46636c8d213a52cfa4c31d6aab42b1e82a1787cd25e63707e4bce006e582&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/814791564.jpg?k=de456f948422c4823550e540c33bfa44d5dca8df83cf78e6de459e51b39a3794&o=}
15	The Oberoi Udaivilas	Дворцовый отель на берегу озера Пичола в Удайпуре	Индия	Удайпур	Haridasji Ki Magri	313001	5	+91 294 243 3300	reservations.udaivilas@oberoihotels.com	https://www.oberoihotels.com/hotels-in-udaipur-udaivilas-resort/	14:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,boat}	2024-02-28 09:30:00	2026-04-20 11:55:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/48812893.jpg?k=a034ea2f5c5431b95bedb68ac0aaa9507f6d2ba261a3182554b1dc81b4ab0f52&o=	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/32/eb/db/36/caption.jpg?w=1100&h=1100&s=1,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/ca/d3/2b/lobby--v16662282.jpg?w=900&h=500&s=1,https://www.oberoihotels.com/-/media/oberoi-hotel/udaivilas-resized/udaivilas-new/gallery/desktop-fullsize-1640x1292/20.jpg}
16	Hotel Metropole Monte-Carlo	Бель-эпок дворец в сердце Монако с рестораном Мишлен	Монако	Монте-Карло	4 Avenue de la Madone	98000	5	+377 93 15 15 15	reservations.metropole@metropole.com	https://metropole.com/ru/	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,michelin}	2024-03-05 15:20:00	2026-04-22 13:30:00	https://excellenceriviera.com/wp-content/uploads/2020/11/Hotel-Metropole-Monaco-1.jpg	{https://static-new.lhw.com/HotelImages/Final/LW0662/lw0662_161556457_960x540.jpg,https://www.rutage.com/wp-content/uploads/2026/04/Metropole-Monte-Carlo.jpg,https://www.visitmonaco.com/var/visitmonaco/storage/images/_aliases/w621/3/2/2/7/857223-1-fre-FR/a470322d1d0e-1500x1500_LobbyBar_HotelMetropoleMonteCarlo_W.Pryce.png.webp}
17	Aman Tokyo	Минималистичный люкс в небоскрёбе с видом на Императорский сад	Япония	Токио	The Otemachi Tower, 1-5-6 Otemachi	100-0004	5	+81 3 5224 3333	reservations@aman.com	https://www.aman.com/hotels/aman-tokyo	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking}	2024-02-12 10:40:00	2026-04-25 15:10:00	https://www.eurotourism.az/site/assets/files/3545/0-1.jpg	{https://www.quinta.ru/upload/iblock/ef5/mj75dqrlkvkyfmx8fu8r84r0sjquyech/Aman-Tokyo_Gallery_26.jpg,https://avatars.mds.yandex.net/get-altay/4341149/2a0000017bcb80e672e6bbebe66f5078370a/orig,https://www.aman.com/sites/default/files/2023-01/Aman%20Tokyo%20-%20Japan%20-%20Lobby.jpg,https://www.aman.com/sites/default/files/styles/full_size_browser%402x/public/2021-08/aman-tokyo-lounge%20%282%29_0.jpg?itok=7uxhBNqg}
18	Claridges London	Арт-деко иконa Mayfair, любимый отель королевской семьи	Великобритания	Лондон	Brook Street, Mayfair	W1K 4HR	5	+44 20 7629 8860	reservations@claridges.co.uk	https://www.claridges.co.uk	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,concierge}	2024-01-28 12:25:00	2026-04-21 10:45:00	https://hips.hearstapps.com/hbz.h-cdn.co/assets/16/29/1600x1071/gallery-1469155624-hbz-brit-week-claridges-01.jpg?resize=640:*	{https://media.cntraveller.com/photos/69273c95310b260f170d9d3e/16:9/w_2560%2Cc_limit/Foyer-Reading-Room-Claridges-November2025-PR-Global.jpg,https://thetravelista.net/wp-content/uploads/2025/06/Claridge_s19.jpg}
19	Novotel Paris Centre Tour Eiffel	Современный отель с видом на Эйфелеву башню	Франция	Париж	61 Quai de Grenelle	75015	4	+33 1 40 58 20 00	h365@novotel.com	https://www.novotel-paris-toureiffel.com/	14:00:00	12:00:00	{wifi,pool,restaurant,gym,parking,bar}	2024-02-22 11:45:00	2026-04-22 10:30:00	https://www.dayuse.com/_next/image?url=https%3A%2F%2Fstatic.dayuse.com%2Fhotels%2F8007%2F03c35aed088f528f8572dd682fefdafe-novotel-paris-centre-tour-eiffel.jpg&w=3840&q=75	{https://www.novotel-paris-toureiffel.com/wp-content/uploads/sites/6/2022/07/Teppan-7-1500x400.jpg,https://crazyforparis.com/wp-content/uploads/2026/01/novotel-paris-centre-tour-eiffel.jpeg}
20	Courtyard by Marriott Dubai	Бизнес-отель в Financial Centre с современным дизайном	ОАЭ	Дубай	Al Mustaqbal Street	00000	4	+971 4 318 0000	reservations@courtyard-dubai.com	https://www.marriott.com/en-us/hotels/dxbct-courtyard-world-trade-centre-dubai/overview/	15:00:00	12:00:00	{wifi,pool,restaurant,gym,parking,business}	2024-03-15 09:20:00	2026-04-25 11:40:00	https://cache.marriott.com/content/dam/marriott-digital/cy/emea/hws/d/dxbct/en_us/photo/unlimited/assets/dxbct-exterior-4082.jpg	{https://avatars.mds.yandex.net/get-altay/9831711/2a0000018e877c6ea60201be6403313036bf/L_height,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/a6/78/87/enjoy-a-cup-of-coffee.jpg?w=900&h=500&s=1,https://milesopedia.com/wp-content/uploads/2022/03/Courtyard-World-Trade-Centre-Dubai-Marriott-31-1024x768.jpg}
21	Holiday Inn Express London	Уютный отель в Кенсингтоне с бесплатным завтраком	Великобритания	Лондон	127 Cromwell Road	SW7 4DT	4	+44 20 7373 5000	reservations@hiexpress-london.com	https://www.ihg.com/holidayinnexpress/hotels/us/en/london/lonct/hoteldetail	14:00:00	11:00:00	{wifi,restaurant,business,breakfast}	2024-02-08 13:10:00	2026-04-21 15:25:00	https://digital.ihg.com/is/image/ihg/holiday-inn-express-london-4553042096-2x1	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/226143690.jpg?k=3244e2dbb00da497792365407be286e0b0469a4a9fca0b571299e9760fad592f&o=,https://digital.ihg.com/is/image/ihg/holiday-inn-express-london-7162121906-4x3}
22	Ibis Styles Bangkok	Яркий дизайнерский отель рядом с BTS Sukhumvit	Таиланд	Бангкок	982/22 Sukhumvit Road	10110	4	+66 2 714 8080	h7389@accor.com	https://www.ibisstylesbangkoksilom.com/	14:00:00	12:00:00	{wifi,pool,restaurant,gym,bar}	2024-03-18 10:50:00	2026-04-23 14:05:00	https://kompastour.com/useruploads/hotels/main_ce8df039d2.jpg	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/752430596.jpg?k=0ff11b59066a6ea0c77da761ab1c935e561ef18d265d2d9a2830052c5fcf55c0&o=,https://www.ahstatic.com/photos/b6n1_ho_03_p_1024x768.jpg}
23	Mercure Hotel Moscow	Комфортабельный отель в деловом центре Москвы	Россия	Москва	Партийный пер., 1	119021	4	+7 495 737 7000	reservations@mercure-moscow.ru	https://accor.ru/moscow/mercure-moscow-paveletskaya/	14:00:00	12:00:00	{wifi,restaurant,gym,parking,business}	2024-02-15 11:30:00	2026-04-24 09:50:00	https://accor.ru/upload/iblock/30b/6vcpkm0dtz7oaox33uwh6o2g5k9xfndq.jpeg	{https://andychef.ru/wp-content/uploads/2017/06/IMG_1258.jpg,https://accor.ru/upload/resize_cache/iblock/87f/854_480_1619711fa078991f0a23d032687646b21/kd8hcrs94j8bime25twsxptpv8lyerlc.jpeg}
25	Park Inn by Radisson St. Petersburg	Современный отель на площади Александра Невского	Россия	Санкт-Петербург	ул. Александра Невского, 6	191167	4	+7 812 324 4444	info.stpetersburg@parkinn.com	https://www.radissonhotels.com/en-us/hotels/radisson-individuals-st-petersburg-nevsky	14:00:00	12:00:00	{wifi,restaurant,gym,parking,bar}	2024-02-28 12:20:00	2026-04-21 14:40:00	https://media.radissonhotels.net/image/cosmos-saint-petersburg-nevsky-hotel-a-member-of-radisson-individuals/exterior/16256-113831-f63822911_4K.jpg?impolicy=HomeHero	{https://paks.ru/imagecache/orig/9197/big-4-2_1.jpg}
26	Hotel National Moscow	Исторический отель 1903 года напротив Большого театра	Россия	Москва	ул. Большая Дмитровка, 10/2	125009	4	+7 495 258 7000	reservations@national.ru	https://national.ru/	14:00:00	12:00:00	{wifi,restaurant,bar,parking,concierge}	2024-01-25 11:00:00	2026-04-23 15:30:00	https://s1.it.atcdn.net/wp-content/uploads/2017/05/hotel-800x584.jpg	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/29/cb/65/91/caption.jpg?w=900&h=500&s=1,https://top100awards.ru/storage/persons/photos/February2024/thumbnails/desktop-half-2x/dlnrExmQAXdgfhwoyYPN.webp?1708877886,https://static.tildacdn.com/tild6138-3666-4232-b335-366230356236/nazional_msk_4.jpg}
27	Azimut Hotel Sochi	Современный отель в центре Сочи рядом с морем	Россия	Сочи	ул. Черноморская, 3	354000	4	+7 862 266 6000	sochi@azimuthotels.ru	https://azimuthotels.com/ru/sochi/azimut-hotel-vinogradnaya-sochi	14:00:00	12:00:00	{wifi,pool,restaurant,gym,parking,beach}	2024-03-25 10:30:00	2026-04-24 11:20:00	https://tophotels.ru/icache/hotel_photos/1/1173/141651/1956941_740x550.jpg	{https://i.travel.ru/data2/pictures_by_hotel/503139/920_612/azimut_hotel__3__45.jpg,https://images.putevka.com/thumb_1366_2408071525584.jpg}
1	Marina Bay Sands	Иконический отель с бесконечным бассейном на крыше и панорамным видом на Сингапур	Сингапур	Сингапур	10 Bayfront Avenue	018956	5	+65 6688 8868	reservations@marinabaysands.com	https://www.marinabaysands.com	15:00:00	11:00:00	{wifi,pool,spa,restaurant,gym,parking,casino,shopping}	2024-02-10 09:15:00	2026-04-18 11:45:00	https://www.marinabaysands.com/content/dam/marinabaysands/guides/exceptional-experiences/architecture-of-mbs/masthead-m.jpg	{https://www.marinabaysands.com/content/dam/marinabaysands/guides/exceptional-experiences/architecture-of-mbs/mbs-overview-1.jpg,https://www.marinabaysands.com/content/dam/marinabaysands/guides/exceptional-experiences/architecture-of-mbs/curved-architecture-1.jpg,https://www.marinabaysands.com/guides/exceptional-experiences/marina-bay-sands-architecture/_jcr_content/root/container/table_2034929113/1-2/image.coreimg.jpeg/1730792991964/skypark.jpeg,https://www.marinabaysands.com/guides/exceptional-experiences/marina-bay-sands-architecture/_jcr_content/root/container/table/1-1/image.coreimg.jpeg/1730792984775/infinity-pool.jpeg,https://www.marinabaysands.com/content/dam/marinabaysands/guides/exceptional-experiences/architecture-of-mbs/art-2.jpg,https://www.marinabaysands.com/content/dam/marinabaysands/guides/exceptional-experiences/architecture-of-mbs/art-3.jpg}
2	Burj Al Arab Jumeirah	Самый роскошный отель мира в форме паруса, с возможность предоставления персонального дворецкого, вертолётной площадки и многого другого	ОАЭ	Дубай	Jumeirah Street, Umm Suqeim 3	00000	5	+971 4 301 7777	reservations@burjalarab.com	https://www.jumeirah.com/en/stay/dubai/burj-al-arab-jumeirah	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,beach,helipad,butler}	2024-01-15 10:30:00	2026-04-20 14:22:00	https://mywowo.net/media/images/cache/dubai_jumeirah_02_burj_al_arab_jpg_1200_630_cover_85.jpg	{https://orange-traveler.com/uploads/travel_blog_message/content_ru/0003/15/47.jpg,https://imagedelivery.net/UxkPwxNl9WkpdvqmlW14WA/3a4d1aa2-3343-4e89-151d-cdf5e4014f00/public}
3	The Ritz Paris	Легендарный отель Place Vendome, где останавливались такие культовые личности как - Коко Шанель, Эрнест Хемингуэй и др.	Франция	Париж	15 Place Vendome	75001	5	+33 1 43 16 30 30	reservations@ritzparis.com	https://www.ritzparis.com	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,concierge}	2024-01-20 14:00:00	2026-04-22 16:30:00	https://upload.wikimedia.org/wikipedia/commons/e/ec/H%C3%B4tel_Ritz.jpg	{https://media.ritzparis.com/medias/domain12964/media100003/1164-k0ukidj2ft-web4k.jpg,https://cdn.sortiraparis.com/images/80/108804/1132355-le-tea-time-imperial-de-noel-du-ritz-paris-l-experience-exceptionnelle-les-photos-salon-marie-louise-harpe.jpg,https://media.ritzparis.com/medias/domain12964/media100003/1107-i3pp5qjqol-web4k.jpg}
4	Atlantis The Palm	Роскошный курорт на искусственном острове Пальма Джумейра с аквапарком	ОАЭ	Дубай	Crescent Road, The Palm	00000	5	+971 4 426 2000	reservations@atlantisthepalm.com	https://www.atlantis.com/dubai	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,beach,aquapark,kids_club}	2024-03-05 11:20:00	2026-04-25 09:10:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2f/ba/99/f5/atlantis-the-palm.jpg?w=900&h=500&s=1	{https://farm8.staticflickr.com/7333/16387453171_3f68e19f06_b.jpg,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2f/d8/80/a4/underwater-suite.jpg?w=900&h=500&s=1,https://s0.rbk.ru/v6_top_pics/media/img/0/61/346941891869610.jpeg}
5	The Plaza New York	Исторический отель на Fifth Avenue рядом с Центральным парком	США	Нью-Йорк	768 5th Avenue	10019	5	+1 212 759 3000	reservations@theplazany.com	https://www.fairmont.com/the-plaza-new-york	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,concierge}	2024-01-25 10:00:00	2026-04-19 13:20:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/766074664.jpg?k=d174c6a892c41650c91815e2f2bfa004ef3033cdd4e6d051be2adbae5b60eb7b&o=	{https://media.cntraveler.com/photos/62a8e975d822d883b3c26a8d/16:9/w_2560,c_limit/The%20Plaza%20NYC_6011-40-2.jpg,https://www.hotels-newyorkcity.org/data/Imgs/700x500w/17170/1717008/1717008375/img-the-plaza-new-york-32.JPEG,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/33/02/05/9c/caption.jpg?w=1100&h=1100&s=1}
28	Hotel Cosmos Moscow	Советский отель 1979 года на ВДНХ	Россия	Москва	просп. Мира, 150	129110	3	+7 495 683 3030	info@cosmos-hotel.ru	https://www.hotelcosmos.ru/	14:00:00	12:00:00	{wifi,restaurant,parking,bar}	2024-02-12 10:40:00	2026-04-25 14:25:00	https://www.hotelcosmos.ru/upload/resize_cache/iblock/ee0/44ai221vbtgb1quak11b5wzemc77geld/1920_1280_2/o_gostinichnom_komplekse.jpg	{https://images.putevka.com/thumb_5034_25073116081610.jpg,https://images.putevka.com/thumb_5034_2507311608113.jpg}
6	Hotel de Crillon	Дворец XVIII века на Place de la Concorde, один из старейших отелей Парижа	Франция	Париж	10 Place de la Concorde	75008	5	+33 1 44 71 15 00	reservations@crillon.com	https://www.rosewoodhotels.com/crillon	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,bar}	2024-02-14 15:30:00	2026-04-21 10:15:00	https://upload.wikimedia.org/wikipedia/commons/9/98/H%C3%B4tels_Crillon_Cartier_Plessis_Belli%C3%A8re_Coislin_Paris_2.jpg	{https://www.svoiludi.ru/images/tb/226/de-crillon-palace-hotel-17712743420822_w687h357.jpg,https://hips.hearstapps.com/hmg-prod/images/marie-antoinette-comp-1504204975.png}
7	Taj Mahal Palace	Легендарный отель в Мумбаи с видом на Ворота Индии, построен в 1903 году	Индия	Мумбаи	Apollo Bunder, Colaba	400001	5	+91 22 6665 3366	reservations.tajmahalpalace@tajhotels.com	https://www.tajhotels.com/en-in/hotels/taj-mahal-palace-mumbai	14:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,bar}	2024-01-30 09:45:00	2026-04-23 14:50:00	https://upload.wikimedia.org/wikipedia/commons/7/73/Taj_Mahal_Palace_Hotel.jpg	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/e9/b9/6e/the-taj-mahal-palace.jpg?w=700&h=-1&s=1,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2f/d1/11/fe/caption.jpg?w=1200&h=1200&s=1}
9	Copacabana Palace	Самый знаменитый отель Рио-де-Жанейро на берегу океана с 1923 года	Бразилия	Рио-де-Жанейро	Avenida Atlantica 1702	22021-001	5	+55 21 2548 7070	reservations.copacabanapalace@belmond.com	https://www.belmond.com/copacabana-palace	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,beach}	2024-03-10 10:20:00	2026-04-20 15:40:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/662715879.jpg?k=d8680285d503f02dc0facfc7fe3683ad6cec036ba0878ccac007bf2854f50ba2&o=	{https://lostworld.com/media/18808/belmond07.jpg,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/d8/0b/31/belmond-copacabana-palace.jpg?w=900&h=500&s=1,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/1e/7d/f2/inside-pergula.jpg?w=900&h=500&s=1,https://www.quinta.ru/upload/iblock/718/cop-gst-pool01_1600x900.jpg}
10	Mandarin Oriental Bangkok	Легендарный отель на берегу реки Чао Прайя, лучший сервис Азии	Таиланд	Бангкок	48 Oriental Avenue	10500	5	+66 2 659 9000	mobkk-reservations@mohg.com	https://www.mandarinoriental.com/bangkok	14:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,boat}	2024-02-20 11:15:00	2026-04-22 09:25:00	https://upload.wikimedia.org/wikipedia/commons/e/e5/Mandarin_Oriental_Bangkok_Bang_Rak.jpg	{https://hotelessencephotography.com/wp-content/uploads/2025/02/MVC161300208-Mandarin-Oriental.Bangkok-1.jpg,https://hotelessencephotography.com/wp-content/uploads/2017/04/MVC163800032-Mandarin-Oriental-Bangkok.jpg}
11	Grand Hotel Europe	Исторический пятизвёздочный отель в центре Санкт-Петербурга с 1875 года	Россия	Санкт-Петербург	Михайловская ул., 1/7	191186	5	+7 812 329 6000	reservations@grandhoteleurope.com	https://www.grandhoteleurope.com	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,bar}	2024-01-18 13:30:00	2026-04-25 10:20:00	https://grandhoteleurope.com/upload/iblock/238/qy4iom3zig9z0rojnnnwt1vd7j6wehju.jpg	{https://grandhoteleurope.com/upload/iblock/eee/3ocng67rfd1iryfdwcoz9xvbhsf1xrnh.jpeg,https://grandhoteleurope.com/upload/iblock/99e/n7860h0e07o2hh8qkqs4f3kyqrnwn15b.jpeg}
12	The Peninsula Hong Kong	Легендарный отель с видом на Виктория-Харбор и собственным флотом Rolls-Royce	Гонконг	Гонконг	Salisbury Road, Tsim Sha Tsui	00000	5	+852 2920 2888	reservations@peninsula.com	https://www.peninsula.com/hong-kong	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,helipad}	2024-02-25 14:45:00	2026-04-21 16:15:00	https://www.peninsula.com/en/-/media/hotel-exterior.png?mw=980&hash=C672A1F117FE7F20EE22C6A892F9782E	{https://robbreport.com/wp-content/uploads/2013/06/1550531.jpg?w=1000,https://cdn.kiwicollection.com/media/property/PR002554/xl/002554-16-peninsula%20moments%20-%20victoria%20harbour%20view%20from%20the%20pool.jpg?cb=1491330474}
13	Four Seasons George V Paris	Арт-деко дворец находящийся рядом с Елисейскими полями и с тремя ресторанами Мишлен	Франция	Париж	31 Avenue George V	75008	5	+33 1 49 52 70 00	reservations.par@fourseasons.com	https://www.fourseasons.com/paris	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,bar,michelin}	2024-03-01 10:10:00	2026-04-23 12:40:00	https://www.fourseasons.com/alt/img-opt/~70.1530.0,0000-463,6595-3000,0000-1687,5000/publish/content/dam/fourseasons/images/web/PAR/PAR_1769_original.jpg	{https://cdn.worldota.net/t/1200x616/ostrovok/da/a6/daa67cd36406af06aa8e93c2086d6c7e4e468beb.JPEG,https://www.fourseasons.com/alt/img-opt/~75.701.0,0000-157,2500-3000,0000-1687,5000/publish/content/dam/fourseasons/images/web/PAR/PAR_2060_original.jpg,https://images.aircharterservice.com/content/four-seasons-hotel-george-v-intro-1.jpg}
8	The Savoy London	Иконический отель на Strand с видом на Темзу, любимец звёзд и аристократов	Великобритания	Лондон	Strand	WC2R 0EZ	5	+44 20 7836 4343	reservations@thesavoylondon.com	https://www.thesavoylondon.com	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,bar}	2024-02-05 12:00:00	2026-04-24 11:30:00	https://www.chaine.co.uk/wp-content/uploads/2026/03/The-Savoy-London-front-entrance.webp	{https://www.svoiludi.ru/images/tb/12174/the-savoy-hotel-14175160305143_w687h357.jpg,https://cf.bstatic.com/xdata/images/hotel/max1024x768/844479711.jpg?k=46e2ee6fb2c0d7dde0333b090dddea0d35750d757721ebcf9b7625aa211fb176&o=,https://media.blacktomato.com/cdn-cgi/image/width=1520,height=800,fit=cover,quality=82,format=auto/https://media.blacktomato.com/2014/03/BvaS9Dff-thomas-foyer.jpg}
29	Comfort Hotel Stockholm	Простой скандинавский отель рядом с центром	Швеция	Стокгольм	Kungsbron 1	11122	3	+46 8 457 58 00	info@comforthotel.se	https://www.booking.com/hotel/se/comfort-hotel-xpress-stockholm-central.ru.html	15:00:00	12:00:00	{wifi,restaurant,breakfast}	2024-03-05 10:15:00	2026-04-24 15:40:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1d/14/eb/66/comfort-hotel-solna.jpg?w=500&h=400&s=1	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/161752398.jpg?k=48bd74a073bd12ea3aa75c0a4db556f5851bdc7c50649fdd5327d164dd5e39ba&o=}
30	Premier Inn London	Надёжный бюджетный отель с гарантией хорошего сна	Великобритания	Лондон	45 Waterloo Road	SE1 8TX	3	+44 871 527 9222	reservations@premierinn.com	https://www.premierinn.com/gb/en/hotels/england/greater-london.html	14:00:00	12:00:00	{wifi,restaurant,bar,breakfast}	2024-02-22 11:45:00	2026-04-20 10:20:00	https://www.premierinn.com/_next/image?url=https%3A%2F%2Fwww.premierinn.com%2Fcontent%2Fdam%2Fpi%2Fwebsites%2Fhotelimages%2Fgb%2Fen%2FL%2FLONWAT%2FLONWAT%201.jpg&w=3840&q=75	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/09/d5/cc/premier-inn-london-waterloo.jpg?w=800&h=800&s=1}
31	Hotel Leningrad Moscow	Сталинский высотный отель у Комсомольской площади	Россия	Москва	Каланчёвская ул., 21/40	107079	5	+7 495 627 5550	info@hotel-leningrad.ru	https://moscow-leningradskaya.ru/	14:00:00	12:00:00	{wifi,restaurant,bar,parking}	2024-01-30 13:20:00	2026-04-22 16:15:00	https://um.mos.ru/content/house/main-image/16550d2e73b695.jpg	{https://mosmuseum.ru/wp/wp-content/uploads/2022/04/wTyB1-y51bUq8zltxUqoo_dlJZgmUrzk_tNG_-U724dQHZjKIbhHsjYmy809qlIfevmcb4icNWQWljBQ6bGk1akL.jpeg,https://um.mos.ru/_next/image/?url=https%3A%2F%2Fum.mos.ru%2Fcontent%2Fhouse%2Fmedia%2F3492%2F16550d2e6e6d62.jpg&w=1920&q=75,https://mf.b37mrtl.ru/rbthmedia/images/2024.07/original/66a905ba3b70ff4f4906dc76.jpg}
32	The Ritz-Carlton Tokyo	Роскошный отель в небоскрёбе Tokyo Midtown с видом на гору Фудзи	Япония	Токио	9-7-1 Akasaka, Minato-ku	107-6245	5	+81 3-3423-8000	rc.tyort.reservations@ritzcarlton.com	https://www.ritzcarlton.com/en/hotels/tyorz-the-ritz-carlton-tokyo/overview/	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,bar}	2024-01-10 10:00:00	2026-04-20 14:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/538638940.jpg?k=98b5bdf94718a4f56d5e2bb0fb206298fb512754f8009f5033669421dcb4c9e0&o=	{https://cdn.worldota.net/t/1024x768/content/88/31/883184ada8ea3a712dc30e6655a2ed3723b21005.jpeg,https://cf.bstatic.com/xdata/images/hotel/max1024x768/600191242.jpg?k=d4e1945e9d8820d09ee6c667193a10558c827a68721b7532c0022eda574e5f64&o=}
33	Aman Venice	Дворец Palazzo Papadopoli на Гранд-канале XVI века	Италия	Венеция	San Polo 1364	30125	5	+39 041 270 7333	amanvenice@aman.com	https://www.aman.com/hotels/aman-venice	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,garden,boat}	2024-01-15 11:00:00	2026-04-21 15:00:00	https://www.aman.com/sites/default/files/styles/full_size_browser%402x/public/2021-01/Aman%20Venice%20-%20Exterior%20-%20Palazzo%20by%20night-2.jpg?itok=4dieWz0k	{https://www.aman.com/sites/default/files/styles/central_carousel_small/public/2024-07/aman-venice_italy_-ballroom.jpg?itok=O-XNRHej,https://www.aman.com/sites/default/files/styles/full_size_browser%402x/public/2021-01/Aman%20Venice%20-%20Interior%20-%20The%20Bar.jpg?itok=JyWb0OMO,https://assets.telegraphindia.com/telegraph/2022/Apr/1650743948_new-project-84.jpg}
34	The St. Regis New York	Легендарный отель на Fifth Avenue с 1904 года, изобретатель коктейля Bloody Mary	США	Нью-Йорк	2 East 55th Street	10022	5	+1 212-753-4500	stregis.newyork@stregis.com	https://www.marriott.com/en-us/hotels/nycxr-the-st-regis-new-york/overview/	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,butler}	2024-01-20 10:30:00	2026-04-23 12:00:00	https://monkeymiles.boardingarea.com/wp-content/uploads/2019/07/St-Regis-New-York_0576.jpg	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/44/ef/bd/the-st-regis-new-york.jpg?w=900&h=500&s=1,https://cache.marriott.com/is/image/marriotts7prod/xr-nycxr-hotel-lobby-29316:Wide-Hor?wid=750&fit=constrain,https://img.partyslate.com/companies-cover-image/11609/image-bb535997-46d6-42b4-a6d6-f48f92bcf990.jpg?tr=w-3840}
35	Shangri-La Paris	Азиатская роскошь в историческом здании напротив Эйфелевой башни	Франция	Париж	10 Avenue d'Iena	75116	5	+33 1 53 67 19 98	slpr@shangri-la.com	https://www.shangri-la.com/paris/shangrila/	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,eiffel_view}	2024-02-05 14:00:00	2026-04-24 10:00:00	https://elitetraveler.com/wp-content/uploads/sites/8/2023/12/Shangri1.jpg	{https://beautifulmag-lifestyle.com/wp-content/uploads/2019/04/Grand-Salon-3.jpg,https://sitecore-cd-imgr.shangri-la.com/MediaFiles/A/4/5/%7BA452EF6B-EA7A-4A2E-A391-6CDC4A849884%7DSLPR-ExperienceBox-Pool-1200x700.jpg?width=630&height=480&mode=crop&quality=100&scale=both,https://cdn.sortiraparis.com/images/80/104832/1004786-la-bauhinia-par-quentin-testart-au-shangri-la-paris-a7c0481.jpg}
36	Capella Singapore	Колониальные виллы и современные здания на острове Сентоза	Сингапур	Сингапур	1 The Knolls, Sentosa	098297	5	+65 6377 8888	reservations-cpsg@capellahotels.com	https://capellahotels.com/en/capella-singapore	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,beach}	2024-01-25 09:30:00	2026-04-20 16:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/618565008.jpg?k=b4beb254a34e2e0614271f2e1804de7c79bc9ff7d4f671c16fb85521426b30be&o=	{https://capellahotels.com/assets/img/site_images/singapore/singapore-destination-accommodation-04.jpg,https://capellahotels.com/assets/img/site_images/singapore/Capella_Singapore_Home_Gallery-08.jpg,https://capellahotels.com/assets/img/site_images/singapore/Capella_Singapore_Home_Gallery-08.jpg,https://capellahotels.com/assets/img/site_images/singapore/flystay-synopsis-2.png}
37	The Connaught London	Иконический отель Mayfair с 3 звёздами Мишлен в ресторане	Великобритания	Лондон	Carlos Place, Mayfair	W1K 2AL	5	+44 20 7499 7070	info@the-connaught.co.uk	https://www.maybourne.com/en/hotels/the-connaught	15:00:00	12:00:00	{wifi,spa,restaurant,gym,bar,michelin}	2024-02-10 11:00:00	2026-04-22 14:00:00	https://www.theluxevoyager.com/wp-content/uploads/2020/05/The-Connaught-Hotel-London-Exterior.jpg	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/807583015.jpg?k=981943c89e30a274441a941522a8ed047bb33914c61d1b29dc2816268d618b66&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/664421924.jpg?k=7e1b44d71669299b409258dba36b73e34feace1d025d826127fe59dceed02604&o=}
38	Belmond Hotel Cipriani Venice	Легендарный отель на острове Giudecca с частным садом	Италия	Венеция	Giudecca 10	30133	5	+39 041 240 801	reservations.cip@belmond.com	https://www.belmond.com/hotels/europe/italy/venice/belmond-hotel-cipriani/?srsltid=AfmBOorljg86Q0HhM4NXJ1AwB8yYIodZnmFWf3m_zhohKgexmkkvor4s	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,boat,garden,tennis}	2024-02-15 13:00:00	2026-04-21 10:00:00	https://afar.brightspotcdn.com/dims4/default/bf5be25/2147483647/strip/false/crop/2200x1467+0+0/resize/1486x991!/quality/90/?url=https%3A%2F%2Fk3-prod-afar-media.s3.us-west-2.amazonaws.com%2Fbrightspot%2Ff2%2F9e%2F08b366957c9f744fe28741c84bea%2Foriginal-ci-5430-0.jpg	{https://belmond-cipriani.hotels-in-venice.net/data/Pictures/OriginalPhoto/17061/1706175/1706175690/venice-hotel-cipriani-a-belmond-hotel-venice-picture-30.JPEG,https://belmond-cipriani.hotels-in-venice.net/data/Pictures/OriginalPhoto/14427/1442709/1442709313/venice-hotel-cipriani-a-belmond-hotel-venice-picture-17.JPEG}
39	Park Hyatt Tokyo	Отель из фильма «Трудности перевода» в Shinjuku Park Tower	Япония	Токио	3-7-1-2 Nishi Shinjuku	163-1055	5	+81 3-5322-1234	tokyo.park@hyatt.com	https://www.hyatt.com/park-hyatt/en-US/tyoph-park-hyatt-tokyo	15:00:00	12:00:00	{wifi,pool,spa,restaurant,gym,parking,bar}	2024-01-18 12:00:00	2026-04-23 15:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/425730246.jpg?k=5ba3aaa43e2f99e1a0b058d6ad3da9013e558be768ad0a0cda878cb91edd2d53&o=	{https://assets.hyatt.com/content/dam/hyatt/hyattdam/images/2025/12/05/0459/TYOPH-P0683-The-Peak-Lounge-Side.jpg/TYOPH-P0683-The-Peak-Lounge-Side.4x3.jpg,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/e4/a2/77/caption.jpg?w=900&h=500&s=1,https://whatthefab.com/wp-content/uploads/2018/04/Park-Hyatt-Tokyo-review-16.jpg.webp}
43	NH Collection Berlin Mitte	Современный отель в центре Берлина у Museum Island	Германия	Берлин	Friedrichstrasse 96	10117	4	+49 30 2067880	nhcollectionberlinmitte@nh-hotels.com	https://www.nh-collection.com/en/hotel/nh-collection-berlin-mitte-friedrichstrasse	15:00:00	12:00:00	{wifi,restaurant,gym,parking,business}	2024-01-22 11:00:00	2026-04-24 10:00:00	https://foto.hrsstatic.com/fotos/0/2/800/458/80/000000/http%3A%2F%2Ffoto-origin.hrsstatic.com%2Ffoto%2FMTS%2F86773%2F086773_a_21048947_47.jpg/nxAtL%2FELY6PkWBp1EZXQrQ%3D%3D/749%2C500/6/NH_Collection_Berlin_Mitte_Friedrichstrasse-Berlin-Aussenansicht-4-86773.jpg	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/8e/45/83/rc-nh-collection-berlin.jpg?w=900&h=500&s=1,https://www.berlin.de/binaries/asset/image_assets/8931957/source/1717154733/1000x500/}
44	Pullman Bangkok Hotel G	Дизайнерский отель на Silom Road	Таиланд	Бангкок	188 Silom Road	10500	5	+66 2 238 1991	h6286@accor.com	https://www.pullmanbangkokhotelg.com/	14:00:00	12:00:00	{wifi,pool,restaurant,gym,bar,spa}	2024-01-30 09:30:00	2026-04-22 16:00:00	https://www.aqua-travelgroup.com/Hotel/PULBKK.jpg	{https://q-xx.bstatic.com/xdata/images/hotel/max500/462757695.jpg?k=a9530bc94122e820c293a3d7976802a7bf0d80b3844c55d9be5f3325a5e072ec&o=,https://www.panteon.ru/upload/catalog/11122/swimming-pool.jpg,https://d2e5ushqwiltxm.cloudfront.net/wp-content/uploads/sites/21/2025/05/15064302/SCARLETT-WINE-BAR-RESTAURANT-1800x1200-1.jpg}
47	B&B Hotel Milano Centrale	Простой отель у Центрального вокзала Милана	Италия	Милан	Via Napo Torriani 18	20124	2	+39 02 6698 7461	milano.centrale@hotelbb.com	https://www.hotel-bb.com/en/hotel/milano-central-station	14:00:00	10:00:00	{wifi,breakfast,parking}	2024-02-05 11:00:00	2026-04-21 10:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/804123724.jpg?k=342a18de46971211152390c33a2d633e481c7ee0d2180849bbd2bba2a5cd84af&o=	{https://res.cloudinary.com/hzekpb1cg/image/upload/q_95%2Cf_auto/s3/public/prod/s3fs-public/Centrale-breakfast_1.89625d8b-56853_0.jpg,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/11/9c/9a/6c/b-b-hotel-milano-central.jpg?w=900&h=500&s=1}
48	Ibis Styles Toulouse Centre	Бюджетный дизайн-отель в Тулузе	Франция	Тулуза	50 Rue de la Concorde	31000	2	+33 5 61 23 45 67	h3666@accor.com	https://all.accor.com/hotel/B3A1/index.en.shtml	14:00:00	12:00:00	{wifi,breakfast,bar}	2024-02-08 10:30:00	2026-04-21 13:00:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/11/8a/0b/f7/cour-interieure-de-l.jpg?w=700&h=-1&s=1	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/324442147.jpg?k=097fe08cca650eb0a903a5da8f1e099319584e8be7104741fc2a977fea78e2d2&o=,https://www.ahstatic.com/photos/9912_ho_03_p_1024x768.jpg}
49	Wombat's City Hostel London	Популярный хостел у вокзала King's Cross	Великобритания	Лондон	7 Dock Street	E1 8LL	1	+44 20 7702 7979	london@wombats-hostels.com	https://www.tripadvisor.com/Hotel_Review-g186338-d7147409-Reviews-Wombat_s_City_Hostel_London-London_England.html	15:00:00	10:00:00	{wifi,bar,shared_kitchen,lockers,laundry}	2024-01-28 11:00:00	2026-04-22 15:00:00	https://blogs.ucl.ac.uk/survey-of-london/files/2019/04/SoL-Whitechapel-101145-1h00cnn.jpg	{https://images.example.com/hotels/wom-lon-1.jpg,https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/2a/78/a1/outside-area-wombat-s.jpg?w=700&h=-1&s=1}
40	Moxy NYC Times Square	Молодёжный дизайн-отель Marriott в центре Таймс-сквер	США	Нью-Йорк	485 7th Avenue	10018	4	+1 212-921-1900	moxy.nyctimessquare@marriott.com	https://moxytimessquare.com/	15:00:00	12:00:00	{wifi,restaurant,bar,gym}	2024-02-01 10:00:00	2026-04-20 12:00:00	https://cache.marriott.com/content/dam/marriott-renditions/NYCOX/nycox-exterior-0048-sq.jpg??image	{https://moxytimessquare.com/content/uploads/sites/1/2017/05/Magic-Hour-Corridor-1024x692.jpg,https://cf.bstatic.com/xdata/images/hotel/max1024x768/538657027.jpg?k=fd5f777f8043ff6ee25a32c3f109d8904d6ec1a4dd97172612e6cea6a75d91cb&o=}
41	citizenM Paris Gare de Lyon	Инновационный отель с планшетами и rooftop баром	Франция	Париж	8 Rue Van Gogh	75012	4	+33 1 84 88 18 00	parisgarelyon@citizenm.com	https://www.marriott.com/en-us/hotels/parly-citizenm-paris-gare-de-lyon/overview/	14:00:00	11:00:00	{wifi,restaurant,bar}	2024-02-05 11:00:00	2026-04-22 14:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/772469537.jpg?k=c642fb3a92e0ca67339341d97aae04db107961a0c58d3380198e5ca95ce1b6da&o=	{https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/2f/c2/7a/citizenm-paris-gare-de.jpg?w=900&h=500&s=1,https://x.cdrst.com/foto/hotel-sf/1220991e/granderesp/foto-hotel-12208e74.jpg}
42	Melia Barcelona Sky	Небоскрёб-отель в деловом районе Poblenou	Испания	Барселона	Carrer de la Llacuna 129	08018	4	+34 93 367 77 70	melia.barcelonasky@melia.com	https://www.melia.com/en/hotels/spain/barcelona/melia-barcelona-sky	15:00:00	12:00:00	{wifi,pool,restaurant,gym,parking,bar}	2024-02-10 10:30:00	2026-04-23 15:00:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/31/4a/5c/16/caption.jpg?w=900&h=500&s=1	{https://www.sardatur-holidays.co.uk/images/1-meliabarcelonasky-entrance-lope-de-vega-158392248997_l.jpg,https://cf.bstatic.com/xdata/images/hotel/max1024x768/855595124.jpg?k=733b3c5a2bab22836f6ff13710524d225931564dbabeca35ab847d3246a0893e&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/855595078.jpg?k=8e11dc0bbd383f6cb803dd50b3c3a0dc0021e6438eaf74d876fa15102232e06c&o=}
45	Renaissance Amsterdam Hotel	Отель в бывшем телефонном здании 1900 года	Нидерланды	Амстердам	Kattengat 1	1012 SZ	4	+31 20 522 3333	reservations.amsterdam@renaissancehotels.com	https://www.marriott.com/en-us/hotels/amsrd-renaissance-amsterdam-hotel/overview/	15:00:00	12:00:00	{wifi,restaurant,gym,bar}	2024-02-08 11:30:00	2026-04-25 12:00:00	https://cf.bstatic.com/xdata/images/hotel/max1024x768/732118295.jpg?k=322c919c461e827bcd6d3beff96ba1dfe917fb60c3c61b233e20dcbb5e0b22e8&o=	{https://cache.marriott.com/is/image/marriotts7prod/br-amsrd-specht-bar-and-lo-20105-39546:Feature-Hor?wid=1920&fit=constrain,https://cache.marriott.com/is/image/marriotts7prod/br-amsrd-lobby-reception-pods-36221:Feature-Hor?wid=1920&fit=constrain}
46	easyHotel London Victoria	Супер-бюджетный отель без лишних удобств	Великобритания	Лондон	36-40 Belgrave Road	SW1V 1RG	2	+44 20 7932 0932	london.victoria@easyhotel.com	https://www.easyhotel.com/hotels/united-kingdom/london/victoria	15:00:00	10:00:00	{wifi,ac}	2024-02-01 10:00:00	2026-04-20 11:00:00	https://cdn.easyhotel.com/easy_Hotel_London_Victoria_Exterior_1_1_deea6ef59c.jpg	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/662472378.jpg?k=0efcb1308c09ce3bbf4d57f0c57a5427c8e34a227afb42790222ad5a227a9a18&o=,https://cdn.daybreakhotels.com/images/hotels/9585946/easyHotel_London_Victoria_05.0xe8822f9e0a411dcd91eccbfafff787b5.jpg?quality=85&width=1280}
50	Smart Stay Hostel Munich	Бюджетный хостел в Мюнхене	Германия	Мюнхен	Bahnhofplatz 1	80335	1	+49 89 55 29 58 90	munich@smartstayhostel.com	https://www.tripadvisor.com/Hotel_Review-g187309-d286378-Reviews-Smart_Stay_Hostel_Munich_City-Munich_Upper_Bavaria_Bavaria.html	15:00:00	10:00:00	{wifi,shared_kitchen,lockers}	2024-01-22 11:00:00	2026-04-25 10:00:00	https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/8a/be/5e/smart-stay-hostel-munich.jpg?w=900&h=500&s=1	{https://pix10.agoda.net/hotelImages/117410/-1/eb9ffd7684a93e558c76f27ef0556596.jpg?ca=9&ce=1&s=414x232,https://www.smart-stay.de/fileadmin/user_upload/Hotels/Munich_Station/Bar_Smart_Stay_Hotel_Station_MUEnchen.jpg}
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (review_id, hotel_id, guest_id, booking_id, rating, title, comment, cleanliness_rating, service_rating, location_rating, value_rating, created_at, is_approved) FROM stdin;
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rooms (room_id, hotel_id, room_type, description, max_guests, beds_count, bed_type, price_per_night, amenities, is_available, image_url, created_at, updated_at, size_sqm) FROM stdin;
1	1	Sands Premier Double Queen	Двухместный номер с собственной ванной комнатой с ванной, душем и биде, а также халатами и бесплатными туалетно-косметическими принадлежностями. Просторный двухместный номер с кондиционером, телевизором с плоским экраном , шкафом для одежды, мини-баром и принадлежностями для чая/кофе. К услугам гостей — 2 кровати.	2	2	queen-size	47065.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/646826123.jpg?k=6c74d2dd8ef0cac2438c491c8dcc198cab8eecdf182922b17aeb9d01bec5a88e&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/669841409.jpg?k=d42161433413382090e221d9a9fbbddff2d1a61339db0fb4c77241fe383be68e&o=}	2026-05-02 00:54:33.602874	2026-05-02 00:54:33.602874	45.00
2	1	Sands Premier King	Двухместный номер с 1 кроватью и собственной ванной комнатой с ванной, душем и биде. Предоставляются халаты и бесплатные туалетно-косметические принадлежности. Просторный двухместный номер с 1 кроватью оснащен кондиционером, мини-баром и телевизором с плоским экраном. В числе удобств шкаф для одежды и принадлежности для чая/кофе. Установлена 1 кровать.	2	1	king-size	47065.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/646829906.jpg?k=f9146cb08bef6ff1a7cc72d2fb7c6a46e1cc2cff33ce3de43a70bdcd24ac4ce7&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/669841409.jpg?k=d42161433413382090e221d9a9fbbddff2d1a61339db0fb4c77241fe383be68e&o=}	2026-05-02 01:47:24.46899	2026-05-02 01:47:24.46899	45.00
38	3	Suite Charlie Chaplin	Главная изюминка этого номера — потрясающий вид на Вандомскую площадь, открывающийся с большого экрана. Это великолепный широкоформатный ракурс на архитектурную жемчужину — королевскую площадь. Он позволяет увидеть все как единое целое, независимо от освещения — дневным светом или искусственным. А теперь... Мотор!	2	1	king-size	914410.00	{Wi-Fi,Паркинг,Завтрак,"Вид на площадь Вандом","Большая отдельная гардеробная комната",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100003/927-86reg1rl2e-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/924-qxuqhmuigu-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/930-dabepry97u-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/939-56xu06vtgp-web4k.jpg}	2026-05-02 02:59:33.343658	2026-05-02 02:59:33.343658	72.00
50	5	Plaza 1 king	Высокие потолки, удобная зона отдыха с видом на внутренний дворик или город. Просторная ванная комната, отделанная мозаичной плиткой и золотой сантехникой, с ванной и отдельной душевой кабиной.	2	1	king-size	115489.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rokgc_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgc_01_p_2048x1536.jpg}	2026-05-02 14:50:55.774022	2026-05-02 14:50:55.774022	44.00
13	1	Sands Premier King Gardens by the Bay View	Просторный двухместный номер с 1 кроватью, кондиционером, мини-баром, балконом с видом на сад и собственной ванной комнатой с ванной. К услугам гостей 1 кровать.	2	1	king-size	52948.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647110796.jpg?k=63ff9c46943d4e1d572d13110f07d361df25ef1076a3fbc5f7d82a40b5728bf8&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/669841409.jpg?k=d42161433413382090e221d9a9fbbddff2d1a61339db0fb4c77241fe383be68e&o=}	2026-05-02 02:19:07.05623	2026-05-02 02:19:07.05623	45.00
14	1	Sands Premier Double Queen Gardens by the Bay View	Ощутите атмосферу роскошного образа жизни и несравненного гостеприимства, превосходящую все ваши ожидания. Отдохните в элегантном номере, оснащенном 75-дюймовым телевизором и встроенными интеллектуальными технологиями. В тележке для коктейлей вы найдете большое количество чая ручной работы, различных закусок, вина, пива и газированных напитков, а также готовых коктейлей. Освежитесь в просторной ванной комнате с роскошной ванной, тропическим душем и отдельным умывальником.	2	2	queen-size	52948.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647110588.jpg?k=c2aca828b5b33effb91755971302958522a863f69529129b2b2ea328c84d8fd3&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/669841409.jpg?k=d42161433413382090e221d9a9fbbddff2d1a61339db0fb4c77241fe383be68e&o=}	2026-05-02 02:19:21.042938	2026-05-02 02:19:21.042938	45.00
15	1	Sands Premier Double Queen City View	Двухместный номер с 2 отдельными кроватями и собственной ванной комнатой с ванной, душем и биде. Предоставляются халаты и бесплатные туалетно-косметические принадлежности. Просторный двухместный номер с 2 отдельными кроватями оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств шкаф для одежды и принадлежности для чая/кофе. Из окон открывается вид на город. Установлены 2 кровати.	2	2	queen-size	55890.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111401.jpg?k=4f6ad56b992884b6277da8184c1014c6f100195413912b4495ee0490db8ef589&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111400.jpg?k=cc7658e47bda6bf7d8aeda89694d56e15d00c91e4eab6164995a108a91bd5a20&o=}	2026-05-02 02:19:35.920079	2026-05-02 02:19:35.920079	45.00
51	5	Deluxe 1 king	Высокие потолки, удобная зона отдыха и вид на внутренний дворик или город. Просторная ванная комната, отделанная мозаичной плиткой и золотой сантехникой, с ванной и отдельной душевой кабиной. Возможна раскладная кровать.	3	1	king-size	120721.00	{Wi-Fi,"Сейф в номере","Вид на город или вид на внутренний двор","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rokga_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgc_01_p_2048x1536.jpg}	2026-05-02 14:53:02.927858	2026-05-02 14:53:02.927858	51.00
16	1	Sands Premier Double Queen City View	Двухместный номер с 2 отдельными кроватями и собственной ванной комнатой с ванной, душем и биде. Предоставляются халаты и бесплатные туалетно-косметические принадлежности. Просторный двухместный номер с 2 отдельными кроватями оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств шкаф для одежды и принадлежности для чая/кофе. Из окон открывается вид на город. Установлены 2 кровати.	2	2	queen-size	55890.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111401.jpg?k=4f6ad56b992884b6277da8184c1014c6f100195413912b4495ee0490db8ef589&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111400.jpg?k=cc7658e47bda6bf7d8aeda89694d56e15d00c91e4eab6164995a108a91bd5a20&o=}	2026-05-02 02:19:48.132713	2026-05-02 02:19:48.132713	45.00
17	1	Sands Premier King City View	К услугам гостей двухместный номер с 1 кроватью и собственной ванной комнатой с ванной, душем и биде. Предоставляются халаты и бесплатные туалетно-косметические принадлежности. Просторный двухместный номер с 1 кроватью оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств шкаф для одежды и принадлежности для чая/кофе. Из номера открывается вид на город. Установлена 1 кровать.	2	1	king-size	55890.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111514.jpg?k=23998e6a0ae8334c63c8d023f55143ad47d505f54b98eee11ec0865947df69fa&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647111400.jpg?k=cc7658e47bda6bf7d8aeda89694d56e15d00c91e4eab6164995a108a91bd5a20&o=}	2026-05-02 02:19:56.454205	2026-05-02 02:19:56.454205	45.00
18	1	Sands Premier Studio King Gardens by the Bay View	Среди удобств просторного двухместного номера с 1 кроватью — кондиционер, мини-бар, балкон с видом на сад, а также собственная ванная комната с ванной. Установлена 1 кровать.	2	1	king-size	67656.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/710488823.jpg?k=b1d488d623accc831d7f421d1a7429ba8f675c7c377bf548f588d6c334d6a067&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/710488840.jpg?k=7c2811dbb60cf585c10199c8464b8e3fc9dc0727241f19188cb35231d54a0267&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/710489075.jpg?k=feddda595b598bbfaec42a6654567cb13a49b6b116a2d56ceb409b8b853dc86b&o=}	2026-05-02 02:20:05.088446	2026-05-02 02:20:05.088446	70.00
19	1	Sands Premier Studio King City View	В распоряжении гостей этого двухместного номера с 1 кроватью собственная ванная комната с душем, ванной, биде, халатами и бесплатными туалетно-косметическими принадлежностями. Среди удобств просторного двухместного номера с 1 кроватью и видом на город — кондиционер, мини-бар, чайник/кофеварка, гостиная зона, а также телевизор с плоским экраном. Установлена 1 кровать.	2	1	king-size	73540.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/710490323.jpg?k=a413e10f81b60cd6d517de024d8d2c164a05491cd84a3e543a2205c73240cd9c&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/710490326.jpg?k=d9db2cfeb08dd69f5d06b2172332f6d1051c9161ce5a0100afb58f396c08117b&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/780953829.jpg?k=e644ae45fde7e75a7cde13ded4615a2ccd6a53d514a8fa08eca3bb6f0426d59c&o=}	2026-05-02 02:20:13.561088	2026-05-02 02:20:13.561088	70.00
20	1	Sands Bay Suite King Gardens by the Bay View	В распоряжении гостей этого просторного люкса кондиционер, мини-бар, балкон с видом на сад, а также собственная ванная комната с ванной. Установлена 1 кровать.	2	1	king-size	88247.00	{"Бесплатные туалетно-косметические принадлежности",Халат,Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/710490323.jpg?k=a413e10f81b60cd6d517de024d8d2c164a05491cd84a3e543a2205c73240cd9c&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/710490326.jpg?k=d9db2cfeb08dd69f5d06b2172332f6d1051c9161ce5a0100afb58f396c08117b&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/780953829.jpg?k=e644ae45fde7e75a7cde13ded4615a2ccd6a53d514a8fa08eca3bb6f0426d59c&o=}	2026-05-02 02:20:21.204709	2026-05-02 02:20:21.204709	81.00
21	1	Sands Bay Suite Double Queen Gardens by the Bay View	Просторный люкс с 1 гостиной, 1 отдельной спальней и 1 ванной комнатой с ванной. Предоставляются бесплатные туалетно-косметические принадлежности. Люкс с видом на сад оснащен кондиционером и телевизором с плоским экраном. В числе удобств мини-бар, принадлежности для чая/кофе и гостиная зона. Установлены 2 кровати.	2	2	queen-size	88247.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс",Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/708326169.jpg?k=409353c6c054acc46d25304ccd36b7f3e62c2ff39e74f74835c39c515c0ea604&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178152.jpg?k=40a0088663b15fdd8de6ead6bb00256ecef67b66a674af97347cedf6911ba344&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178143.jpg?k=e0de64a1f1ca7dda6cca44372f9d6cc9579f06c9c257d15c5e4c86dfe4b1dd3a&o=}	2026-05-02 02:20:30.173233	2026-05-02 02:20:30.173233	81.00
22	1	Sands Bay Suite King City View	К услугам гостей люкса собственная ванная комната с ванной, душем и биде. Предоставляются халаты и бесплатные туалетно-косметические принадлежности. Просторный люкс с видом на город оснащен кондиционером, мини-баром и телевизором с плоским экраном. В числе удобств гостиная зона и принадлежности для чая/кофе. Установлена 1 кровать.	2	1	king-size	94131.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс","Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178515.jpg?k=eb629bb2e8c8c059c5a717cbc7996e5057b6c69e4ff0bf3b6502a927ab2eb25d&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178514.jpg?k=b646a59c64724dbea2e3a2a8ffeece6dc0e7a46d5114922f655e71a73acb3324&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178512.jpg?k=77ddf1404f6168d0a6ef1f5594a435925bc0b3bfac2df08d55d622e150a1b277&o=}	2026-05-02 02:20:40.166308	2026-05-02 02:20:40.166308	81.00
23	1	Sands Bay Suite Double Queen City View	Просторный люкс с 1 гостиной, 1 отдельной спальней и 1 ванной комнатой с ванной. Предоставляются бесплатные туалетно-косметические принадлежности. Люкс с видом на город оснащен кондиционером и телевизором с плоским экраном. В числе удобств мини-бар, принадлежности для чая/кофе и гостиная зона. Установлены 2 кровати.	2	2	queen-size	94131.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс","Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/708326273.jpg?k=109b2d02a54ddd94c89d58300c8e5f02fec91ba487dcf72d8025e14d891872f7&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178514.jpg?k=b646a59c64724dbea2e3a2a8ffeece6dc0e7a46d5114922f655e71a73acb3324&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178512.jpg?k=77ddf1404f6168d0a6ef1f5594a435925bc0b3bfac2df08d55d622e150a1b277&o=}	2026-05-02 02:20:49.403517	2026-05-02 02:20:49.403517	81.00
24	1	Sands Premier Suite King Gardens by the Bay View	Просторный люкс с 1 спальней и 1 ванной комнатой с ванной и бесплатными туалетно-косметическими принадлежностями. Люкс оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств гостиная зона и принадлежности для чая/кофе. Из окон открывается вид на сад. Установлена 1 кровать.	2	1	king-size	100014.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс",Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118927.jpg?k=3336fdc99900254d39bbfe701af0b298ce6d096216f4fc663e71895716b385ce&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118933.jpg?k=55a24a792cacbd01bff4d963dd3ea6fe3eed7fbd8f9e3fd2605f08a022097039&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118928.jpg?k=609a9a3cfb9f2c3a105d2ece330cf731911faee3123ff5995ee5a044aa760873&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118930.jpg?k=48390b03a432153aef8e57a230579e4d2c7ab0237faff412430bff5bd6133817&o=}	2026-05-02 02:20:58.144565	2026-05-02 02:20:58.144565	95.00
25	1	Sands Premier Suite King City View	Просторный люкс с 1 спальней и 1 ванной комнатой с ванной и бесплатными туалетно-косметическими принадлежностями. Люкс оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств гостиная зона и принадлежности для чая/кофе. Из окон открывается вид на город. Установлена 1 кровать.	2	1	king-size	105897.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс","Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647171049.jpg?k=4390e4c4eb3e6ce1ed738c982274e39839d484fe65616ec8485a099b27beaf11&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647171010.jpg?k=40b84cfe28f6f6d10dd73ac7aa8020d975d421c9ee0883b22d32bd2b85b16941&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118928.jpg?k=609a9a3cfb9f2c3a105d2ece330cf731911faee3123ff5995ee5a044aa760873&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118930.jpg?k=48390b03a432153aef8e57a230579e4d2c7ab0237faff412430bff5bd6133817&o=}	2026-05-02 02:21:06.127994	2026-05-02 02:21:06.127994	95.00
26	1	Sands Premier Suite Double Queen City View	Просторный люкс с 1 спальней и 1 ванной комнатой с ванной и бесплатными туалетно-косметическими принадлежностями. Люкс оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств гостиная зона и принадлежности для чая/кофе. Из окон открывается вид на город. Установлены 2 кровати.	2	2	queen-size	105897.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс","Вид на город",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647171049.jpg?k=4390e4c4eb3e6ce1ed738c982274e39839d484fe65616ec8485a099b27beaf11&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647171010.jpg?k=40b84cfe28f6f6d10dd73ac7aa8020d975d421c9ee0883b22d32bd2b85b16941&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118928.jpg?k=609a9a3cfb9f2c3a105d2ece330cf731911faee3123ff5995ee5a044aa760873&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647118930.jpg?k=48390b03a432153aef8e57a230579e4d2c7ab0237faff412430bff5bd6133817&o=}	2026-05-02 02:21:13.968739	2026-05-02 02:21:13.968739	95.00
27	1	Sands Family Suite	В распоряжении гостей просторного семейного номера кондиционер, стиральная машина, а также собственная ванная комната с душем и ванной. Мини-кухня укомплектована посудой и микроволновой печью. Среди удобств семейного номера — балкон, мини-бар, принадлежности для чая/кофе и телевизор с плоским экраном. Установлены 2 кровати.	4	2	king-size	117663.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственная мини-кухня",Балкон,Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647172364.jpg?k=7bf3ec368561c72339d114efe87898423bfc09464939849bf5ccc35623dcaeaf&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647172376.jpg?k=950158b5eb5d684e2fe718b2ac36ba127b75dd99c95166e9345528bb3b01a4cb&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647172411.jpg?k=0007c601fbef15a08f93446111731bbb55b02e80828006f30f4e43821579f77a&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/669841409.jpg?k=d42161433413382090e221d9a9fbbddff2d1a61339db0fb4c77241fe383be68e&o=}	2026-05-02 02:21:20.906211	2026-05-02 02:21:20.906211	75.00
28	1	Sands Premier 2-Bedroom Suite Gardens by the Bay View	Просторный люкс с 1 гостиной, 2 отдельными спальнями и 2 ванными комнатами с ванной. Предоставляются бесплатные туалетно-косметические принадлежности. Люкс оснащен кондиционером, телевизором с плоским экраном и мини-баром. В числе удобств гостиная зона и принадлежности для чая/кофе. Из окон открывается вид на сад. Установлены 2 кровати.	6	2	king-size	223560.00	{"Бесплатные туалетно-косметические принадлежности",Халат,"Собственный люкс",Балкон,"Вид на сад",Сейф,Биде,Туалет,"Ванна или душ",Полотенца,Телевизор,Тапочки,Телефон,"Гладильные принадлежности",Кофеварка/чайник,Утюг,Фен,"Ковровое покрытие","Электрический чайник","Услуга «звонок-будильник»","Сейф для ноутбука","Шкаф или гардероб","Лифт для доступа к верхним этажам","Туалетная бумага"}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178152.jpg?k=40a0088663b15fdd8de6ead6bb00256ecef67b66a674af97347cedf6911ba344&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178172.jpg?k=f61023bcd32f8c7bb20e7a6301b35414c0ca247a5fc91a433a0f6c6be6a9f571&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/647178143.jpg?k=e0de64a1f1ca7dda6cca44372f9d6cc9579f06c9c257d15c5e4c86dfe4b1dd3a&o=}	2026-05-02 02:21:27.686618	2026-05-02 02:21:27.686618	131.00
29	2	Burj Three Bedroom Family Suite	Роскошный двухуровневый люкс 670 м? с видом на Марину и Палму. Три спальни, три гостиные, столовая на 8 персон и детские игровые зоны. В каждой спальне — ванная с джакузи. Бесплатный дворецкий, рабочий кабинет, вместимость до 8 гостей.	7	2	king-size	899671.00	{"Услуги дворецкого мирового класса","Вид на море","Ежедневный завтрак \\"шведский стол\\" для двоих в Junsui или Bab Al Yam или в номере","3 ванные комнаты с джакузи и отдельным душем","Набор для Него и для Неё Hermes","Отдельный вход для персонала",Wi-Fi,"21-дюймовый iMac","Среда с дистанционным управлением - включая шторы, телевизор, встроенную музыку и освещение, а также персональный многофункциональный принтер, копир, сканер и факс"}	t	{https://s01.cdn.pegast.ru/get/d0/57/17/410c125b8211e752c8121a9a3cbc7322c787ee77c504cb9082472c47e0/5d81e72d73022.jpg,https://s01.cdn.pegast.ru/get/09/58/8f/dfea3d99f523519c84b5ab88ab0ea3676142acf8afa8d7f86a339c8414/5d81e72e17eb6.jpg,https://s01.cdn.pegast.ru/get/47/e2/17/3f13259469ebc3acc8e510aec23faf9fd8000f667aa812480ed9c0d309/5d81e72cce1ea.jpg}	2026-05-02 02:24:04.618869	2026-05-02 02:24:04.618869	670.00
30	2	Burj 2 Bedroom Family Suite	Роскошный двухуровневый люкс 335 м? с видом на Марину и Пальму. Две спальни с ванными (джакузи + душ), гостиная, столовая на 6 персон, рабочий кабинет. Бесплатный дворецкий, детская игровая зона. Вместимость до 7 гостей.	6	2	king-size	534521.00	{"Услуги дворецкого мирового класса","Вид на море","Ежедневный завтрак \\"шведский стол\\" для двоих в Junsui или Bab Al Yam или в номере","2 ванные комнаты с джакузи и отдельным душем","Набор для Него и для Неё Hermes","Отдельный вход для персонала",Wi-Fi,"21-дюймовый iMac","Среда с дистанционным управлением - включая шторы, телевизор, встроенную музыку и освещение, а также персональный многофункциональный принтер, копир, сканер и факс"}	t	{https://s01.cdn.pegast.ru/get/06/52/9b/2a7db59da9a76c3283e3696c5f95b7647285ce1aedc090f289e4684ef0/5d81e637775fb.jpg,https://s01.cdn.pegast.ru/get/8a/51/1f/6d2a8515f60167f4d4b2d87adc3ea43979a10eb4627f1a425e6532e56a/5d81e6350a740.jpg,https://s01.cdn.pegast.ru/get/b5/0d/c7/f4e59bc7ef4cead6c7106c60d4fd698c141d465f3b922338fa82ea131f/5d81e63593fbd.jpg}	2026-05-02 02:28:58.720552	2026-05-02 02:28:58.720552	335.00
31	2	Sky Palm Suite	Роскошный двухуровневый люкс 170 м? с видом на Пальму. Спальня king-size с ванной (джакузи + душ), гостиная, рабочий кабинет с iMac. Бесплатный дворецкий. Вместимость до 4 гостей.	4	2	king-size	449835.00	{"Окна от пола до потолка с прекрасным видом океана","Электронная система в номере, рабочий стол и высокоскоростное соединение Wi-Fi","Услуги дворецкого мирового класса","Трансфер Rolls Royce","Доступ к частному пляжу Джумейры, бассейны и The Terrace","Неограниченный доступ в аквапарк Wild Wadi Waterpark","Вертолетная площадка для частных трансферов"}	t	{https://pic-h.cdn.pegast.ru/getimage-h/thumbh720/19/c9/50/cfd89034f36e110bcd65075ff6053f37edc14a1c6344c36418905d2390/61c3ab35549d2.jpg,https://pic-h.cdn.pegast.ru/getimage-h/thumbh720/52/5d/14/871b1a1b565bf7d641fbcbdc9135dfd4c5a758f8d0f8bbe593e73c7c7f/61c3ab3373e0e.jpg,https://pic-h.cdn.pegast.ru/getimage-h/thumbh720/a2/81/16/1faeec7efb5478511c2c57c92265032ffb5b3226b31a3d534cb831993d/61c3ab31381bd.jpg}	2026-05-02 02:34:01.118601	2026-05-02 02:34:01.118601	170.00
39	3	Suite Maria Callas	Этот престижный люкс на шестом этаже посвящен легендарной сопрано, которая находила здесь убежище между своими концертами. Это романтический оазис абсолютной женственности, с балконами, выходящими на ее любимый Париж; уединенное место, достойное королевы, которой она была.	3	1	king-size	2110178.00	{Wi-Fi,Паркинг,Завтрак,"4 балкона","Большая отдельная гардеробная комната",Хаммам,"2 ванные комнаты",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100003/960-pxgj0lwvs1-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/951-yq9tgy8wbw-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/954-idf87tdm3u-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/957-9qd4i04bnl-web4k.jpg}	2026-05-02 03:01:43.065856	2026-05-02 03:01:43.065856	120.00
32	2	Panoramic Suite	Панорамный двухуровневый люкс 225 м? с видом 180° на Дубай и залив. Спальня king-size с ванной (джакузи), гостиная с баром, столовая на 4 персоны. Бесплатный дворецкий, панорамные окна. Вместимость до 4 гостей.	4	2	king-size	712239.00	{"Услуги дворецкого мирового класса","Вид на море","Ежедневный завтрак \\"шведский стол\\" для двоих в Junsui или Bab Al Yam или в номере","ванная комната с джакузи и отдельным душем","Набор для Него и для Неё Hermes","Отдельный вход для персонала",Wi-Fi,"21-дюймовый iMac","Среда с дистанционным управлением - включая шторы, телевизор, встроенную музыку и освещение, а также персональный многофункциональный принтер, копир, сканер и факс"}	t	{https://s01.cdn.pegast.ru/get/41/82/44/c8dd592b10832e7f450f1336043aa09dd4be859be893914de00c283933/5d81df2999e75.jpg,https://s01.cdn.pegast.ru/get/3e/ce/c9/90063241a13bd199156d999a32fe429fcec7bef66c4be70cc285ea6646/5d81df2a3617f.jpg,https://s01.cdn.pegast.ru/get/b5/0d/c7/f4e59bc7ef4cead6c7106c60d4fd698c141d465f3b922338fa82ea131f/5d81df2adcdc8.jpg}	2026-05-02 02:38:22.269026	2026-05-02 02:38:22.269026	225.00
33	3	Superior Room	Когда вы впервые мечтали о романтическом отдыхе в историческом центре Парижа, именно этот роскошный номер был у вас в голове. Мраморный камин, изысканные зеркала, шикарная ванная комната, томный свет, проникающий сквозь элегантные окна. Ваша мечта сбылась.	2	1	king-size	284895.00	{Wi-Fi,Паркинг,Завтрак,Кондиционер,Балкон,"Спа и бассейн"}	t	{https://ak-d.tripcdn.com/images/1mc5p12000nz2grzmA1CA_W_1280_853_R5.webp,https://ak-d.tripcdn.com/images/1mc1a12000nz2gwwyACC0_W_1280_853_R5.webp,https://ak-d.tripcdn.com/images/1mc3h12000nz2h6ja23F5_W_1280_853_R5.webp}	2026-05-02 02:47:19.982684	2026-05-02 02:47:19.982684	35.00
34	3	Grand Deluxe Room	Мы называем его Grand не просто так. Часть "Deluxe" вполне ожидаема, но ощущение простора в наших самых больших номерах просто невероятное. За каждым углом вас ждут всевозможные очаровательные сюрпризы, и по ощущениям номер почти не уступает люксу.	3	1	king-size	342903.00	{Wi-Fi,Паркинг,Завтрак,Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100003/1092-yjlob3ep2m-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/1089-m9i3y25vyq-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100003/1083-p7buoe1lri-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100001/525-5y6ei27hop-web4k.jpg}	2026-05-02 02:49:58.125506	2026-05-02 02:49:58.125506	55.00
35	3	Suite Prince de Galles	Самый франкофильский из всех английских принцев, будущий Эдуард VII, настолько ценил искусство жизни , что заявлял: «Куда бы ни пошёл Ritz, я пойду за ним!» Тот же дух аристократического мастерства пронизывает номер, названный в его честь. Воплощение очарования.	3	1	king-size	650638.00	{Wi-Fi,Паркинг,Завтрак,"Большая отдельная гардеробная комната","2 ванные комнаты",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100002/813-82bkjlmwq5-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/816-ru9s3e8wtb-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/819-6uqb7b241e-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/810-wef82s144i-web4k.jpg}	2026-05-02 02:52:42.092572	2026-05-02 02:52:42.092572	93.00
36	3	Suite Grand Jardin	В самом сердце нашего отеля находится драгоценный камень; волшебное место, уединенное над деревьями. Белые цветы расцветают в тени листвы террасы, и в этом «висячем саду» прямо посреди Парижа царит почти олимпийское спокойствие.	3	1	king-size	773732.00	{Wi-Fi,Паркинг,Завтрак,"Вид на Большой сад","Частная крыша","2 отдельных входа","Большая отдельная гардеробная комната","2 ванные комнаты",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100002/684-b7bbdokvav-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/699-pqsrwp1ckl-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/705-rau6xkg8hu-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/687-qe22otgo3k-web4k.jpg}	2026-05-02 02:55:08.265674	2026-05-02 02:55:08.265674	80.00
37	3	Suite Grand Jardin	Откройте для себя культовый парижский горизонт прямо из своего номера. Вы окажетесь в первом ряду, достойном оперной сцены, с величественным видом на позолоченный дворец Гарнье и характерные крыши Города Света. Пусть представление начнется!	3	1	king-size	861656.00	{Wi-Fi,Паркинг,Завтрак,"Вид на Большой сад","Вид на Оперу Гарнье","2 отдельных входа","Большая отдельная гардеробная комната","2 ванные комнаты",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100001/486-lued4oh3su-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100001/498-u7my9rtti1-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100001/489-o32tbi0hp1-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100001/495-am2aamvfht-web4k.jpg}	2026-05-02 02:57:08.077551	2026-05-02 02:57:08.077551	87.00
146	21	Double Room	Двухместный номер с кроватью  "queen-size", для людей с ограниченными физическими возможностями.	2	1	queen-size	15019.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/576822281.jpg?k=bb6bb26db1630c8da4b4a98c45b9433e0bf3b605f57efb167253078946f9e0cb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/576812993.jpg?k=7975a02c10c4394355ac5ee9412cdd36223707535ec8966aee080d64acc95290&o=}	2026-05-03 02:06:43.346154	2026-05-03 02:06:43.346154	25.00
40	3	L Appartement Ritz	Неповторимая парижская квартира: весь седьмой этаж отеля с отдельным выходом в великолепное пространство площадью 170 м?. Снаружи две террасы с видом на Большой сад и крыши города. Именно здесь в отеле Ritz чувствуешь себя как дома.	3	2	king-size	2637723.00	{Wi-Fi,Паркинг,Завтрак,"Вид на Оперу Гарнье","Вид на Большой сад","Отдельная кухня",Терраса,"Большая отдельная гардеробная комната","2 спальни",Кондиционер,Балкон,"Спа и бассейн"}	t	{https://media.ritzparis.com/medias/domain12964/media100002/615-2qchs4it4y-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/612-inrhbusktr-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/615-2qchs4it4y-web4k.jpg,https://media.ritzparis.com/medias/domain12964/media100002/624-4bmase2s3g-web4k.jpg}	2026-05-02 03:08:00.553154	2026-05-02 03:08:00.553154	169.00
41	4	Ocean King Room	Трехместный номер с кондиционером и шкафом для одежды. В распоряжении гостей 1 кровать.	2	1	king-size	32892.00	{Wi-Fi,"Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476403.jpg?k=62b729fbc16a796086d0acb33a4bdc96e7a33cb594902ca44e7b34701265e51a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476393.jpg?k=4113971bea52eb7e37a77b3093e2d141576aeb76ff0f696248982b1325b74cef&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476586.jpg?k=9b7ed2e3df84298eff7c194ebf4379468c26db2463f4efa534052455753b72ed&o=}	2026-05-02 03:18:03.141111	2026-05-02 03:18:03.141111	45.00
42	4	Ocean Queen Room	Четырехместный номер с кондиционером и шкафом для одежды. Установлены 2 кровати.	2	2	queen-size	37487.00	{Wi-Fi,"Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476386.jpg?k=98c49c9e089f0026369d66c14cc6660189ca2580d909e25af47031b5b2d99c9f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476390.jpg?k=231d8543c064a5554d6bd820b2258d2c6cd6fc0b695fab29e6472cb6545c09c4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476586.jpg?k=9b7ed2e3df84298eff7c194ebf4379468c26db2463f4efa534052455753b72ed&o=}	2026-05-02 14:26:27.174148	2026-05-02 14:26:27.174148	45.00
43	4	Imperial Club King Palm Room	Трехместный номер с кондиционером и шкафом для одежды. Установлена 1 кровать.	2	1	king-size	44134.00	{Wi-Fi,"Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476383.jpg?k=9ce0629ff86c96be79cb29bbff810c0fb634bd1f94260d9d3b6b9b9feaa8bba6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476374.jpg?k=bdc4eb3974c2b70978b3b6a0a57553be4de8cb243a2894afbd4307373cc5ab1e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476602.jpg?k=e3a2126ae9eb39f0a7cb422e5615d5d14f10d33bfe26f3ca1a094b50fc32fd3f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476586.jpg?k=9b7ed2e3df84298eff7c194ebf4379468c26db2463f4efa534052455753b72ed&o=}	2026-05-02 14:28:44.277438	2026-05-02 14:28:44.277438	45.00
44	4	Terrace Suite - includes Club access	В Клубном люксе Terrace обустроена терраса с 2 шезлонгами, обеденным столом на 4 персоны и видом на море или городской пейзаж Дубая. В гостиной комнате с раздвижными деревянными дверями установлены телевизор с плоским экраном и рабочий стол. В спальне к услугам гостей гардеробная и кровать размера «king-size». В ванной комнате с отдельными душевыми кабинами (для него и для нее) и большой гидромассажной ванной предоставляются банные халаты, тапочки и туалетно-косметические принадлежности.	2	1	king-size	58530.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476427.jpg?k=8a596ab40029ca73d55081010c02d275cc6d88f1743eafca307fc090837b48a7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476429.jpg?k=4bdd2f71ba9f4bb86962e81d486186721310fe5fcda79da5e554246bddc44159&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476435.jpg?k=7ca548a4c4f91af91273e871d6159794ae2781bc2c1ca5df55397e171b56543b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476436.jpg?k=11b24717df329b29c36b06500af392afe3a81d53bd090c3e8768d1d3d736c0a4&o=}	2026-05-02 14:31:17.576461	2026-05-02 14:31:17.576461	94.00
45	4	Regal Suite Club - includes Club access	Люкс с видом на море или городской пейзаж Дубая. В числе удобств рабочий стол с кожаным креслом, обеденный стол на 6 человек, гостиная с телевизором с плоским экраном и балкон с 2 шезлонгами. В спальне установлена кровать размера «king-size» и встроенный шкаф, обустроена гостиная зона. В ванной комнате к услугам гостей 2 отдельных душа (для него и для нее) и гидромассажная ванна. Предоставляются туалетно-косметические принадлежности.	2	1	king-size	72415.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476413.jpg?k=a459d5ed5d441c0a5055657f79827533d3c0a53c0b2071c21fee9b84465e3b52&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476416.jpg?k=f31b3cece490c386d150315a9f746a0af7033bb96eff953184daa08e5747d647&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476402.jpg?k=f6329218ffb4bf6b09c0b19e1c5849dec0d2620a91dbca254e6314f470ac3c85&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476426.jpg?k=38f565478b12206eb1b9da13c1cb3db0baa7eb26b0912317656a05db500eab44&o=}	2026-05-02 14:33:33.263033	2026-05-02 14:33:33.263033	164.00
147	21	Standard Double Room with Sofa Bed	Стандартный двухместный номер с 1 кроватью и диваном-кроватью	2	2	queen-size	18595.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/576821513.jpg?k=70fb891a6845f3c78668fb65ce393c269a2d68394f30ea267026276fe8eba9a1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/576821828.jpg?k=779cee5938c2e490c66f77040c299382ae0a928d874ca4dac47198ae50f335f4&o=}	2026-05-03 02:09:34.699185	2026-05-03 02:09:34.699185	22.00
46	4	Regal Family Suite - includes Club access	Люкс с видом на море или городской пейзаж Дубая. В числе удобств рабочий стол с кожаным креслом, обеденный стол на 6 человек, гостиная с телевизором с плоским экраном и балкон с 2 шезлонгами. В распоряжении гостей 2 смежные комнаты, в каждой из которых установлена кровать размера «king-size» и встроенный шкаф, а также обустроена гостиная зона. В ванной комнате к услугам гостей 2 отдельных душа (для него и для нее) и гидромассажная ванна в центре комнаты. Предоставляются туалетно-косметические принадлежности.	4	3	king-size	115780.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476413.jpg?k=a459d5ed5d441c0a5055657f79827533d3c0a53c0b2071c21fee9b84465e3b52&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476416.jpg?k=f31b3cece490c386d150315a9f746a0af7033bb96eff953184daa08e5747d647&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476402.jpg?k=f6329218ffb4bf6b09c0b19e1c5849dec0d2620a91dbca254e6314f470ac3c85&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476426.jpg?k=38f565478b12206eb1b9da13c1cb3db0baa7eb26b0912317656a05db500eab44&o=}	2026-05-02 14:36:33.325011	2026-05-02 14:36:33.325011	164.00
47	4	Presidential Suite	Светлый люкс с кондиционером и балконом с панорамным видом на пляжи отеля Atlantis и городской пейзаж Дубая. Номер украшен хрустальными люстрами. В числе удобств отдельная гостиная с 60-дюймовым телевизором с плоским экраном, обеденный стол на 8 человек и смежный кабинет. В номере можно воспользоваться бесплатным Wi-Fi. В распоряжении гостей полностью оборудованная кухня с плитой, посудомоечной машиной и холодильником. В ванной комнате установлена большая гидромассажная ванна и 2 отдельных тропических душа для него и для нее, предоставляются бесплатные туалетно-косметические принадлежности.	3	1	king-size	361839.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476477.jpg?k=f0041175bb25c5983567ef631ac08e5345096da10b07d509acf23006e9afe61a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476472.jpg?k=d382e3b038e07a32e18d8614f3962b52020526ed247eeb0f23af0c2c90d36f44&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/727476484.jpg?k=4b3079b54756ab7a7df63cc51a832f9407957f1285ea556e0c134a8d3c499110&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/727476500.jpg?k=da127338dead0ff5c55842d89e123e2a63c98ab3c383dbe744ae117191d1da63&o=}	2026-05-02 14:38:53.589678	2026-05-02 14:38:53.589678	250.00
48	4	Poseidon Underwater Suite	Трехуровневый подводный люкс с собственным лифтом, который соединяет вход в фойе с гостиной с французскими окнами, из которых открывается вид на океанариум Ambassador Lagoon. К услугам гостей обеденная зона на 6 персон и телевизор с плоским 60-дюймовым экраном. Винтовая лестница ведет в подводную спальню с уникальной атмосферой и прямым видом на подводный мир. Уютная гостиная зона в арабском стиле меджлис оснащена телевизором с плоским экраном. К услугам гостей собственная гидромассажная ванна с видом на океанариум с 65 000 морскими животными и роскошные туалетно-косметические принадлежности.	3	1	king-size	588908.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/852090562.jpg?k=2f081a1c0ac4bcfc497653927161e892bffcbea32f898e739a5842ab1351a6f7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/852090545.jpg?k=528f4c777c380c92d818a5a3755e3d7e943094413cb868d01ce838cf0a7e60c7&o=}	2026-05-02 14:40:50.171181	2026-05-02 14:40:50.171181	165.00
49	4	Grand Atlantis Suite	Каждая комната этого люкса Grand Atlantis площадью 358 кв. метров демонстрирует настоящее понимание роскоши. К услугам гостей не менее 5 балконов, а также огромная терраса для загара с выходом на три стороны люкса и видом на 270 градусов. В люкс с декорированным высоким потолком ведут 3 входа, украшенные большими фонтанами в виде статуи рыбы-дракона. В гостиной со сомежным кабинетом установлены телевизор с плоским 60-дюймовым экраном и обеденный стол на 8 персон. Гости могут готовить на полностью оборудованной кухне с плитой, посудомоечной машиной и холодильником. В двух изысканных спальнях с прекрасным дизайном к услугам гостей 4 встроенных шкафа, туалетная комната и гостиный уголок. Гости могут расслабиться в потрясающих ванных комнатах с видом на голубой океан. В каждой из них установлены тропический душ и очень большая гидромассажная ванна. Предоставляются роскошные туалетно-косметические принадлежности.	6	2	king-size	740423.00	{Wi-Fi,"Собственный люкс",Балкон,"Вид на море","Завтрак и ужин",Кондиционер,"Шкаф или гардероб"}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/727476461.jpg?k=27c504bbb32e9dbe70c1d49b7ae27efe5988bf81c63cf4a50d30da8d4758fc18&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476530.jpg?k=32854fd5de851459e0e28c8f9ba9375215358ac5a979451894f49a41e081312f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476510.jpg?k=c37f1d6de5c2e058b98f3d68eaba16d2cf61cfa130367df31d7bf4e5b8cb559e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476511.jpg?k=22305d69584326ae2d15846cb697c35c0eb9151ce2857f863d803089b1a9128a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/727476513.jpg?k=b3770bd37de50f2ce2e89180b421641d1aa618782e2890072c600caf85876f01&o=}	2026-05-02 14:42:49.66426	2026-05-02 14:42:49.66426	429.00
52	5	Terrace room 1 king	Высокие потолки, собственная терраса. Включает в себя удобную зону отдыха, просторную ванную комнату, отделанную мозаичной плиткой и золотой сантехникой, а также столешницы из белого мрамора. Дополнительную раскладную кровать можно установить.	2	1	king-size	124459.00	{Wi-Fi,"Сейф в номере","Вид на город или вид на внутренний двор","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rokgb_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgc_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgb_02_p_2048x1536.jpg}	2026-05-02 14:54:43.317335	2026-05-02 14:54:43.317335	51.00
53	5	Grand luxe 1 king	Высокие потолки и просторная зона отдыха открытой планировки. В ванной комнате ванна, отдельная душевая кабина и фурнитура золотистого цвета. Включает мраморный мини-бар. Разрешается установка дополнительной раскладной кровати.	3	1	king-size	134176.00	{Wi-Fi,"Сейф в номере","Вид на город или вид на внутренний двор","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosob_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgc_01_p_2048x1536.jpg}	2026-05-02 14:56:56.05737	2026-05-02 14:56:56.05737	58.00
54	5	Family grand luxe 2 queens	Просторный номер с двумя двуспальными кроватями, высокими потолками и большой гостиной зоной открытой планировки, включающей раскладной диван и кладовую для продуктов. Ванная комната оборудована ванной, отдельной душевой кабиной и сантехникой золотистого цвета. Вид на город.	6	2	king-size	175288.00	{Wi-Fi,"Сейф в номере","Вид на город или вид на внутренний двор","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosra_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rokgc_01_p_2048x1536.jpg}	2026-05-02 14:58:49.978863	2026-05-02 14:58:49.978863	68.00
55	5	Edwardian suite 1 king	Высокие потолки и просторная отдельная гостиная. В ванной комнате есть ванна, отдельная душевая кабина и фурнитура золотистого цвета. Также имеется гостевой туалет, диван-кровать, мини-бар и услуги дворецкого (по запросу).	4	1	king-size	167813.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_roskc_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_roskc_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_roskc_02_p_2048x1536.jpg}	2026-05-02 15:00:47.002426	2026-05-02 15:00:47.002426	93.00
56	5	Gatsby suite 1 king	Полулюкс в эффектном стиле ар-деко эпохи джаза с купольными потолками, антикварными зеркалами и стеклянными люстрами. Включает услуги дворецкого.	2	1	king-size	173793.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosld_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosld_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosld_02_p_2048x1536.jpg}	2026-05-02 15:02:23.947974	2026-05-02 15:02:23.947974	65.00
57	5	Pulitzer fifth ave suite 1 king	Высокие потолки и вид на Пятую авеню, отдельная гостиная, гостевой туалет и большая ванная комната с отдельной душевой кабиной. В стоимость включены услуги дворецкого.	4	1	king-size	220138.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Вид на город","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosrb_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosrb_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosrb_02_p_2048x1536.jpg}	2026-05-02 15:05:14.661391	2026-05-02 15:05:14.661391	93.00
58	5	Penthouse suite 1 king	Двухуровневый люкс с одной спальней, отдельным кабинетом, большой частной террасой, двумя ванными комнатами и раскладным диваном двуспальной кровати.	4	1	king-size	291150.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Вид на город","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rostb_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rostb_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosrb_02_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rostb_03_p_2048x1536.jpg}	2026-05-02 15:06:39.252525	2026-05-02 15:06:39.252525	139.00
59	5	Vanderbilt fifth ave 2 br suite king	Двухкомнатный люкс с видом на 5-ю авеню. Просторная гостиная, обеденная зона, 2 ванные комнаты, ванна на ножках и отдельная душевая кабина. В стоимость включены услуги дворецкого.	6	2	king-size	343475.00	{Wi-Fi,"Сейф в номере","Затемняющая штора","Вид на город","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosta_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosta_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosta_02_p_2048x1536.jpg}	2026-05-02 15:08:47.901636	2026-05-02 15:08:47.901636	139.00
60	5	Grand penthouse 2 br terrace suite	Двухуровневый люкс с двумя спальнями, расположенный на верхнем этаже, предлагает захватывающий вид на Центральный парк и городской пейзаж. В каждой спальне — кровать размера «кинг-сайз». Большая терраса. В стоимость включены услуги дворецкого.	4	2	king-size	2991107.00	{Wi-Fi,"Сейф в номере",Терраса,"Затемняющая штора","Вид на парк","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rovca_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rovca_03_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rovca_05_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rovca_01_p_2048x1536.jpg}	2026-05-02 15:11:16.994774	2026-05-02 15:11:16.994774	232.00
61	5	Royal suite 3 bedrooms	Трехкомнатный люкс с тремя ванными комнатами, собственным лифтом и видом на 5-ю авеню. Собственный тренажерный зал, кухня, библиотека, кухня для шеф-повара и обеденный стол на 12 человек. Включает услуги дворецкого.	8	3	king-size	4110856.00	{Wi-Fi,"Сейф в номере",Терраса,"Затемняющая штора","Вид на парк","Рабочий стол",Завтрак,Кондиционер,"Шкаф или гардероб"}	t	{https://www.ahstatic.com/photos/a568_rosba_00_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosba_01_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosba_02_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosba_03_p_2048x1536.jpg,https://www.ahstatic.com/photos/a568_rosba_07_p_2048x1536.jpg}	2026-05-02 15:13:54.834533	2026-05-02 15:13:54.834533	409.00
62	6	Grand Premier King Room	В этом просторном номере царит атмосфера очаровательной современной парижской резиденции. В распоряжении гостей просторная отделанная мрамором ванная комната с системой подогрева пола, зеркалом со встроенным телевизором, тропическим душем и ванной.	2	1	king-size	317723.00	{Wi-Fi,"Сейф в номере",Балкон,"Затемняющая штора","Вид на сад",Сауна,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/475494180.jpg?k=32d98092eb23178b0cc1e40c7134356d0c8014137ed6bdea342e71748c0b3507&o=,https://cf.bstatic.com/xdata/images/hotel/square60/826930928.jpg?k=c3ffafe46aa5ea29203f8b287b7e3ec2144cc0c363b16373474c77b5f26e4713&o=,https://cf.bstatic.com/xdata/images/hotel/square60/143117851.jpg?k=e8afe11c82838faf3beeae8049afd2331b04e4e24b15a5d19bfd999b2377698a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/104374799.jpg?k=598169b119396e23e9309b41111ec7a8d56f8204d6cf870952f630646bd131d5&o=}	2026-05-02 15:20:17.310436	2026-05-02 15:20:17.310436	42.00
63	6	Junior Suite	Сауна — главная изюминка этого трехместного номера. В номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с душевой кабиной, ванной и биде. Просторный трехместный номер с кондиционером оснащен телевизором с плоским экраном и возможностью просмотра потоковых сервисов, звукоизолированными стенами, мини-баром, принадлежностями для приготовления чая и кофе, а также видом на город. В номере 1 кровать.	2	1	king-size	348612.00	{Wi-Fi,"Сейф в номере",Балкон,"Затемняющая штора","Вид на сад",Сауна,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/827631553.jpg?k=8ed46b6ea93cf9b0913d582e6f1b88ae8243adae5196b9f0e8f32ac92a08aaf1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/436512985.jpg?k=c77db7df223eb5dae3abc4644633b23fa4cfb9a59b83a820e6481967ec71e486&o=,https://cf.bstatic.com/xdata/images/hotel/square60/349474499.jpg?k=8c0bb48ac3fb76afcd531ae5880e783d47c89b5c919c290915c07cbd2f2159e0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/827631427.jpg?k=09fb840e177722f853e92576913837495a3cf1cffdaab33ef91f730d61e921a6&o=}	2026-05-02 15:22:23.769112	2026-05-02 15:22:23.769112	45.00
64	6	Premier Suite	Этот люкс с просторной спальней и отдельной гостиной обставлен элегантной мебелью, выполненной на заказ, и украшен художественными работами. В распоряжении гостей просторная отделанная мрамором ванная комната с системой подогрева пола, зеркалом со встроенным телевизором, тропическим душем и ванной.	2	1	king-size	503061.00	{Wi-Fi,"Сейф в номере",Балкон,"Затемняющая штора","Вид на сад",Сауна,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/826926598.jpg?k=d9962645dfbf6aacb9302be8627f39b815ec5bfdcc9fa1f0caac8d74dbd4a650&o=,https://cf.bstatic.com/xdata/images/hotel/square60/826928130.jpg?k=0735da949aa2b838dad22cce0afa6a21b4f8c703251b725c073abea3b3d66d7d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/143119299.jpg?k=a21d3bf0e114c45224d1102a78ea82abcc42bdb1e72a971e9e910fbd5ece7fc8&o=,https://cf.bstatic.com/xdata/images/hotel/square60/826929300.jpg?k=8562499c4957aab0e80b9307be01ed9bd044f93bb6a04da8a88e04a02ee12ab3&o=}	2026-05-02 15:23:56.629427	2026-05-02 15:23:56.629427	57.00
76	8	Two-Bedroom Family	В распоряжении гостей 2 спальни и общая ванная комната. Спальни оформлены в элегантном эдвардианском стиле со множеством оригинальных элементов интерьера. Через окна с видом во внутренний двор проникает много естественного света.	4	3	king-size	296289.00	{Wi-Fi,"Собственный люкс","Вид на город","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/770210834.jpg?k=45aa178a889134b26a8ba2e3781fa2c4e613d06c1c986ad741fc7bc7b1542b1f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/846049607.jpg?k=ed50bd0b63c1af298f4d3c07e8704ef254c09cb9023c7a3f8115b69a7375c3dd&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210980.jpg?k=580c6d1ba7150fd2b7d42a2ebfb9f40c0bc63ff8a6918481c05e33a8937f6641&o=}	2026-05-02 15:57:29.520811	2026-05-02 15:57:29.520811	55.00
65	6	Grand Premier Suite	Этот люкс с просторной спальней и отдельной гостиной оформлен в уникальном парижском стиле. В распоряжении гостей просторная отделанная мрамором ванная комната с системой подогрева пола, зеркалом со встроенным телевизором, тропическим душем и ванной.	2	1	king-size	564840.00	{Wi-Fi,"Сейф в номере",Балкон,"Затемняющая штора","Вид на сад",Сауна,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/614225229.jpg?k=59b5f8e5e41e9d7ca4b70a19ab0dd025f103a9b31c6433073c78b3b9786bc00c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/826932625.jpg?k=9b97d5318134ed7e882dcc6f21da13ce279b9b2b5eec9d96252c6d4f4b7c6804&o=,https://cf.bstatic.com/xdata/images/hotel/square60/172289724.jpg?k=a2e3c7375aec8980e0fd550bd94439352ae17db5df0486e333990e2b473117c7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/826932722.jpg?k=f3f1029c4473b1bcc84c94ec30f6005a4bc19a0c4d23ce25d103df8ae2879b9a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/827628393.jpg?k=9d4410dafb862db767a29fe93d80d72d3fece348f29b18c3c26404417fb34487&o=}	2026-05-02 15:26:13.554074	2026-05-02 15:26:13.554074	72.00
66	7	Luxury Room Palace wing	Уютные номера расположены в историческом крыле Palace и подарят гостям незабываемые впечатления. В данных номерах нет окон, что создает атмосферу полного спокойствия. Номера подойдут бизнес-путешественникам, которые ценят высокие стандарты роскоши.	2	1	king-size	33188.00	{Wi-Fi,"Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/103556733.jpg?k=a4d4d421cb0a31d374b9fb1761cb7e65e25643461d247c134f448b87b7cfd798&o=,https://cf.bstatic.com/xdata/images/hotel/square60/216924011.jpg?k=6b88b22be777fcc6a45b505c9b8b4ba6e3a10df67190996fc9eeceb56e5ffdc4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103556645.jpg?k=dbc9d7474bfcc3203fb444341f077ac7a13d6ec40ffe232c36a47eb908ba1673&o=}	2026-05-02 15:31:56.745759	2026-05-02 15:31:56.745759	33.00
67	7	Luxury Grande Room Sea View	Элегантно оформленные номера с атмосферой очаровательной старины. Из изысканных эркерных окон в раджпутском стиле открывается вид на море. В некоторых номерах установлена ванна.	2	1	king-size	35559.00	{Wi-Fi,"Вид на море","Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/103556733.jpg?k=a4d4d421cb0a31d374b9fb1761cb7e65e25643461d247c134f448b87b7cfd798&o=,https://cf.bstatic.com/xdata/images/hotel/square60/152822703.jpg?k=06d8a8497fdd78c3d9aeddfcb48d3a36879352caf1960c8f58221130cdd7e509&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103556645.jpg?k=dbc9d7474bfcc3203fb444341f077ac7a13d6ec40ffe232c36a47eb908ba1673&o=}	2026-05-02 15:33:27.796026	2026-05-02 15:33:27.796026	33.00
68	7	Taj Club Room Sea View King Bed with Complimentary One Way Airport Transfer	Элегантно оформленные номера с атмосферой очаровательной старины. Из изысканных эркерных окон в раджпутском стиле открывается вид на море. В некоторых номерах установлена ванна.	2	1	king-size	38719.00	{Wi-Fi,"Вид на море","Трансфер от/до аэропорта на выбор","Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/305159686.jpg?k=ae35948fc9b37da38b9f9662d93c0623f6525cd659852af15cedaaa72f543619&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103704163.jpg?k=9dd8b05e48351b64895b00908231925c942bcef4f591f26d39fbcda05e26c454&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103556645.jpg?k=dbc9d7474bfcc3203fb444341f077ac7a13d6ec40ffe232c36a47eb908ba1673&o=}	2026-05-02 15:38:14.497494	2026-05-02 15:38:14.497494	37.00
69	7	Executive Suite City View with Complimentary One Way Airport Transfer	Элегантно оформленные номера с атмосферой очаровательной старины. Из изысканных эркерных окон в раджпутском стиле открывается вид на море. Во всех номерах установлена ванна.	2	1	king-size	58474.00	{Wi-Fi,"Вид на город","Собственный люкс","Трансфер от/до аэропорта на выбор","Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/102614877.jpg?k=765e20225d6be39daf00a6dbe479c4e6dcbfcc8e00f20466e204afb0f1b244e9&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103703440.jpg?k=2392b0e11df1f24e6a04238bf42a6dd27c9e5964e5139cdbec756062f7db61d0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103556882.jpg?k=b97773ac9d16d032990d528f2b9fc697e2a76eca4f62152b979f1fc47548f021&o=}	2026-05-02 15:40:35.302493	2026-05-02 15:40:35.302493	70.00
70	7	Luxury Suite 1 Bedroom City View - 2 Way Airport Transfer	Элегантно оформленные номера с атмосферой очаровательной старины. Из изысканных эркерных окон в раджпутском стиле открывается вид на море. Во всех номерах установлена ванна.	2	1	king-size	66376.00	{Wi-Fi,"Вид на город","Трансфер от и до аэропорта ","Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/176113777.jpg?k=982b8710d50b0e5b6e2db2b275928784748b993a039a1c3b1257e58b19a235fc&o=,https://cf.bstatic.com/xdata/images/hotel/square60/176113646.jpg?k=8c8b8207d416d7f51cce910a578fd570cf5e8da93be2e6c6ddb81e39237c0780&o=,https://cf.bstatic.com/xdata/images/hotel/square60/216924131.jpg?k=a0e0d42abc7c4fb3af32b5568dbfb6494492676cf85e5a69b76ce506bf9ae585&o=}	2026-05-02 15:42:29.298851	2026-05-02 15:42:29.298851	83.00
71	7	Grande Luxury Suite 1 Bedroom Sea View - 2 Way Airport Transfer	Элегантно оформленные номера с атмосферой очаровательной старины. Из изысканных эркерных окон в раджпутском стиле открывается вид на море. Во всех номерах установлена ванна.	2	1	king-size	128801.00	{Wi-Fi,"Вид на море","Собственный люкс","Трансфер от и до аэропорта ","Сейф в номере","Телевизор с плоским экраном","Завтрак, обед, ужин",Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/102614888.jpg?k=46d6683d293307b02ed3420977984bebb54449f8dbf1290130fa619b32ea0060&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103704615.jpg?k=cd0caa4306d0f6c713ec4e91d5641e837b01694d161d9ecc8a51fb478af34b0e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103703707.jpg?k=ff7137bde4172579c84f5e9b22a4c18ad1af45b96428e42cd2fe7ace13dd454a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/216924603.jpg?k=95f2ee32d0c822dd912a1fdc466c34446371a299204aef5dbe11c12e4ecfd1fa&o=}	2026-05-02 15:44:26.175979	2026-05-02 15:44:26.175979	121.00
72	8	Superior Queen Room	Эти номера, идеально подходящие для одноместного размещения, оформлены в эдвардианском стиле или в стиле ар-деко со множеством оригинальных элементов интерьера. В номерах установлены кровати размера «queen-size». Из улучшенных номеров с кроватью размера «queen-size» открывается вид во внутренний двор или на город. В этих номерах прекрасное естественное освещение.	2	1	queen-size	101147.00	{Wi-Fi,"Вид на город","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/787654115.jpg?k=30e677afbb66afdeecc8d4c3f7f32e0fecaf2ebe772d753141edd3f951ff6168&o=,https://cf.bstatic.com/xdata/images/hotel/square60/789587895.jpg?k=90c9ba192fc4a0cb6fa747f0253e5936ebe5359009dab53dd36a2008010b033b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/787654129.jpg?k=b67411e716a597a197da88010123ef9435e518036afa39b4f655c9dd6a3ef836&o=}	2026-05-02 15:49:44.31386	2026-05-02 15:49:44.31386	30.00
73	8	Luxury King Room	Отличительными особенностями роскошного номера с кроватью размера «king-size» являются его большая площадь и индивидуальный декор. Номер оформлен в эдвардианском стиле или в стиле ар-деко, в интерьере сохранились многие оригинальные черты эпохи. Из окон открывается вид на город, во внутренний двор или частичный вид на реку. В роскошных номерах с кроватью размера «king-size» прекрасное естественное освещение.	2	1	king-size	115451.00	{Wi-Fi,"Вид на город","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/846049601.jpg?k=6900e938a2d92577217fe81b1ded755434dfe1327c86891c8938d88533c47789&o=,https://cf.bstatic.com/xdata/images/hotel/square60/846049598.jpg?k=81974954a04818b72e6e7f255107854986f9b34b7874d545998a6e566be5171c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/191547520.jpg?k=2d9deb06f738ff6c1a1d8342e7f48961db06c27e7fb7201e548827dce40c2756&o=}	2026-05-02 15:51:19.327125	2026-05-02 15:51:19.327125	40.00
74	8	Junior Suite	Просторные полулюксы открытой планировки с гостиной и спальной зонами, встроенным шкафом и гардеробом. Номера оформлены в элегантном эдвардианском стиле или в изысканном стиле ар-деко. Среди удобств кровати размера «king-size» и большие окна с видом на город или сад, обеспечивающие хорошее естественное освещение.	2	1	king-size	149166.00	{Wi-Fi,"Собственный люкс","Вид на город","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/787654115.jpg?k=30e677afbb66afdeecc8d4c3f7f32e0fecaf2ebe772d753141edd3f951ff6168&o=,https://cf.bstatic.com/xdata/images/hotel/square60/707235057.jpg?k=07b239d19a99e88aa698ccdfa4cd8f68db9f2c95854faad8335ecf753306005a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210924.jpg?k=11fe2880a49eb20a42c58f830cfef813eb9ab31a4739a5d7322962c4e3df9e66&o=}	2026-05-02 15:53:08.740414	2026-05-02 15:53:08.740414	42.00
75	8	One-Bedroom Suite	Люкс Timeless с 1 спальней оформлен в элегантном эдвардианском стиле или в изысканном стиле ар-деко. На входе имеется фойе, из которого можно пройти в гостиную, спальню и ванную комнату. В числе удобств кровать размера «king-size» или «queen-size». Из окон открывается вид во внутренний двор или на город, благодаря чему в номер проникает большое количество естественного света. Люксы в значительной степени сохранили свои оригинальные черты и не похожи друг на друга.	2	1	king-size	169600.00	{Wi-Fi,"Собственный люкс","Вид на город","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/770210858.jpg?k=b7df9ec43a32f4706c477116c1249b43a398fb93a112849e8f39952e0898531f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210929.jpg?k=8e7348171fc4d09852afa1e1e00dfdbb0d006cf9a4fd1eabe07038875d759a99&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210999.jpg?k=7560c2f03e06e0ea5446ae0cbe7322db110a247f9a89fe5ce255444dfca436b1&o=}	2026-05-02 15:55:20.246391	2026-05-02 15:55:20.246391	60.00
77	8	Terrace Suite	Этот люкс включает в себя 2 гостиные, 2 отдельные спальни и 2 ванные комнаты с ванной и бесплатными туалетными принадлежностями. В этом люксе с кондиционером есть обеденная зона, телевизор с плоским экраном и спутниковыми каналами, мини-бар и терраса. В номере 2 кровати.	4	2	king-size	537832.00	{Wi-Fi,"Собственный люкс","Вид на город","Вид на реку","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/770210823.jpg?k=99445fbda43e2d712c48abec4d2d67c4144d4e2805407ed0ebc00000917bd8b7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210931.jpg?k=3878ba9327a3bbfd9c8c7ac277d2862463a592c021ffb47db5f4856c0d1c8be1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770210966.jpg?k=3589895cf40095acfc7bfce61a148e76f211c36fc0df4136e6f3c4b01b5f3d4b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770211016.jpg?k=684bf044a35a5cc54743078440341550277b235d4af77f1f9d86a70dace29e64&o=,https://cf.bstatic.com/xdata/images/hotel/square60/770211028.jpg?k=73046e3625fd81d9a4cbed388406542f0185f25ed70f0844d0efdc23dd6103a8&o=}	2026-05-02 15:59:59.805904	2026-05-02 15:59:59.805904	42.00
78	9	City View Deluxe Room	Большие окна в этих номерах открывают захватывающие виды на оживленный район Копакабана в Рио.	2	1	king-size	53460.00	{Wi-Fi,"Вид на город","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере","Телевизор с плоским экраном",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXC/1.jpg&quot,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXC/2.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXC/4.jpg}	2026-05-02 16:13:22.663205	2026-05-02 16:13:22.663205	40.00
79	9	Deluxe Ocean View	Каждое утро вы будете просыпаться, любуясь потрясающим видом на пляж Копакабана и океан за ним.	2	1	king-size	80353.00	{Wi-Fi,"Вид на море","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере",Балкон,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXO/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXO/3.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/DLXO/4.jpg}	2026-05-02 16:17:06.630734	2026-05-02 16:17:06.630734	45.00
80	9	One Bedroom Suites Ocean Viewz	Люксы с одной спальней и видом на океан выходят окнами на море или пляж Копакабана.	3	1	king-size	100611.00	{Wi-Fi,"Вид на море","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере",Балкон,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/STEO/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/STEO/2.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/STEO/6.jpg}	2026-05-02 16:19:33.653272	2026-05-02 16:19:33.653272	60.00
81	9	Two Bedroom Ocean View Suites	Роскошные двухкомнатные люксы с видом на океан выходят на пляж Копакабана и предлагают захватывающие виды на пляж и океан.	5	2	king-size	221107.00	{Wi-Fi,"Вид на море","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере",Балкон,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR2DOS/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR2DOS/2.jpg}	2026-05-02 16:27:43.432113	2026-05-02 16:27:43.432113	106.00
82	9	Ocean View Penthouse	Эти номера-люкс расположены на верхнем этаже главного здания и предлагают панорамный вид на океан.	2	1	king-size	274719.00	{Wi-Fi,"Вид на море","Полуприватный доступ к бассейну на шестом этаже","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере",Балкон,Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/PSTO/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/PSTO/2.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/PSTO/4.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/PSTO/10.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/PSTO/11}	2026-05-02 16:31:43.573967	2026-05-02 16:31:43.573967	113.00
83	9	Two Bedroom Ocean View Penthouse	Эти апартаменты с двумя спальнями расположены на верхнем этаже и имеют веранду с видом на пляж Копакабана.	4	2	king-size	576484.00	{Wi-Fi,"Вид на море","Полуприватный доступ к бассейну на шестом этаже","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере","Веранда с видом на пляж",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR2PEN/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR2PEN/2.jpg}	2026-05-02 16:34:12.208338	2026-05-02 16:34:12.208338	223.00
84	9	Two Bedroom Copacabana	Эти элегантные апартаменты с двумя спальнями предлагают дополнительную приватность и вид на море с веранды.	6	2	king-size	887417.00	{Wi-Fi,"Вид на море","Полуприватный доступ к бассейну на шестом этаже","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере","Оборудованная веранда выходит на пляж",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/COPA/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/COPA/3.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/COPA/4.jpg}	2026-05-02 16:36:58.474505	2026-05-02 16:36:58.474505	235.00
85	9	Seven Bedroom Penthouse suite	Роскошный пентхаус на верхнем этаже с семью спальнями – это настоящий оазис роскоши.	14	7	king-size	2279149.00	{Wi-Fi,"Вид на море","Отдельный доступ к бассейну на шестом этаже.","50-дюймовый смарт-телевизор LED HDTV с кабельным телевидением и премиум-каналами","Аудиоколонка Bluetooth","Сейф в номере","Оборудованная веранда выходит на пляж",Завтрак,Кондиционер,"Шкаф или гардероб",Кофемашина}	t	{https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/1.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/2.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/3.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/4.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/5.jpg,https://storage.googleapis.com/bbe-media/assets/images/RoomImages/COP/CR7PEN/6.jpg}	2026-05-02 16:40:26.771512	2026-05-02 16:40:26.771512	833.00
86	10	Junior Terrace Suite King	Этот просторный люкс состоит из 1 гостиной, 1 отдельной спальни и 1 ванной комнаты с феном и бесплатными туалетными принадлежностями. В люксе есть кондиционер, мини-бар, сейф и телевизор с кабельными каналами. В номере 1 кровать.	2	1	king-size	140373.00	{Wi-Fi,Кондиционер,Сейф,Телевизор,Фен,Телефон,Завтрак,Балкон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811167890.jpg?k=ce8fcbcf2040462973e3bdf60e195ba0f1e62efcba4453d2938b5738f8abdcd7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811167892.jpg?k=06250345511f4af9075d9ced1308ff865046d49a5b3b24989b0c361007ea6a75&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811167889.jpg?k=ee7a502c73249f3dbacdc593aaeb926ad29617b5d7dcd10dc0b4747fd0db1b4d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811462383.jpg?k=0358e253eb56770f8a60905362395850d6a31a116c89384d225ee65e19184895&o=}	2026-05-02 16:46:02.19175	2026-05-02 16:46:02.19175	97.00
87	10	Chao Phraya Suite King	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с феном и бесплатными туалетными принадлежностями. В люксе также есть балкон, кондиционер, мини-бар и телевизор с кабельными каналами. В номере 1 кровать.	2	1	king-size	143099.00	{Wi-Fi,Кондиционер,Сейф,Телевизор,Фен,Телефон,Завтрак,Балкон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811165551.jpg?k=74001ff9cb4fdfbee73825664d1660f76d76f9949b859ee348e42c6f28850b0e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811165555.jpg?k=f3cd663a4f7ba78edf99d716a50fa5a69c22cc471557d90c0d3d8e646d6be373&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811165560.jpg?k=c27dc6a6a9f400b3c1fd899fd6ed948d72bda38fbf8bbc15286feca0cc191430&o=,https://cf.bstatic.com/xdata/images/hotel/square60/814356146.jpg?k=4395658b56825c26e29d22a159b5a1d9648aa966a17cc6991512195d0120dcc2&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811165550.jpg?k=f43f6c154e7d55921f732115ce2677d19de5320d8247e077842a4bb8d2fc5c0e&o=}	2026-05-02 16:48:16.040536	2026-05-02 16:48:16.040536	83.00
88	10	Deluxe One-Bedroom Suite King	Просторный люкс оборудован кондиционером, мини-баром, а также собственной ванной комнатой с феном. В номере 1 кровать.	2	1	king-size	154001.00	{Wi-Fi,Кондиционер,Сейф,Телевизор,Фен,Телефон,Завтрак}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811168294.jpg?k=d9e1bb387dfba81c13204a9b454c4c1e125178d2ff45bcb5a6794c1463e790a2&o=,https://cf.bstatic.com/xdata/images/hotel/square60/813924318.jpg?k=900b6dd87fe7a01e2b0b9d17f0b66a33cd72fc7e320eaf2103f0e01d3b8b393c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811168290.jpg?k=1037e267d17d11626a28a43bbe24f90437b49c3fe161a1e60239938133a32797&o=,https://cf.bstatic.com/xdata/images/hotel/square60/814356226.jpg?k=dc1255cdc0322d87b38494de0d0b21165ef7a94b68f75db7f7ffd572ee6d06ba&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811168287.jpg?k=88b1ff5d1a8451b550abfa6345ed9aa1b107b3120e831c1c660da5124a2a9991&o=}	2026-05-02 16:50:16.777823	2026-05-02 16:50:16.777823	83.00
89	10	Premier Suite King	В номере есть кондиционер. В номере 2 кровати.	2	1	king-size	159453.00	{Wi-Fi,"Собственный люкс",Балкон,Кондиционер,Сейф,Телевизор,Фен,Телефон,Завтрак}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811159655.jpg?k=cdeb1a646d3919b9ab238dd3b120ba367c39aa2efe9790b25b104166efe166d2&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811159652.jpg?k=9815e1580eb20fe27c525f9fe2f36395c794b0e76caccd8d73a815a14adefa9a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811159653.jpg?k=6c3abfa874e55a9be9c3cc04e1ab127ecd8c1a571d84e3f324ad387c65bb9375&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811159647.jpg?k=5d435bc2289fa49ea51fe9aa6eadda4d14c254ec217d6694dd5b3d3bbc3a9c34&o=,https://cf.bstatic.com/xdata/images/hotel/square60/814356240.jpg?k=63b549b0682e04703edef9bb2181650b19543c22d02aaceec2fdb4f245dd4655&o=}	2026-05-02 16:53:39.626173	2026-05-02 16:53:39.626173	108.00
90	10	Authors Suite King	Просторный люкс оборудован кондиционером, мини-баром, а также собственной ванной комнатой с ванной или душем и феном. В люксе также есть сейф, телевизор с кабельными каналами и балкон. В номере имеется 1 кровать.	2	1	king-size	164904.00	{Wi-Fi,"Собственный люкс",Балкон,Кондиционер,Сейф,Телевизор,Фен,Телефон,Завтрак}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811167530.jpg?k=aa8e99d56c59aa87c775491c2fc8874de89d1db5587e4e6714a2d0ae1c333400&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811167635.jpg?k=24d566e626823398080cdb275a4167f6cfe56f3da852cac2eb96aa02203b03f4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811167600.jpg?k=a2768c5cc2ec51b8a546cfe2051d327a319a28f7e084d409ca11c414bf17d17d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/811167612.jpg?k=b2b297629ff550f664a79d67865fd3d23155385a7f54db88cb750369bf74e717&o=,https://cf.bstatic.com/xdata/images/hotel/square60/814356110.jpg?k=43578ddcbc498ca406f7cf670e60f908e11fd0e5b85e5a61443417584c6d0397&o=}	2026-05-02 16:55:35.958384	2026-05-02 16:55:35.958384	101.00
91	11	Superior Double Room	Номера категории «Супериор» — это образец аутентичного, элегантного русского стиля, которым наш отель славится уже много лет. Из окон открывается вид на внутренний двор.	2	1	queen-size	24000.00	{Wi-Fi,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186800/639113344286806052-05d77b1a-9ea9-4b52-b90a-72694b308bf9,https://secure.travelline.ru/resource/images/rt/186800/639113344306262862-de2be8f9-df29-4507-9c92-9f41e02cd526,https://secure.travelline.ru/resource/images/rt/186800/639113344296597337-9d56d49a-7a03-4473-944a-1ff8c30d4773}	2026-05-02 17:59:30.78044	2026-05-02 17:59:30.78044	23.00
92	11	Deluxe Arts Square view room	Из этих номеров открывается прекрасный вид на ансамбль Художественной площади, Русский музей и живописную зеленую зону в центре города.	2	1	king-size	33000.00	{Wi-Fi,"Вид на город",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186801/637883825613517210-ef6efb21-54fe-4d2b-8716-78100b4ec746,https://secure.travelline.ru/resource/images/rt/186801/637883825613517210-ef6efb21-54fe-4d2b-8716-78100b4ec746,https://secure.travelline.ru/resource/images/rt/186801/637883825644482425-2d14f8a3-7a0f-4a12-aee7-451293fb64a0}	2026-05-02 18:01:53.591192	2026-05-02 18:01:53.591192	32.00
93	11	Junior Suite	Номера категории «полулюкс» оформлены в классическом стиле XIX века. В них есть просторная гостиная с большими окнами, выходящими на Невский проспект.	3	1	king-size	52000.00	{Wi-Fi,"Вид на город",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186819/639113350000560093-f81ceab5-3147-4b45-88f4-4a148d49e672,https://secure.travelline.ru/resource/images/rt/186819/639113349982657121-413bf7a4-5c2e-4e9c-9431-5a8d5b9c3fb0,https://secure.travelline.ru/resource/images/rt/186819/639113350010324606-bb1ab5d7-02d1-4b53-b815-446f6526be52}	2026-05-02 18:04:47.33978	2026-05-02 18:04:47.33978	41.00
95	11	Historic Suite	Номера люкс расположены на историческом этаже отеля и сохранили декор и антикварную мебель XIX века. Планировка исторических номеров люкс включает гостиную, спальню, прихожую и просторную ванную комнату, отделанную итальянским мрамором. Все номера люкс оборудованы большой кроватью или двуспальной кроватью. Каждый номер имеет свое название и соответствующий уникальный дизайн.	3	1	king-size	117000.00	{Wi-Fi,"Вид на город",Терраса,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186834/637883847730078068-a44a950b-453e-4419-9dad-ecca26d8c1d4,https://secure.travelline.ru/resource/images/rt/186834/637883846312812284-d882b3e0-cd01-4203-8005-f568a4df1b0c,https://secure.travelline.ru/resource/images/rt/186834/637883849795957916-6cbbfb91-6325-4c34-beea-4b495a87d420}	2026-05-02 18:13:03.902164	2026-05-02 18:13:03.902164	55.00
96	11	Presidential Suite	Дизайн этих люксов вдохновлен творчеством выдающихся художников-авангардистов, живших и работавших в России. Каждый из них выполнен в уникальном стиле. Интерьеры вызывают в памяти работы известных художников, в честь которых названы номера. Большинство люксов имеют просторную гостиную и отдельный холл.	3	1	king-size	357000.00	{Wi-Fi,"Вид на город","Эксклюзивная мебель",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186883/637883857090086268-147b68a0-f268-4e3c-a665-f569348c65ae,https://secure.travelline.ru/resource/images/rt/186883/637883857155189002-3171fee0-60fb-403b-bc6a-e26f271c33ef,https://secure.travelline.ru/resource/images/rt/186883/637883857819113877-e583e042-6b86-4df8-9d51-d9b2087618f9}	2026-05-02 18:15:07.165764	2026-05-02 18:15:07.165764	125.00
97	11	Imperial Suite	Расположенные на углу Невского проспекта и Михайловской улицы, эти апартаменты не имеют себе равных среди всех гостиничных номеров города. Роскошные апартаменты «Император» занимают 350 квадратных метров. Просторная и роскошная планировка позволила разместить здесь кабинет с библиотекой, спальню с большой кроватью с балдахином, тренажерный зал, сауну. Просторная гостиная, столовая на десять человек с полностью оборудованной кухней, лаунж-бар с потрясающим видом на Невский проспект, простирающийся вдаль.	3	2	king-size	607000.00	{Wi-Fi,"Вид на город",Сауна,"Тренажёрный зал","Эксклюзивная мебель",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/186887/637883861080882371-e123f8f3-0fb4-433e-85c9-08ef12e3a41c,https://secure.travelline.ru/resource/images/rt/186887/637883860719433646-a410df42-a5c8-4a9d-933b-d620324b836a,https://secure.travelline.ru/resource/images/rt/186887/637883859693230467-ed02387b-b6d0-4682-8492-ad71f4a2b590,https://secure.travelline.ru/resource/images/rt/186887/637883860422158549-60b23800-dc30-4cbe-98d1-c0e51cef90fd}	2026-05-02 18:17:57.630792	2026-05-02 18:17:57.630792	350.00
98	12	Grand Deluxe King Room	Номера «Гранд Делюкс» с видом на округ Коулун-Сити и горы вдалеке расположены на верхних этажах башни отеля Peninsula. Окна номеров обеспечивают отличное естественное освещение. К услугам гостей бесплатный доступ в интернет и роскошная мебель.	2	1	king-size	60304.00	{Wi-Fi,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/736840739.jpg?k=3074a1172b8c15d51749c3006375df69bd7e5f1d1090781b9e115eaa8357d18f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/104104437.jpg?k=91ac5f75a806e315daee91e0704a35c9aba7c90c42eb7374a1cfa480e7cf0a2c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/736850250.jpg?k=5d5b1c76e494729b72db3eadb829bf7b641db56674fc6fd6e6c24c2d9fb67e6b&o=}	2026-05-02 18:23:50.19258	2026-05-02 18:23:50.19258	43.00
99	12	Grand Deluxe Harbour View King Room	Из этого просторного номера открывается живописный вид на гавань Виктория. В числе удобств место для работы и качественное аудиовизуальное оборудование. Доставка еды и напитков осуществляется круглосуточно. В отделанной мрамором ванной комнате установлена гидромассажная ванна.	2	1	king-size	71791.00	{Wi-Fi,Шкаф,Завтрак,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/534754911.jpg?k=8addd908cd4f806e675a26e24f609008fc1ec476114487c4a50bb78547126ad4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/103899137.jpg?k=39b8d4b78584cbbff038e239e6d887dd9ae37e0ea4261fd05ba4f60d22abd734&o=,https://cf.bstatic.com/xdata/images/hotel/square60/736850250.jpg?k=5d5b1c76e494729b72db3eadb829bf7b641db56674fc6fd6e6c24c2d9fb67e6b&o=}	2026-05-02 18:26:10.973657	2026-05-02 18:26:10.973657	42.00
100	12	Superior Courtyard Suite	Просторный люкс с 1 спальней, гостиной зоной и 1 ванной комнатой с безбарьерным душем и ванной. Из окон открывается вид на город; установлен кондиционер. В числе удобств — мини-бар, принадлежности для чая/кофе и шкаф для одежды, а также телевизор с плоским экраном и кабельными каналами. Установлена 1 кровать.	2	1	king-size	84235.00	{Wi-Fi,"Собственный люкс","Вид на город",Шкаф,Завтрак,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/534754232.jpg?k=b63a2c9a7532257d3466d87a57f9b6b1dfe54e5d45813afc218fbed43602dd0e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/481218635.jpg?k=f4c8f9bc1182bd1031a75a518564f45c9d82b58b6c9c58cdb7c366768968def7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/486470911.jpg?k=5c2c70bbb1d0bb17282d170d3abea00d577b2d4ff67f2b66b59a405e60a4b59d&o=}	2026-05-02 18:28:36.492831	2026-05-02 18:28:36.492831	86.00
101	12	Deluxe Suite	Люкс с гостиной зоной. К услугам гостей 1 кровать.	2	1	king-size	100507.00	{Wi-Fi,"Собственный люкс","Вид на город",Шкаф,Завтрак,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/533649761.jpg?k=f2ed2c1caea39ea732b54e2dc9ca3f0826dc429cc5a1ded8200b1da95dfbd648&o=,https://cf.bstatic.com/xdata/images/hotel/square60/533649771.jpg?k=deab1aafa96a4cb7cc7111c33c6ab9a340a19eda39901f5534f7c1831d79cb13&o=,https://cf.bstatic.com/xdata/images/hotel/square60/19758430.jpg?k=901bc864152378d7c7c6e8e2c02b8ad10b801737deab0657e9bb3596651ec86a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/486470911.jpg?k=5c2c70bbb1d0bb17282d170d3abea00d577b2d4ff67f2b66b59a405e60a4b59d&o=}	2026-05-02 18:30:05.478806	2026-05-02 18:30:05.478806	121.00
108	14	State Room Suite King	В этом люксе, расположенном в историческом крыле Брас-Баса, есть гостиная, 2 отдельных входа и ванная комната, отделанная мрамором. В номере есть двуспальная кровать, высокие потолки и вентиляторы.	2	1	king-size	106941.00	{Wi-Fi,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766115028.jpg?k=2ad0d13a620ebea24ef288fe5aad81932373be7d659a53627bcfdcf0e928651d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766115115.jpg?k=755e7ffa5a0c98e0a47e70ffa5b9508cf5a334e953893fc9a7338575e1efa86d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/220983385.jpg?k=c07f8c0fdaf183e60f2a8d7330b1d5ba899343efa2f9f7b1bd91a866f1737687&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766115063.jpg?k=4397091492ee1cefdc32fd7480ae7e614651152e0142ecffb84b9bc52880f036&o=}	2026-05-02 18:45:01.640396	2026-05-02 18:45:01.640396	67.00
102	12	Deluxe Harbour View Suite	Люкс с видом на гавань Виктория. В распоряжении гостей большая обеденная зона, место для работы и просторная комната для отдыха. В числе удобств мягкий Г-образный диван у камина и Blu-Ray телевизор со светодиодной подсветкой. К услугам гостей телескоп, 2 кресла, полностью оборудованный аудиовизуальный центр и мини-бар. Из просторной гардеробной со встроенным шкафом можно выйти в отделанную мрамором ванную комнату с угловой ванной и видом на город.	2	1	king-size	145496.00	{Wi-Fi,"Собственный люкс","Вид на город",Шкаф,Завтрак,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/486473087.jpg?k=3cf92af7366b1bd96dc64f368dd9cc7e164894dc3f50072bf0c3bd9310f50e60&o=,https://cf.bstatic.com/xdata/images/hotel/square60/17058479.jpg?k=11e5bd838fe5566d62b4fa58c45b28e1ff023732734d0f66fed21e0b6be176b5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/459533485.jpg?k=1ee367b23a6cdc1ea7a68b2647ac87965cf861400841dcf255a36ab2731390c9&o=,https://cf.bstatic.com/xdata/images/hotel/square60/736855064.jpg?k=f99a6a3e5f58830df6fd09f50fe821737a676545e0f62a5085fbe1f71031b6aa&o=}	2026-05-02 18:31:32.009589	2026-05-02 18:31:32.009589	107.00
103	13	Superior King Room	Из Улучшенных номеров открывается умиротворяющий вид на сад отеля и мраморный внутренний двор, причудливый Западный сад или шумные проспекты Георга V и Пьера 1-го де Серби.	2	1	king-size	282178.00	{Wi-Fi,"Вид на сад",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/722089980.jpg?k=2f982caaf52b353226fff5856d9099bfc6586cb715d98b3a784a6e435fe82c5e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/794130492.jpg?k=ad8231607a60d251419d2898a585c87dff960fcecb1b1835d99a727446a2a0bb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722089959.jpg?k=990e29e915df28023cdf16ad2dc71d0cefea7582c5952d15a8c6525638847c45&o=}	2026-05-02 18:34:46.54589	2026-05-02 18:34:46.54589	38.00
104	13	Deluxe King Room	В просторных, изящно оформленных номерах Делюкс с хрустальными люстрами обустроена облицованная мрамором ванная комната с расслабляющей глубокой ванной и отдельным душем.	2	1	king-size	300071.00	{Wi-Fi,"Вид на сад",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/722089983.jpg?k=797bf48517e94e10241150ea4c214b40ca91e510918901c6d0755a4cd59a7a49&o=,https://cf.bstatic.com/xdata/images/hotel/square60/794132822.jpg?k=6c296db94c1a99c0b639afb5aefdd17e7f6012136ec01eb63095aea2ebc038cc&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722092352.jpg?k=4e9698e1813b156327c38f77fa4d79aeb6c3aef2b063c6d8cf0b8f57d0dc3509&o=}	2026-05-02 18:36:19.24126	2026-05-02 18:36:19.24126	45.00
105	13	Premier King Room	Из номеров открывается вид на Мраморный двор и окружающие улицы.	2	1	king-size	403772.00	{Wi-Fi,"Вид на сад",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/722092986.jpg?k=071a357d3c65f4f182b0725e17361f0b99b382a9862b911668b0a37c1a034666&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722093005.jpg?k=6499e9fbf2dc130d76eadfdd1e0b9ee74f14b76fc7c79e3f606872bd18c401aa&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722093035.jpg?k=283bcf3d8ab0e7527143ff91d4a92acd931e38ccd67e9b2b22fb27ca8d59f22c&o=}	2026-05-02 18:37:58.924849	2026-05-02 18:37:58.924849	55.00
106	13	Executive Suite king bed	Изящные люксы с прихожей, ведущей в большую гостиную и спальню, тактично отделенную раздвижными дверями, по праву гордятся сверкающими люстрами и просторной гостиной зоной с элегантной старинной мебелью, большим рабочим столом и всеми современными удобствами.	2	1	king-size	529538.00	{Wi-Fi,"Собственный люкс","Вид на сад",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/722093712.jpg?k=aee3ff4473cc72c752c36b1f1bc520b408246aafa040591a2aa17f6a0f3ebaff&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722093756.jpg?k=18e192d4e57ebea4fdb12aca3612a68b55de467235e7279b125c8a2245b1ef75&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722093820.jpg?k=eced2e45dd6df2bd7146356e7f4b088086fabe289deb2cc5099e5f3d1fed0391&o=}	2026-05-02 18:39:44.623737	2026-05-02 18:39:44.623737	75.00
107	13	Deluxe King Suite	Из окон роскошных люксов, передающих атмосферу парижских апартаментов и украшенных предметами антиквариата и изобразительного искусства, открываются различные виды на город. В роскошной облицованной мрамором главной ванной комнате к услугам гостей глубокая ванна и отдельный душ.	2	1	king-size	617794.00	{Wi-Fi,"Собственный люкс","Собственная мини-кухня","Вид на сад",Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/722094326.jpg?k=2ac1ad02491b024c7a3c290f2f7d7c6e1e25a25034f9133867842f5158f9585a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722094388.jpg?k=a0f47f2cddf8bcb288973f3311e3c55e5eaec48fe58120800a24e3266c5d54d2&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722094495.jpg?k=8bd54c69aeb18317bc7be8d5362cbaa54a4077f29b01dadfc4b84fca24fde145&o=,https://cf.bstatic.com/xdata/images/hotel/square60/722094561.jpg?k=0c80671a0d3fe16962604191875d93b0de4bb77a713650d7edef0d55e4b94fff&o=}	2026-05-02 18:41:35.728846	2026-05-02 18:41:35.728846	101.00
109	14	Courtyard Suite King	Этот номер, соединенный с главным зданием, с видом на сад, кроватью размера «king-size», гостиной, потолочными вентиляторами и собственной ванной комнатой.	2	1	king-size	129355.00	{Wi-Fi,Завтрак,"Вид на сад",Терраса,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766115050.jpg?k=f8d5fb84eb61b3f9af8f24b58a9c048194923008ee45b45f7e682e1fe38e17b6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766115070.jpg?k=95db33c8546cdb62d284817a93e40e8669f257a2f3a09a2b8978de1f8980bbbb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/211136188.jpg?k=c86c0de9e3ea692dcdc156655aa9863fb0eab98de19c7900ec43ffe34783e295&o=}	2026-05-02 18:46:57.744363	2026-05-02 18:46:57.744363	58.00
110	14	Palm Court King Suite	Люкс с видом на парк «Пальм-Корт¬ и общей верандой. Номер с высоким потолком, кроватью размера «king-size», собственной ванной комнатой и небольшой гостиной.	2	1	king-size	151770.00	{Wi-Fi,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766115054.jpg?k=bd12168be540d58d74027e4e391f8929c35aa6d95e15a2ddb32a83c19b30f7a3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766115082.jpg?k=cf0db59fbb5bfdfcdd39b86535a6f52799645f48df20ccb6fa5c9b181732a60b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766115147.jpg?k=6739e76660cea240fcab00c306964ad2e1d2b891b0017f0e01b571f749e63d33&o=}	2026-05-02 18:48:45.627199	2026-05-02 18:48:45.627199	55.00
111	14	Personality King Suite	В этом люксе есть большая двуспальная кровать, памятные вещи знаменитой личности, отдельная спальня и гостиная зона.	2	1	king-size	168286.00	{Wi-Fi,Завтрак,"Вид на сад",Терраса,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/220983323.jpg?k=f6c64bbb3e02413a165f3df61a50b998c13690507690f69eb5edeb96e2a96733&o=,https://cf.bstatic.com/xdata/images/hotel/square60/220983319.jpg?k=56bd1c7c0048ace16c6e58723efff89d56705e8847ef2a6810cdf0026443ff3d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/795758462.jpg?k=69af45652b1aff67e20948942340887e0706ec56a4e6270e48b84231c9e1fb71&o=}	2026-05-02 18:50:16.013689	2026-05-02 18:50:16.013689	55.00
112	15	Premier Room with Garden View	Из просторных номеров открывается живописный вид на ландшафтные сады курорта. Номера элегантно оформлены оригинальными произведениями искусства и мебелью ручной работы. В ванных комнатах установлены отдельно стоящие ванны в викторианском стиле и отдельные душевые кабины с видом на частный внутренний дворик, окруженный стеной.	2	1	king-size	29237.00	{Wi-Fi,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/93387387.jpg?k=111ba2880c797ad339dd61038c397d85684a554af5cc97161d5fda094fb9bc17&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93387394.jpg?k=6fe6130285f0a4639ccf9538892aa0639e05d0152c28f6a1481476c54ccfafba&o=}	2026-05-02 18:52:43.395825	2026-05-02 18:52:43.395825	86.00
113	15	Premier Room Garden View with semi private pool	Просторный четырехместный номер оборудован кондиционером, мини-баром, принадлежностями для приготовления чая и кофе, а также фруктами для гостей. В номере имеется 1 кровать.	2	1	king-size	37534.00	{Wi-Fi,"Полу-приватный бассейн",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/93389218.jpg?k=8cdb60accb2ae7c860364ed415ce661e43b8bd1c031a65fed15d0657445bb22f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93387394.jpg?k=6fe6130285f0a4639ccf9538892aa0639e05d0152c28f6a1481476c54ccfafba&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93381543.jpg?k=ae278a942adcfc1587ff0b9abfb3cf2cccf1447bf6df7c72f6f9422971e29ecd&o=}	2026-05-02 18:54:43.844133	2026-05-02 18:54:43.844133	86.00
114	15	Luxury Suite With Two Way Airport Transfers	В числе дополнительных преимуществ – трансфер в обе стороны от железнодорожного вокзала Удайпура. Из этого номера-люкс открывается вид на озеро, есть кондиционер и зона отдыха. Завтрак и трансфер из/в аэропорт предоставляются бесплатно.	2	1	king-size	276567.00	{Wi-Fi,"Собственный люкс","Трансфер из/в аэропорт",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/93380779.jpg?k=4565e5a93df1237c1692e48d8ffaa4916d4f43eff327e1359d1f731e28f51290&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93380990.jpg?k=63152527b5c6faee3868339720a5fe5d8d0c115f05b8cc8e16cfef63ffcb2347&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93381570.jpg?k=326395225a62792dd68bd12260d59ad946b8fe023492cdd528efd94e2a4df191&o=,https://cf.bstatic.com/xdata/images/hotel/square60/93380994.jpg?k=c936ccd9788590f8f58e91ccaece48c03f29dca72d640c6e8e269e898cad99c3&o=}	2026-05-02 18:56:52.310232	2026-05-02 18:56:52.310232	143.00
115	16	Deluxe Premium Room	Двухместный номер с 1 кроватью, кондиционером, телевизором с плоским экраном и кабельными каналами, балконом с видом на город и собственной ванной комнатой. В этом номере установлена 1 кровать.	2	1	king-size	121794.00	{Wi-Fi,"Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/772297645.jpg?k=a3b05258c889e974a65b159d0f1b6be83e0c8868d1e800ab2c3afb687d4b9cb8&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772297648.jpg?k=cd12dae1081919c694a8aaaf72d8dd6eee3a2c0b034858d366d5afa92536fdab&o=}	2026-05-02 19:00:40.390123	2026-05-02 19:00:40.390123	25.00
116	16	Prestige Double Room	Просторный двухместный номер с 1 кроватью, кондиционером, мини-баром, балконом с видом на город и собственной ванной комнатой с душевым уголком. Установлена 1 кровать.	2	1	king-size	140680.00	{Wi-Fi,"Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/772298695.jpg?k=2bcbdd9217281310690b8172516ce26c8cdd002f3f652ec4f6642f0c325ae7b5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772297648.jpg?k=cd12dae1081919c694a8aaaf72d8dd6eee3a2c0b034858d366d5afa92536fdab&o=}	2026-05-02 19:01:59.287347	2026-05-02 19:01:59.287347	30.00
117	16	Deluxe Junior Suite	Из полулюксов Делюкс открывается вид на город Монте-Карло. В них имеется спальня, выходящая в гостиную зону. Ванная комната, отделанная мрамором и красным деревом, оснащена двойной раковиной, массажным душем и большой ванной.	2	1	king-size	150124.00	{Wi-Fi,"Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/111006268.jpg?k=415de6bdceae2baa96eed49d015103411b9347bd48e050ac182a8cf16be002e1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/549845992.jpg?k=81bb291e51cc800b6134ba3fe072fe26970cd1bccc027671081ff1af4de2a9af&o=,https://cf.bstatic.com/xdata/images/hotel/square60/111006254.jpg?k=08299a9cdefa9e9e8923fdf54153164bbd3f9f18f4d00fff56c8e7ecc139d131&o=}	2026-05-02 19:03:57.187153	2026-05-02 19:03:57.187153	37.00
118	16	Deluxe Premium Junior Suite	В номере люкс с кондиционером есть 1 спальня и 1 ванная комната с душевой кабиной и ванной. К услугам гостей балкон с видом на город, мини-бар и телевизор с плоским экраном и кабельными каналами. В номере также имеется 1 кровать.	2	1	king-size	164245.00	{Wi-Fi,"Собственный люкс","Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/772301369.jpg?k=e1208aa8bd286ad1d897dda6bcb8b1078cb5f630e7383b1ccf295ba1688860be&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772301356.jpg?k=16026e05a42c69acf784e7ac3baeb980dbcad724acda365d29592224ff3842cd&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772301357.jpg?k=492a7a07f5dfd53f8f327987d8803aa8257764c9c9c3762089b3d3faf376d2ce&o=}	2026-05-02 19:05:34.269939	2026-05-02 19:05:34.269939	45.00
119	16	Prestige Junior Suite	Из полулюксов «Престиж», расположенных на верхних этажах, открывается вид на город Монте-Карло или усаженную кипарисами аллею отеля. Спальни и гостиные были оформлены дизайнером Жаком Гарсиа. В ванной комнате, отделанной мрамором и красным деревом, есть двойная раковина, массажный душ и ванна.	2	1	king-size	173688.00	{Wi-Fi,"Собственный люкс","Вид на море","Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/131581786.jpg?k=9e41d7ecc94ba8a771c220d02008e738a93354baf51916cf5040749df299e927&o=,https://cf.bstatic.com/xdata/images/hotel/square60/123694176.jpg?k=52772ec5bee956c03cded6a953252d3f8680e1fa42481f7bafe82999b1391e9f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/237877398.jpg?k=b5c7761a30986c4d04f62ac32d3b0e90f5e2793047716f7369a3bbab7e4acd25&o=}	2026-05-02 19:07:15.395602	2026-05-02 19:07:15.395602	40.00
120	16	Family Suite	Семейные люксы, расположенные на верхних этажах, состоят из 2 спален и 2 ванных комнат. В стоимость проживания в люксе входит посещение Океанографического музея Монако.	2	2	king-size	224524.00	{Wi-Fi,"Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/111006022.jpg?k=85c6512a4935270b11c9e91b3bbe00f3321c047483a9a86acb892d77400c5ab1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/721370031.jpg?k=b14f4a086bf96391d1af8358d7315615b3c39777c03d06c9d1f8995625b993c9&o=,https://cf.bstatic.com/xdata/images/hotel/square60/721372441.jpg?k=691e949405f82c78d528b6958c22d32987863d2b8253caadb61b673bbbff5bd9&o=}	2026-05-02 19:09:15.4808	2026-05-02 19:09:15.4808	65.00
121	16	Deluxe Suite with Sea View	Этот люкс с видом на Средиземное море и казино Монте-Карло расположен на верхних этажах. Он состоит из спальни, отдельной гостиной, кабинета и гардеробной. В ванной комнате, отделанной мрамором и красным деревом, есть двойная раковина, массажный душ и ванна.	2	1	king-size	261945.00	{Wi-Fi,"Собственный люкс","Вид на море","Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/249026658.jpg?k=23f57b7a2af083f5b6935d0e5e2e7bd06286887f5a0121aab4bc889b0bf2f463&o=,https://cf.bstatic.com/xdata/images/hotel/square60/249026703.jpg?k=67c6a252ac19512c7d55314a981dbb61810e305aa154c6d1a244928cd2a3d520&o=,https://cf.bstatic.com/xdata/images/hotel/square60/249026687.jpg?k=ae91bd091d395bba12e2c059e62597279cf7150d8a33ef8f7cc66017e55ab7f2&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/107335281.jpg?k=664d954155f636ac92b221c1841310549aa50edb05110cbb0f03fb2e07229658&o=}	2026-05-02 19:11:26.324775	2026-05-02 19:11:26.324775	52.00
144	20	One Bedroom Executive Suite	Представительский люкс с одной спальней, ванной и кроватью "king-size".	3	1	king-size	11725.00	{Wi-Fi,"Бассейн на крыше",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/643199844.jpg?k=3bdbedddf49110b4b7cce2f357ff6e9149f462b49232ab8613b5ff157ee167d6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643199854.jpg?k=067e932dd9635a163d678de5e1e25aef2e7a71f1aafd31dc73c6d0306bf64ee3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643199925.jpg?k=fe0c283552125c7ada7d5b35e2d9e0f7dd7d881f8be3bc748094cce26c13194f&o=}	2026-05-03 01:58:40.041652	2026-05-03 01:58:40.041652	69.00
122	16	Prestige Suite	Люксы «Престиж» находятся на верхнем этаже отеля. Из вестибюля можно выйти в отдельную гостиную и на террасу с собственными шезлонгами.	2	1	king-size	279508.00	{Wi-Fi,"Собственный люкс","Вид на море","Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/541030358.jpg?k=265ee5080e804c410e125b58506129a12b47c273d4af7999b9fde7b1d9acafa3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/111009857.jpg?k=bd7d9c920760617f3224787e346bd43d5f55c765409d99e0a1fdc9834cc99a27&o=,https://cf.bstatic.com/xdata/images/hotel/square60/113106413.jpg?k=b5afd68faf72700b7a13d40a57d1337e2a0a589388b153bd223964f13cb813b3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/541030383.jpg?k=38538d16d6f9f25e07e6ed96db7ce9283b19a209be654a03ba83a5bb1b6f2062&o=}	2026-05-02 19:12:53.176194	2026-05-02 19:12:53.176194	50.00
123	16	Azur Suite	Люкс находится на 1 этаже отеля. Из эркеров открывается вид на сад казино и трассу Гран-при Монако.	2	1	king-size	422483.00	{Wi-Fi,"Собственный люкс","Вид на город",Балкон,Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/max1024x768/111009892.jpg?k=b47c6e4be092dc04315333e98fc1a632ac1b4527e94cf354649774f6ee463f1e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/384588354.jpg?k=4a4a18fc47171a5f2c6f66250ac02b7909af604129c63ec4232333df47924736&o=,https://cf.bstatic.com/xdata/images/hotel/square60/541029752.jpg?k=c4c87f3b048df48bf18ec30a68dcb329be3c648315eebf8a46d392cbd86c3059&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/175235897.jpg?k=e17a893891e519c2d47c970e5c8d22fa8898b9007e7cda3bf109dd631cd928b9&o=}	2026-05-02 19:14:24.418297	2026-05-02 19:14:24.418297	56.00
125	17	Deluxe Suite King	Эти просторные люксы, выходящие на запад, предлагают захватывающие виды на закат и городской пейзаж.	2	1	king-size	134181.00	{Wi-Fi,"Вид на город",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b66b53251278679725.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b66ac7df4201098764.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b66aef57d296810764.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b66aae2d7202256560.jpg}	2026-05-02 19:22:37.713331	2026-05-02 19:22:37.713331	71.00
126	17	Garden View Suite King	Расположенные на высоте 38 этажей - на самом высоком этаже Aman Tokyo - апартаменты Garden View Suites предлагают превосходный вид на горизонт и сады Императорского дворца.	2	1	king-size	152453.00	{Wi-Fi,"Вид на город","Вид на сад",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6892956c688855641.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6890f8c6670638983.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b68905e86379648545.jpg}	2026-05-02 19:25:03.846947	2026-05-02 19:25:03.846947	71.00
127	17	Grand Suite King	Гранд-люксы, одни из самых больших в отеле, отличаются простором и обилием света, а из окон открывается захватывающий вид на город.	2	1	king-size	311140.00	{Wi-Fi,"Вид на город","Обеденный стол","Вид на сад",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b696a847d305822020.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b696afeef487364387.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b69664dd1011608722.jpg}	2026-05-02 19:28:26.762673	2026-05-02 19:28:26.762673	141.00
128	17	Panorama Suite King	Расположенный на углу отеля Aman Tokyo, этот отель предлагает панорамные виды и площадь в 139 квадратных метров.	2	1	king-size	365620.00	{Wi-Fi,"Вид на город","Персональный бар","Обеденный стол","Вид на сад",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6b63c33a768266083.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6b658235154474753.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6b658235154474753.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6b61b88f888858738.jpg}	2026-05-02 19:30:38.405073	2026-05-02 19:30:38.405073	139.00
129	17	Aman Suite King	Самые большие люксы отеля Aman Tokyo предлагают абсолютный отдых и непревзойденные виды, позволяющие насладиться вершиной городской жизни.	2	1	king-size	365620.00	{Wi-Fi,"Вид на город","Персональный бар","Обеденный стол","Вид на сад",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b64ec9243864067814.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b64ea9abb629636458.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b64f02fc4848400379.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b64ec0921804715922.jpg}	2026-05-02 19:32:11.441504	2026-05-02 19:32:11.441504	157.00
130	18	Superior Room	Просторный двухместный номер с кондиционером, мини-баром и собственной ванной комнатой с безбарьерным душем и ванной. В числе удобств — гостиная зона, кофемашина, шкаф для одежды, а также телевизор с плоским экраном и спутниковыми каналами. Из номера открывается вид на внутренний двор. В распоряжении гостей 1 кровать.	2	1	king-size	110342.00	{Wi-Fi,"Вид во внутренний дворик",Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/719807885.jpg?k=09fcdce41daead542ccc36c4d02ad07047ea046d05e10041e4074ec52456d2a8&o=,https://cf.bstatic.com/xdata/images/hotel/square60/719807888.jpg?k=4ccc83b12c5f96a5b2e4711c76161e807b60ea2a647bbc7cb9d3fa77902ff8df&o=}	2026-05-02 19:37:33.109915	2026-05-02 19:37:33.109915	35.00
131	18	Mayfair Room	Просторный двухместный номер с 1 кроватью, кондиционером, мини-баром и собственной ванной комнатой с душевым уголком и ванной. Установлена 1 кровать.	2	1	king-size	122603.00	{Wi-Fi,"Вид во внутренний дворик",Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/719807371.jpg?k=ab017dfe4a3a5678b4557b1cfb4b075ec286c0f126cc32993b302302969e0477&o=,https://cf.bstatic.com/xdata/images/hotel/square60/719807365.jpg?k=de7bbabf21a70041e823224dd356b30aeb648de8b8e7c59905071084ac3ca8e7&o=}	2026-05-02 19:38:45.276693	2026-05-02 19:38:45.276693	40.00
132	18	Claridge’s Balcony Room	Просторный двухместный номер с кондиционером, мини-баром и собственной ванной комнатой с безбарьерным душем и ванной. В числе удобств — кофемашина, гостиная зона, балкон, а также телевизор с плоским экраном и спутниковыми каналами. В распоряжении гостей 1 кровать.	2	1	king-size	159383.00	{Wi-Fi,"Вид во внутренний дворик",Балкон,Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/720405110.jpg?k=4b448f4a96fd29085bafe671156d062b4fb031fdd494fdcdc60bc0c611d3235b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/720405108.jpg?k=ce931a3220e2c5c14150e57c63af91bff022f3eb341b601854cabd23ee0782e6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/730619706.jpg?k=ad6009f4be6f99cdd8f9bb1dd30af7c7edd24d1950fe03779806635930a2d2af&o=}	2026-05-02 19:40:26.769523	2026-05-02 19:40:26.769523	55.00
133	18	Claridges Studio	Просторный люкс с 1 спальней, гостиной зоной и 1 ванной комнатой с безбарьерным душем и ванной. В числе удобств — кондиционер, телевизор с плоским экраном и спутниковыми каналами, мини-бар, кофемашина и шкаф для одежды. Из окон открывается вид во внутренний двор. В распоряжении гостей 1 кровать.	2	1	king-size	171644.00	{Wi-Fi,"Собственный люкс","Вид во внутренний дворик",Балкон,Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/767558907.jpg?k=01d6f6b12ab38a6f2aa83e68db01108260dbf6e1e74d44a61f702e970563ba98&o=,https://cf.bstatic.com/xdata/images/hotel/square60/767558911.jpg?k=59c4f5eeac7835a3c80f70bdefc3742f992ab9bd49dc98df2e062f35ed167e7e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/767558910.jpg?k=efadbd375cdfc5338c37854a8d84eb4f4e0f66739d8d355a1cdfc15f454c255f&o=}	2026-05-02 19:42:49.657919	2026-05-02 19:42:49.657919	60.00
134	18	Mayfair Suite	Просторный люкс с 1 гостиной, 1 отдельной спальней и 1 ванной комнатой с безбарьерным душем и бесплатными туалетно-косметическими принадлежностями. В числе удобств — кондиционер, мини-бар и телевизор с плоским экраном и спутниковыми каналами. Гостям предлагается вино или шампанское. В распоряжении гостей 1 кровать.	2	1	king-size	312636.00	{Wi-Fi,"Собственный люкс","Вид во внутренний дворик",Балкон,Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/767561877.jpg?k=f0d622db1f4e62a25042dccd5b3237bccf40cedaff5bfbe3534f2c037850b089&o=,https://cf.bstatic.com/xdata/images/hotel/square60/767561872.jpg?k=0303027b0c7df5ccde4470a27c1903d0e0559823ceb44a81c9798fd6f65d1eba&o=,https://cf.bstatic.com/xdata/images/hotel/square60/767561873.jpg?k=47116a73409b7e21941cb1571bdd45a292c4b445205b7a94de92744df7876074&o=}	2026-05-02 19:44:17.113367	2026-05-02 19:44:17.113367	80.00
135	18	Claridges Suite	Просторный люкс с 1 гостиной, 1 отдельной спальней и 1 ванной комнатой с безбарьерным душем и бесплатными туалетно-косметическими принадлежностями. В числе удобств — кондиционер, мини-бар, а также телевизор с плоским экраном и спутниковыми каналами. Гостям предлагается вино вино или шампанское. В распоряжении гостей 1 кровать.	2	1	king-size	312636.00	{Wi-Fi,"Собственный люкс","Вид во внутренний дворик",Балкон,Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/484865931.jpg?k=ff49922b103cfa5820548d3b13790d931bc923333fd44097e1b9c360a8f0c4e5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/484866574.jpg?k=148b8c60eb88a783fbd8bced15fa91c05bf8d5518d4b2fcc16dac86249941c56&o=,https://cf.bstatic.com/xdata/images/hotel/square60/484866605.jpg?k=c8599d2d3569ce8b3cf989dda069dae485a2a36b54c653ff0ed9f04ff63aae14&o=,https://cf.bstatic.com/xdata/images/hotel/square60/484866954.jpg?k=10c6eac072f4170fd2a8f4f88666c7aa6ae6db97aad94a3661a577e27ce73bed&o=,https://cf.bstatic.com/xdata/images/hotel/square60/579193787.jpg?k=4d3b456ca05972c4dbdfa45049159c57b92649ce4eaa2282d1485eba9d904230&o=}	2026-05-02 19:45:44.658588	2026-05-02 19:45:44.658588	95.00
136	18	Suite	Просторный люкс с 1 отдельной спальней, 1 гостиной и 1 ванной комнатой с душевым уголком и бесплатными туалетно-косметическими принадлежностями. В числе прочих удобств люкса — кондиционер, мини-бар и телевизор с плоским экраном и спутниковыми каналами. Гостям предоставляется вино или игристое вино. В этом номере установлена 1 кровать.	2	1	king-size	682487.00	{Wi-Fi,"Собственный люкс","Вид во внутренний дворик",Балкон,Завтрак,Шкаф,Кофемашина,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/720458362.jpg?k=1bb2888a5b1a1ada9cf0b326aa2d615a5fb9b9bc9d76d3eb4d7058b99e34afae&o=,https://cf.bstatic.com/xdata/images/hotel/square60/720458373.jpg?k=ee25bddfbf28c1f82a4f45557092de7a3a27ec05eda27815cc9c58a298e20de4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/730621069.jpg?k=a7aed2aebe1acda6f3aa29f218534a2eb76de0813591f1e9d3022471342b4296&o=,https://cf.bstatic.com/xdata/images/hotel/square60/730621153.jpg?k=ed61f6c1fda23a2d6ffc9db4f60c491e39623f9d8d860f44abbe5dcccb2ea97c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/720458350.jpg?k=393ab769a0bd59b11490f6cb489f50dc229ff2ea6e49db758866e1ab3a624918&o=}	2026-05-02 19:47:19.044293	2026-05-02 19:47:19.044293	115.00
137	19	Double Room	Двухместный номер с 1 кроватью.	2	1	king-size	42010.00	{Wi-Fi,"Собственный бассейн","Вид на город","Вид на реку",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/838888462.jpg?k=90e3830323cd7c96f362631ce3c82d2aa95663ce55b78a2fda14d21ba41b5836&o=,https://cf.bstatic.com/xdata/images/hotel/square60/838001860.jpg?k=4b77dd60c107f721eeaa3f5f015419e06c5600a92ca7acc213dab65d425d9bba&o=}	2026-05-03 01:43:22.079154	2026-05-03 01:43:22.079154	20.00
138	19	Classic Family Room	Классический семейный номер 1 диван-кровать  и 1 большая двуспальная кровать	3	2	king-size	46776.00	{Wi-Fi,"Собственный бассейн","Вид на город","Вид на реку",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/838001989.jpg?k=6667823a1211d97ed5b86ea053efd46e0baa12c7e4694c8d6975e5d1f2fcb6c6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/518920491.jpg?k=11fdda8bc4589e13b87630312e0b2fb670bf9e8deb10ff6dbebcde3e4ff24ab3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/518920455.jpg?k=d4878267fdfa856de8da8f252dfc88268ba7084e9008d3c61699c19d643227ff&o=}	2026-05-03 01:45:11.968765	2026-05-03 01:45:11.968765	26.00
139	19	Superior Queen Room with Sofa Bed	Улучшенный номер с кроватью размера "queen-size" и диваном-кроватью,	4	2	queen-size	49159.00	{Wi-Fi,"Собственный бассейн","Вид на город","Вид на реку",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/838001972.jpg?k=991b999a9398a359e5d8a6b3e8da958cc0e7f719f1a5568db17eea2a3486ecd3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/838001979.jpg?k=3fe1a425ca58a02d3f285844e31b24354ef111c77aa9d243aecae7a003e4668e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/518920455.jpg?k=d4878267fdfa856de8da8f252dfc88268ba7084e9008d3c61699c19d643227ff&o=,https://cf.bstatic.com/xdata/images/hotel/square60/681422066.jpg?k=3326ea0153ec1b471ec2669a34f5b194e735975effe7fa6838efc4e7ccc9bebf&o=}	2026-05-03 01:47:13.964276	2026-05-03 01:47:13.964276	30.00
140	19	Executive Queen Room With Sofa Bed	Представительский номер с кроватью размера "queen-size" и диваном-кроватью	4	2	queen-size	50588.00	{Wi-Fi,"Собственный бассейн","Вид на город","Вид на реку",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/846235677.jpg?k=eafc170a9bda6baa7d7b7c1f7511454aeb08d9d5c325e4f946f7484ab2c85682&o=,https://cf.bstatic.com/xdata/images/hotel/square60/838001898.jpg?k=5639506ebf2d2cf01557799ed94c0a913eabf75f0e04ae70f20570d36e2f9aeb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/838001933.jpg?k=a13075322d89f8f26f22e48e036fe3b8e9b474c4f25ff6bad447641ec008f6b0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/519248973.jpg?k=9a3cda5ad476063233eb2f2216294f5c7cad1201b12dd703b83b226d80c9ac58&o=}	2026-05-03 01:48:46.465312	2026-05-03 01:48:46.465312	28.00
141	20	Standard King Room with City View	Стандартный номер с кроватью "king-size", вид из окна на город.	2	1	king-size	6391.00	{Wi-Fi,"Бассейн на крыше","Вид на город",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/454315527.jpg?k=2ddc4da275fed134a49c2b332ff0de7ebdb42788891c88f67c6f0c0e70fa716c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643199974.jpg?k=1d893f3d835a7ac06d11a1b9bc70330ae02782c04026619b1093edb25b0091f7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643200007.jpg?k=8b37a3f55b99f7a4dfe9d6036dca15a34895d30ba76a3f5d7f02b8c0f39e76e9&o=}	2026-05-03 01:53:01.060694	2026-05-03 01:53:01.060694	27.00
142	20	Superior King Room with City View	Улучшенный номер с кроватью "king-size", вид из окна на город.	2	1	king-size	7923.00	{Wi-Fi,"Бассейн на крыше","Вид на город",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/454314745.jpg?k=df34c384b24f0489a55bf0bb0215cc6168b46969e41a6fb153c0c0aa79b8ba3a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/719172854.jpg?k=7843103ebfd050dfcb5f5d80bff9d19a5d48a4526c35419997043e8bd0d05df6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643200007.jpg?k=8b37a3f55b99f7a4dfe9d6036dca15a34895d30ba76a3f5d7f02b8c0f39e76e9&o=}	2026-05-03 01:54:57.812028	2026-05-03 01:54:57.812028	29.00
143	20	Junior King Suite	Полулюкс номер с ванной и кроватью "king-size".	2	1	king-size	14788.00	{Wi-Fi,"Бассейн на крыше","Собственный люкс",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/719172849.jpg?k=ac0cfd97159e53c368f0e9847e1b918620ea21d75ee1451b11f817743086d661&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643199880.jpg?k=b08fd1b273f02ced9e103d0384c59fa5fdd50177d638e86147cc3bc3c1d6e82a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/643199925.jpg?k=fe0c283552125c7ada7d5b35e2d9e0f7dd7d881f8be3bc748094cce26c13194f&o=}	2026-05-03 01:57:10.443409	2026-05-03 01:57:10.443409	56.00
148	22	Standard King Room	Стандартный двухместный номер с 1 кроватью	2	1	king-size	6716.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766048870.jpg?k=2436ba05c475011dcd09972b19ba9bb1954f15a17465e0ee3044b3d02c1382af&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048883.jpg?k=e2441ee4089ecf6e99888c0196e8bdc8fa4f974e742ce40ff8857491d71082bc&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048910.jpg?k=04cdb46c25b13d75a89bac83869c8591067744cee90cc8293ecfb62504028bd3&o=}	2026-05-03 02:12:49.721196	2026-05-03 02:12:49.721196	18.00
94	11	Terrace Suite	В номере «Террасный люкс» сохранены исторические элементы декора. Цветовая гамма и стиль оформления отражают элегантность и сдержанность царской России. Планировка номера включает в себя прихожую, спальню, гостиную, просторную ванную комнату и большую террасу с видом на город.	3	1	king-size	97000.00	{Wi-Fi,"Вид на парк",Терраса,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://secure.travelline.ru/resource/images/rt/296846/638664240421121130-3bae1d66-c27d-4efc-b506-1ce267c1eb51,https://secure.travelline.ru/resource/images/rt/296846/638664240627369652-41b1d8b8-c949-4a59-b0b4-ea7bc75a06f2,https://secure.travelline.ru/resource/images/rt/296846/638664243397171615-f6989394-d116-4f4a-ab29-70a329cef3fc}	2026-05-02 18:06:44.091792	2026-05-02 18:06:44.091792	52.00
124	17	Tokyo Suite King	Окна этих просторных люксов выходят на восток японской столицы, откуда днем и ночью открывается захватывающий вид на город.	2	1	king-size	128091.00	{Wi-Fi,"Вид на город",Завтрак,Шкаф,Кондиционер,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6bfa2b95714421303.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6bf6676d878060432.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6bf87343354913515.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6617b6bfabd4f740789662.jpg}	2026-05-02 19:19:21.17506	2026-05-02 19:19:21.17506	77.00
145	21	Standard Double Room	Стандартный двухместный номер с кроватью "queen-size".	2	1	queen-size	15019.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/576821882.jpg?k=dc1d050b5eb418d04bc8004063d1c284e14c61cef5eead484a5228351ab18835&o=,https://cf.bstatic.com/xdata/images/hotel/square60/576822024.jpg?k=9b506bfa7a1b976a9e237cbfc5587416afff777d9e7b1286b5e9a262974a5c2a&o=}	2026-05-03 02:02:22.477923	2026-05-03 02:02:22.477923	22.00
149	22	Superior King Room with Atrium View	Улучшенный номер с кроватью размера «king-size» и видом на атриум.	2	1	king-size	7411.00	{Wi-Fi,"Вид во внутренний дворик",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766048869.jpg?k=dc9fa946e8be5ec66703cdcfad0afc83d671e80ce949c2b42ece9f62b9c3dd25&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048895.jpg?k=993848cf7ed64b6c6b2635b346fecfc87f59c3b1623e5724cb723f2ed2a47b33&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048915.jpg?k=8bca586f2d18e37fe221e8f1c91a83273202d19733f048fed66601ba089f4730&o=}	2026-05-03 02:15:48.873653	2026-05-03 02:15:48.873653	19.00
150	22	Premium King Room with Atrium View	Номер премиум-класса с кроватью размера "king-size" и видом на атриум.	2	1	king-size	8105.00	{Wi-Fi,"Вид во внутренний дворик",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766048922.jpg?k=d3bdfb2f546c8c081f2a9189b2cbb4c726fdebc4a4b61761fc86df1d39ea2922&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048914.jpg?k=ad0a42bbe1b34651c3abfd92905e265ba06736120f146cf6dc39ce842bd97cec&o=,https://cf.bstatic.com/xdata/images/hotel/square60/460739243.jpg?k=ac7698518cf802bf3da68e77458c71cad25b42c247ca304558bf7d4b37a84832&o=}	2026-05-03 02:17:25.898036	2026-05-03 02:17:25.898036	23.00
151	22	Premium King Room with Balcony	Номер премиум-класса с кроватью размера "king-size" и собственным балконом.	2	1	king-size	9495.00	{Wi-Fi,Балкон,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/766048878.jpg?k=64ee64132285d6cbab919158886606257fe8b54083c290844dc83693dcb7f6be&o=,https://cf.bstatic.com/xdata/images/hotel/square60/766048908.jpg?k=9316137b2f38f02ccad31e45388e92c682c4022a313eec64132840133dd15a49&o=,https://cf.bstatic.com/xdata/images/hotel/square60/460739243.jpg?k=ac7698518cf802bf3da68e77458c71cad25b42c247ca304558bf7d4b37a84832&o=}	2026-05-03 02:18:51.330935	2026-05-03 02:18:51.330935	26.00
152	23	Standard Double Room	Светлый и современный номер Стандарт: удобная кровать, изголовье которой обрамляют изображения красивейших станций московского метрополитена, и роскошная ванная комната в сочетании с домашней атмосферой отеля идеально подойдут для Вашего отдыха в Москве.	2	1	queen-size	6000.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://accor.ru/upload/iblock/d39/fws06lx7gcjxqiwd580uqjb92ua88eaw.jpeg,https://accor.ru/upload/iblock/2dd/6zqvd068ny72liosc9pjbfqkr5ij1por.jpeg}	2026-05-03 02:30:18.877116	2026-05-03 02:30:18.877116	23.00
153	23	Privilege Double Room	Почувствуйте себя как дома в просторном номере Привилегия. Насладитесь бесценными минутами отдыха за чашкой ароматного чая или кофе и безмятежным сном в мягкой удобной кровати. Дизайн ванной комнаты подарит Вам позитивный настрой на целый день.	2	1	queen-size	9000.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://accor.ru/upload/iblock/f32/5a1vqnyhlx3e6w4x98q70jowub8rux3v.jpeg,https://accor.ru/upload/iblock/681/2x7n7qpgkp30j90ozi4zejzquez2lbr0.jpeg,https://accor.ru/upload/iblock/1ba/n6fi0xd2wmabtj5so7oema8oaudelyw8.jpeg}	2026-05-03 02:31:58.058711	2026-05-03 02:31:58.058711	37.00
154	23	Classic Superior Double Room	Откройте для себя новый уровень комфорта номеров Superior с видом в уединенный дворик отеля. Светлый интерьер номера с яркими акцентами сделает ваше прибывание незабываемым. Утренний аромат кофе разбудит даже самых больших любителей поспать	2	1	queen-size	6000.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://accor.ru/upload/iblock/c37/kafav6e3c4qnm53udmasrfbwyqqvn37x.jpeg,https://accor.ru/upload/iblock/cc0/z1a2x3zmw8fr6xa45pg6ffwmluhh9pc9.jpeg,https://accor.ru/upload/iblock/9d8/e1blobcnqdelllaigsty5r47jfy76igl.jpeg}	2026-05-03 02:33:57.159274	2026-05-03 02:33:57.159274	27.00
155	24	Collection Room	Отдохните в нашем номере категории «Коллекция», который отличается современной элегантностью и продуманными удобствами. Выберите кровать размера «king-size» или две односпальные для комфортного сна. Начните утро с горячего кофе из кофемашины Nespresso или чая из принадлежностей для дома, а также зарядитесь энергией, приняв тропический душ с высококачественными туалетными принадлежностями. Рабочий стол позволит вам оставаться продуктивным во время вашего пребывания, независимо от цели поездки — деловой или туристической.	2	1	king-size	18949.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room/16256-116437-f83223072_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room-bath/16256-116437-f83223092_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:37:56.505368	2026-05-03 02:37:56.505368	27.00
156	24	Collection Superior Room	Насладитесь уникальным отдыхом в номере категории «Супериор» из нашей коллекции. Отдохните со вкусом и оцените исключительный комфорт двуспальной кровати. Выпейте утренний кофе из кофемашины Nespresso или чай из принадлежностей для кофемашины в номере, расслабьтесь под тропическим душем с использованием высококачественных туалетных принадлежностей. Современный рабочий стол поможет вам оставаться продуктивным во время вашего пребывания.	2	1	queen-size	19772.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room/16256-116437-f84518854_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room-bath/16256-116437-f83223038_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:39:42.908026	2026-05-03 02:39:42.908026	27.00
157	24	Collection Room with Balcony	Отдохните и восстановите силы в одном из наших стильных номеров категории Collection с собственным балконом и зоной отдыха на двоих. Насладитесь исключительным комфортом, выбрав кровать размера king-size или две односпальные кровати. К вашим услугам просторная рабочая зона и современные удобства, включая кофемашину, принадлежности для приготовления чая в номере, освежающий тропический душ и высококачественные туалетные принадлежности.	2	1	king-size	22164.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room/16256-116437-f83223088_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room-bath/16256-116437-f83223000_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:41:48.711844	2026-05-03 02:41:48.711844	27.00
158	24	Collection Premium Room with Balcony	Отдохните и восстановите силы в одном из наших стильных номеров категории Collection с собственным балконом и зоной отдыха на двоих. Насладитесь исключительным комфортом, выбрав кровать размера king-size или две односпальные кровати. К вашим услугам просторная рабочая зона и современные удобства, включая кофемашину, принадлежности для приготовления чая в номере, освежающий тропический душ и высококачественные туалетные принадлежности.	2	1	king-size	24574.00	{Wi-Fi,Балкон,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room/16256-116437-f83223072_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room-bath/16256-116437-f83223082_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:44:57.011379	2026-05-03 02:44:57.011379	27.00
159	24	Junior Suite	Просторный номер Junior Suite идеально подходит для длительного проживания. Начните день с освежающего тропического душа с высококачественными банными принадлежностями и расслабьтесь в уютном халате и тапочках. Благодаря исключительным удобствам, таким как кровать размера king-size, кофемашина и комфортная рабочая зона, этот номер позволит вам по-настоящему расслабиться и насладиться незабываемым отдыхом с потрясающим видом на город.	4	1	king-size	28528.00	{Wi-Fi,Балкон,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite/16256-116437-f72219113_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite/16256-116437-f84518850_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room-bath/16256-116437-f83223024_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/guest-room/16256-116437-f83223174_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:47:08.216861	2026-05-03 02:47:08.216861	47.00
160	24	Nikolai Suite	Сделайте свой отдых еще приятнее, остановившись в нашем люксе «Николай», идеальном выборе, если вы ищете больше пространства и комфорта. Этот просторный люкс включает в себя кровать размера «king-size» и рабочую зону, отделенную от спальни, для максимального комфорта и уединения. Начните свой день с потрясающего вида на Берлин, насладитесь свежим кофе из кофемашины или чаем из принадлежностей для душа в номере и восстановите силы в бодрящем тропическом душе с высококачественными косметическими средствами.	2	1	king-size	72952.00	{Wi-Fi,Балкон,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Холодильник,Кофемашина,Фен,Телефон}	t	{https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite/16256-116437-f83266480_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite/16256-116437-f83134466_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite/16256-116437-f83133354_4K.jpg?impolicy=GalleryLightboxFullscreen,https://media.radissonhotels.net/image/radisson-collection-hotel-berlin/suite-bath/16256-116437-f83133352_4K.jpg?impolicy=GalleryLightboxFullscreen}	2026-05-03 02:49:15.934132	2026-05-03 02:49:15.934132	101.00
161	25	Standard Double Room	Двухместный номер Стандарт с двуспальной кроватью.	2	1	queen-size	9945.00	{Wi-Fi,"Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cdn.worldota.net/t/240x240/extranet/66/f8/66f8fffc75a943e49df77fa47a727db759423023.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/76/df/76dfcc539b4dfef352f57bafd9381e2ef9d1ed5f.jpeg?format=webp}	2026-05-03 02:54:59.893964	2026-05-03 02:54:59.893964	16.00
162	25	Superior Double Room	Двухместный номер Улучшенный с двуспальной кроватью.	2	1	queen-size	12325.00	{Wi-Fi,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cdn.worldota.net/t/240x240/extranet/14/04/1404726dde5893ebacfac9afc2f0ba2fda315a4c.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/76/df/76dfcc539b4dfef352f57bafd9381e2ef9d1ed5f.jpeg?format=webp}	2026-05-03 02:56:56.924909	2026-05-03 02:56:56.924909	20.00
163	25	Superior Double Room	Двухместный номер Улучшенный с видом на город и двуспальной кроватью.	2	1	queen-size	14875.00	{Wi-Fi,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cdn.worldota.net/t/240x240/extranet/25/be/25be5f6d81c134e1bc6d5c5b4bc332cc30cc5645.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/25/91/2591bad4e074ef7680987afcf2bab8804b4b3e9e.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/fa/71/fa713db7e243bffe4a3c4f72252716064f9f16c7.jpeg?format=webp}	2026-05-03 02:59:42.103714	2026-05-03 02:59:42.103714	20.00
164	25	Superior Double Room	Двухместный номер Улучшенный с балконом, с видом на город и двуспальной кроватью.	2	1	queen-size	15725.00	{Wi-Fi,Балкон,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cdn.worldota.net/t/240x240/extranet/84/20/8420945059bd83f47f9d322bf1f35e765a7cd6d5.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/b9/a0/b9a0163f2af3970f922ed31bd3e9297c0b94a99c.jpeg?format=webp,https://cdn.worldota.net/t/240x240/extranet/fa/71/fa713db7e243bffe4a3c4f72252716064f9f16c7.jpeg?format=webp}	2026-05-03 03:01:41.209072	2026-05-03 03:01:41.209072	20.00
165	26	Standard Double Room	Классический двухместный номер с двуспальной кроватью.	2	1	king-size	15900.00	{Wi-Fi,Спа-зона,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/123396/638133499737718351-6cf08bcf-aa2a-46fa-a352-84ee9c8cd3af,https://secure.travelline.ru/resource/images/rt/123396/638133499750438125-0f4c84b1-e332-4adc-a475-5eab28561775,https://secure.travelline.ru/resource/images/rt/123396/638133499758674524-e83c55a5-77a9-4a95-ae9f-0c634da58b5a}	2026-05-03 03:04:29.395715	2026-05-03 03:04:29.395715	23.00
166	26	Studio Double Room	Просторные и уютные номера с отдельной зоной отдыха. Все номера обставлены изысканной мебелью, в том числе двуспальной кроватью (King) с мягкими подушками и одеялами. Дорогие ткани рубиново-красных, темно-синих или изумрудно-зеленых оттенков создают ощущение яркости и изысканности.	3	1	king-size	25400.00	{Wi-Fi,Спа-зона,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/123436/638133500457596882-1eab2634-2af2-4bff-9265-bdaa8ee17d1a,https://secure.travelline.ru/resource/images/rt/123436/638133500457596882-1eab2634-2af2-4bff-9265-bdaa8ee17d1a,https://secure.travelline.ru/resource/images/rt/123436/638133500446003023-7d30e301-8a96-45cc-a632-1d87d0cbdcc6}	2026-05-03 03:07:00.408864	2026-05-03 03:07:00.408864	27.00
167	26	Junior Suite with a view of Tverskaya	Просторные одно- и двухкомнатные полулюксы с отдельной гостиной и уютными спальнями с двуспальной кроватью (King) или фирменными односпальными кроватями с мягкими подушками и одеялами. В номерах удобные, вместительные гардеробы, просторные прихожие или отдельная гардеробная. Дорогие ткани рубиново-красных, темно-синих или изумрудно-зеленых оттенков создают ощущение яркости и изысканности.	3	1	king-size	27900.00	{Wi-Fi,Спа-зона,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/227943/638525996010939378-9c09d0bf-d37d-408b-9b6b-e90b056328c3,https://secure.travelline.ru/resource/images/rt/227943/638169844933943318-57b26adc-7cc6-4910-b3f0-501f54a3d10b,https://secure.travelline.ru/resource/images/rt/227943/638525996059889045-651200c4-7bf0-4c96-9001-c8e8d7c41b31}	2026-05-03 03:09:06.865752	2026-05-03 03:09:06.865752	36.00
168	26	The Kremlin Suite	В просторных двухкомнатных люксах «Кремль» уникальная коллекция роскошных люстр, оригинальные произведения искусства и антикварная мебель.\nВ люксах предусмотрена просторная спальная зона, полностью отделенная от жилой и рабочей зон, что обеспечивает необходимую приватность во время неформальных встреч и совместных мероприятий. Диваны с мягкой обивкой на заказ, редкие предметы антиквариата, мягкое освещение и толстые ковры делают жилую зону уютной и элегантной, а удобный письменный стол, стул и светильник в рабочей зоне превращают любую деятельность в удовольствие.	3	1	king-size	104000.00	{Wi-Fi,Спа-зона,"Красивый вид","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/127059/638133502437807315-60757aa1-1a1a-4c03-9240-0af777c4a3f5,https://secure.travelline.ru/resource/images/rt/127059/638133502453445309-66e06cc3-c3fe-4348-b6aa-905fd8a790ca,https://secure.travelline.ru/resource/images/rt/127059/638133502490704500-57d44851-05a5-414d-b446-a8ff0c928da6,https://secure.travelline.ru/resource/images/rt/127059/638133502142321763-90e4d699-a2c6-45c5-aeb0-eabc1638e038,https://secure.travelline.ru/resource/images/rt/127059/638133502624406994-bd6a16c2-ec3d-4926-b516-5b379fb51d22}	2026-05-03 03:11:37.407228	2026-05-03 03:11:37.407228	75.00
169	26	The Leninsky Suite	Люкс № 107 – это уникальный номер отеля «Националь», известный как «Ленинский» люкс, который в 1918 году служил резиденцией Главы Совета Народных Комиссаров В.И. Ленина.\nМы приглашаем Вас насладиться лучшими видами на Кремль из гостиной этого роскошного люкса и прикоснуться к богатой истории нашего отеля в самом центре Москвы. Откройте для себя атмосферу прошлого и получите неповторимое впечатление от проживания в «Ленинском» люксе.	3	1	king-size	120000.00	{Wi-Fi,Спа-зона,"Высокие потолки","Вид на город","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/277714/638494045800646749-f8e74ae4-cc9a-4d3c-b60b-73da25540c1b,https://secure.travelline.ru/resource/images/rt/277714/638494045845657407-0309fe1c-4b3a-4eb5-a9dc-b42fcc2cfb45,https://secure.travelline.ru/resource/images/rt/277714/638494048068767345-2ab85d0d-c884-43b3-9251-e8663f30803f,https://secure.travelline.ru/resource/images/rt/277714/638494045765287199-e7e255d1-e7e6-4cac-8862-2fcddce76933,https://secure.travelline.ru/resource/images/rt/277714/638494046342293961-c971d008-d913-4ee7-941b-c2e8e85e1d54}	2026-05-03 03:14:10.87139	2026-05-03 03:14:10.87139	64.00
170	26	Presidential Suite	Непревзойденные роскошные двух- и трехкомнатные люксы с гостиной, спальней и уютным кабинетом. Из номера открывается панорамный вид на Кремль и Исторический музей. В просторной гостиной зоне с мягкой мебелью, антикварным столом и редкими предметами старины созданы все условия как для приватных встреч, так и для отдыха. В спальне с фирменными двуспальными кроватями (King) с мягкими одеялами и множеством подушек вам обеспечен идеальный отдых. 	3	1	king-size	204000.00	{Wi-Fi,Спа-зона,"Высокие потолки","Вид на город","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/191644/638133504177981780-c9dac9d4-d32c-44d1-b37a-306e23c96cb3,https://secure.travelline.ru/resource/images/rt/191644/638133504460483680-ee11aa6f-352e-4b88-831a-603ebfede443,https://secure.travelline.ru/resource/images/rt/191644/638133503400334653-d5a0b1a6-a590-441c-b7e6-c87f35853da7,https://secure.travelline.ru/resource/images/rt/191644/638133503431272669-e0ba8a84-5ea8-4e76-83d2-27709341c1b1,https://secure.travelline.ru/resource/images/rt/191644/638133503486782311-c2878fd0-629b-4835-b6a7-4481ddab877b}	2026-05-03 03:16:30.552089	2026-05-03 03:16:30.552089	85.00
171	26	Chaliapin Suite	Люкс № 411 – это уникальный номер отеля «Националь» в центре Москвы, известный как Люкс «Шаляпин». Мы предлагаем Вам эксклюзивную возможность погрузиться в атмосферу роскоши в трехкомнатном люксе «Шаляпин». Именно в этом номере останавливался знаменитый русский оперный певец Федор Шаляпин во время визитов к меценату Савве Мамонтову.	3	1	king-size	210000.00	{Wi-Fi,Спа-зона,Балкон,"Высокие потолки","Вид на город","Доступ в тренажёрный зал",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/283497/638526695956534466-a57aeb97-643d-4155-ae86-97717e28c8a6,https://secure.travelline.ru/resource/images/rt/283497/638526695865241001-580cda6c-0f39-4710-baa3-9af9b2ba63b7,https://secure.travelline.ru/resource/images/rt/283497/638526695969264432-0cbeea38-0f61-4c07-9b90-71f05179add7,https://secure.travelline.ru/resource/images/rt/283497/638526695976657619-c8f4d071-a85f-42ed-a918-2f88120255e2,https://secure.travelline.ru/resource/images/rt/283497/638526695868637966-094ae523-1410-425b-a91a-13466b753bd7}	2026-05-03 03:19:01.345612	2026-05-03 03:19:01.345612	97.00
172	27	Standard Double Room	Идеальное сочетание комфорта и современного стиля! Дизайн этого светлого уютного номера продуман до мелочей: элегантная мебель, приятные цветовые решения и внимание к деталям делают пространство по-настоящему гармоничным. К вашим услугам собственная ванная комната, небольшая кухня, где можно приготовить лёгкий завтрак, удобная двуспальная кровать или 2 односпальные с ортопедическим матрасом, которая подарит вам крепкий и здоровый сон.	2	1	queen-size	11592.00	{Wi-Fi,Кондиционер,"Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://azimuthotels.com/resize/images/upload/standard_353340_room7.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_stand_353340_room3.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_stand_353340_room9.jpg?w=1400}	2026-05-03 03:24:01.1997	2026-05-03 03:24:01.1997	21.00
173	27	Superior Standard Double Room	Ощутите атмосферу комфорта и стиля в просторном номере Стандарт улучшенный, где всё продумано для вашего удобства. Большая кровать или 2 односпальные оснащены ортопедическим матрасом для безмятежного сна. В вашем распоряжении – собственная ванная комната с набором косметических средств и небольшая, полностью оборудованная кухня, где есть всё необходимое для приготовления пищи.	2	1	queen-size	12512.00	{Wi-Fi,Кондиционер,Балкон,"Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://azimuthotels.com/resize/images/upload/Residence_super_353341_room3.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_super_353341_room6.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_stand_353340_room9.jpg?w=1400}	2026-05-03 03:25:57.276977	2026-05-03 03:25:57.276977	23.00
174	27	Family Standard Double Room	Просторный номер для идеального отдыха всей семьи. Эта категория подходит тем, кто выбирает практичность и дополнительное пространство. Номер оснащён одной двуспальной или двумя односпальными кроватями и раскладным диваном, современной ванной комнатой и функциональной мини-кухней, позволяющей готовить лёгкие блюда для всей семьи. Номера расположены в спокойной, уединённой части отеля на минус первом этаже, где ничто не отвлекает от отдыха и при этом удобно добраться до всей инфраструктуры.	4	2	queen-size	14352.00	{Wi-Fi,Кондиционер,Балкон,"Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://azimuthotels.com/resize/images/upload/Vinogradnaya_family_370772_room8.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Vinogradnaya_family_370772_room11.png?w=1400,https://azimuthotels.com/resize/images/upload/Vinogradnaya_family_370772_room10.jpg?w=1400}	2026-05-03 03:27:49.703603	2026-05-03 03:27:49.703603	34.00
175	27	Suite Room with Balcony	Ваш личный уголок комфорта и стиля, где каждая деталь продумана для вашего удобства! Элегантный двухкомнатный номер Люкс с балконом  оснащён всем необходимым для комфортного проживания: собственная ванная комната с современной сантехникой и набором косметических принадлежностей, кухня, укомплектованная посудой, где можно в любое время приготовить любимые блюда, удобная кровать или 2 односпальные с ортопедическим матрасом для крепкого и здорового сна, раскладной диван, который может служить дополнительным спальным местом. С балкона, обставленного удобной ротанговой мебелью, открывается потрясающий панорамный вид на море.	4	2	queen-size	16652.00	{Wi-Fi,Кондиционер,Балкон,"Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://azimuthotels.com/resize/images/upload/Residence_suit_354566_room2.jpg?w=1400,https://azimuthotels.com/resize/images/upload/suite_354566_room6.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_suit_354566_room9.jpg?w=1400,https://azimuthotels.com/resize/images/upload/Residence_suit_354566_room11.jpg?w=1400}	2026-05-03 03:30:11.203612	2026-05-03 03:30:11.203612	43.00
176	28	Standard Double Room	Уютный классический однокомнатный номер, в котором созданы условия для работы и отдыха, с бесплатным ВАЙ-ФАЙ (Wi-Fi) и прекрасными видами на ВДНХ, Останкинскую башню и городские пейзажи Москвы.	3	2	queen-size	6100.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/203670/637975506549041208-b9fc6858-1529-4cdd-bed3-d4480870ab1a/f/webp,https://secure.travelline.ru/resource/images/rt/203670/637975507175400499-828defb1-8467-4c8e-b5fe-122fe720053d/f/webp,https://secure.travelline.ru/resource/images/rt/203670/638040468890011206-17c6f73b-a362-4e6e-8da9-5406f8b3e081/f/webp}	2026-05-03 03:34:37.802328	2026-05-03 03:34:37.802328	24.00
177	28	Business Double Room	Из окна этого светлого номера бизнес-класса, оснащенного современной удобной мебелью, открывается панорамный вид на город. Тщательно подобранный интерьер создает атмосферу уюта и комфорта для плодотворной работы или беспечного отдыха.В числе удобств — телевизор с плоским экраном, центральная система кондиционирования и холодильник. Собственная ванная комната укомплектована феном.	3	1	king-size	8100.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/41647/637631531113699837-7a6990e4-075b-4847-a1cf-238c23096165/f/webp,https://secure.travelline.ru/resource/images/rt/41647/637631531125611873-9fd77484-c2fb-49e8-839c-3489ffd6fe25/f/webp,https://secure.travelline.ru/resource/images/rt/41647/637631531128657399-2c0cd5b5-2908-4c46-a7fd-f76f33031fe2/f/webp}	2026-05-03 03:36:38.026831	2026-05-03 03:36:38.026831	24.00
178	28	Suite Double Room	Номер "Люкс" состоит из двух раздельных комнат - гостиной и спальни, ванной комнаты и гостевого туалета. Площадь номера – 45,5 кв.м.	3	1	king-size	11100.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/10896/637631535128562576-eef74ad6-f773-46fc-b40a-f6ce1d7d26a2/f/webp,https://secure.travelline.ru/resource/images/rt/10896/637631535127017275-0b54d03b-b420-4905-913a-0450215ee30a/f/webp,https://secure.travelline.ru/resource/images/rt/10896/637631535144695996-3d6a436d-a8d6-4764-8935-a9ddad17d8e1/f/webp}	2026-05-03 03:38:17.213474	2026-05-03 03:38:17.213474	46.00
179	28	Suite-Grand Executive Room	Полностью обновленный комфортабельный двухкомнатный номер состоит из гостиной, спальни, ванной комнаты и гостевого туалета. Расположение номера позволяет любоваться видами города, открывающимися в разных направлениях.	3	1	king-size	14600.00	{Wi-Fi,"Красивый вид",Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/41646/637631541156618365-84ec02e6-97e7-4bc2-8483-e82a9bf71dd2/f/webp,https://secure.travelline.ru/resource/images/rt/41646/637631541164601116-0dd562cd-d9e1-4416-ab62-81ff19e89b22/f/webp,https://secure.travelline.ru/resource/images/rt/41646/637631541165741755-026b1c80-87cc-44fe-bd6e-aa0805c7c409/f/webp,https://secure.travelline.ru/resource/images/rt/41646/637631541177380988-c662aefa-53e9-4902-b68a-b30a684f9fe4/f/webp}	2026-05-03 03:40:32.003041	2026-05-03 03:40:32.003041	61.00
180	29	Compact Double Room without Window	Номер без окон, с красочной, мягко подсвеченной стеной и письменным столом оснащен телевизором с плоским экраном. В собственной ванной комнате установлен душ.	2	1	queen-size	13070.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/523627531.jpg?k=246cb0cb5b382f7aea05a2847270db85b2a5fd70555a24b35ea19e03cfc07b0b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/110997484.jpg?k=64b6a22f7be13a7002538aff45b3102d56698c95f56bd5c92b666231c70319a6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/110997507.jpg?k=a6b69ba2f45acf98516c82af95f61e722ea8e66bcb225b3880587834d8c4abd5&o=}	2026-05-03 03:45:07.196374	2026-05-03 03:45:07.196374	12.00
181	29	Compact Double Room	Двухместный номер оборудован паркетным полом, отоплением, а также собственной ванной комнатой с душевой кабиной и феном. Номера на верхних этажах доступны на лифте. В номере имеется 1 кровать.	2	1	queen-size	13642.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/110997511.jpg?k=db194c0bb7677d3b8a09931857fe38f26caf76f282b1037f0238ef65612a3fb3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/110997484.jpg?k=64b6a22f7be13a7002538aff45b3102d56698c95f56bd5c92b666231c70319a6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/110997457.jpg?k=9012a7fb0bf76684f1a2c950f4ed00596569df14ee2b82bfe35e6611223d1152&o=}	2026-05-03 03:46:42.705396	2026-05-03 03:46:42.705396	12.00
182	29	Standard Double Room	В числе удобств этого номера — телевизор с плоским экраном и рабочий стол. В ванной комнате с душем предоставляется фен. В некоторых номерах установлена кровать, встроенная в стену, а в других — есть место для установки дополнительной кровати.	2	1	queen-size	15440.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/161752604.jpg?k=c9f4ef1ca58e72936cf8c541765c79460ff88564bd1b6b6d28f8638150e2c75b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/523621316.jpg?k=5ef48f884373c1e6560d9750411742fd8361af7cf20e8df77f8938d325467794&o=,https://cf.bstatic.com/xdata/images/hotel/square60/110997457.jpg?k=9012a7fb0bf76684f1a2c950f4ed00596569df14ee2b82bfe35e6611223d1152&o=}	2026-05-03 03:48:23.028177	2026-05-03 03:48:23.028177	14.00
183	30	Standard Double Room	Удобная кровать, плотные шторы, мощный душ и бесплатный Wi-Fi – в наших двухместных номерах есть все необходимое для прекрасного ночного сна.	2	1	queen-size	35642.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{"https://ak-d.tripcdn.com/images/1mc1912000klhuyobDC20_W_1280_853_R5.webp?proc=watermark/image_trip1,l_ne,x_16,y_16,w_67,h_16;digimark/t_image,logo_tripbinary;ignoredefaultwm,1A8F","https://ak-d.tripcdn.com/images/0224n12000lwb7tnb1A58_W_1280_853_R5.webp?proc=watermark/image_trip1,l_ne,x_16,y_16,w_67,h_16;digimark/t_image,logo_tripbinary;ignoredefaultwm,1A8F"}	2026-05-03 03:53:16.096237	2026-05-03 03:53:16.096237	17.00
184	30	Standard Family Room	В наших семейных номерах есть двуспальная или большая двуспальная кровать, а также диван-кровать и раскладной диван в зависимости от количества гостей. Мы также предоставляем детские кроватки без дополнительной платы. Размер и комплектация номера могут варьироваться в зависимости от отеля и количества гостей.	4	3	queen-size	41453.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://www.premierinn.com/_next/image?url=https%3A%2F%2Fwww.premierinn.com%2Fcontent%2Fdam%2Fpi%2Fwebsites%2Fhotelimages%2Fgb%2Fen%2Fnon-hotel-specific%2FID4%2FID4-family-quad.jpg&w=640&q=75,https://www.premierinn.com/_next/image?url=https%3A%2F%2Fwww.premierinn.com%2Fcontent%2Fdam%2Fpi%2Fwebsites%2Fhotelimages%2Fgb%2Fen%2Fnon-hotel-specific%2FID4%2FID4-Bathroom.jpg&w=640&q=75}	2026-05-03 03:55:14.047267	2026-05-03 03:55:14.047267	20.00
185	31	Standard Double Room	Комфортабельный номер площадью 26 кв. м. оснащен двуспальной кроватью размера 180 х 200 см или 150 x 200 см, телевизором с плоским экраном, рабочим столом, кондиционером и бесплатным доступом к Wi-Fi.	2	1	king-size	13500.00	{Wi-Fi,Кондиционер,"Тренажёрный зал",Сауна,Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/170532/637824355707183549-d4e83875-1e5d-4502-8bd4-9a7b14c69b53,https://secure.travelline.ru/resource/images/rt/170532/637824356513549203-98af2c40-3234-4c37-b86b-ed5eaf9b886c,https://secure.travelline.ru/resource/images/rt/170532/637824356306319680-8538da2d-f22b-46ca-95dd-d5423b2515ee}	2026-05-03 03:57:58.689401	2026-05-03 03:57:58.689401	26.00
186	31	Deluxe Double Room	Номер улучшенной категории площадью 30 кв. м. оснащен двуспальной кроватью размера "кинг" 180 х 200 см, кондиционером, бесплатным доступом к Wi-Fi и телевизором с плоским экраном с международными и российскими каналами. В номере также есть электрический чайник, ассортимент чая и кофе, минеральная вода, гладильная доска и утюг, сейф и мини-бар. Мини-бар предоставляется за дополнительную плату.  	2	1	king-size	16700.00	{Wi-Fi,Кондиционер,"Тренажёрный зал",Сауна,Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/170536/637824357402904302-2b944a96-fafa-4789-a355-ebd48fe012f9,https://secure.travelline.ru/resource/images/rt/170536/637824357526844023-9a7d8610-f704-4cdd-85ab-1b5f5c403fe8,https://secure.travelline.ru/resource/images/rt/170536/637824357642424518-c8741fc9-72e0-4417-8886-45a966f96d19}	2026-05-03 04:00:14.410351	2026-05-03 04:00:14.410351	30.00
187	31	Executive  Double Room	Представительский номер площадью 33 кв. м. В стоимость входит доступ в представительскую гостиную, услуги которой включают завтрак шведский стол; напитки, фрукты и снеки в течение дня; ужин шведский стол с напитками.	3	1	king-size	19700.00	{Wi-Fi,Кондиционер,"Тренажёрный зал",Сауна,Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/170882/637825197272050451-d33d7043-2345-44d0-918f-b9ef7f555bd8,https://secure.travelline.ru/resource/images/rt/170882/637825197170540692-3fdc67d5-cbdf-47b4-8bc1-af858ff0ee51,https://secure.travelline.ru/resource/images/rt/170536/637824357642424518-c8741fc9-72e0-4417-8886-45a966f96d19}	2026-05-03 04:02:12.39686	2026-05-03 04:02:12.39686	33.00
188	31	Junior Suite Double Room	Уютный и просторный номер площадью от 45 до 50 кв. м. В стоимость входит доступ в представительскую гостиную, услуги которой включают завтрак шведский стол; напитки, фрукты и снеки в течение дня; ужин шведский стол с напитками.	3	1	king-size	21700.00	{Wi-Fi,Кондиционер,"Тренажёрный зал",Сауна,Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/170894/637825209327580846-5b3f5e13-90b1-4876-a037-74b94eeae91e,https://secure.travelline.ru/resource/images/rt/170894/637825209505310302-f16867b2-5fb9-4562-aad3-65e66f897eb4,https://secure.travelline.ru/resource/images/rt/170536/637824357642424518-c8741fc9-72e0-4417-8886-45a966f96d19}	2026-05-03 04:03:42.32756	2026-05-03 04:03:42.32756	45.00
189	31	Embassy Suite	Трехкомнатный люкс площадью 90 кв. м. В стоимость входит доступ в представительскую гостиную, услуги которой включают завтрак шведский стол; напитки, фрукты и снеки в течение дня; ужин шведский стол с напитками. Люкс оформлен в стиле 50-х гг. и состоит из гостиной, рабочего кабинета и спальни с кроватью размера 180 x 200 см. Каждая комната оснащена телевизором с плоским экраном, кондиционером и доступом к Wi-Fi. 	2	1	king-size	49000.00	{Wi-Fi,Кондиционер,"Тренажёрный зал",Сауна,Бассейн,Завтрак,Шкаф,"Обеденная зона",Сейф,Телевизор,Фен,Телефон}	t	{https://secure.travelline.ru/resource/images/rt/170907/638773918431121522-0e3818f6-3bbf-409d-8b73-79e7b033da60,https://secure.travelline.ru/resource/images/rt/170907/638652967585777565-3efdaadd-1276-49f6-a9dd-4e1a5fbc16da,https://secure.travelline.ru/resource/images/rt/170907/638652967502239808-f06f44ce-de27-4207-8764-86871e4196ef,https://secure.travelline.ru/resource/images/rt/170907/637825221158996977-629c77d1-15fe-4e37-a76d-01aa6205b9ea}	2026-05-03 04:05:37.445104	2026-05-03 04:05:37.445104	90.00
190	32	Tokyo Deluxe King	Двухместный номер на 48–52 этаже с 1 кроватью и видом на Токийскую башню или вулкан Фудзияма. В числе удобств телевизор с плоским экраном и спутниковыми каналами, мини-бар и кофемашина.	3	1	king-size	80908.00	{Wi-Fi,Кондиционер,"Вид на город","Гидромассажная ванна",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433374692.jpg?k=398c8f97f637eb5f8fbe48e6b6b25143a545c49c6e495e604ec0a30c5271e009&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374746.jpg?k=5a8d2cbb7cb0fd41bc78bd79689db471671695cbb3acd7667aa6faca72b08c86&o=}	2026-05-03 04:09:55.101291	2026-05-03 04:09:55.101291	52.00
191	32	Tokyo Deluxe Twin	Номер на 48–52 этаже с видом на телевизионную башню Tokyo Skytree и сады Императорского дворца или вулкан Фудзияма. В числе удобств телевизор с плоским экраном и спутниковыми каналами, мини-бар и кофемашина.	3	2	queen-size	80908.00	{Wi-Fi,Кондиционер,"Вид на город","Гидромассажная ванна",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/484864734.jpg?k=9483c01ea1aa1b8c83d21cdc971c1e296c1597f96837efcb62acd7fa774490b2&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374746.jpg?k=5a8d2cbb7cb0fd41bc78bd79689db471671695cbb3acd7667aa6faca72b08c86&o=}	2026-05-03 04:11:51.561826	2026-05-03 04:11:51.561826	52.00
192	32	Club Deluxe King	Номер Делюкс, расположенный на одном из клубных этажей. Гостям предоставляются эксклюзивные клубные привилегии, включая услуги консьержа и выбор блюд/напитков в клубном лаундже. В числе удобств телевизор с плоским экраном и спутниковыми каналами, мини-бар и кофемашина.	3	1	king-size	90961.00	{Wi-Fi,Кондиционер,"Вид на город","Гидромассажная ванна",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433374702.jpg?k=ac61c35c6c3730d7458cbc8082fc5b9ed58b5ebe987582c2b5f8469b4237e51b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374746.jpg?k=5a8d2cbb7cb0fd41bc78bd79689db471671695cbb3acd7667aa6faca72b08c86&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374755.jpg?k=2129e21d2471cae38737f9415d58eae2458fdba9a8b7be3338f59c76891bf1a1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374765.jpg?k=5181dab0ffd92e6957b19d59a34c9cf0e6f4c7b950f54aabc1f1b004f9401bd7&o=}	2026-05-03 04:13:37.271256	2026-05-03 04:13:37.271256	52.00
193	32	Club Deluxe Twin	Двухместный номер с 2 отдельными кроватями и гидромассажной ванной. В числе удобств собственная ванная комната с ванной, душем, биде, халатами и бесплатными туалетно-косметическими принадлежностями. В числе прочих удобств этого просторного звукоизолированного номера с видом на город кондиционер, телевизор с плоским экраном и спутниковыми каналами, мини-бар и принадлежности для чая/кофе. В распоряжении гостей 2 кровати.	3	2	queen-size	90961.00	{Wi-Fi,Кондиционер,"Вид на город","Гидромассажная ванна",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433374702.jpg?k=ac61c35c6c3730d7458cbc8082fc5b9ed58b5ebe987582c2b5f8469b4237e51b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374746.jpg?k=5a8d2cbb7cb0fd41bc78bd79689db471671695cbb3acd7667aa6faca72b08c86&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374755.jpg?k=2129e21d2471cae38737f9415d58eae2458fdba9a8b7be3338f59c76891bf1a1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433374765.jpg?k=5181dab0ffd92e6957b19d59a34c9cf0e6f4c7b950f54aabc1f1b004f9401bd7&o=}	2026-05-03 04:14:10.650848	2026-05-03 04:14:10.650848	52.00
194	33	Palazzo Bedroom	Из окон спален Palazzo открывается спокойный вид на сад. В номерах есть просторные спальни с двуспальными кроватями, совмещенные гостиные и письменные столы.	2	1	king-size	251462.00	{Wi-Fi,Кондиционер,"Вид на cад","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f009b6fa0070627035.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f009ce75b471761846.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f009f0653804534879.jpg}	2026-05-03 12:37:15.696028	2026-05-03 12:37:15.696028	47.00
195	33	Palazzo Chamber Affresco	Элегантные залы Palazzo Chamber Affresco украшены прекрасными историческими фресками и открывают чудесный вид на расположенные внизу сады.	2	1	king-size	290149.00	{Wi-Fi,Кондиционер,"Вид на частный cад","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f013c9b92864593302.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f0142952e270905457.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f0140ebe1870380280.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f013e9d9b933699378.jpg}	2026-05-03 12:39:56.056665	2026-05-03 12:39:56.056665	49.00
196	33	Palazzo Chamber Luminoso	Окна выходят на юг, залит естественным светом и предоставляют достаточно места для отдыха после дня, проведенного за исследованиями окрестностей.	2	1	king-size	338507.00	{Wi-Fi,Кондиционер,"Вид на частный cад и Гранд-канал","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f0236f7bd080190518.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02378c91186070287.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02338210900995307.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02351c33847162711.jpg}	2026-05-03 12:42:45.727558	2026-05-03 12:42:45.727558	56.00
197	33	Palazzo Stanza Canal Grande	Из некоторых палаццо Станца Канал Гранде открываются исключительные виды на Гранд-канал и сад, а также сохранилось множество оригинальных исторических архитектурных деталей.	2	1	king-size	386866.00	{Wi-Fi,"Исторически архитектурные детали",Кондиционер,"Вид на частный cад и Гранд-канал","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02ea3579925321812.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02e89697004407610.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f02ebe168977596577.jpg}	2026-05-03 12:45:02.058003	2026-05-03 12:45:02.058003	70.00
198	33	Maddalena Stanza Canal Grande	Отель Aman Venices Maddalena Stanza Canal Grande – это исторический отель с видом на Садовую террасу и Гранд-канал.	2	1	king-size	517433.00	{Wi-Fi,"Исторически архитектурные детали",Кондиционер,"Вид на сад и Гранд-канала с собственной террасы","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f0491f2e9732600572.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f048d92e6383836933.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f048e8270061011207.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f048b3474014058559.jpg}	2026-05-03 12:48:12.50936	2026-05-03 12:48:12.50936	78.00
199	33	Alcova Tiepolo Suite	Просторный люкс с большой гостиной и спальней, украшенными фресками Tiepolo XVIII века.	4	2	king-size	778567.00	{Wi-Fi,"Исторически архитектурные детали",Кондиционер,"Вид на сад с собственной террасы","Высокие окна","Мраморный камин","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06b0e938609465909.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06b29e6d481746259.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06b3adef775116490.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06b801e0365646956.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06b67af2569564249.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f06ba587f897054231.jpg}	2026-05-03 12:51:55.183581	2026-05-03 12:51:55.183581	112.00
200	33	Grand Canal Suite	В номере Grand Canal Suite есть отдельная гостиная с великолепным видом на венецианские каналы.	2	1	king-size	923642.00	{Wi-Fi,"Исторически архитектурные детали",Кондиционер,"Виды на Гранд-канал","Высокие окна","Мраморный камин","Звуковая система","Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f088cc0c7624677539.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f08866018563661806.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f088b2173253519254.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f088a47f6176531129.jpg,https://d1t1qzzb2zwrre.cloudfront.net/master/room/66/6639f088828db602228093.jpg}	2026-05-03 12:54:24.023927	2026-05-03 12:54:24.023927	105.00
201	34	Superior King Room - Butler Service	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также собственная ванная комната с ванной, душем и феном. Просторный двухместный номер с кондиционером оборудован телевизором с плоским экраном и доступом к потоковым сервисам, зоной отдыха, шкафом для одежды и сейфом. В номере имеется 1 кровать.	2	1	king-size	116663.00	{Wi-Fi,Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/591708275.jpg?k=21031155b316206a1abe37d3940ae0a96fd706cef265e18648c4a67a0cd6c78f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/661158207.jpg?k=d5f53d381ae4674471390a4c3ed5a8c319b9aea698add75d90b4571b442b718b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/661158217.jpg?k=73df9f7339a016c889225c90115e3790048416078f9910ec2921800297db414f&o=}	2026-05-03 12:58:50.348851	2026-05-03 12:58:50.348851	40.00
202	34	Deluxe King Room - Butler Service	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с ванной, душем и феном. Просторный двухместный номер оборудован кондиционером, зоной отдыха, шкафом для одежды, сейфом и телевизором с плоским экраном и возможностью просмотра потоковых сервисов. В номере 1 кровать.	2	1	king-size	130163.00	{Wi-Fi,Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353188.jpg?k=9b09c3057e0c1ff9a889c2633df622113c1776e11f7f681046f503f5dcc17a0f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/591705639.jpg?k=223f19f6465220f24ccc3df2a9652f882defdd123652b873d763857e1b7b2ddf&o=}	2026-05-03 13:01:09.342058	2026-05-03 13:01:09.342058	42.00
203	34	Grand Luxe King Room - Butler Service	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также собственная ванная комната с ванной, душем и феном. Просторный двухместный номер оборудован кондиционером, зоной отдыха, шкафом для одежды, сейфом и телевизором с плоским экраном и возможностью просмотра потоковых сервисов. В номере имеется 1 кровать.	3	1	king-size	133538.00	{Wi-Fi,Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353191.jpg?k=bccee6ead49500d55db2b358f85950ac5a112d111ebed72da8382eeb70dff57a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353189.jpg?k=ec86ad3c06ebd0ce03eb9a3334ba08363f0733d66877bfacb0ef6c5774c55fcc&o=,https://cf.bstatic.com/xdata/images/hotel/square60/591705639.jpg?k=223f19f6465220f24ccc3df2a9652f882defdd123652b873d763857e1b7b2ddf&o=}	2026-05-03 13:03:09.29563	2026-05-03 13:03:09.29563	42.00
204	34	Grand Luxe Double Room with Two Double Beds - Butler Service	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также собственная ванная комната с ванной, душем и феном. Просторный двухместный номер оборудован кондиционером, зоной отдыха, шкафом для одежды, сейфом и телевизором с плоским экраном и возможностью просмотра потоковых сервисов. В номере 2 кровати.	4	2	queen-size	160538.00	{Wi-Fi,Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/591708280.jpg?k=3c1daccb91c4b878731ac6c94c9aeed04013e0ff73f05b978c5b3fdebe409e06&o=,https://cf.bstatic.com/xdata/images/hotel/square60/591705639.jpg?k=223f19f6465220f24ccc3df2a9652f882defdd123652b873d763857e1b7b2ddf&o=}	2026-05-03 13:04:46.490331	2026-05-03 13:04:46.490331	42.00
211	35	Terrace Room	Номер с просторными окнами с видом на тихий сад отеля или окружающие проспекты.	2	1	king-size	277125.00	{Wi-Fi,Кондиционер,"Вид на сад",Терраса,"Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/782989756.jpg?k=82140edae2145b9af6b7fbe113a1c805db9fe661989959a02674c0016cfe9cb5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/338398370.jpg?k=e4150352c886cb5d3dc598c2e1afd008cec6c363d9daf53bcf9831bed3b866f7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782989727.jpg?k=277e520a700599fd4ef4fcafe727fb7486907f2ba5cc59742c48732424e847e6&o=}	2026-05-03 13:17:46.280605	2026-05-03 13:17:46.280605	45.00
205	34	One-Bedroom Astor Suite - Butler Service	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть ковровое покрытие на полу, зона отдыха с телевизором с плоским экраном и доступом к потоковым сервисам, кондиционер, шкаф для одежды, а также сейф. В номере 1 кровать.	4	1	king-size	211163.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353195.jpg?k=4cf1967af9d2ab1ea5f768a196c58e0fcdc1c6f8146d7754857fa9b490dac24c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353193.jpg?k=778b6a0dc597badfa9d785d81f94eb5a5661689757c7a3b214cf5ad40bdd7213&o=,https://cf.bstatic.com/xdata/images/hotel/square60/591705639.jpg?k=223f19f6465220f24ccc3df2a9652f882defdd123652b873d763857e1b7b2ddf&o=}	2026-05-03 13:06:51.997062	2026-05-03 13:06:51.997062	56.00
206	34	One-Bedroom Deluxe Suite - Butler Service	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть ковровое покрытие пола, зона отдыха с телевизором с плоским экраном и доступом к потоковым сервисам, кондиционер, шкаф для одежды, а также сейф. В номере имеется 1 кровать.	4	1	king-size	221288.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353195.jpg?k=4cf1967af9d2ab1ea5f768a196c58e0fcdc1c6f8146d7754857fa9b490dac24c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353196.jpg?k=bcf6edd39a2f4acbada372ebf7f696dcbdd9eab8acdfcc3ae9de0eef99ad0874&o=,https://cf.bstatic.com/xdata/images/hotel/square60/591705639.jpg?k=223f19f6465220f24ccc3df2a9652f882defdd123652b873d763857e1b7b2ddf&o=}	2026-05-03 13:08:14.882473	2026-05-03 13:08:14.882473	74.00
207	34	One-Bedroom 5th Avenue Suite - Butler Service	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть ковровое покрытие на полу, зона отдыха с телевизором с плоским экраном и доступом к потоковым сервисам, кондиционер, шкаф для одежды, а также сейф. В номере 1 кровать.	4	1	king-size	312413.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353203.jpg?k=b878760f2ba52dbd994b8b1d76677a8ff4e66848e33bbd786ff85c77a1373e77&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353325.jpg?k=5bc2a92a9d16ee394d5524935ff45def8483bef1a4a6f13c89b3dd6a1ed497b3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353358.jpg?k=337acf90a7807a0b0461dae402357683e03a3060b937df307c5cbc8df8740046&o=}	2026-05-03 13:09:50.475709	2026-05-03 13:09:50.475709	98.00
208	34	One-Bedroom St Regis Suite - Butler Service	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть ковровое покрытие пола, зона отдыха с телевизором с плоским экраном и доступом к потоковым сервисам, кондиционер, шкаф для одежды, а также сейф. В номере имеется 1 кровать.	4	1	king-size	386663.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Письменный стол",Бассейн,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/433353207.jpg?k=db296b73b3ed1c7f762120156a9478e0a20485fe841a70e3f4e0e82063b65319&o=,https://cf.bstatic.com/xdata/images/hotel/square60/711828176.jpg?k=f9469f84e668fc8f791d60632ec52e9710bbb0cc21daf3dde1162711c1a15c80&o=,https://cf.bstatic.com/xdata/images/hotel/square60/433353351.jpg?k=4a5a029ca10f1fc77f34ed868e7a758e7dd411879a1ebc453eba93bc5980e248&o=}	2026-05-03 13:11:29.880701	2026-05-03 13:11:29.880701	102.00
209	35	Superior Twin Room	Из этого двухместного номера с 2 отдельными кроватями открывается вид на стеклянный купол ресторана La Bauhinia или во внутренний двор.	2	2	queen-size	206520.00	{Wi-Fi,Кондиционер,"Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/295686327.jpg?k=bedc567ff5389fc5c84a8576c0081b373caa662050e7947a55233769db8dcf1b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373137.jpg?k=5540079d4198f8dbaef18c37042e2538649a5c696e6cf9045af3aaf0c3aaa74c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:14:57.870926	2026-05-03 13:14:57.870926	37.00
210	35	Deluxe Double Room	Из этого улучшенного двухместного номера с 1 кроватью открывается вид на сад отеля или окружающие проспекты.	2	1	king-size	224171.00	{Wi-Fi,Кондиционер,"Вид на сад","Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/782984888.jpg?k=fa9a24018514b492e0db5cc003e44615016134e39ecd7e6deaf629918ea63230&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782984886.jpg?k=0eccb9cd6792a8b7b42567f0722d2f7e7ed2b4b6fc848a5bca07e39292bd1d9b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:16:18.005604	2026-05-03 13:16:18.005604	40.00
212	35	King Room With Eiffel Tower View	Просторный двухместный номер с 1 кроватью, кондиционером, звукоизолированными стенами и собственной ванной комнатой с ванной и душем. В номере установлена 1 кровать.	2	1	king-size	356555.00	{Wi-Fi,Кондиционер,"Вид на Эйфелеву башню","Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/782986779.jpg?k=a4a145bf6c603e96bacc71444f89a40d5c158ba729b36ab89d4d63af4a2b8c24&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782987353.jpg?k=71727dcba753cf48cfbabbebc7739b4e4070d6b913f01492eb98685587f75120&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782987351.jpg?k=7a74ab3da266b340a8ba2bf7491556624bde0445159733959012dc7ee9c5b8d0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:19:36.982168	2026-05-03 13:19:36.982168	45.00
213	35	Junior Suite with Paris View	В этом люксе есть большие окна с видом на городской пейзаж Парижа, сад отеля и частичный вид на Эйфелеву башню.	3	2	king-size	338904.00	{Wi-Fi,Кондиционер,"Вид на Париж","Собственный люкс","Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/338398390.jpg?k=da04924f028a52e8799e634c24719a3a92184d05389d7c2a18aa5ffe78c07ca8&o=,https://cf.bstatic.com/xdata/images/hotel/square60/338398393.jpg?k=660959fd946be60c6743cd425865519b22149eebfd1372b2075bac8cfdefc107&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782371931.jpg?k=d96c56c727096fd5401ccd34b4d10c27686e42fb1cb5c012878d11c89d6aab85&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:22:16.751678	2026-05-03 13:22:16.751678	55.00
214	35	Duplex Eiffel view suite	Гости этого двухуровневого люкса Eiffel View смогут насладиться большими двухуровневыми окнами с непревзойденным видом на Эйфелеву башню.	3	2	king-size	524242.00	{Wi-Fi,Кондиционер,"Вид на Эйфелеву башню","Собственный люкс","Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/782988494.jpg?k=3fcd3c9063c43fea88c35e15f78d9812a0795829c54e2e0d800487503367e403&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782988510.jpg?k=090009ce1a4a7e60a958631a1048309916eeb4254b57b9088cb3e6b664db3c8e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782988507.jpg?k=a30b1d3b769b926eaae1a24cf08fc7dac6014b79ddc162b1c0a30716575c861f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782988479.jpg?k=8842f36f737ac83750141ff841dc82f33b209e5793fd7ab026d517ac491f66f1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:24:15.712223	2026-05-03 13:24:15.712223	80.00
215	35	Terrace Suite	Двухместный номер с 1 кроватью и большими окнами, которые выходят на собственную открытую террасу с потрясающим частичным видом на Эйфелеву башню или изысканный французский сад.	3	2	king-size	541893.00	{Wi-Fi,Кондиционер,"Вид на сад",Терраса,"Письменный стол",Звукоизоляция,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/782989148.jpg?k=e88e832e79053c73af1b6c6ced2851c7de81035db03c5448c319bdeaf8875a52&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782989142.jpg?k=c24522c84f5b32ce975388e010e3caa77cc43534d7d6c1601b6ac3c2bcac7315&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782989140.jpg?k=a25dbcebc6bbd7c216d25d0251a14b12868efc2dcebf90a9e8d95e3c9c4990c5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782989137.jpg?k=bd2f0be25cfd3324db1ebf43a7d7e7c64e758493e7f2bf0cf8eef14d863f358f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/782373151.jpg?k=78224658a03a4ab2abccce2cc616bf434c5666fc87dc4e0a4f2c76886d264208&o=}	2026-05-03 13:26:16.016727	2026-05-03 13:26:16.016727	70.00
216	36	King Room with Garden View	Из этого просторного номера с кондиционером открывается умиротворяющий вид на ландшафтный сад. В номере есть телевизор с плоским экраном и большой балкон. В ванной комнате установлен расслабляющий тропический душ.	2	1	king-size	78834.00	{Wi-Fi,Кондиционер,Балкон,"Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317286505.jpg?k=47412fb2cc7835f875f3458442cd54bc6a60d70e9a4b022addb24bd8f702179b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317286524.jpg?k=1c834cd3a9753602a0118b5781d7361739d011ab6b87e2afe8c77892ca8f8ee0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317286528.jpg?k=c63757fe940c775f9360f4df7aa4d2e61936545b5e68499c7e37fc399db888f0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/318952200.jpg?k=b127f9db074498a1aa8f5925276af8f4c8d55fd361f2b0fdf17dfb5d2ff7c6d5&o=}	2026-05-03 15:14:27.436733	2026-05-03 15:14:27.436733	77.00
217	36	Premier Double Room with Sea View	Из этого просторного номера с кондиционером открывается потрясающий вид на Южно-Китайское море. В номере есть большая двуспальная кровать, телевизор с плоским экраном и просторный балкон. В ванной комнате установлен расслабляющий тропический душ.	2	1	king-size	84674.00	{Wi-Fi,Кондиционер,Балкон,"Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317283400.jpg?k=9b362cd2d270883b50d1d06707ce6900aacf84362cd63b665f0c0ed9fd3ee5c6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317286524.jpg?k=1c834cd3a9753602a0118b5781d7361739d011ab6b87e2afe8c77892ca8f8ee0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317286528.jpg?k=c63757fe940c775f9360f4df7aa4d2e61936545b5e68499c7e37fc399db888f0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317285834.jpg?k=01d398eeed7c36b939f7aca7f2d776ffe428db9cb51a0df49af3bea726da79ed&o=}	2026-05-03 15:15:43.128331	2026-05-03 15:15:43.128331	77.00
218	36	One-Bedroom Villa with Private Pool	Отдохните в собственном бассейне или насладитесь чашечкой кофе на открытой террасе, окруженной тропическим садом. Эта роскошная вилла, оборудованная кроватью размера «кинг-сайз», также оснащена телевизором с плоским экраном и душем на открытом воздухе.	2	1	king-size	108032.00	{Wi-Fi,Кондиционер,"Собственный люкс",Балкон,"Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317283443.jpg?k=4f57ab60d3d6e88b13cd006b32a679b1d1e29551bde0a5f5d24c346ff405c23c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283454.jpg?k=16d080ac8e3ec1bd26ac1bb114a8251f37a844e408463abc1cbaed62e1163f66&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283732.jpg?k=7f5b6599f84569abb770d9e9fadd029cb458997754b957a9b346f1718423cbeb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283431.jpg?k=719e0565b5a4f1bb2d209c6cd910034250a8970957d570eb33efa0aa0202e62e&o=}	2026-05-03 15:17:42.381068	2026-05-03 15:17:42.381068	166.00
219	36	Constellation Garden Room	Гости могут наслаждаться видом на тропический лес или Южно-Китайское море с большого балкона, отдыхая в гидромассажной ванне. Номера с кроватью размера «king-size» оснащены 46-дюймовым телевизором с плоским экраном, док-станцией для iPod и аудиосистемой BOSE. Также предоставляется кофемашина Nespresso. В ванной комнате, примыкающей к номеру, есть тропический душ.	2	1	king-size	108032.00	{Wi-Fi,Кондиционер,"Собственный люкс",Терраса,"Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317285390.jpg?k=a6cb8aca50bc6d1bdb968d4659b113c0db93cf9c55ad50cb2090d3f72b814f92&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317285438.jpg?k=714ba830adb7700ca2de31a8e63d33ea235ecdb6dfd6b78e282882ac7b385b5a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/581787012.jpg?k=b9672d12cf06bb21978e84b63b2a15cc808f0d9d482c835c36d0900979c097c0&o=}	2026-05-03 15:20:00.483298	2026-05-03 15:20:00.483298	109.00
220	36	Sentosa Suite	Этот просторный люкс включает в себя гостиную, отдельную спальню с большой двуспальной кроватью и просторный балкон с видом на Южно-Китайское море. Номера оборудованы док-станцией для iPod, аудиосистемой BOSE и 46-дюймовым плоским телевизором. В люксах также есть кофемашина. В ванной комнате установлен тропический душ.	2	1	king-size	108032.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317285824.jpg?k=8ab45415ddf9dabdf3be5e93650247066be2de552fa9c6a6e8ff3f063176350e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317285831.jpg?k=86fa0da42ca66813e4a69db4e3b091ca5dd3916dc00ea7640d36776178c31812&o=,https://cf.bstatic.com/xdata/images/hotel/square60/687232996.jpg?k=44c30968851630add367551ed9d71e45d46cc7b1713d7bb52fb48b650354f150&o=}	2026-05-03 15:21:44.713929	2026-05-03 15:21:44.713929	86.00
221	36	Capella Suite	Из окон люксов Capella открывается вид на Южно-Китайское море. В каждом номере есть отдельная спальня с кроватью размера «king-size», гостиная зона и большой балкон. Люксы оборудованы док-станцией для iPod, аудиосистемой BOSE и 46-дюймовым плоским телевизором. Также в номерах есть кофемашина. В ванной комнате установлен тропический душ.	2	1	king-size	125551.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/318952355.jpg?k=bef0da6620c343108de53e592859601bfda7383a0ee70804cd11cc7bc6007946&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317286011.jpg?k=bd35ebb4d1a2ece5b9a6f339bb081b273dde2eb7a119067d806f157a986414b4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/581787236.jpg?k=36febc1d7793f5e0106f9996d42a64ecb3a714aeca168ce84a385dd5ebdf2dc6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/581787236.jpg?k=36febc1d7793f5e0106f9996d42a64ecb3a714aeca168ce84a385dd5ebdf2dc6&o=}	2026-05-03 15:23:39.117281	2026-05-03 15:23:39.117281	100.00
222	36	One Bedroom Palawan Villa	Эта вилла с одной спальней располагает просторной террасой с собственным небольшим бассейном и предлагает эксклюзивный доступ к частному пляжу отеля, расположенному всего в нескольких минутах ходьбы, а также к трем каскадным бассейнам.	2	1	king-size	125551.00	{Wi-Fi,Кондиционер,"Собственный вилла",Терраса,"Собственный бассейн","Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/317283769.jpg?k=4027320fac788b039800bcf75640767263c71b139fdf97feb8ec010e088a1f53&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283454.jpg?k=16d080ac8e3ec1bd26ac1bb114a8251f37a844e408463abc1cbaed62e1163f66&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283431.jpg?k=719e0565b5a4f1bb2d209c6cd910034250a8970957d570eb33efa0aa0202e62e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/317283732.jpg?k=7f5b6599f84569abb770d9e9fadd029cb458997754b957a9b346f1718423cbeb&o=}	2026-05-03 15:26:23.794652	2026-05-03 15:26:23.794652	166.00
224	36	Colonial Manor	Комплекс Colonial Manors — это здания, находящиеся под охраной государства и прекрасно отреставрированные. Каждая роскошная усадьба располагает тремя просторными спальнями с ванными комнатами, двумя гостиными и элегантной столовой. Также имеется кабинет, полностью оборудованная кухня и частный бассейн.	6	4	{"2 king-size","2 queen-size"}	1327173.00	{Wi-Fi,Кондиционер,"Собственный особняк",Терраса,"Собственный бассейн","Собственная кухня","Обеденная зона","Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/618530127.jpg?k=4a70c4762f018de91672baff41455912ccc0e45c68b6417e2d5cdffcd4df6404&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530038.jpg?k=bf07257b3858437c45b595d8220ecf36a1db214b71c4e0724522563e64b031d4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530064.jpg?k=b8ed1938f5e652f56713e9765c07875b9a93db24670758d6fa13b468b74d5e6d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530068.jpg?k=73c172ef69756ab56ce8f080d999e8b81713beac3a940034f0da93d6c5be615f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530071.jpg?k=027438c104b46eb36a9d7c25c14d6247d81e422e4d4adf550be2b80fccd1dd40&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530095.jpg?k=e4601a04f095411fbf30749f3d6825af80c3e4e5a4e103ea9b1dbfd105110b91&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530110.jpg?k=209c34974165106be47ffb82e2c2ee6b6930c9067a7b444707846ea56218e96f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530131.jpg?k=29c5e4d37f10f54d78c6bd4b51a226f7f34c454a34d8cebfe761bf4e8fbfcf0b&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530043.jpg?k=fc4f9f603b87414fc9abce02a55e0e09c54c82e88095df6acb4f4da9489d1f02&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530046.jpg?k=1117ae1a4787543f90c16441b8321df33a424a2434e9e49af9e766b8d0a76d08&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618530037.jpg?k=7e3b25c00609f5b0f85696589417e229ab877d4bb3eb87c6111a31d16e34d775&o=}	2026-05-03 15:35:27.342505	2026-05-03 15:35:27.342505	500.00
225	36	Capella Manor	Этот просторный люкс включает в себя 1 гостиную, 3 отдельные спальни и 3 ванные комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть кондиционер и балкон. В номере 4 спальных места.	6	4	{"2 king-size","2 queen-size"}	1592607.00	{Wi-Fi,Кондиционер,"Собственный особняк",Терраса,"Собственный бассейн","Собственная кухня","Обеденная зона","Вид на сад","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/618561959.jpg?k=896c0e480361c4de7cc9192fb35e3e4439222b88f70ab0c41e442ade9fbc81de&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618562034.jpg?k=97c5e9a791bf8952202718dfc5b4674c3cc8c157049c21e0d2bcf233ec8f47c4&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561982.jpg?k=b1f83dfd70011a8a28e59ffb4060b5aa941147af3b0f6d04cf407d388c67e933&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561985.jpg?k=18ddfd289d7c87da1176ef96f9cdbbe51b380a73867d112b108e31d6450c0a92&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561993.jpg?k=a6b61f70b18463cfb21cccba025627d5f7231eb77ed00ff27aa2874213a00111&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561989.jpg?k=b751145e6cdceb0f8605128fc0abe1c9349804b20595135b255f8cb622364d89&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561996.jpg?k=3f039f3239662c3cc7d9c9610bec4b2857ec86a9dec71d68552e9caf41676394&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561987.jpg?k=fa340f216d92ed99b953f5f457e7ff37cc4abf671166c935191fbb2b663069ae&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618561973.jpg?k=50800b9d176d1114bf2847f9d6f540e046f7241755bf4784f4f416674ab2cbda&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618562002.jpg?k=6a6e1657ddb451368139f9f638751c5656fc07418d78b542c0fa5d59840a55e7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618562007.jpg?k=e94c44202b80f700aa787b4ce3abb1ead8e2080f22ff5e99856d7f6f431f051d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618562000.jpg?k=676d2751f82994225c54c7ac1727a824d58ad857fd85c67688608ff91f5867b0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/618562013.jpg?k=fca4d4e3f63d5d11bc49a918448b2df6e933c3b21b4b71c19762f2ea31551ee2&o=}	2026-05-03 15:38:38.149711	2026-05-03 15:38:38.149711	576.00
226	37	Superior Room	Каждый номер оформлен индивидуально, украшен оригинальными произведениями современного искусства, а круглосуточное обслуживание дворецкого готово удовлетворить любую вашу просьбу.	2	1	king-size	121472.00	{Wi-Fi,Кондиционер,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/788857005.jpg?k=d501acae7d4d571e11d290f42e75a60dfdedcc9fbce0897d3af6f0d394b03030&o=,https://cf.bstatic.com/xdata/images/hotel/square60/803728138.jpg?k=a52bc5da129765d87a2f93d20ce2474d9c8b2bae6759bab9a7873a2ae489e0fa&o=}	2026-05-03 15:45:24.843594	2026-05-03 15:45:24.843594	30.00
227	37	Contemporary Deluxe Room	Просторный двухместный номер оборудован кондиционером, мини-баром, а также собственной ванной комнатой с ванной и душем. В двухместном номере есть шкаф для одежды, сейф, паркетный пол, кафельный пол, а также телевизор с плоским экраном и кабельными каналами. В номере 1 кровать.	2	1	king-size	137928.00	{Wi-Fi,Кондиционер,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/778745485.jpg?k=fff5badfac5a1261fe6b280e5e4eeb6eb74d52890196f390ddd5daef55957dc0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/778745480.jpg?k=822d0c4cb09001d7573f3268872cd094f58c96dd0b744d2db00c59c31202b162&o=,https://cf.bstatic.com/xdata/images/hotel/square60/778745472.jpg?k=d00e8a8beb5aed24eb0de983679bad439e31afd3c1a21162da91d8723177e73a&o=}	2026-05-03 15:46:34.000495	2026-05-03 15:46:34.000495	35.00
228	37	Contemporary Studio	В номере-студии предоставляются бесплатные туалетные принадлежности и халаты. В номере есть собственная ванная комната с ванной, душем и феном. В номере-студии имеется кондиционер, мини-бар, кофемашина, шкаф для одежды, а также телевизор с плоским экраном и кабельными каналами. В номере 1 кровать.	2	1	king-size	170513.00	{Wi-Fi,Кондиционер,"Собственная студия","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/778746342.jpg?k=780c650cd9be6b914550f39d4ac80f655da61f4408bb9d3615a85047dac2694f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/778746342.jpg?k=780c650cd9be6b914550f39d4ac80f655da61f4408bb9d3615a85047dac2694f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/787334550.jpg?k=83ed892f18b55cdfef8233ebab66c645a6acbf53a8622c986d8f04a1ee8ebcfe&o=}	2026-05-03 15:48:41.863916	2026-05-03 15:48:41.863916	40.00
229	37	The Lodges	Этот просторный люкс состоит из 1 спальни, гостиной зоны и 1 ванной комнаты с ванной и душем. В люксе есть кондиционер, мини-бар, телевизор с плоским экраном и кабельными каналами, а также вино/шампанское для гостей. В номере имеется 1 кровать.	2	1	king-size	234988.00	{Wi-Fi,Кондиционер,"Собственный люкс",Терраса,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/776461715.jpg?k=d07307bf966adeb21b35382df93eff0295926b32e77408a2422b16e76c7a0708&o=,https://cf.bstatic.com/xdata/images/hotel/square60/776461577.jpg?k=4c43ccac9ee96b83b93f521be1bd6c8f86709a36bda09932c08a70d9ea043cbc&o=,https://cf.bstatic.com/xdata/images/hotel/square60/738131616.jpg?k=837368aa769456cf140dc415c37bc03b7ab65bae7968b4cf55e8017ebf2c7c1a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/776461576.jpg?k=55a613708e9f80234e85d6c6a87c6993c76db7fabae0f427c89b2fc0fb2acf06&o=}	2026-05-03 15:50:28.863	2026-05-03 15:50:28.863	51.00
230	37	Carlos Suite	Этот просторный люкс включает в себя 1 гостиную, 1 отдельную спальню и 1 ванную комнату с ванной и бесплатными туалетными принадлежностями. В люксе есть кондиционер, мини-бар, телевизор с плоским экраном и кабельными каналами, а также вино/шампанское для гостей. В номере 1 кровать.	2	1	king-size	323767.00	{Wi-Fi,Кондиционер,"Собственный люкс","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/708086901.jpg?k=b01a7dfed42310ec96d149df94e7f371792ae2b4eca14d4575e1094feef5c488&o=,https://cf.bstatic.com/xdata/images/hotel/square60/708086921.jpg?k=f7eaba7551f5cc7c06bed5c979fbec9c16fab24fd5030f55f458f53c680770a0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/708086946.jpg?k=ea0d4e42b8ed1a15b82c2db57e0c63db11b73026ada8704cb9dcc4fc07b733c9&o=,https://cf.bstatic.com/xdata/images/hotel/square60/708086956.jpg?k=2ab9eb71bc3a062d03ed068e56177d7833ec3a2d65d73e98115b2bf799fcf122&o=}	2026-05-03 15:51:43.900065	2026-05-03 15:51:43.900065	56.00
231	37	Connaught Suite	Этот просторный люкс состоит из 1 гостиной, 1 отдельной спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе есть кондиционер, мини-бар, телевизор с плоским экраном и кабельными каналами, а также вино/шампанское для гостей. В номере 1 кровать.	2	1	king-size	433109.00	{Wi-Fi,Кондиционер,"Собственный люкс",Терраса,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/703618466.jpg?k=4796b0798cb20d61ed1fc5a82ea16240db330011f9f3c40724cf98e3843a5cf5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/703618871.jpg?k=a4c48b7ba20d5e757183cc782861c75a29d7c76bdf7305186e91bcd9e07b2fa5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/703619468.jpg?k=1bbc188e6d7b52629219bbf8ccea120303f623a837756c6284e76c70af7cab9c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/703619045.jpg?k=accd511c2f3a24ad96ef017bacb159a5c974caf5f8e129f79f46d2c361e6028f&o=}	2026-05-03 15:54:02.489638	2026-05-03 15:54:02.489638	72.00
246	40	King Room	Этот трехместный номер с кондиционером оборудован телевизором с плоским экраном и возможностью потокового вещания, а также собственной ванной комнатой. В номере 1 кровать.	3	1	king-size	27925.00	{Wi-Fi,Кондиционер,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/542036118.jpg?k=3b246ff49ca5e04548df299a4f2f2163fd53fc6a7dd04acdb27a18caf3536f3f&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/442270036.jpg?k=78a46c90b13ce33e67530dfdc7f9b809bdf8c7dbbf548b12665a8f829c3b5e26&o=}	2026-05-03 16:50:52.282871	2026-05-03 16:50:52.282871	19.00
232	37	Two Bedroom Grosvenor Suite	Этот просторный люкс состоит из 1 гостиной, 2 отдельных спален и 2 ванных комнат с душевой кабиной и бесплатными туалетными принадлежностями. В люксе с кондиционером есть телевизор с плоским экраном и кабельными каналами, мини-бар, кофемашина, зона отдыха, а также вид на внутренний двор. В номере 2 кровати.	4	2	king-size	506757.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид во внутренний дворик","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/606907778.jpg?k=a696034e9ea7301546c22e568c638bfd651735da48f29452c25949d1b1e95c01&o=,https://cf.bstatic.com/xdata/images/hotel/square60/664315881.jpg?k=e00ade71b1a8a5235a7d15fd16a4193b7a6a5b85d247ba3228795540bbad1a13&o=,https://cf.bstatic.com/xdata/images/hotel/square60/606907777.jpg?k=f17398ff4a0a5194193bfb6963c236eb240a6e767f1ed4a6f4b0e570c477003a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/606907773.jpg?k=93b5f0cfd6842e0e0eec655b8710d4ea40e53b8121c0a66c6345962b6f8bc49f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/606907772.jpg?k=afe44b964467a64376af563dccf7c8145bc44e838d3025d50308586b71879e6d&o=}	2026-05-03 15:56:12.433723	2026-05-03 15:56:12.433723	96.00
233	38	Premium Double Room with St. Mark view	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с ванной, биде и феном. Просторный двухместный номер с кондиционером оборудован телевизором с плоским экраном и кабельными каналами, мини-баром, принадлежностями для приготовления чая и кофе, зоной отдыха и видом на море. В номере 3 кровати.	2	1	king-size	249792.00	{Wi-Fi,Кондиционер,"Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/376263992.jpg?k=170f2ef2785c9478973c7a62780f31549a40042c259baf7ec1c5f89097537704&o=,https://cf.bstatic.com/xdata/images/hotel/square60/376263990.jpg?k=207bfd69f1a747bea73356b3c2d2170c087cf6c6a96f549d0ebdea80557e341b&o=}	2026-05-03 16:06:38.299698	2026-05-03 16:06:38.299698	40.00
235	38	Junior Suite Lagoon View with Balcony or Terrace	Этот полулюкс с балконом или террасой, откуда открывается потрясающий вид на Венецианскую лагуну, располагает удобной зоной отдыха и просторной мраморной ванной комнатой с бесплатными туалетными принадлежностями. К услугам гостей также бесплатный Wi-Fi, телевизор с плоским экраном HD, CD/DVD-плеер, док-станция для iPod и многофункциональный факс, принтер и копировальный аппарат.	2	1	king-size	334350.00	{Wi-Fi,Кондиционер,"Балкон или терраса","Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/278527874.jpg?k=f547056dd74a28ed1ad3b05a76321f89ab38bf6a0a56858d5175cd46d7bb4714&o=,https://cf.bstatic.com/xdata/images/hotel/square60/278527859.jpg?k=efb6cf2017faad7220b7ec7e77c4078bff73e17b42def8e8c275a27ea285ebd1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/335902316.jpg?k=0eb66d871c82c4fac96d9de71d544794b729bcac410f7ac3548b7e68c94dda60&o=}	2026-05-03 16:15:03.13413	2026-05-03 16:15:03.13413	33.00
236	38	Suite with St. Mark View	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе с кондиционером есть телевизор с плоским экраном и кабельными каналами, мини-бар, принадлежности для приготовления чая и кофе, зона отдыха, а также вид на море. В номере 2 кровати.	2	2	king-size	458712.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/400753193.jpg?k=4b0374cb8869bc75a225692124ce84f199258569ae82776064e81ebd8dac30bb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753192.jpg?k=bd8f4a8656a925a3330691b2c16723e5450231057a27d7e7ebff933537caab0e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753191.jpg?k=5f32a83e806175b85ad7beee3a7d1afcc8d75bcb47beaa5a46d6c75d2a767aab&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753188.jpg?k=25e30a7433479f2b0adbb370305dea2cf34c91e837ed61a5449420880cea8778&o=}	2026-05-03 16:16:56.743548	2026-05-03 16:16:56.743548	61.00
237	38	Suite with Balcony and Lagoon View (San Giorgio)	Этот просторный люкс состоит из 1 гостиной, 1 отдельной спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе с кондиционером есть телевизор с плоским экраном и кабельными каналами, мини-бар, чайник и кофеварка, зона отдыха, а также вид на море. В номере 3 кровати.	2	3	{"1 king-size","2 queen-size"}	600452.00	{Wi-Fi,Кондиционер,"Собственный люкс",Балкон,"Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/400753491.jpg?k=adf37e570fa63fac2400fe3270b6fd907ba3b125a989727671d928c77af877fa&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753490.jpg?k=2335995aaafcd8094c5c8d9b762dbbad737db8768ebd1be3674f17ed5ce87e40&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753486.jpg?k=85aa7bb794a632cf9a70147390ab9c30bddf7a99d1484154760555c64a15def0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400753494.jpg?k=9bbccf575c7f02a9fad52558d92e5bc8530a5693f8b19bde3f9d3f9405dfc24a&o=}	2026-05-03 16:19:20.836715	2026-05-03 16:19:20.836715	70.00
238	38	Signature Suite with Plunge Pool and Lagoon View (Palladio)	К услугам гостей этого люкса частный бассейн и гидромассажная ванна. Этот просторный люкс состоит из 1 гостиной, 1 отдельной спальни и 2 ванных комнат с ванной и бесплатными туалетными принадлежностями. В люксе с кондиционером есть телевизор с плоским экраном и кабельными каналами, мини-бар, чайник и кофеварка, зона отдыха, а также вид на море. В номере также имеется 1 кровать.	2	1	king-size	1154983.00	{Wi-Fi,Кондиционер,"Собственный люкс","Собственный бассейн",Балкон,"Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/400755317.jpg?k=663404cd43d4732bc600420a4945240c7d4e4f4b7a86fee57daa64430dc3c2f6&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400755337.jpg?k=43237330b810e789b4ad2ad580797790970558edb9b3385a0b4763eb576a99f1&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400755323.jpg?k=b86f61a282237df09787ce1fb0c9d17bbe53c54771788f66c2c4dad0e18c8bb3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/400755322.jpg?k=a9674b54c7e2b7de853a9387aa75b431574821210dfdc1c8bc2c3fdfad7d8200&o=}	2026-05-03 16:22:18.104589	2026-05-03 16:22:18.104589	108.00
239	38	Signature Suite with Terrace (Serenissima)	Просторный люкс состоит из 1 спальни и 1 ванной комнаты с ванной и бесплатными туалетными принадлежностями. В люксе с кондиционером есть телевизор с плоским экраном и кабельными каналами, мини-бар, принадлежности для приготовления чая и кофе, зона отдыха, а также вид на море. В номере также имеется 1 кровать.	2	1	king-size	1679905.00	{Wi-Fi,Кондиционер,"Собственный люкс",Терраса,Балкон,"Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/699509861.jpg?k=65c422cca45e1b47a4591737f469e46b33df74092f1c7139c49e15510682c979&o=,https://cf.bstatic.com/xdata/images/hotel/square60/699509857.jpg?k=23e9692be2afa7423f35d1697b97581f2de67070cf1bc0537d6510e6ffd1f87c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/699509854.jpg?k=2508839f4f9d1a1b21646d5674a0315df78e59ae34c32b73b9924c78e1cf5772&o=}	2026-05-03 16:28:19.215905	2026-05-03 16:28:19.215905	188.00
234	38	Junior Suite Poolside with Patio	Этот номер-полулюкс оборудован CD-проигрывателем и DVD-проигрывателем, элегантной зоной отдыха и собственной террасой. В ванной комнате есть душевая кабина и круглая ванна. Номер расположен рядом с бассейном и имеет прямой доступ к бассейну олимпийских размеров.	2	1	king-size	300760.00	{Wi-Fi,Кондиционер,"Собственный внутренний дворик","Вид на море","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/335902940.jpg?k=292727c554d18c20a4336a6fcc064181b32c1d472bd26b27d78e318964be32e7&o=,https://cf.bstatic.com/xdata/images/hotel/square60/335902942.jpg?k=0b4e57b62faba3f152b280f58d4aa76f15a19c9a88285f7fb73298e9714ff99c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/335902938.jpg?k=dc5a63008f152e7300cc0c21fc7b68bf36860f127eb08a28de9dc1a88cd3efd7&o=}	2026-05-03 16:12:15.233161	2026-05-03 16:12:15.233161	44.00
240	39	Twin Room with City View	Номера в отеле Park Hyatt Tokyo оформлены с использованием деревянных панелей Хоккайдо. Гостям предоставляется постельное белье из египетского хлопка. Гости могут провести время с напитком у мокрого бара, расслабиться в глубокой ванне или посмотреть фильм по запросу, укутавшись в мягкий халат. Гостям предоставляются тапочки, фен и бесплатные туалетно-косметические принадлежности. В числе удобств также гостиный уголок, письменный стол, бесплатный высокоскоростной проводной доступ в интернет, а также Wi-Fi.	2	2	queen-size	96898.00	{Wi-Fi,Кондиционер,"Вид на город","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/825832809.jpg?k=11b728f5b7dd30d34a42893b0cf1e7064508bf306ef68c2a793fa84215d9473d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/825832745.jpg?k=31d8dfa2888b9b4935264493f3bb72499009efffd6b87596d960946c69954338&o=,https://cf.bstatic.com/xdata/images/hotel/square60/825832732.jpg?k=dcce6d8b4157095cdf50fe35fba9d26180b16a9ff513bc031f32c0642c1a29d2&o=}	2026-05-03 16:37:31.646567	2026-05-03 16:37:31.646567	45.00
241	39	Deluxe King Room	Из окон открывается вид на район Синдзюку или гору Фудзияма. Этот просторный номер оформлен с использованием деревянных панелей с острова Хоккайдо. Гостям предоставляется постельное белье из египетского хлопка. В номере обустроена гардеробная. Гости могут расслабиться в глубокой ванне или посмотреть фильм по запросу, укутавшись в мягкий халат.	2	1	king-size	101685.00	{Wi-Fi,Кондиционер,"Вид на горы и город","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/822146748.jpg?k=a8be277b2737509510ccc68c564a57d50d0933f83fd653ece31c45ff41e41de3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/754105572.jpg?k=ac2620b36a4933c770180556d56c3a925842d7d18d8b8452e2e39bc2aded5f9e&o=,https://cf.bstatic.com/xdata/images/hotel/square60/754105940.jpg?k=e2ce54da12e7a7af38e172a88bb03cc7a2dd9f2a192231e97bb8ba0bdff6093a&o=}	2026-05-03 16:38:51.277091	2026-05-03 16:38:51.277091	55.00
242	39	Premier King Room	Номера в отеле Park Hyatt Tokyo оформлены с использованием деревянных панелей Хоккайдо. Гостям предоставляется постельное белье из египетского хлопка. Гости могут провести время с напитком у мокрого бара, расслабиться в глубокой ванне или посмотреть фильм по запросу, укутавшись в мягкий халат. Гостям предоставляются тапочки, фен и бесплатные туалетно-косметические принадлежности. В числе удобств также гостиный уголок, письменный стол, бесплатный высокоскоростной проводной доступ в интернет, а также Wi-Fi.	2	1	king-size	120883.00	{Wi-Fi,Кондиционер,"Вид на город","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/822146202.jpg?k=57814818b1aab7fed29d0c2734e8b5e971d649ab0de8c46666fcb57e04ca6ff3&o=,https://cf.bstatic.com/xdata/images/hotel/square60/822146277.jpg?k=9ab6ff46178e847992559f6d8ea08ac0d27b2f91a443539201974ce2555d0621&o=,https://cf.bstatic.com/xdata/images/hotel/square60/822146288.jpg?k=c8aaf535a9de1a44d69fde04062720e930514f3a86f9335966137af0d02cbb26&o=}	2026-05-03 16:40:02.776994	2026-05-03 16:40:02.776994	65.00
243	39	Premier Park Suite with Two Double Beds	В этом люксе, оборудованном бесплатными туалетными принадлежностями и халатами, есть собственная ванная комната с душевой кабиной, ванной и биде. Просторный люкс с кондиционером оснащен телевизором с плоским экраном и спутниковыми каналами, звукоизолирующими стенами, мини-баром, принадлежностями для приготовления чая и кофе, а также видом на город.	2	2	queen-size	242914.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид на город","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/825833433.jpg?k=49bc56bce443cc6641943f403e8f209561b6f3af4d1c582cabafbb9b11983f1f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/829301262.jpg?k=d500461da51f9d0409061442ec40a69867f0409445d2ca816442a829966e624a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/825833432.jpg?k=52cfa08c2bc62fb4521d3192fdfbe7c1b790713b4306e7d0c61833bd722eb260&o=}	2026-05-03 16:41:45.899229	2026-05-03 16:41:45.899229	100.00
244	39	Ambassador King Suite	В этом люксе, оборудованном бесплатными туалетными принадлежностями и халатами, есть собственная ванная комната с душевой кабиной, ванной и биде. Просторный люкс с кондиционером оснащен телевизором с плоским экраном и спутниковыми каналами, звукоизолированными стенами, мини-баром, принадлежностями для приготовления чая и кофе, а также видом на горы.	2	1	king-size	292225.00	{Wi-Fi,Кондиционер,"Собственный люкс","Вид на горы и город","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/825832872.jpg?k=76e1c5f9cd43cb82a18501987c0a9e221f05b40d6b5e64f8b8541b6084b10517&o=,https://cf.bstatic.com/xdata/images/hotel/square60/829300697.jpg?k=acd545744ac4e17bbf988aa4e25ee939f3f439efb3ac9321efb268e17531864d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/825832873.jpg?k=0c33343978a8887a8b63081dcedfaccd763ab27581a47ec7eb57648a944e0272&o=,https://cf.bstatic.com/xdata/images/hotel/square60/829385788.jpg?k=08c1946fbf0c5fb7cb5c92ff794fc24726b0b9b458bf6fcb2d62b38ec4ed657a&o=}	2026-05-03 16:43:50.770845	2026-05-03 16:43:50.770845	115.00
245	40	Queen Room	Этот трехместный номер с кондиционером оснащен телевизором с плоским экраном и возможностью потокового вещания, а также собственной ванной комнатой. В номере имеется 1 кровать.	3	1	queen-size	25925.00	{Wi-Fi,Кондиционер,"Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/542036110.jpg?k=d2971ef0119b06ab376e4093fd43946a561c5856f5fe1d164b0b9363ba66ac75&o=,https://cf.bstatic.com/xdata/images/hotel/max1024x768/442270036.jpg?k=78a46c90b13ce33e67530dfdc7f9b809bdf8c7dbbf548b12665a8f829c3b5e26&o=}	2026-05-03 16:47:24.23262	2026-05-03 16:47:24.23262	19.00
247	40	King Suite	В этом люксе, где предоставляются бесплатные туалетные принадлежности, есть собственная ванная комната с душевой кабиной и феном. Люкс с кондиционером оснащен телевизором с плоским экраном и потоковыми сервисами, мини-баром, зоной отдыха, сейфом, а также видом на город.	3	1	king-size	36425.00	{Wi-Fi,Кондиционер,"Вид на город","Собственный люкс","Письменный стол",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/630140721.jpg?k=4026792065940ba55dc079c6da3c65e834bc4f3aa37bd59c4f9d54e9287ae835&o=,https://cf.bstatic.com/xdata/images/hotel/square60/630140723.jpg?k=23ac8ed8b585c0cb7d8d97c0bfac8cbf7950373d81d11ac8464d8bfbd2800181&o=,https://cf.bstatic.com/xdata/images/hotel/square60/630140724.jpg?k=2ee93b7a19d692b0230f0046f4ec792d56df245dd8fa3b8b238bca3fb95c05e0&o=}	2026-05-03 16:54:05.995999	2026-05-03 16:54:05.995999	33.00
248	40	Room with One Set of Bunk Beds	Этот четырехместный номер с кондиционером оборудован телевизором с плоским экраном и возможностью потокового вещания, а также собственной ванной комнатой. В номере 4 кровати.	4	4	bunk-size	28175.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/439518259.jpg?k=f1603dc829308c5bb3bb147875080dd75a531a60ad92273fe5f05dfc17be1967&o=,https://cf.bstatic.com/xdata/images/hotel/square60/439518278.jpg?k=87795f0a41897448982fdfb3a000bb973c317824884afcb860203283d1f42b43&o=,https://cf.bstatic.com/xdata/images/hotel/square60/442270036.jpg?k=e0010190baefb0ab8069dbb8a1e9f2003acad538cc8856142472e312cc9a55fa&o=}	2026-05-03 16:57:34.450508	2026-05-03 16:57:34.450508	20.00
249	41	King Room	Двухместный номер с 1 кроватью и кондиционером. В числе удобств — собственная ванная комната и телевизор с плоским экраном, подключенный к кабельным каналам. В распоряжении гостей 1 кровать.	2	1	king-size	26742.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/852135462.jpg?k=6d3e9865d8d01da65e01e6ee1bcbc9e6cc722f2648e576c0c20855932f2a8226&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772469557.jpg?k=217c4d49c55c8cb4f6e49b6296e5db83119d05801ad6cc80a5e77e324282e66a&o=}	2026-05-03 17:00:07.798809	2026-05-03 17:00:07.798809	14.00
250	41	King Room - High Floor	Двухместный номер с 1 кроватью, кондиционером, телевизором с плоским экраном и кабельными каналами, а также собственной ванной комнатой. В распоряжении гостей 1 кровать.	2	1	king-size	26742.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/852135462.jpg?k=6d3e9865d8d01da65e01e6ee1bcbc9e6cc722f2648e576c0c20855932f2a8226&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772469557.jpg?k=217c4d49c55c8cb4f6e49b6296e5db83119d05801ad6cc80a5e77e324282e66a&o=}	2026-05-03 17:00:47.69875	2026-05-03 17:00:47.69875	14.00
251	41	King Room with Premium View	Двухместный номер с 1 кроватью, кондиционером, телевизором с плоским экраном и кабельными каналами, а также собственной ванной комнатой. В распоряжении гостей 1 кровать.	2	1	king-size	26742.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/772469550.jpg?k=881e4244225a1aeaaeae16a790a7a70d9e54ddf0ee1966f5199e5c60c132c6fa&o=,https://cf.bstatic.com/xdata/images/hotel/square60/772469557.jpg?k=217c4d49c55c8cb4f6e49b6296e5db83119d05801ad6cc80a5e77e324282e66a&o=}	2026-05-03 17:01:42.697033	2026-05-03 17:01:42.697033	14.00
252	42	The Level Room	Этот номер, расположенный между 14-м и 17-м этажами, оснащен телевизором с плоским экраном и спутниковыми каналами, мини-баром и кофемашиной. К услугам гостей бесплатный Wi-Fi. В собственной ванной комнате есть душ, фен и бесплатные туалетные принадлежности.	2	1	king-size	47041.00	{Wi-Fi,Кондиционер,"Вид на город или горы или достопримечательности",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/861141293.jpg?k=210c497117a49ada22d91a16c3fc11588207841574515c7ea32c7ed04a729c35&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860975622.jpg?k=d6fd3a46f8842a7f9af67a72eb27fdc5361269ccccfc5143597772259002a4a7&o=}	2026-05-03 17:05:19.884255	2026-05-03 17:05:19.884255	25.00
253	42	The Level Grand Premium Room City View	Из номера открывается вид на город. В номере есть 1 большая двуспальная кровать и 1 собственная ванная комната с душем, феном и бесплатными туалетными принадлежностями. Также имеется телевизор с плоским экраном и спутниковыми каналами, мини-бар и кофемашина. Предоставляется бесплатный Wi-Fi.	2	1	king-size	51983.00	{Wi-Fi,Кондиционер,"Вид на город или горы или достопримечательности",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/861141299.jpg?k=d460dbae64897e5c88644d7dc47cf3ed2b2f33bb5e1f8e2484c78219f8a87344&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860975622.jpg?k=d6fd3a46f8842a7f9af67a72eb27fdc5361269ccccfc5143597772259002a4a7&o=}	2026-05-03 17:06:25.335461	2026-05-03 17:06:25.335461	25.00
254	42	The Level Suite with Sea View	Из люкса открывается вид на море. В номере есть 1 большая двуспальная кровать и 1 собственная ванная комната с душем, феном и бесплатными туалетными принадлежностями. Также имеется телевизор с плоским экраном и спутниковыми каналами, мини-бар и кофемашина. Предоставляется бесплатный Wi-Fi.	2	1	king-size	67340.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Вид на море",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/861141347.jpg?k=6dd9efd41242902fad7f6ea98bf84d927f4a69b025b1e7a77c9a814f3fef1a55&o=,https://cf.bstatic.com/xdata/images/hotel/square60/861141342.jpg?k=6fd51cd90dcba2b9fb61418897f86785cfb6133b97f3c82c3792e368c8dd1e15&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860976534.jpg?k=b345f9724de6d974919c723c30340c956459f2d4a995241c8fa5980825bc26f7&o=}	2026-05-03 17:08:37.925461	2026-05-03 17:08:37.925461	70.00
255	42	The Level Master Suite with Sea View	Просторный люкс оборудован кондиционером, кофемашиной, отоплением, телевизором с плоским экраном и спутниковыми каналами, а также видом на море. В номере имеется 1 кровать.	2	1	king-size	94346.00	{Wi-Fi,"Собственный люкс",Кондиционер,"Вид на море",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/861141324.jpg?k=aeaa9257c82c1ea6abad81ac0195e4aa7200ed2e8130e2fe511147580c6d25bd&o=,https://cf.bstatic.com/xdata/images/hotel/square60/861141333.jpg?k=bee87f6efefcefdedfd4f429656dd5fd532357c9a9a5a7affd56f926d51c4615&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860976558.jpg?k=46e8e54efa2f25c2111b40965e7ef6473707191b0da06951133a1fe395bc43dd&o=}	2026-05-03 17:09:57.41971	2026-05-03 17:09:57.41971	80.00
256	42	The Level Family Room with City View	Этот семейный номер расположен на верхнем этаже отеля и состоит из двух номеров The Level Gran Premium City Views, соединенных внешней дверью. Из номера открывается панорамный вид на Барселону. В номере есть кофемашина, мини-бар и телевизор с плоским экраном. В собственной ванной комнате установлен тропический душ, а также предоставляются халат и тапочки The Level.	4	2	king-size	84108.00	{Wi-Fi,Кондиционер,"Вид на город","Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/861141299.jpg?k=d460dbae64897e5c88644d7dc47cf3ed2b2f33bb5e1f8e2484c78219f8a87344&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860976420.jpg?k=35cef358e385481c8afc03c610efd61ddb9d4849d83df62dce2cffe558dba579&o=}	2026-05-03 17:11:41.471501	2026-05-03 17:11:41.471501	50.00
257	42	The Level Family Room with Sea View	Этот семейный номер расположен на верхнем этаже отеля и состоит из двух номеров The Level Gran Premium Sea Views, соединенных внешней дверью. Из номера открывается вид на море. В номере есть кофеварка Nespresso, мини-бар и телевизор с плоским экраном. В собственной ванной комнате установлен тропический душ, а также предоставляются халат и тапочки The Level.	4	2	king-size	84991.00	{Wi-Fi,Кондиционер,"Вид на море","Завтрак и ужин",Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/860976202.jpg?k=d335b0478e2da61da9957f9a0b811c6d99a22752f380e25a448e540373f9b3b5&o=,https://cf.bstatic.com/xdata/images/hotel/square60/860976420.jpg?k=35cef358e385481c8afc03c610efd61ddb9d4849d83df62dce2cffe558dba579&o=}	2026-05-03 17:12:54.064026	2026-05-03 17:12:54.064026	60.00
258	43	Superior Double Room	В этом двухместном номере с двумя односпальными кроватями предоставляются бесплатные туалетные принадлежности, а также имеется собственная ванная комната с душевой кабиной, ванной и биде. В номере с двумя односпальными кроватями и кондиционером есть телевизор с плоским экраном и кабельными каналами, звукоизолированные стены, мини-бар, принадлежности для приготовления чая и кофе, а также вид на город.	2	1	king-size	21976.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/757306857.jpg?k=2030bd1916a57faa39050df2fdacaa0568247d06d8b940f8a63590c6b1063e72&o=,https://cf.bstatic.com/xdata/images/hotel/square60/751960939.jpg?k=065485b928f985a48dfc77c9cd0f52570d24496efab5d7672317c614d413c0de&o=}	2026-05-03 17:16:56.249076	2026-05-03 17:16:56.249076	25.00
259	43	Superior Double Room XL	В этом двухместном номере с двумя односпальными кроватями предоставляются бесплатные туалетные принадлежности, а также имеется собственная ванная комната с ванной, душем и биде. Просторный двухместный номер с кондиционером оснащен телевизором с плоским экраном и кабельными каналами, звукоизолированными стенами, мини-баром, принадлежностями для приготовления чая и кофе, а также видом на город.	2	1	king-size	26389.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/757306894.jpg?k=67d5c24b8573733d55866bd971c94c4af4553bb45503952ffde61d746e132666&o=,https://cf.bstatic.com/xdata/images/hotel/square60/751960939.jpg?k=065485b928f985a48dfc77c9cd0f52570d24496efab5d7672317c614d413c0de&o=}	2026-05-03 17:18:08.409332	2026-05-03 17:18:08.409332	32.00
260	43	Junior Suite	В этом трехместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с ванной, душем и биде. Просторный трехместный номер с кондиционером оборудован телевизором с плоским экраном и кабельными каналами, звукоизолированными стенами, мини-баром, принадлежностями для приготовления чая и кофе, а также видом на город.	2	1	king-size	30713.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/693690798.jpg?k=690a4f2cbaf712735eb0b6deb06a5e5cec8ac6f68c0a1a69bd6f0c4695e9b138&o=,https://cf.bstatic.com/xdata/images/hotel/square60/757306838.jpg?k=af5b61dd300abe444f6f828770dd6afb9e58858e7faeeb370b5e72c60cb7f71c&o=}	2026-05-03 17:19:36.979585	2026-05-03 17:19:36.979585	35.00
261	43	Superior Single Room	В этом одноместном номере предоставляются бесплатные туалетные принадлежности и имеется собственная ванная комната с душевой кабиной, ванной и биде. В номере с кондиционером есть телевизор с плоским экраном и кабельными каналами, звукоизолирующие стены, мини-бар, принадлежности для приготовления чая и кофе, а также вид на город. В номере 1 кровать.	1	1	queen-size	19681.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/693690826.jpg?k=e96bb56f3d7c9adc7d89c023b914ee5e085e45c899079a381f38670f3774fd98&o=,https://cf.bstatic.com/xdata/images/hotel/square60/757306838.jpg?k=af5b61dd300abe444f6f828770dd6afb9e58858e7faeeb370b5e72c60cb7f71c&o=}	2026-05-03 17:20:48.628153	2026-05-03 17:20:48.628153	21.00
262	44	Deluxe Double Room	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с душевой кабиной, ванной и биде. Просторный двухместный номер с кондиционером оборудован телевизором с плоским экраном и кабельными каналами, принадлежностями для приготовления чая и кофе, шкафом для одежды, сейфом, а также видом на город. В номере имеется 1 кровать.	2	1	king-size	9726.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/842876279.jpg?k=5eaa0596ac160a2b624114661761843b96685c6a0ecf200887dfee504817e099&o=,https://cf.bstatic.com/xdata/images/hotel/square60/462749893.jpg?k=908b0e83a1b93d270f2a1a8ddbd7655dab59a94be923b00aa31154d274958419&o=}	2026-05-03 17:25:03.713565	2026-05-03 17:25:03.713565	34.00
263	44	G Deluxe Room with Double Bed	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с душевой кабиной, ванной и биде. Просторный двухместный номер с кондиционером оборудован телевизором с плоским экраном и кабельными каналами, принадлежностями для приготовления чая и кофе, зоной отдыха, шкафом для одежды, а также видом на город. В номере имеется 1 кровать.	2	1	king-size	10189.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/807521247.jpg?k=ac2ca7711d906a1a61ebbaaa06a8e7ea0fb13993255d22fdeca71230449b1335&o=,https://cf.bstatic.com/xdata/images/hotel/square60/776684543.jpg?k=3a4f48caf64a23af0dfc6f4b1516e55b93b3b2b88a4ccc46a3fc8fd8400f27e1&o=}	2026-05-03 17:26:34.013437	2026-05-03 17:26:34.013437	34.00
264	44	Executive Room with Lounge Access and Double Bed	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также собственная ванная комната с душевой кабиной, ванной и биде. Просторный двухместный номер с кондиционером оборудован телевизором с плоским экраном и кабельными каналами, принадлежностями для приготовления чая и кофе, доступом в представительский лаундж, зоной отдыха и видом на город. В номере имеется 1 кровать.	2	1	king-size	15863.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/842876283.jpg?k=63065acc471ab50d2e5d60f1a2dd2eeea038b9da109d3c0d46d74da383ed77f9&o=,https://cf.bstatic.com/xdata/images/hotel/square60/776684543.jpg?k=3a4f48caf64a23af0dfc6f4b1516e55b93b3b2b88a4ccc46a3fc8fd8400f27e1&o=}	2026-05-03 17:27:57.019364	2026-05-03 17:27:57.019364	34.00
265	45	King Room	Современный номер с роскошным постельным бельем, 42-дюймовым плоским HD-телевизором с широким выбором каналов на разных языках. В собственной ванной комнате есть ванна или душ и бесплатные туалетные принадлежности.	2	1	king-size	39627.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/733692855.jpg?k=45d8475855c810178899b95167872015f0ddcef66d265bc45180006c9e033019&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692867.jpg?k=959289ee1dbd139ebe051735fdcde83995e47297c63582a59aa585d84f676f36&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692875.jpg?k=432ef7faa2203a609850ecfaf62ba79bafeb449fd3f83f7182cbd04bc3c4a6b4&o=}	2026-05-03 17:31:10.922448	2026-05-03 17:31:10.922448	23.00
266	45	REN Room	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с душем, феном и тапочками. В двухместном номере паркетный пол, зона отдыха с телевизором с плоским экраном и кабельными каналами, кондиционер, принадлежности для приготовления чая и кофе, а также шкаф для одежды. В номере 1 кровать.	2	1	king-size	40510.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/794340057.jpg?k=5bef42f02f33b8d72e2d9e358b5bde869faa9ced9401ffbd4c727fca68ccc755&o=,https://cf.bstatic.com/xdata/images/hotel/square60/794340052.jpg?k=b803dd32bd2766840eaaad2bffa2a5c20322cf0faf65c39f7aca9a85f151e640&o=,https://cf.bstatic.com/xdata/images/hotel/square60/794340063.jpg?k=a6b71be4f041569a8a12333c018a18105e71d4ecf30b9c3cde02756c48f09b25&o=}	2026-05-03 17:33:08.629882	2026-05-03 17:33:08.629882	23.00
267	45	Deluxe King Room with City View	В этом двухместном номере предоставляются бесплатные туалетные принадлежности и халаты, а также имеется собственная ванная комната с душем, феном и тапочками. В двухместном номере с кондиционером есть телевизор с плоским экраном и кабельными каналами, принадлежности для приготовления чая и кофе, зона отдыха, шкаф для одежды, а также вид на город. В номере 1 кровать.	2	1	king-size	41833.00	{Wi-Fi,Кондиционер,"Вид на город",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/733692865.jpg?k=dae376acd7af40379d84deca438ec950d36b2f7ba40119f3edb0d3ba84d59b87&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692868.jpg?k=251494437fc727063787218928f048c702058f46861b21e14e8497775be0197d&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692875.jpg?k=432ef7faa2203a609850ecfaf62ba79bafeb449fd3f83f7182cbd04bc3c4a6b4&o=}	2026-05-03 17:34:50.441426	2026-05-03 17:34:50.441426	25.00
268	45	Larger Family Suite with Two Double Beds	Этот семейный номер, оформленный в современном стиле, располагает двумя двуспальными кроватями. В номере есть кондиционер, зона отдыха и телевизор с плоским экраном и кабельными каналами. В собственной ванной комнате имеется ванна или душ и бесплатные туалетные принадлежности.	4	2	queen-size	66104.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон,Кофемашина}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/611389134.jpg?k=966a0b83020c458bf655da199aeb0b5632dcd546faa5cae2609164cc167ecc6c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692830.jpg?k=990ce8ab1e0927eb4312706780505ed20781c78594d9a78ba083d471532a6840&o=,https://cf.bstatic.com/xdata/images/hotel/square60/733692846.jpg?k=95b50ea7829be60499477409c041ebb863e239ca830ee855ac4d70428920e6c3&o=}	2026-05-03 17:36:35.474674	2026-05-03 17:36:35.474674	45.00
269	46	Economy Double Room	В этом двухместном номере есть кондиционер и собственная ванная комната.	2	1	queen-size	31876.00	{Wi-Fi,Кондиционер,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/661793079.jpg?k=71586b173b2f80f6853a706af07d398b6a7dfe977c53dd37a1e1561e13e7cc11&o=,https://cf.bstatic.com/xdata/images/hotel/square60/661793066.jpg?k=9543860a048e6c5eb5388e19047ae3a6df7714e54baac10076dd9244c9686b62&o=}	2026-05-03 17:39:08.8249	2026-05-03 17:39:08.8249	7.00
270	46	Standard Double Room	В этом двухместном номере есть кондиционер и собственная ванная комната.	2	1	queen-size	32284.00	{Wi-Fi,Кондиционер,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{"https://cf.bstatic.com/xdata/images/hotel/square60/661794311.jpg?k=9957402e3b744c05047b2dbbaf00d629257b2bbf6c567080c85e60068186c308&o=",https://cf.bstatic.com/xdata/images/hotel/square60/661794311.jpg?k=9957402e3b744c05047b2dbbaf00d629257b2bbf6c567080c85e60068186c308&o=}	2026-05-03 17:40:36.842613	2026-05-03 17:40:36.842613	9.00
271	46	Family Room	В этом семейном номере есть кондиционер и собственная ванная комната.	4	2	queen-size	32284.00	{Wi-Fi,Кондиционер,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/661792540.jpg?k=425674d9c7c69bf80ebf2faf94a65212fdf4162d73431ecc759299beb4b0126f&o=,https://cf.bstatic.com/xdata/images/hotel/square60/661792237.jpg?k=11460a4c044cf17fcdfb02d4ecbf8e39b49590511a37cda3191437b0c1cb72fd&o=,https://cf.bstatic.com/xdata/images/hotel/square60/661792516.jpg?k=979fa224ada648111b928ac5f077d36c6f6f8e0f97d64d298e220129eae73562&o=}	2026-05-03 17:42:55.108317	2026-05-03 17:42:55.108317	9.00
272	47	Superior Double Room	Двухместный номер оборудован кондиционером, сейфом, а также собственной ванной комнатой с ванной или душем и феном. В номере имеется 1 кровать.	2	1	king-size	18070.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/785165226.jpg?k=741fbfdea287d917aa325c099ff5d50d0cca0b821cf935b58696ca849ba643be&o=,https://cf.bstatic.com/xdata/images/hotel/square60/785165202.jpg?k=694b8455aaa6a5f207607143c8627f36e8d88d4ef7d22fa899f4aae665608ab8&o=}	2026-05-03 17:44:50.194257	2026-05-03 17:44:50.194257	22.00
273	47	Junior Suite	В номере люкс есть кондиционер, сейф, а также собственная ванная комната с ванной или душем и феном. В номера на верхних этажах можно подняться на лифте. В номере имеется 1 кровать.	2	1	king-size	18070.00	{Wi-Fi,Кондиционер,"Собственный люкс",Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/785165149.jpg?k=168f611331164c7f70266eefdb61906ba5a35498c78de3366271c2efeb6e65a0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/785165193.jpg?k=83bdfb326a32b839d03a3149e4d55eff415d41cda096611954d664ebd694a820&o=,https://cf.bstatic.com/xdata/images/hotel/square60/785165216.jpg?k=ac765ab83b2773dcf6ccfeca3400cc44e72418d481cd50f44d5a08d9559fb677&o=}	2026-05-03 17:45:55.815147	2026-05-03 17:45:55.815147	22.00
274	48	Standard Double Room	Двухместный номер оборудован кондиционером, ковровым покрытием пола и собственной ванной комнатой с ванной или душем. В номере имеется 1 кровать.	2	1	king-size	11420.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/776023321.jpg?k=74f4a1f353763a733e3361e93e896ae97224abefeba3fe5ccd6c7bc395719dd0&o=,https://cf.bstatic.com/xdata/images/hotel/square60/329384632.jpg?k=128b77373ae8cd89b4bf9438a12940cd3d93521942138dac5f714f7f7c7239ad&o=}	2026-05-03 17:47:26.637049	2026-05-03 17:47:26.637049	13.00
275	48	Family Room with One Double Bed and Two Bunk Beds	В четырехместном номере есть кондиционер, ковровое покрытие пола, а также собственная ванная комната с ванной или душем. В номере 2 кровати.	4	2	{"1 queen-size","1 bunk-size"}	15474.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811635806.jpg?k=6d8396a46b4e5c2d9b29c65bac5836609396caf97137a04b34c8dd635390e610&o=,https://cf.bstatic.com/xdata/images/hotel/square60/329384632.jpg?k=128b77373ae8cd89b4bf9438a12940cd3d93521942138dac5f714f7f7c7239ad&o=}	2026-05-03 17:49:41.93832	2026-05-03 17:49:41.93832	25.00
276	48	Standard Twin Room	Двухместный номер оборудован кондиционером, ковровым покрытием пола и собственной ванной комнатой с ванной или душем. В номере 2 кровати.	2	2	single-size	14721.00	{Wi-Fi,Кондиционер,Завтрак,Шкаф,Сейф,Телевизор,Фен,Телефон}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/811635804.jpg?k=c3f74685a851b40da241aa8dd047da9608a6eec8d9d44cd873c680e126b0279c&o=,https://cf.bstatic.com/xdata/images/hotel/square60/329384632.jpg?k=128b77373ae8cd89b4bf9438a12940cd3d93521942138dac5f714f7f7c7239ad&o=}	2026-05-03 17:51:58.001452	2026-05-03 17:51:58.001452	13.00
277	49	Double Room with Bathroom	В номере есть собственная ванная комната с душем.	2	1	double-size	21035.00	{Wi-Fi,Завтрак,Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/547612267.jpg?k=410278a96c32605f6bec4a55bdac13ffcb3c64b28deec04e9e8a72509aed5121&o=,https://cf.bstatic.com/xdata/images/hotel/square60/547612163.jpg?k=5a629ec870e6d7a365725b3bec3e566928791a36f6f663e02a0e0fd50bd9245f&o=}	2026-05-03 17:54:32.988672	2026-05-03 17:54:32.988672	19.00
278	49	Twin Room with Private Bathroom	В двухместном номере есть шкаф для одежды, сейф, а также собственная ванная комната с душем. В номера на верхних этажах можно подняться на лифте. В номере 2 кровати.	2	2	single-size	27708.00	{Wi-Fi,Завтрак,Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/547612287.jpg?k=a9efff07474c9a2e1c78bfa48ed3811cc36092a142af7f19ac6ce52a8af8c746&o=,https://cf.bstatic.com/xdata/images/hotel/square60/547612163.jpg?k=5a629ec870e6d7a365725b3bec3e566928791a36f6f663e02a0e0fd50bd9245f&o=}	2026-05-03 17:55:46.01166	2026-05-03 17:55:46.01166	20.00
279	49	4-Bed Mixed Dormitory Room	В общей комнате есть паркетный пол, отопление, а также собственная ванная комната с душем. До комнат на верхних этажах можно добраться на лифте. В номере 4 спальных места.	4	4	bunk-size	31993.00	{Wi-Fi,Завтрак,Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/547612030.jpg?k=df442262d4f0c64697f5538cae3969f766bdb040f7f9cf6eba2c677bc44a3edb&o=,https://cf.bstatic.com/xdata/images/hotel/square60/547612009.jpg?k=108c97ca5418589369ee4d8c89e4059829bcae026403f27307c36264cdf93ad1&o=}	2026-05-03 17:57:07.774611	2026-05-03 17:57:07.774611	24.00
280	49	6-Bed Mixed Dormitory Room	В общей комнате есть паркетный пол, отопление, а также собственная ванная комната с душем. До комнат на верхних этажах можно добраться на лифте. В номере 6 спальных места.	6	6	bunk-size	27517.00	{Wi-Fi,Завтрак,Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/547612049.jpg?k=0ec2e307f0d17c870d202eba6f3ad05681573e2ef13f23fd6c2e977858e11bbe&o=,https://cf.bstatic.com/xdata/images/hotel/square60/547612009.jpg?k=108c97ca5418589369ee4d8c89e4059829bcae026403f27307c36264cdf93ad1&o=}	2026-05-03 17:57:56.984055	2026-05-03 17:57:56.984055	26.00
281	49	8-Bed Mixed Dormitory Room	В общей комнате есть паркетный пол, отопление, а также собственная ванная комната с душем. До комнат на верхних этажах можно добраться на лифте. В номере 8 спальных места.	8	8	bunk-size	37441.00	{Wi-Fi,Завтрак,Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/547611924.jpg?k=c7e58ac710d3c6ffb74bb466ae1e7df94e892c15ea5237ab1fefbfd4525ed386&o=,https://cf.bstatic.com/xdata/images/hotel/square60/547612009.jpg?k=108c97ca5418589369ee4d8c89e4059829bcae026403f27307c36264cdf93ad1&o=}	2026-05-03 17:58:49.84846	2026-05-03 17:58:49.84846	30.00
282	50	Double Room	В этом двухместном номере предоставляются бесплатные туалетные принадлежности, а также имеется собственная ванная комната с душевой кабиной и феном. Двухместный номер оборудован звукоизолирующими стенами, зоной отдыха, шкафом для одежды, телевизором с плоским экраном и кабельными каналами, а также видом на внутренний двор. В номере 2 кровати.	2	2	single-size	11297.00	{Wi-Fi,"Вид на внутренний дворик",Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/623671076.jpg?k=7351848cbb5b1889df2e6a2bcd0e6ce178147352fbc63f2bc4a2019c2118d29a&o=,https://cf.bstatic.com/xdata/images/hotel/square60/623670619.jpg?k=d1cbe3001ced3172fb2276bcd580a1c3346a0b3342e485d39a51b26a1cefbc1e&o=}	2026-05-03 18:01:31.154419	2026-05-03 18:01:31.154419	16.00
283	50	Single Room	В этом одноместном номере предоставляются бесплатные туалетные принадлежности, а также имеется собственная ванная комната с душевой кабиной и феном. В номере также есть телевизор с плоским экраном и кабельными каналами, звукоизолированные стены, зона отдыха, шкаф для одежды, а также вид на внутренний двор. В номере 1 кровать.	1	1	single-size	9620.00	{Wi-Fi,"Вид на внутренний дворик",Шкаф,Сейф,Фен}	t	{https://cf.bstatic.com/xdata/images/hotel/square60/623672094.jpg?k=0e1aa0710dd92eaaacfe470f52beba5c009a7b782de7b78e9a7b8c20156541fa&o=,https://cf.bstatic.com/xdata/images/hotel/square60/623670619.jpg?k=d1cbe3001ced3172fb2276bcd580a1c3346a0b3342e485d39a51b26a1cefbc1e&o=}	2026-05-03 18:03:00.663632	2026-05-03 18:03:00.663632	8.00
\.


--
-- Name: amenities_amenitie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.amenities_amenitie_id_seq', 26, true);


--
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 1, false);


--
-- Name: guests_guest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.guests_guest_id_seq', 21, true);


--
-- Name: hotels_hotel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hotels_hotel_id_seq', 50, true);


--
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 1, false);


--
-- Name: rooms_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rooms_room_id_seq', 283, true);


--
-- Name: amenities amenities_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_name_key UNIQUE (name);


--
-- Name: amenities amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_pkey PRIMARY KEY (amenitie_id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- Name: guests guests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_pkey PRIMARY KEY (guest_id);


--
-- Name: hotels hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (hotel_id);


--
-- Name: bookings no_double_booking; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT no_double_booking EXCLUDE USING gist (room_id WITH =, stay WITH &&);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_id);


--
-- Name: idx_amenities_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_amenities_name ON public.amenities USING btree (name);


--
-- Name: idx_bookings_check_in_out; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_check_in_out ON public.bookings USING btree (check_in_date, check_out_date);


--
-- Name: idx_bookings_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_dates ON public.bookings USING btree (check_in_date, check_out_date);


--
-- Name: idx_bookings_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_hotel_id ON public.bookings USING btree (hotel_id);


--
-- Name: idx_bookings_room_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_room_id ON public.bookings USING btree (room_id);


--
-- Name: idx_bookings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_status ON public.bookings USING btree (status);


--
-- Name: idx_bookings_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_user_id ON public.bookings USING btree (user_id);


--
-- Name: idx_guests_country; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_guests_country ON public.guests USING btree (country);


--
-- Name: idx_guests_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_guests_email ON public.guests USING btree (email);


--
-- Name: idx_hotel_amenities_amenity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotel_amenities_amenity_id ON public.hotel_amenities USING btree (amenity_id);


--
-- Name: idx_hotel_amenities_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotel_amenities_hotel_id ON public.hotel_amenities USING btree (hotel_id);


--
-- Name: idx_hotel_amenities_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_hotel_amenities_unique ON public.hotel_amenities USING btree (hotel_id, amenity_id);


--
-- Name: idx_hotels_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_city ON public.hotels USING btree (city);


--
-- Name: idx_hotels_country; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_country ON public.hotels USING btree (country);


--
-- Name: idx_hotels_star_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_hotels_star_rating ON public.hotels USING btree (star_rating);


--
-- Name: idx_reviews_booking_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_booking_id ON public.reviews USING btree (booking_id);


--
-- Name: idx_reviews_guest_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_guest_id ON public.reviews USING btree (guest_id);


--
-- Name: idx_reviews_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_hotel_id ON public.reviews USING btree (hotel_id);


--
-- Name: idx_reviews_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_rating ON public.reviews USING btree (rating);


--
-- Name: idx_rooms_available; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_available ON public.rooms USING btree (is_available);


--
-- Name: idx_rooms_hotel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_hotel_id ON public.rooms USING btree (hotel_id);


--
-- Name: idx_rooms_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_price ON public.rooms USING btree (price_per_night);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.guests USING btree (email);


--
-- Name: bookings set_bookings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: hotels set_hotels_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_hotels_updated_at BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: rooms set_rooms_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_rooms_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: bookings trg_bookings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: hotels trg_hotels_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_hotels_updated_at BEFORE UPDATE ON public.hotels FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: rooms trg_rooms_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_rooms_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: bookings bookings_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE SET NULL;


--
-- Name: bookings bookings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.guests(guest_id) ON DELETE SET NULL;


--
-- Name: bookings fk_bookings_guest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_bookings_guest FOREIGN KEY (user_id) REFERENCES public.guests(guest_id) ON DELETE CASCADE;


--
-- Name: bookings fk_bookings_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_bookings_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: bookings fk_bookings_room; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_bookings_room FOREIGN KEY (room_id) REFERENCES public.rooms(room_id) ON DELETE CASCADE;


--
-- Name: hotel_amenities fk_hotel_amenities_amenity; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_amenities
    ADD CONSTRAINT fk_hotel_amenities_amenity FOREIGN KEY (amenity_id) REFERENCES public.amenities(amenitie_id) ON DELETE CASCADE;


--
-- Name: hotel_amenities fk_hotel_amenities_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hotel_amenities
    ADD CONSTRAINT fk_hotel_amenities_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: reviews fk_reviews_booking; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_booking FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE SET NULL;


--
-- Name: reviews fk_reviews_guest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_guest FOREIGN KEY (guest_id) REFERENCES public.guests(guest_id) ON DELETE CASCADE;


--
-- Name: reviews fk_reviews_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: rooms fk_rooms_hotel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_rooms_hotel FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE SET NULL;


--
-- Name: reviews reviews_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES public.guests(guest_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE CASCADE;


--
-- Name: rooms rooms_hotel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_hotel_id_fkey FOREIGN KEY (hotel_id) REFERENCES public.hotels(hotel_id) ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO backend_dev;
GRANT USAGE ON SCHEMA public TO frontend_user;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO backend_dev;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO frontend_user;


--
-- Name: TABLE amenities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.amenities TO backend_dev;
GRANT ALL ON TABLE public.amenities TO frontend_user;


--
-- Name: SEQUENCE amenities_amenitie_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.amenities_amenitie_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.amenities_amenitie_id_seq TO frontend_user;


--
-- Name: TABLE bookings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bookings TO backend_dev;
GRANT ALL ON TABLE public.bookings TO frontend_user;


--
-- Name: SEQUENCE bookings_booking_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.bookings_booking_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.bookings_booking_id_seq TO frontend_user;


--
-- Name: TABLE guests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.guests TO backend_dev;
GRANT ALL ON TABLE public.guests TO frontend_user;


--
-- Name: SEQUENCE guests_guest_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.guests_guest_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.guests_guest_id_seq TO frontend_user;


--
-- Name: TABLE hotel_amenities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.hotel_amenities TO backend_dev;
GRANT ALL ON TABLE public.hotel_amenities TO frontend_user;


--
-- Name: TABLE hotels; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.hotels TO backend_dev;
GRANT ALL ON TABLE public.hotels TO frontend_user;


--
-- Name: SEQUENCE hotels_hotel_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.hotels_hotel_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.hotels_hotel_id_seq TO frontend_user;


--
-- Name: TABLE reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reviews TO backend_dev;
GRANT ALL ON TABLE public.reviews TO frontend_user;


--
-- Name: SEQUENCE reviews_review_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.reviews_review_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.reviews_review_id_seq TO frontend_user;


--
-- Name: TABLE rooms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rooms TO backend_dev;
GRANT ALL ON TABLE public.rooms TO frontend_user;


--
-- Name: SEQUENCE rooms_room_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.rooms_room_id_seq TO backend_dev;
GRANT ALL ON SEQUENCE public.rooms_room_id_seq TO frontend_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO frontend_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO backend_dev;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO frontend_user;


--
-- PostgreSQL database dump complete
--

\unrestrict gInqAWX7VHlsqh6feb6Ap0b6dlWFVmNsMqJB020FvTa7IdYPeGUWycADSp0FYRj

