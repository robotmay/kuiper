--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: browsers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE browsers (
    id integer NOT NULL,
    name character varying(255),
    parent_id integer,
    lft integer,
    rgt integer,
    depth integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: browsers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE browsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: browsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE browsers_id_seq OWNED BY browsers.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    site_id integer,
    path character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: platforms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE platforms (
    id integer NOT NULL,
    name character varying(255),
    parent_id integer,
    lft integer,
    rgt integer,
    depth integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: platforms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE platforms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: platforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE platforms_id_seq OWNED BY platforms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    user_id integer,
    api_key character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    allowed_hosts character varying(255)[]
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id integer NOT NULL,
    site_id integer,
    "timestamp" timestamp without time zone,
    ip_address inet,
    visitor_id uuid,
    previous_visit timestamp without time zone,
    previous_page character varying(255),
    user_agent character varying(255),
    platform character varying(255),
    cookies_enabled boolean,
    java_enabled boolean,
    plugins text,
    screen_height integer,
    screen_width integer,
    screen_colour_depth integer,
    screen_available_height integer,
    screen_available_width integer,
    url character varying(255),
    referrer character varying(255),
    title character varying(255),
    last_modified timestamp without time zone,
    created_at timestamp without time zone,
    browser_id integer,
    platform_id integer,
    page_id integer
);


--
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE visits_id_seq OWNED BY visits.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY browsers ALTER COLUMN id SET DEFAULT nextval('browsers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY platforms ALTER COLUMN id SET DEFAULT nextval('platforms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY visits ALTER COLUMN id SET DEFAULT nextval('visits_id_seq'::regclass);


--
-- Name: browsers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY browsers
    ADD CONSTRAINT browsers_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY platforms
    ADD CONSTRAINT platforms_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: index_browsers_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_browsers_on_name ON browsers USING btree (name);


--
-- Name: index_browsers_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_browsers_on_parent_id ON browsers USING btree (parent_id);


--
-- Name: index_pages_on_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_path ON pages USING btree (path);


--
-- Name: index_pages_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_site_id ON pages USING btree (site_id);


--
-- Name: index_platforms_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_platforms_on_name ON platforms USING btree (name);


--
-- Name: index_platforms_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_platforms_on_parent_id ON platforms USING btree (parent_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_visits_on_browser_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_browser_id ON visits USING btree (browser_id);


--
-- Name: index_visits_on_cookies_enabled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_cookies_enabled ON visits USING btree (cookies_enabled);


--
-- Name: index_visits_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_created_at ON visits USING btree (created_at);


--
-- Name: index_visits_on_java_enabled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_java_enabled ON visits USING btree (java_enabled);


--
-- Name: index_visits_on_last_modified; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_last_modified ON visits USING btree (last_modified);


--
-- Name: index_visits_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_page_id ON visits USING btree (page_id);


--
-- Name: index_visits_on_platform_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_platform_id ON visits USING btree (platform_id);


--
-- Name: index_visits_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_site_id ON visits USING btree (site_id);


--
-- Name: index_visits_on_timestamp; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_timestamp ON visits USING btree ("timestamp");


--
-- Name: index_visits_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_url ON visits USING btree (url);


--
-- Name: index_visits_on_visitor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_visitor_id ON visits USING btree (visitor_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20121210184716');

INSERT INTO schema_migrations (version) VALUES ('20121210185033');

INSERT INTO schema_migrations (version) VALUES ('20121211001002');

INSERT INTO schema_migrations (version) VALUES ('20121211001810');

INSERT INTO schema_migrations (version) VALUES ('20121212092529');

INSERT INTO schema_migrations (version) VALUES ('20121212200050');

INSERT INTO schema_migrations (version) VALUES ('20121212200115');

INSERT INTO schema_migrations (version) VALUES ('20121212233830');