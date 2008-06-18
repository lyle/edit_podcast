--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET search_path = public, pg_catalog;

--
-- TOC entry 5 (OID 17313)
-- Name: users; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE users (
    id serial NOT NULL,
    login character varying(80),
    "password" character varying,
    display_name character varying(64),
    email character varying(128)
);


--
-- TOC entry 6 (OID 17321)
-- Name: articles; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE articles (
    id serial NOT NULL,
    user_id integer NOT NULL,
    category character varying(128) NOT NULL,
    title character varying(64) NOT NULL,
    subtitle character varying(64),
    abstract character varying(1024) NOT NULL,
    publishdate timestamp without time zone,
    content text,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    lock_version integer DEFAULT 0,
    publishid integer,
    teaser_id integer,
    status character varying(64) DEFAULT 'new'::character varying
) WITHOUT OIDS;


--
-- TOC entry 8 (OID 17330)
-- Name: images; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE images (
    id serial NOT NULL,
    name character varying(64),
    mimetype character varying(64),
    height integer,
    width integer,
    data bytea,
    user_id integer,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- TOC entry 10 (OID 17336)
-- Name: articles_images; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE articles_images (
    article_id integer,
    image_id integer,
    user_id integer,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- TOC entry 12 (OID 17340)
-- Name: questions; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE questions (
    id serial NOT NULL,
    title character varying(64) NOT NULL,
    content text NOT NULL,
    person_name character varying(64) NOT NULL,
    "location" character varying(64) NOT NULL,
    user_id integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_on timestamp without time zone NOT NULL,
    person_email character varying(254),
    status character varying(64) DEFAULT 'new'::character varying
);


--
-- TOC entry 14 (OID 17348)
-- Name: answers; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE answers (
    id serial NOT NULL,
    question_id integer NOT NULL,
    content text NOT NULL,
    user_id integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_on timestamp without time zone NOT NULL
);


--
-- TOC entry 16 (OID 17356)
-- Name: shows; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE shows (
    id serial NOT NULL,
    title character varying(64) NOT NULL,
    category character varying(254),
    promo text,
    abstract text NOT NULL,
    content text,
    user_id integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    updated_on timestamp without time zone NOT NULL,
    status character varying(64) DEFAULT 'new'::character varying,
    showtime timestamp without time zone,
    teaser_id integer,
    planning_notes text
);


--
-- TOC entry 20 (OID 17365)
-- Name: groups; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE groups (
    id serial NOT NULL,
    name character varying(64) NOT NULL,
    description text,
    created_on timestamp without time zone,
    created_by integer
);


--
-- TOC entry 22 (OID 17371)
-- Name: groups_users; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE groups_users (
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    created_on date
);


--
-- TOC entry 24 (OID 41972)
-- Name: questions_shows; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE questions_shows (
    question_id integer,
    show_id integer
);


--
-- TOC entry 26 (OID 41976)
-- Name: images_shows; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE images_shows (
    image_id integer NOT NULL,
    show_id integer NOT NULL
);


--
-- TOC entry 27 (OID 99661)
-- Name: schema_info; Type: TABLE; Schema: public; Owner: troxell
--

CREATE TABLE schema_info (
    "version" integer
);


--
-- TOC entry 3 (OID 2200)
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


--
-- TOC entry 7 (OID 17321)
-- Name: TABLE articles; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE articles IS 'Holds the articles, of course.';


--
-- TOC entry 9 (OID 17330)
-- Name: TABLE images; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE images IS 'holds all of are images';


--
-- TOC entry 11 (OID 17336)
-- Name: TABLE articles_images; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE articles_images IS 'maps articles with images';


--
-- TOC entry 13 (OID 17340)
-- Name: TABLE questions; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE questions IS 'questions people ask';


--
-- TOC entry 15 (OID 17348)
-- Name: TABLE answers; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE answers IS 'answers to questions';


--
-- TOC entry 17 (OID 17356)
-- Name: TABLE shows; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE shows IS 'our shows';


--
-- TOC entry 18 (OID 17356)
-- Name: COLUMN shows.category; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON COLUMN shows.category IS 'a loose category with / as separators';


--
-- TOC entry 19 (OID 17356)
-- Name: COLUMN shows.planning_notes; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON COLUMN shows.planning_notes IS 'To help plan the show... contac info, esp - non-public';


--
-- TOC entry 21 (OID 17365)
-- Name: TABLE groups; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE groups IS 'lists the user groups';


--
-- TOC entry 23 (OID 17371)
-- Name: TABLE groups_users; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE groups_users IS 'Holds mappings of users to groups';


--
-- TOC entry 25 (OID 41972)
-- Name: TABLE questions_shows; Type: COMMENT; Schema: public; Owner: troxell
--

COMMENT ON TABLE questions_shows IS 'mapps shows and questions';


INSERT INTO schema_info (version) VALUES (1)