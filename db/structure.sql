--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: concepts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE concepts (
    id integer NOT NULL,
    concept_type integer NOT NULL,
    title character varying NOT NULL,
    description character varying NOT NULL
);


--
-- Name: concepts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE concepts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: concepts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE concepts_id_seq OWNED BY concepts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    title character varying NOT NULL,
    word_id integer NOT NULL
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
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
-- Name: word_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_groups (
    id integer NOT NULL,
    starting_word_id integer NOT NULL,
    ending_word_id integer NOT NULL,
    group_type character varying,
    concept_id integer
);


--
-- Name: word_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE word_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: word_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE word_groups_id_seq OWNED BY word_groups.id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE words (
    id integer NOT NULL,
    word character varying NOT NULL,
    word_index integer NOT NULL
);


--
-- Name: words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE words_id_seq OWNED BY words.id;


--
-- Name: words_word_index_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE words_word_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: words_word_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE words_word_index_seq OWNED BY words.word_index;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY concepts ALTER COLUMN id SET DEFAULT nextval('concepts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_groups ALTER COLUMN id SET DEFAULT nextval('word_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY words ALTER COLUMN id SET DEFAULT nextval('words_id_seq'::regclass);


--
-- Name: word_index; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY words ALTER COLUMN word_index SET DEFAULT nextval('words_word_index_seq'::regclass);


--
-- Name: concepts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY concepts
    ADD CONSTRAINT concepts_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: word_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_groups
    ADD CONSTRAINT word_groups_pkey PRIMARY KEY (id);


--
-- Name: words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY words
    ADD CONSTRAINT words_pkey PRIMARY KEY (id);


--
-- Name: idx_gin_concepts_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX idx_gin_concepts_description ON concepts USING gin (to_tsvector('english'::regconfig, (description)::text));


--
-- Name: idx_gin_concepts_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX idx_gin_concepts_title ON concepts USING gin (to_tsvector('english'::regconfig, (title)::text));


--
-- Name: index_concepts_on_concept_type_and_title_and_description; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_concepts_on_concept_type_and_title_and_description ON concepts USING btree (concept_type, title, description);


--
-- Name: index_sections_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sections_on_title ON sections USING btree (title);


--
-- Name: index_sections_on_word_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sections_on_word_id ON sections USING btree (word_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_word_groups_on_concept_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_groups_on_concept_id ON word_groups USING btree (concept_id);


--
-- Name: index_word_groups_on_ending_word_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_groups_on_ending_word_id ON word_groups USING btree (ending_word_id);


--
-- Name: index_word_groups_on_starting_word_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_word_groups_on_starting_word_id ON word_groups USING btree (starting_word_id);


--
-- Name: index_word_groups_on_starting_word_id_and_ending_word_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_word_groups_on_starting_word_id_and_ending_word_id ON word_groups USING btree (starting_word_id, ending_word_id);


--
-- Name: index_words_on_word_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_words_on_word_index ON words USING btree (word_index);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_8b7da50b55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_groups
    ADD CONSTRAINT fk_rails_8b7da50b55 FOREIGN KEY (concept_id) REFERENCES concepts(id);


--
-- Name: fk_rails_bc7392e2b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT fk_rails_bc7392e2b6 FOREIGN KEY (word_id) REFERENCES words(id);


--
-- Name: fk_word_groups_words_end; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_groups
    ADD CONSTRAINT fk_word_groups_words_end FOREIGN KEY (ending_word_id) REFERENCES words(id);


--
-- Name: fk_word_groups_words_start; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_groups
    ADD CONSTRAINT fk_word_groups_words_start FOREIGN KEY (starting_word_id) REFERENCES words(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151107175553');

INSERT INTO schema_migrations (version) VALUES ('20151107184230');

INSERT INTO schema_migrations (version) VALUES ('20151108135947');

INSERT INTO schema_migrations (version) VALUES ('20151108172732');

INSERT INTO schema_migrations (version) VALUES ('20151108184114');

INSERT INTO schema_migrations (version) VALUES ('20151108184147');

