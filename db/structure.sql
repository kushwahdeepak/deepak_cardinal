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
-- Name: mail_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mail_status AS ENUM (
    'pending',
    'sent',
    'failed'
);


SET default_tablespace = '';

--
-- Name: academic_honors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.academic_honors (
    id integer NOT NULL,
    name character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    createdonsystem timestamp without time zone,
    crelate_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: academic_honors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.academic_honors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academic_honors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.academic_honors_id_seq OWNED BY public.academic_honors.id;


--
-- Name: account_managers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_managers (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: account_managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_managers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_managers_id_seq OWNED BY public.account_managers.id;


--
-- Name: account_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_sources (
    id integer NOT NULL,
    name character varying,
    createdonsystem timestamp without time zone,
    crelate_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: account_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_sources_id_seq OWNED BY public.account_sources.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    modifiedon timestamp without time zone,
    createdon timestamp without time zone,
    updatedbyid character varying,
    createdbyid character varying,
    department character varying,
    iconattachmentid character varying,
    primarydocumentattachmentid character varying,
    description character varying,
    statusid character varying,
    parentaccountid character varying,
    formdefinitionid character varying,
    recordtype character varying,
    createdonsystem timestamp without time zone,
    customfield1 character varying,
    customfield2 character varying,
    customfield3 character varying,
    customfield4 character varying,
    customfield5 character varying,
    customfield6 character varying,
    customfield7 character varying,
    customfield8 character varying,
    customfield9 character varying,
    customfield10 character varying,
    accountsourceid character varying,
    accountsourceid_type character varying,
    estimatedrevenue character varying,
    ebitda character varying,
    revenue character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recruiter_update_id integer,
    user_id integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: accreditations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accreditations (
    id integer NOT NULL,
    value character varying,
    createdonsystem timestamp without time zone,
    crelate_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accreditations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accreditations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accreditations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accreditations_id_seq OWNED BY public.accreditations.id;


--
-- Name: accrediting_institutions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accrediting_institutions (
    id integer NOT NULL,
    name character varying,
    createdonsystem timestamp without time zone,
    crelate_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accrediting_institutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.accrediting_institutions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accrediting_institutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.accrediting_institutions_id_seq OWNED BY public.accrediting_institutions.id;


--
-- Name: active_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_candidates (
    id bigint NOT NULL,
    person_id bigint,
    job_id bigint,
    "candidate_match_Score" integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: active_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_candidates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_candidates_id_seq OWNED BY public.active_candidates.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: acts_as_bookable_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acts_as_bookable_bookings (
    id integer NOT NULL,
    bookable_type character varying,
    bookable_id integer,
    booker_type character varying,
    booker_id integer,
    amount integer,
    schedule text,
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    "time" timestamp without time zone,
    created_at timestamp without time zone
);


--
-- Name: acts_as_bookable_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.acts_as_bookable_bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: acts_as_bookable_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.acts_as_bookable_bookings_id_seq OWNED BY public.acts_as_bookable_bookings.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    categorytypeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    line1 character varying,
    line2 character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    location character varying,
    isprimary boolean,
    countryid character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ahoy_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_messages (
    id bigint NOT NULL,
    user_type character varying,
    user_id bigint,
    "to" text,
    mailer character varying,
    subject text,
    sent_at timestamp without time zone,
    opened_at timestamp without time zone,
    token character varying
);


--
-- Name: ahoy_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_messages_id_seq OWNED BY public.ahoy_messages.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    body text,
    question_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: applicant_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applicant_batches (
    id bigint NOT NULL,
    model_klass character varying,
    ok_count integer DEFAULT 0 NOT NULL,
    err_count integer DEFAULT 0 NOT NULL,
    code_version character varying,
    status character varying DEFAULT 'not done'::character varying NOT NULL,
    user_id bigint,
    log text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id uuid,
    job_id integer
);


--
-- Name: applicant_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applicant_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicant_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applicant_batches_id_seq OWNED BY public.applicant_batches.id;


--
-- Name: applicants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applicants (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    formatted_name character varying,
    linkedin_profile_url character varying,
    phone_number character varying,
    search_text character varying,
    keyword character varying,
    location character varying,
    employer character varying,
    title character varying,
    school character varying,
    degree character varying,
    discipline character varying,
    name character varying,
    min_time_in_job integer,
    max_time_in_job integer,
    min_career_length integer,
    max_career_length integer,
    min_activity_date integer,
    max_activity_date integer,
    email_available boolean,
    linkedin_available boolean,
    phone_number_available boolean,
    github_available boolean,
    top_company_status boolean,
    linkedin_profile_id_id integer,
    avatar_url character varying,
    linkedin_profile character varying,
    company_position character varying,
    email_address character varying NOT NULL,
    linkedin_field_of_study character varying,
    linkedin_industry character varying,
    linkedin_profile_education character varying,
    linkedin_profile_position character varying,
    linkedin_profile_publication character varying,
    linkedin_profile_recommendation text,
    linkedin_profile_url_resource character varying,
    linkedin_school character varying,
    active boolean,
    user_id integer,
    note_id integer,
    flag boolean,
    crelate_id character varying,
    created_by_id character varying,
    modified_on timestamp without time zone,
    updated_by_id character varying,
    created_on timestamp without time zone,
    salary integer,
    salutation character varying,
    icon_attachment_id character varying,
    primary_document_attachment_id character varying,
    nickname character varying,
    account_id character varying,
    contact_number character varying,
    twitter_name character varying,
    contact_source_id character varying,
    middle_name character varying,
    suffix_id character varying,
    ethnicity_id character varying,
    gender_id character varying,
    preferred_contact_method_type_id character varying,
    last_activity_regarding_id character varying,
    last_activity_regarding_id_type character varying,
    last_activity_date timestamp without time zone,
    spoken_to character varying,
    contact_status_id character varying,
    contact_merge_id character varying,
    approve_for_job_id character varying,
    salary_details character varying,
    record_type character varying,
    description character varying,
    created_on_system timestamp without time zone,
    contact_num integer,
    skills character varying,
    school_names character varying,
    degrees character varying,
    fields character varying,
    company_names character varying,
    createdbyid character varying,
    modifiedon timestamp without time zone,
    updatedbyid character varying,
    work_authorization_status character varying,
    document_file_name character varying,
    document_content_type character varying,
    document_file_size integer,
    document_updated_at timestamp without time zone,
    top_one_percent_status boolean,
    top_five_percent_status boolean,
    top_ten_percent_status boolean,
    status character varying,
    recruiter_update_id integer,
    recently_added boolean,
    active_date_at timestamp without time zone,
    active_set_by_user_id integer,
    inbound_user_id integer,
    phone_number_id integer,
    person_id integer,
    remote_interest character varying,
    position_interest character varying,
    experience_years integer,
    supervising_num integer,
    salary_expectations character varying,
    job_search_stage character varying,
    position_desc character varying,
    visa_status boolean,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    latest_pinned_note text,
    sms_last_from_user_id integer,
    github_url character varying,
    stack_overflow_url character varying,
    personal_site character varying,
    personal_site_available boolean,
    stack_overflow_url_available boolean,
    public_profile_url json,
    api_standard_profile_request json,
    industry json,
    current_share json,
    num_connections json,
    num_connections_capped json,
    summary json,
    specialties json,
    positions json,
    picture_url json,
    site_standard_profile_request json,
    lever_candidate_id character varying,
    company_position_id integer,
    linkedin_profile_id integer,
    email_address_id integer,
    linkedin_field_of_study_id integer,
    linkedin_industry_id integer,
    linkedin_profile_education_id integer,
    linkedin_profile_position_id integer,
    linkedin_profile_publication_id integer,
    linkedin_profile_recommendation_id integer,
    linkedin_profile_url_resource_id integer,
    linkedin_school_id integer,
    education_level integer,
    public boolean,
    attached_document_file_name character varying,
    attached_document_content_type character varying,
    attached_document_file_size integer,
    attached_document_updated_at timestamp without time zone,
    message_date time without time zone,
    top_company boolean,
    top_school boolean,
    tags character varying,
    original character varying,
    resume_text text,
    applied_to_all_jobs timestamp without time zone,
    organization_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applicants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applicants_id_seq OWNED BY public.applicants.id;


--
-- Name: applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applications (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    primarydocumentattachmentid character varying,
    firstname character varying,
    lastname character varying,
    parsedfirstname character varying,
    parsedlastname character varying,
    parsedemail character varying,
    parsedcity character varying,
    parsedstate character varying,
    parsedzip character varying,
    statusid character varying,
    contactid character varying,
    parsedphone character varying,
    workflowid character varying,
    contactsourceid character varying,
    formid character varying,
    middlename character varying,
    createdonsystem timestamp without time zone,
    jobtitle character varying,
    currentcompanyid character varying,
    nickname character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    jobid character varying
);


--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applications_id_seq OWNED BY public.applications.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: archive_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.archive_states (
    id integer NOT NULL,
    person_id integer,
    lever_id character varying,
    archived_at timestamp without time zone,
    reason character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: archive_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.archive_states_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: archive_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.archive_states_id_seq OWNED BY public.archive_states.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    title character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attachments (
    id integer NOT NULL,
    "Attachment" character varying,
    crelate_id character varying,
    filename character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    entitytypeid character varying,
    contenttype character varying,
    contentlength integer,
    targetentityid character varying,
    targetentityid_type character varying,
    isimage boolean,
    isdocument boolean,
    attachmenttypeid character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    statuscode integer
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attachments_id_seq OWNED BY public.attachments.id;


--
-- Name: avatars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.avatars (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: avatars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.avatars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: avatars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.avatars_id_seq OWNED BY public.avatars.id;


--
-- Name: blacklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blacklists (
    id bigint NOT NULL,
    person_id bigint,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blacklists_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blacklists_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blacklists_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blacklists_id_seq1 OWNED BY public.blacklists.id;


--
-- Name: call_sheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.call_sheets (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    num_calls integer,
    person_id integer,
    num_submittals integer,
    num_phone_interviews integer,
    num_onsite_interviews integer,
    num_placements integer,
    num_inmails integer,
    client_update_email_sent_at timestamp without time zone,
    call_sheet_upload_file_name character varying,
    call_sheet_upload_content_type character varying,
    call_sheet_upload_file_size integer,
    call_sheet_upload_updated_at timestamp without time zone,
    status character varying,
    notes text,
    date date,
    name character varying,
    role character varying,
    client character varying,
    lead_source character varying,
    email character varying,
    phone_number character varying,
    visa character varying,
    company character varying,
    university character varying,
    linkedin_url character varying
);


--
-- Name: call_sheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.call_sheets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: call_sheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.call_sheets_id_seq OWNED BY public.call_sheets.id;


--
-- Name: calls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.calls (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    scheduled_time timestamp without time zone,
    person_id integer,
    call_sheet_id integer,
    first_name character varying,
    last_name character varying
);


--
-- Name: calls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.calls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: calls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.calls_id_seq OWNED BY public.calls.id;


--
-- Name: campaign_recipients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaign_recipients (
    id bigint NOT NULL,
    contact_recipient_at timestamp without time zone,
    recipient_id integer NOT NULL,
    campaign_id integer NOT NULL,
    status public.mail_status DEFAULT 'pending'::public.mail_status,
    organization_id integer
);


--
-- Name: campaign_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campaign_recipients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaign_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campaign_recipients_id_seq OWNED BY public.campaign_recipients.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaigns (
    id bigint NOT NULL,
    start_date timestamp without time zone,
    duration_days integer,
    source_address character varying NOT NULL,
    subject character varying NOT NULL,
    content text NOT NULL,
    job_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: candidate_company_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_company_searches (
    id bigint NOT NULL,
    company_name character varying
);


--
-- Name: candidate_company_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_company_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_company_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_company_searches_id_seq OWNED BY public.candidate_company_searches.id;


--
-- Name: candidate_location_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_location_searches (
    id bigint NOT NULL,
    city character varying,
    state character varying
);


--
-- Name: candidate_location_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_location_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_location_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_location_searches_id_seq OWNED BY public.candidate_location_searches.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: client_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_accounts (
    id integer NOT NULL
);


--
-- Name: client_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_accounts_id_seq OWNED BY public.client_accounts.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    body text,
    post_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    user_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: company_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_positions (
    id integer NOT NULL,
    person_id integer,
    email_address_id integer,
    is_current boolean,
    start_date date,
    start_date_year integer,
    start_date_month integer,
    end_date date,
    end_date_year integer,
    end_date_month integer,
    title character varying,
    linkedin_profile_position_id integer,
    score double precision,
    person_id_id integer,
    email_address_id_id integer,
    linkedin_profile_position_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    linkedin_profile_positions_id integer,
    people_id integer,
    user_id integer
);


--
-- Name: company_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_positions_id_seq OWNED BY public.company_positions.id;


--
-- Name: company_profile_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_profile_jobs (
    id bigint NOT NULL,
    company_profile_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_profile_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_profile_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_profile_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_profile_jobs_id_seq OWNED BY public.company_profile_jobs.id;


--
-- Name: company_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_profiles (
    id bigint NOT NULL,
    company_name character varying
);


--
-- Name: company_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_profiles_id_seq OWNED BY public.company_profiles.id;


--
-- Name: company_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.company_resources (
    id bigint NOT NULL,
    company_email character varying,
    company_name character varying,
    company_representative_name character varying,
    mail_sent boolean DEFAULT false
);


--
-- Name: company_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.company_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.company_resources_id_seq OWNED BY public.company_resources.id;


--
-- Name: contact_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_sources (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contact_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_sources_id_seq OWNED BY public.contact_sources.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    target_user_id integer,
    first_name character varying,
    last_name character varying,
    email character varying,
    phone_number character varying,
    street character varying,
    city character varying,
    region character varying,
    country character varying,
    postal_code character varying,
    company character varying,
    source character varying,
    job_title character varying,
    dob character varying,
    full_address character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversations (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: crelate_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crelate_users (
    id integer NOT NULL,
    crelate_id character varying,
    fullname character varying,
    firstname character varying,
    lastname character varying,
    email character varying,
    userstateid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: crelate_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.crelate_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crelate_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.crelate_users_id_seq OWNED BY public.crelate_users.id;


--
-- Name: date_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.date_items (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    categorytypeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    value timestamp without time zone,
    isprimary boolean,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: date_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.date_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: date_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.date_items_id_seq OWNED BY public.date_items.id;


--
-- Name: dynamic_page_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dynamic_page_contents (
    id bigint NOT NULL,
    name character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dynamic_page_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dynamic_page_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dynamic_page_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dynamic_page_contents_id_seq OWNED BY public.dynamic_page_contents.id;


--
-- Name: education_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_experiences (
    id bigint NOT NULL,
    school_name character varying DEFAULT ''::character varying NOT NULL,
    "from" integer,
    "to" integer,
    degree character varying DEFAULT ''::character varying,
    major character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id bigint
);


--
-- Name: education_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.education_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: education_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.education_experiences_id_seq OWNED BY public.education_experiences.id;


--
-- Name: eeo_others; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eeo_others (
    id integer NOT NULL,
    crelate_id character varying,
    value character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: eeo_others_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eeo_others_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eeo_others_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eeo_others_id_seq OWNED BY public.eeo_others.id;


--
-- Name: email_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_addresses (
    id integer NOT NULL,
    email character varying,
    valid_confidence numeric,
    linkedin_profile_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    credible boolean,
    linkedin_profile_id integer,
    source character varying,
    createdon timestamp without time zone,
    categorytypeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    isprimary boolean,
    emailflagtypeid character varying,
    emailflagerror character varying,
    crelate_id character varying,
    user_id integer,
    person_id integer,
    email_type character varying,
    status character varying
);


--
-- Name: email_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_addresses_id_seq OWNED BY public.email_addresses.id;


--
-- Name: email_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_credentials (
    id bigint NOT NULL,
    email_address character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password character varying,
    organisation_id character varying NOT NULL
);


--
-- Name: email_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_credentials_id_seq OWNED BY public.email_credentials.id;


--
-- Name: email_lookups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_lookups (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    attributeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    rightentityid character varying,
    rightentityid_type character varying,
    address character varying,
    isplainaddress boolean,
    description character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_lookups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_lookups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_lookups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_lookups_id_seq OWNED BY public.email_lookups.id;


--
-- Name: email_sequences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_sequences (
    id bigint NOT NULL,
    subject character varying,
    email_body text,
    sent_at timestamp without time zone,
    job_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_sequences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_sequences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_sequences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_sequences_id_seq OWNED BY public.email_sequences.id;


--
-- Name: employer_company_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_company_profiles (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    logo_file_name character varying,
    logo_content_type character varying,
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    visibility boolean,
    corporate_mission text,
    office_locations character varying,
    year_founded date,
    employees_count integer,
    engineers_count integer,
    industry_specialization character varying,
    company_url character varying,
    crunchbase_url character varying,
    angellist_url character varying,
    tech_stack text,
    perks text,
    benefits text,
    name character varying
);


--
-- Name: employer_company_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_company_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_company_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_company_profiles_id_seq OWNED BY public.employer_company_profiles.id;


--
-- Name: employer_dashboard; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_dashboard (
    id integer NOT NULL,
    organization_id bigint,
    job_id bigint NOT NULL,
    leads integer,
    applicant integer,
    recruitor_screen integer,
    first_interview integer,
    second_interview integer,
    offer integer,
    archived integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: employer_dashboard_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_dashboard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_dashboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_dashboard_id_seq OWNED BY public.employer_dashboard.id;


--
-- Name: employer_sequence_to_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employer_sequence_to_people (
    id bigint NOT NULL,
    person_id bigint,
    email_sequence_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: employer_sequence_to_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employer_sequence_to_people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employer_sequence_to_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employer_sequence_to_people_id_seq OWNED BY public.employer_sequence_to_people.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entries (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- Name: experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiences (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    verbid character varying,
    display character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subject character varying,
    location character varying,
    "when" timestamp without time zone,
    parentid character varying,
    parentid_type character varying,
    resultid character varying,
    regardingid character varying,
    regardingid_type character varying,
    completed boolean,
    completedon timestamp without time zone,
    "from" character varying,
    "to" character varying,
    cc character varying,
    attachmentid character varying,
    allday character varying,
    pinned boolean,
    announced boolean,
    parentexperienceid character varying,
    bcc character varying,
    html character varying,
    emailflagtypeid character varying,
    emailflagreason character varying,
    whenend character varying,
    emailalternatehtml character varying,
    isinvite boolean,
    createdonsystem timestamp without time zone,
    emailrawheader character varying,
    emailimportance character varying,
    displaytype character varying,
    parent2id character varying,
    parent2id_type character varying,
    workflowitemid character varying,
    credentialid character varying,
    emailstatus character varying,
    icaluid character varying
);


--
-- Name: experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.experiences_id_seq OWNED BY public.experiences.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id bigint NOT NULL,
    feedback_text text,
    mention_ids integer[] DEFAULT '{}'::integer[],
    interview_schedule_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: file_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_uploads (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: file_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_uploads_id_seq OWNED BY public.file_uploads.id;


--
-- Name: flagged_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flagged_candidates (
    id integer NOT NULL,
    user_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flagged_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flagged_candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flagged_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flagged_candidates_id_seq OWNED BY public.flagged_candidates.id;


--
-- Name: followed_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.followed_candidates (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    user_id integer
);


--
-- Name: followed_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.followed_candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followed_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.followed_candidates_id_seq OWNED BY public.followed_candidates.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    id integer NOT NULL,
    followable_type character varying NOT NULL,
    followable_id integer NOT NULL,
    follower_type character varying NOT NULL,
    follower_id integer NOT NULL,
    blocked boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.follows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.follows_id_seq OWNED BY public.follows.id;


--
-- Name: form_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_fields (
    id integer NOT NULL,
    crelate_id character varying,
    value character varying,
    formfieldtypeid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: form_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_fields_id_seq OWNED BY public.form_fields.id;


--
-- Name: form_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.form_responses (
    id integer NOT NULL,
    crelate_id character varying,
    modifiedon timestamp without time zone,
    createdon timestamp without time zone,
    updatedbyid character varying,
    createdbyid character varying,
    formfieldid character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    formid character varying,
    rating character varying,
    createdonsystem timestamp without time zone
);


--
-- Name: form_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.form_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: form_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.form_responses_id_seq OWNED BY public.form_responses.id;


--
-- Name: forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forms (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    formdefinitionid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    url character varying,
    iscomplete boolean,
    createdonsystem timestamp without time zone,
    layout character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forms_id_seq OWNED BY public.forms.id;


--
-- Name: group_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_conversations (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: group_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_conversations_id_seq OWNED BY public.group_conversations.id;


--
-- Name: group_conversations_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_conversations_users (
    conversation_id integer,
    user_id integer
);


--
-- Name: group_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_messages (
    id integer NOT NULL,
    content character varying,
    added_new_users character varying,
    seen_by character varying,
    user_id integer,
    conversation_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: group_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_messages_id_seq OWNED BY public.group_messages.id;


--
-- Name: hiring_managers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.hiring_managers (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: hiring_managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.hiring_managers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hiring_managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.hiring_managers_id_seq OWNED BY public.hiring_managers.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id integer NOT NULL,
    user_id integer,
    provider character varying,
    uid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: import_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_jobs (
    id bigint NOT NULL,
    organization_id integer,
    company_name character varying,
    notificationemails character varying,
    status character varying DEFAULT 'not done'::character varying NOT NULL,
    user_id bigint NOT NULL,
    log text
);


--
-- Name: import_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_jobs_id_seq OWNED BY public.import_jobs.id;


--
-- Name: incoming_mails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incoming_mails (
    id bigint NOT NULL,
    plain text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    subject character varying,
    date date,
    resume_text text,
    candidate_email character varying,
    parsed_mail_json text,
    parsed_job_id integer,
    request_id character varying,
    reply text,
    "from" character varying,
    parsed boolean DEFAULT false,
    "to" character varying,
    remote_ip character varying,
    attachment_url character varying,
    source character varying,
    candidate_name character varying DEFAULT ''::character varying
);


--
-- Name: incoming_mails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incoming_mails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incoming_mails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incoming_mails_id_seq OWNED BY public.incoming_mails.id;


--
-- Name: instant_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.instant_addresses (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    value character varying,
    isprimary boolean,
    targetentityid character varying,
    targetentityid_type character varying,
    categorytypeid character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: instant_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.instant_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instant_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.instant_addresses_id_seq OWNED BY public.instant_addresses.id;


--
-- Name: intake_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.intake_batches (
    id bigint NOT NULL,
    model_klass character varying,
    ok_count integer DEFAULT 0 NOT NULL,
    err_count integer DEFAULT 0 NOT NULL,
    code_version character varying,
    status character varying DEFAULT 'not done'::character varying NOT NULL,
    user_id bigint NOT NULL,
    log text
);


--
-- Name: intake_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.intake_batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: intake_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.intake_batches_id_seq OWNED BY public.intake_batches.id;


--
-- Name: interview_feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_feedbacks (
    id bigint NOT NULL,
    user_id bigint,
    feedback character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    interview_schedule_id integer
);


--
-- Name: interview_feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interview_feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interview_feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interview_feedbacks_id_seq OWNED BY public.interview_feedbacks.id;


--
-- Name: interview_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interview_schedules (
    id bigint NOT NULL,
    interview_date integer,
    description text,
    person_id integer,
    interviewer_ids integer[] DEFAULT '{}'::integer[],
    interview_type integer,
    job_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer
);


--
-- Name: interview_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interview_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interview_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interview_schedules_id_seq OWNED BY public.interview_schedules.id;


--
-- Name: interviewees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interviewees (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: interviewees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interviewees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interviewees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interviewees_id_seq OWNED BY public.interviewees.id;


--
-- Name: interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interviews (
    id integer NOT NULL,
    name character varying,
    title character varying,
    content text,
    price integer,
    category character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying,
    timezone character varying,
    duration character varying,
    date date,
    "time" time without time zone,
    format character varying,
    location character varying,
    comment text,
    user_id integer,
    schedule text,
    capacity integer,
    interviewee_id integer
);


--
-- Name: interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interviews_id_seq OWNED BY public.interviews.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitations (
    id bigint NOT NULL,
    organization_id bigint,
    inviting_user_id bigint,
    invited_user_id bigint,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invitations_id_seq OWNED BY public.invitations.id;


--
-- Name: invited_bies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invited_bies (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: invited_bies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invited_bies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invited_bies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invited_bies_id_seq OWNED BY public.invited_bies.id;


--
-- Name: job_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_categories (
    id integer NOT NULL,
    name character varying,
    branch character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_categories_id_seq OWNED BY public.job_categories.id;


--
-- Name: job_companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_companies (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_companies_id_seq OWNED BY public.job_companies.id;


--
-- Name: job_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_experiences (
    id bigint NOT NULL,
    title character varying,
    description text,
    start_date date,
    end_date date,
    person_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_experiences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_experiences_id_seq OWNED BY public.job_experiences.id;


--
-- Name: job_locatables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_locatables (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_locatables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_locatables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_locatables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_locatables_id_seq OWNED BY public.job_locatables.id;


--
-- Name: job_location_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_location_interests (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer
);


--
-- Name: job_location_interests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_location_interests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_location_interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_location_interests_id_seq OWNED BY public.job_location_interests.id;


--
-- Name: job_location_interests_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_location_interests_users (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_location_interests_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_location_interests_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_location_interests_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_location_interests_users_id_seq OWNED BY public.job_location_interests_users.id;


--
-- Name: job_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_locations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    job_locatable_id integer,
    job_locatable_type character varying,
    job_city character varying,
    job_state character varying,
    job_country character varying
);


--
-- Name: job_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_locations_id_seq OWNED BY public.job_locations.id;


--
-- Name: job_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_posts (
    id integer NOT NULL,
    hiring_manager_id integer,
    job_category_id integer,
    job_company_id integer,
    user_id integer,
    h1b_fulfilment boolean,
    relocation_requested boolean,
    remote_position boolean,
    start_date date,
    compensation integer,
    number_open_positions integer,
    compensation_type character varying,
    job_title character varying,
    job_type character varying,
    location character varying,
    website character varying,
    work_authorization character varying,
    compensation_details text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_posts_id_seq OWNED BY public.job_posts.id;


--
-- Name: job_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_searches (
    id integer NOT NULL,
    skills character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    keyword character varying,
    company_names text,
    school_names text,
    title character varying,
    experience_years integer,
    locations character varying,
    job_keyword character varying,
    portalcity character varying
);


--
-- Name: job_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_searches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_searches_id_seq OWNED BY public.job_searches.id;


--
-- Name: job_stage_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_stage_statuses (
    id bigint NOT NULL,
    job_id bigint,
    user_id bigint,
    leads integer,
    applicant integer,
    recruiter integer,
    first_interview integer,
    second_interview integer,
    offer integer,
    archived integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submitted integer DEFAULT 0,
    active_candidates integer DEFAULT 0,
    organization_id integer
);


--
-- Name: job_stage_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_stage_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_stage_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_stage_statuses_id_seq OWNED BY public.job_stage_statuses.id;


--
-- Name: job_titles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_titles (
    id integer NOT NULL,
    crelate_id character varying,
    title character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_titles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_titles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_titles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_titles_id_seq OWNED BY public.job_titles.id;


--
-- Name: job_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_types (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_types_id_seq OWNED BY public.job_types.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    name character varying,
    numberofopenings integer,
    startdate timestamp without time zone,
    description character varying,
    primarydocumentattachmentid character varying,
    externalemailaddress character varying,
    compensation character varying,
    compensationdetails character varying,
    portaldescription character varying,
    portaltitle character varying,
    useropendate timestamp without time zone,
    userclosedate timestamp without time zone,
    portalcompanyname character varying,
    portalcompensation character varying,
    portalcity character varying,
    portallastpostedon timestamp without time zone,
    closedon timestamp without time zone,
    portalvisibility boolean,
    formdefinitionid character varying,
    jobnum integer,
    createdonsystem timestamp without time zone,
    jobcategoryid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    recruiter_update_id integer,
    skills character varying,
    creator_id integer,
    managed_account_id integer,
    job_exp character varying,
    photo_file_name character varying,
    photo_content_type character varying,
    photo_file_size integer,
    photo_updated_at timestamp without time zone,
    pref_skills character varying,
    gen_reqs character varying,
    benefits character varying,
    work_time character varying,
    company_names text,
    school_names text,
    experience_years integer,
    nice_to_have_skills character varying,
    nice_to_have_keywords character varying,
    keywords character varying,
    notificationemails character varying,
    company_name character varying,
    location character varying,
    referral_amount character varying,
    email_campaign_subject character varying,
    email_campaign_desc character varying,
    sms_campaign_desc character varying,
    location_preference character varying,
    prefered_titles character varying,
    prefered_industries character varying,
    department character varying DEFAULT ''::character varying,
    active boolean DEFAULT true,
    linkedin_job_id bigint DEFAULT 0,
    linkedin_url character varying,
    indeed_url character varying,
    campaign_approved boolean DEFAULT false,
    sync_job boolean DEFAULT false,
    leads_count integer DEFAULT 0 NOT NULL,
    referral_candidate boolean DEFAULT false,
    expiry_date timestamp without time zone,
    status integer DEFAULT 0,
    discarded_at timestamp without time zone,
    organization_id bigint
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: jobs_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs_locations (
    id bigint NOT NULL,
    location_id integer,
    job_id integer
);


--
-- Name: jobs_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_locations_id_seq OWNED BY public.jobs_locations.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    email character varying,
    name character varying,
    device character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    accepts boolean,
    accepts_date timestamp without time zone
);


--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: lever_payload_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lever_payload_subscriptions (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lever_payload_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lever_payload_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lever_payload_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lever_payload_subscriptions_id_seq OWNED BY public.lever_payload_subscriptions.id;


--
-- Name: linked_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linked_accounts (
    id integer NOT NULL,
    user_id integer,
    email character varying,
    provider character varying,
    uid character varying,
    token character varying,
    expires integer,
    expires_at integer,
    refresh_token character varying,
    display_name character varying,
    profile_image character varying,
    token_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linked_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linked_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linked_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linked_accounts_id_seq OWNED BY public.linked_accounts.id;


--
-- Name: linkedin_allow_import_profile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_allow_import_profile (
    id integer NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linkedin_allow_import_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_allow_import_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_allow_import_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_allow_import_profile_id_seq OWNED BY public.linkedin_allow_import_profile.id;


--
-- Name: linkedin_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_data (
    id bigint NOT NULL,
    skills character varying,
    profile_url character varying,
    person_id integer,
    education jsonb DEFAULT '[]'::jsonb,
    working_experience jsonb DEFAULT '[]'::jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: linkedin_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_data_id_seq OWNED BY public.linkedin_data.id;


--
-- Name: linkedin_field_of_studies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_field_of_studies (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linkedin_field_of_studies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_field_of_studies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_field_of_studies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_field_of_studies_id_seq OWNED BY public.linkedin_field_of_studies.id;


--
-- Name: linkedin_industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_industries (
    id integer NOT NULL,
    name character varying,
    "group" character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    linkedin_profile_id integer,
    linkedin_profiles_id integer
);


--
-- Name: linkedin_industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_industries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_industries_id_seq OWNED BY public.linkedin_industries.id;


--
-- Name: linkedin_profile_educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profile_educations (
    id integer NOT NULL,
    linkedin_profile_id integer,
    school_name character varying,
    field_of_study character varying,
    degree character varying,
    start_date date,
    start_date_year character varying,
    start_date_month character varying,
    end_date date,
    end_date_year character varying,
    end_date_month character varying,
    activities character varying,
    notes character varying,
    linkedin_field_of_study_id integer,
    linkedin_school_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    user_id integer,
    gpa character varying
);


--
-- Name: linkedin_profile_educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profile_educations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profile_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profile_educations_id_seq OWNED BY public.linkedin_profile_educations.id;


--
-- Name: linkedin_profile_positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profile_positions (
    id integer NOT NULL,
    company_name character varying,
    is_current boolean,
    start_date date,
    start_date_year character varying,
    start_date_month character varying,
    end_date date,
    end_date_year character varying,
    end_date_month character varying,
    title character varying,
    summary character varying,
    locality character varying,
    linkedin_profile_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    user_id integer
);


--
-- Name: linkedin_profile_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profile_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profile_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profile_positions_id_seq OWNED BY public.linkedin_profile_positions.id;


--
-- Name: linkedin_profile_publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profile_publications (
    id integer NOT NULL,
    title character varying,
    date date,
    date_year integer,
    date_month integer,
    linkedin_profile_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer
);


--
-- Name: linkedin_profile_publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profile_publications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profile_publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profile_publications_id_seq OWNED BY public.linkedin_profile_publications.id;


--
-- Name: linkedin_profile_recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profile_recommendations (
    id integer NOT NULL,
    text character varying,
    type character varying,
    recommender_id integer,
    linkedin_profile_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    table_type character varying,
    person_id integer
);


--
-- Name: linkedin_profile_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profile_recommendations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profile_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profile_recommendations_id_seq OWNED BY public.linkedin_profile_recommendations.id;


--
-- Name: linkedin_profile_url_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profile_url_resources (
    id integer NOT NULL,
    name character varying,
    url character varying,
    domain character varying,
    linkedin_profile_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    credible boolean,
    person_id integer
);


--
-- Name: linkedin_profile_url_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profile_url_resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profile_url_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profile_url_resources_id_seq OWNED BY public.linkedin_profile_url_resources.id;


--
-- Name: linkedin_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_profiles (
    id integer NOT NULL,
    first_name character varying,
    headline character varying,
    linkedin_industry_id integer,
    public_profile_url character varying,
    linkedin_industry_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_name character varying,
    formatted_name character varying,
    location_name character varying,
    location_country_code character varying,
    picture_url character varying,
    internal_picture_url character varying,
    connections integer,
    num_recommenders integer,
    skills character varying,
    following_industries character varying,
    associations character varying,
    proposal_comments character varying,
    summary character varying,
    interests character varying,
    internal_picture_url_lg character varying,
    picture_url_lg character varying,
    cse_picture_url character varying,
    cse_picture_url_thumb character varying,
    internal_cse_picture_url character varying,
    internal_cse_picture_url_thumb character varying,
    specialties character varying,
    linkedin_profile_id integer,
    crelate_id character varying,
    createdon timestamp without time zone,
    categorytypeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    value character varying,
    isprimary boolean,
    createdonsystem timestamp without time zone,
    credible boolean,
    linkedin_uid character varying,
    sales_crm_flag boolean,
    user_id integer,
    person_id integer
);


--
-- Name: linkedin_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_profiles_id_seq OWNED BY public.linkedin_profiles.id;


--
-- Name: linkedin_resumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_resumes (
    id bigint NOT NULL,
    skills character varying,
    education character varying,
    experience integer,
    location character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    past_experience character varying[] DEFAULT '{}'::character varying[],
    incoming_mail_id bigint
);


--
-- Name: linkedin_resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_resumes_id_seq OWNED BY public.linkedin_resumes.id;


--
-- Name: linkedin_schools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedin_schools (
    id integer NOT NULL,
    name character varying,
    logo_url character varying,
    internal_logo_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "LinkedinProfileEducation_id" integer,
    linkedin_profile_education_id integer
);


--
-- Name: linkedin_schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedin_schools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedin_schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedin_schools_id_seq OWNED BY public.linkedin_schools.id;


--
-- Name: linkedinprofiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.linkedinprofiles (
    id bigint NOT NULL,
    profile_url character varying,
    user_id integer,
    status boolean DEFAULT false,
    people_id integer
);


--
-- Name: linkedinprofiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.linkedinprofiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linkedinprofiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.linkedinprofiles_id_seq OWNED BY public.linkedinprofiles.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    country character varying,
    state character varying,
    city character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: lookups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lookups (
    id integer NOT NULL,
    name character varying,
    key character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: lookups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lookups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lookups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lookups_id_seq OWNED BY public.lookups.id;


--
-- Name: mailboxer_conversation_opt_outs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailboxer_conversation_opt_outs (
    id integer NOT NULL,
    unsubscriber_type character varying,
    unsubscriber_id integer,
    conversation_id integer
);


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailboxer_conversation_opt_outs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailboxer_conversation_opt_outs_id_seq OWNED BY public.mailboxer_conversation_opt_outs.id;


--
-- Name: mailboxer_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailboxer_conversations (
    id integer NOT NULL,
    subject character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailboxer_conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailboxer_conversations_id_seq OWNED BY public.mailboxer_conversations.id;


--
-- Name: mailboxer_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailboxer_notifications (
    id integer NOT NULL,
    type character varying,
    body text,
    subject character varying DEFAULT ''::character varying,
    sender_type character varying,
    sender_id integer,
    conversation_id integer,
    draft boolean DEFAULT false,
    notification_code character varying,
    notified_object_type character varying,
    notified_object_id integer,
    attachment character varying,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    global boolean DEFAULT false,
    expires timestamp without time zone
);


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailboxer_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailboxer_notifications_id_seq OWNED BY public.mailboxer_notifications.id;


--
-- Name: mailboxer_receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailboxer_receipts (
    id integer NOT NULL,
    receiver_type character varying,
    receiver_id integer,
    notification_id integer NOT NULL,
    is_read boolean DEFAULT false,
    trashed boolean DEFAULT false,
    deleted boolean DEFAULT false,
    mailbox_type character varying(25),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_delivered boolean DEFAULT false,
    delivery_method character varying,
    message_id character varying
);


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailboxer_receipts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailboxer_receipts_id_seq OWNED BY public.mailboxer_receipts.id;


--
-- Name: managed_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.managed_accounts (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    name character varying,
    account_type character varying,
    closed boolean
);


--
-- Name: managed_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.managed_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: managed_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.managed_accounts_id_seq OWNED BY public.managed_accounts.id;


--
-- Name: match_score_histograms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_score_histograms (
    id bigint NOT NULL,
    standard_deviation double precision,
    average double precision,
    histogram json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: match_score_histograms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_score_histograms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_score_histograms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_score_histograms_id_seq OWNED BY public.match_score_histograms.id;


--
-- Name: match_score_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_score_statuses (
    id bigint NOT NULL,
    person_id bigint,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: match_score_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_score_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_score_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_score_statuses_id_seq OWNED BY public.match_score_statuses.id;


--
-- Name: match_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_scores (
    id bigint NOT NULL,
    job_id integer NOT NULL,
    person_id integer NOT NULL,
    score double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: match_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.match_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: match_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.match_scores_id_seq OWNED BY public.match_scores.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    subject character varying,
    "to" character varying,
    body text,
    recipient_name character varying,
    "from" character varying,
    person_id integer
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: multi_lookups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multi_lookups (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    attributeid character varying,
    rightentityid character varying,
    rightentityid_type character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: multi_lookups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.multi_lookups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: multi_lookups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multi_lookups_id_seq OWNED BY public.multi_lookups.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    body text,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    organization_id character varying,
    mention_ids integer[] DEFAULT '{}'::integer[]
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: notified_objects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notified_objects (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: notified_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notified_objects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notified_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notified_objects_id_seq OWNED BY public.notified_objects.id;


--
-- Name: onsite_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onsite_interviews (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    scheduled_time timestamp without time zone,
    person_id integer,
    call_sheet_id integer,
    user_id integer
);


--
-- Name: onsite_interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.onsite_interviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: onsite_interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.onsite_interviews_id_seq OWNED BY public.onsite_interviews.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying,
    owner_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    discarded_at timestamp without time zone,
    website_url character varying,
    image_url text,
    file_name character varying,
    member_organization_id integer,
    min_size integer DEFAULT 1,
    max_size integer DEFAULT 0,
    country character varying DEFAULT ''::character varying,
    state character varying DEFAULT ''::character varying,
    city character varying DEFAULT ''::character varying,
    company_size integer,
    location character varying,
    industry character varying,
    is_deleted boolean DEFAULT false,
    description character varying,
    status character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: outgoing_mails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outgoing_mails (
    id bigint NOT NULL,
    sender_email character varying,
    recipient_email character varying,
    subject character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    content character varying,
    status integer,
    error_msg character varying,
    delivery_id uuid
);


--
-- Name: outgoing_mails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.outgoing_mails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_mails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.outgoing_mails_id_seq OWNED BY public.outgoing_mails.id;


--
-- Name: outgoing_service_blacklists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.outgoing_service_blacklists (
    id bigint NOT NULL,
    vip_resource_id bigint,
    company_resource_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: outgoing_service_blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.outgoing_service_blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: outgoing_service_blacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.outgoing_service_blacklists_id_seq OWNED BY public.outgoing_service_blacklists.id;


--
-- Name: ownerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ownerships (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    attributeid character varying,
    isprimary boolean,
    targetentityid character varying,
    targetentityid_type character varying,
    rightentityid character varying,
    rightentityid_type character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ownerships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ownerships_id_seq OWNED BY public.ownerships.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    id integer NOT NULL,
    conversation_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    formatted_name character varying,
    linkedin_profile_url character varying,
    phone_number character varying,
    search_text character varying,
    keyword character varying,
    location character varying,
    employer character varying,
    title character varying,
    school character varying,
    degree character varying,
    discipline character varying,
    name character varying,
    min_time_in_job integer,
    max_time_in_job integer,
    min_career_length integer,
    max_career_length integer,
    min_activity_date integer,
    max_activity_date integer,
    email_available boolean,
    linkedin_available boolean,
    phone_number_available boolean,
    github_available boolean,
    top_company_status boolean,
    linkedin_profile_id_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    avatar_url character varying,
    linkedin_profile character varying,
    company_position character varying,
    email_address character varying NOT NULL,
    linkedin_field_of_study character varying,
    linkedin_industry character varying,
    linkedin_profile_education character varying,
    linkedin_profile_position character varying,
    linkedin_profile_publication character varying,
    linkedin_profile_recommendation text,
    linkedin_profile_url_resource character varying,
    linkedin_school character varying,
    active boolean,
    user_id integer,
    note_id integer,
    flag boolean,
    crelate_id character varying,
    created_by_id character varying,
    modified_on timestamp without time zone,
    updated_by_id character varying,
    created_on timestamp without time zone,
    salary integer,
    salutation character varying,
    icon_attachment_id character varying,
    primary_document_attachment_id character varying,
    nickname character varying,
    account_id character varying,
    contact_number character varying,
    twitter_name character varying,
    contact_source_id character varying,
    middle_name character varying,
    suffix_id character varying,
    ethnicity_id character varying,
    gender_id character varying,
    preferred_contact_method_type_id character varying,
    last_activity_regarding_id character varying,
    last_activity_regarding_id_type character varying,
    last_activity_date timestamp without time zone,
    spoken_to character varying,
    contact_status_id character varying,
    contact_merge_id character varying,
    approve_for_job_id character varying,
    salary_details character varying,
    record_type character varying,
    description character varying,
    created_on_system timestamp without time zone,
    contact_num integer,
    skills character varying,
    school_names character varying,
    degrees character varying,
    fields character varying,
    company_names character varying,
    createdbyid character varying,
    modifiedon timestamp without time zone,
    updatedbyid character varying,
    work_authorization_status character varying,
    document_file_name character varying,
    document_content_type character varying,
    document_file_size integer,
    document_updated_at timestamp without time zone,
    top_one_percent_status boolean,
    top_five_percent_status boolean,
    top_ten_percent_status boolean,
    status character varying,
    recruiter_update_id integer,
    recently_added boolean,
    active_date_at timestamp without time zone,
    active_set_by_user_id integer,
    inbound_user_id integer,
    phone_number_id integer,
    person_id integer,
    remote_interest character varying,
    position_interest character varying,
    experience_years integer,
    supervising_num integer,
    salary_expectations character varying,
    job_search_stage character varying,
    position_desc character varying,
    visa_status boolean,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    latest_pinned_note text,
    sms_last_from_user_id integer,
    github_url character varying,
    stack_overflow_url character varying,
    personal_site character varying,
    personal_site_available boolean,
    stack_overflow_url_available boolean,
    public_profile_url json,
    api_standard_profile_request json,
    industry json,
    current_share json,
    num_connections json,
    num_connections_capped json,
    summary json,
    specialties json,
    positions json,
    picture_url json,
    site_standard_profile_request json,
    lever_candidate_id character varying,
    company_position_id integer,
    linkedin_profile_id integer,
    email_address_id integer,
    linkedin_field_of_study_id integer,
    linkedin_industry_id integer,
    linkedin_profile_education_id integer,
    linkedin_profile_position_id integer,
    linkedin_profile_publication_id integer,
    linkedin_profile_recommendation_id integer,
    linkedin_profile_url_resource_id integer,
    linkedin_school_id integer,
    education_level integer,
    public boolean,
    attached_document_file_name character varying,
    attached_document_content_type character varying,
    attached_document_file_size integer,
    attached_document_updated_at timestamp without time zone,
    message_date time without time zone,
    top_company boolean,
    top_school boolean,
    tags character varying,
    original character varying,
    resume_text text,
    applied_to_all_jobs timestamp without time zone,
    incoming_mail_id integer,
    links text,
    linkedin_applicant_id bigint DEFAULT 0,
    sourcer_id integer,
    source character varying,
    collector_id integer DEFAULT 0,
    organization_id_id bigint,
    organization_id bigint
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: phone_interviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_interviews (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    scheduled_time timestamp without time zone,
    person_id integer,
    call_sheet_id integer,
    user_id integer
);


--
-- Name: phone_interviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phone_interviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_interviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phone_interviews_id_seq OWNED BY public.phone_interviews.id;


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_numbers (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    createdon timestamp without time zone,
    targetentityid character varying,
    targetentityid_type character varying,
    categorytypeid character varying,
    value character varying,
    isprimary boolean,
    extension character varying,
    createdonsystem timestamp without time zone,
    crelate_id character varying,
    people_id integer,
    invalid_phone boolean,
    credible boolean,
    source character varying,
    valid_since character varying,
    last_seen character varying,
    country_code integer,
    display character varying,
    display_international character varying,
    user_id integer,
    phone_type character varying
);


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phone_numbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phone_numbers_id_seq OWNED BY public.phone_numbers.id;


--
-- Name: placements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.placements (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    person_id integer,
    call_sheet_id integer,
    user_id integer,
    placement_date timestamp without time zone
);


--
-- Name: placements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.placements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: placements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.placements_id_seq OWNED BY public.placements.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer,
    user_id integer,
    subject character varying,
    "to" character varying,
    "from" character varying,
    raw_text text,
    raw_body text,
    attachments bytea,
    headers text,
    raw_headers text
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: private_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.private_conversations (
    id integer NOT NULL,
    recipient_id integer,
    sender_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: private_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.private_conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: private_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.private_conversations_id_seq OWNED BY public.private_conversations.id;


--
-- Name: private_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.private_messages (
    id integer NOT NULL,
    body text,
    user_id integer,
    conversation_id integer,
    seen boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: private_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.private_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: private_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.private_messages_id_seq OWNED BY public.private_messages.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    title character varying,
    body text,
    resolved boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    person_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: recruiter_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruiter_organizations (
    id bigint NOT NULL,
    organization_id bigint,
    user_id bigint,
    status character varying,
    discarded_at timestamp without time zone
);


--
-- Name: recruiter_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruiter_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruiter_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruiter_organizations_id_seq OWNED BY public.recruiter_organizations.id;


--
-- Name: recruiter_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recruiter_updates (
    id integer NOT NULL,
    status character varying,
    notes text,
    date date,
    role character varying,
    client character varying,
    lead_source character varying,
    email character varying,
    phone_number character varying,
    visa character varying,
    company character varying,
    school character varying,
    linkedin_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    first_name character varying,
    last_name character varying,
    name character varying,
    person_id integer,
    archived boolean,
    status_id integer,
    job_id integer,
    account_id integer,
    category_id integer,
    location character varying,
    email_address character varying,
    work_authorization_status character varying,
    salary_details character varying,
    salary integer,
    salutation character varying,
    linkedin_profile_url character varying,
    document_file_name character varying,
    document_content_type character varying,
    document_file_size integer,
    document_updated_at timestamp without time zone,
    document character varying,
    inbound_user_id integer,
    skills character varying,
    title character varying,
    degree character varying,
    active_status boolean,
    managed_account_id integer
);


--
-- Name: recruiter_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recruiter_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recruiter_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recruiter_updates_id_seq OWNED BY public.recruiter_updates.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.referrals (
    id bigint NOT NULL,
    inviter_id integer NOT NULL,
    job_id integer NOT NULL,
    invitee_name character varying,
    invitee_email character varying,
    invitee_phone character varying,
    message text,
    invitation_date timestamp without time zone,
    email_send_date timestamp without time zone,
    invitee_code character varying,
    signup_date timestamp without time zone,
    job_applied_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: referrals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.referrals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: referrals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.referrals_id_seq OWNED BY public.referrals.id;


--
-- Name: resume_grades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resume_grades (
    id bigint NOT NULL,
    job_id integer,
    person_id integer,
    resume_grade integer
);


--
-- Name: resume_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resume_grades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resume_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resume_grades_id_seq OWNED BY public.resume_grades.id;


--
-- Name: saved_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saved_candidates (
    id integer NOT NULL,
    user_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: saved_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saved_candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saved_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saved_candidates_id_seq OWNED BY public.saved_candidates.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searched_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.searched_candidates (
    id integer NOT NULL,
    user_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: searched_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.searched_candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searched_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.searched_candidates_id_seq OWNED BY public.searched_candidates.id;


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.searches (
    id integer NOT NULL,
    search_texts character varying,
    locations character varying,
    company_names character varying,
    titles character varying,
    schools character varying,
    degrees character varying,
    disciplines character varying,
    names character varying,
    min_time_in_job integer,
    max_time_in_job integer,
    min_career_length integer,
    max_career_length integer,
    min_activity_date integer,
    max_activity_date integer,
    email_available boolean,
    linkedin_available boolean,
    phone_number_available boolean,
    github_available boolean,
    top_company_status boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    keyword character varying,
    user_id integer,
    emails character varying,
    phone_numbers character varying,
    linkedin_urls character varying,
    active boolean,
    candidates_without_notes boolean,
    top_one_percent_status boolean,
    top_five_percent_status boolean,
    top_ten_percent_status boolean,
    recently_added boolean,
    candidates_with_notes boolean,
    experience_years integer,
    job_type_full_time boolean,
    job_type_contract boolean,
    relocation boolean,
    remote boolean,
    person_id integer,
    skills character varying,
    first_names character varying,
    last_names character varying,
    top_school boolean,
    min_education_level integer,
    top_company_or_top_school boolean,
    all_candidates boolean,
    fulltime_candidates boolean,
    freelance_candidates boolean,
    open_to_new_opportunities boolean,
    willing_to_work_remote boolean,
    message_date date,
    top_company boolean,
    tags character varying,
    job_id integer
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.searches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.searches_id_seq OWNED BY public.searches.id;


--
-- Name: sign_up_contracts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sign_up_contracts (
    id integer NOT NULL,
    name character varying,
    role character varying,
    content character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sign_up_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sign_up_contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sign_up_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sign_up_contracts_id_seq OWNED BY public.sign_up_contracts.id;


--
-- Name: stage_transitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stage_transitions (
    id bigint NOT NULL,
    feedback text,
    stage character varying NOT NULL,
    submission_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stage_transitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stage_transitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stage_transitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stage_transitions_id_seq OWNED BY public.stage_transitions.id;


--
-- Name: static_list_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.static_list_items (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdonsystem timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    viewid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: static_list_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.static_list_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: static_list_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.static_list_items_id_seq OWNED BY public.static_list_items.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.statuses (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    recruiter_update_id integer,
    name character varying,
    person_id integer,
    lever_id character varying
);


--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submissions (
    id bigint NOT NULL,
    user_id bigint,
    person_id bigint,
    job_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    incoming_mail_id bigint,
    submission_type character varying,
    is_linkedin boolean DEFAULT false
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submissions_id_seq OWNED BY public.submissions.id;


--
-- Name: submittals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submittals (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    submitted_at date,
    person_id integer,
    call_sheet_id integer,
    user_id integer,
    crelate_id character varying,
    createdbyid character varying,
    updatedbyid character varying,
    modifiedon timestamp without time zone,
    createdon timestamp without time zone,
    jobid character varying,
    emailbody character varying,
    emailsubject character varying,
    emailto character varying,
    emailcc character varying,
    emailbcc character varying,
    emailfrom character varying,
    emailfromid character varying,
    createdonsystem timestamp without time zone,
    credentialid character varying,
    phone_number character varying,
    email_address character varying,
    linkedin_profile_url character varying
);


--
-- Name: submittals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submittals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submittals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submittals_id_seq OWNED BY public.submittals.id;


--
-- Name: submitted_candidate_infos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.submitted_candidate_infos AS
 SELECT people.first_name,
    people.last_name,
    people.formatted_name,
    people.linkedin_profile_url,
    people.phone_number,
    people.search_text,
    people.keyword,
    people.location,
    people.employer,
    people.title,
    people.school,
    people.degree,
    people.discipline,
    people.name,
    people.min_time_in_job,
    people.max_time_in_job,
    people.min_career_length,
    people.max_career_length,
    people.min_activity_date,
    people.max_activity_date,
    people.email_available,
    people.linkedin_available,
    people.phone_number_available,
    people.github_available,
    people.top_company_status,
    people.linkedin_profile_id_id,
    people.created_at,
    people.updated_at,
    people.avatar_url,
    people.linkedin_profile,
    people.company_position,
    people.email_address,
    people.linkedin_field_of_study,
    people.linkedin_industry,
    people.linkedin_profile_education,
    people.linkedin_profile_position,
    people.linkedin_profile_publication,
    people.linkedin_profile_recommendation,
    people.linkedin_profile_url_resource,
    people.linkedin_school,
    people.active,
    people.user_id,
    people.note_id,
    people.flag,
    people.crelate_id,
    people.created_by_id,
    people.modified_on,
    people.updated_by_id,
    people.created_on,
    people.salary,
    people.salutation,
    people.icon_attachment_id,
    people.primary_document_attachment_id,
    people.nickname,
    people.account_id,
    people.contact_number,
    people.twitter_name,
    people.contact_source_id,
    people.middle_name,
    people.suffix_id,
    people.ethnicity_id,
    people.gender_id,
    people.preferred_contact_method_type_id,
    people.last_activity_regarding_id,
    people.last_activity_regarding_id_type,
    people.last_activity_date,
    people.spoken_to,
    people.contact_status_id,
    people.contact_merge_id,
    people.approve_for_job_id,
    people.salary_details,
    people.record_type,
    people.description,
    people.created_on_system,
    people.contact_num,
    people.skills,
    people.school_names,
    people.degrees,
    people.fields,
    people.company_names,
    people.createdbyid,
    people.modifiedon,
    people.updatedbyid,
    people.work_authorization_status,
    people.document_file_name,
    people.document_content_type,
    people.document_file_size,
    people.document_updated_at,
    people.top_one_percent_status,
    people.top_five_percent_status,
    people.top_ten_percent_status,
    people.status,
    people.recruiter_update_id,
    people.recently_added,
    people.active_date_at,
    people.active_set_by_user_id,
    people.inbound_user_id,
    people.phone_number_id,
    people.person_id,
    people.remote_interest,
    people.position_interest,
    people.experience_years,
    people.supervising_num,
    people.salary_expectations,
    people.job_search_stage,
    people.position_desc,
    people.visa_status,
    people.avatar_file_name,
    people.avatar_content_type,
    people.avatar_file_size,
    people.avatar_updated_at,
    people.latest_pinned_note,
    people.sms_last_from_user_id,
    people.github_url,
    people.stack_overflow_url,
    people.personal_site,
    people.personal_site_available,
    people.stack_overflow_url_available,
    people.public_profile_url,
    people.api_standard_profile_request,
    people.industry,
    people.current_share,
    people.num_connections,
    people.num_connections_capped,
    people.summary,
    people.specialties,
    people.positions,
    people.picture_url,
    people.site_standard_profile_request,
    people.lever_candidate_id,
    people.company_position_id,
    people.linkedin_profile_id,
    people.email_address_id,
    people.linkedin_field_of_study_id,
    people.linkedin_industry_id,
    people.linkedin_profile_education_id,
    people.linkedin_profile_position_id,
    people.linkedin_profile_publication_id,
    people.linkedin_profile_recommendation_id,
    people.linkedin_profile_url_resource_id,
    people.linkedin_school_id,
    people.education_level,
    people.public,
    people.attached_document_file_name,
    people.attached_document_content_type,
    people.attached_document_file_size,
    people.attached_document_updated_at,
    people.message_date,
    people.top_company,
    people.top_school,
    people.tags,
    people.original,
    people.resume_text,
    people.applied_to_all_jobs,
    people.organization_id,
    people.links,
    concat((people.id)::text, (match_scores.id)::text) AS id,
    people.id AS candidate_id,
    jobs.id AS job_id,
    submissions.id AS submission_id,
    COALESCE(match_scores.score, (0.0)::double precision) AS match_score,
    stage_transitions.stage AS candidate_stage
   FROM ((((public.people
     LEFT JOIN public.match_scores ON ((match_scores.person_id = people.id)))
     LEFT JOIN public.submissions ON (((submissions.person_id = people.id) AND (submissions.job_id = match_scores.job_id))))
     LEFT JOIN public.stage_transitions ON (((stage_transitions.submission_id = submissions.id) AND (stage_transitions.id = ( SELECT max(stage_transitions_1.id) AS max
           FROM public.stage_transitions stage_transitions_1
          WHERE (stage_transitions_1.submission_id = submissions.id))))))
     LEFT JOIN public.jobs ON ((jobs.id = match_scores.job_id)));


--
-- Name: submitted_candidates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submitted_candidates (
    id integer NOT NULL,
    job_id integer,
    user_id integer,
    account_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    employer_id integer,
    hidden_status boolean
);


--
-- Name: submitted_candidates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submitted_candidates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submitted_candidates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submitted_candidates_id_seq OWNED BY public.submitted_candidates.id;


--
-- Name: submitted_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.submitted_requests (
    id integer NOT NULL,
    job_id integer,
    user_id integer,
    account_id integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    candidate_id integer,
    hidden_status boolean,
    recruiter_id integer
);


--
-- Name: submitted_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.submitted_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submitted_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.submitted_requests_id_seq OWNED BY public.submitted_requests.id;


--
-- Name: sync_applicant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_applicant (
    id integer NOT NULL,
    user_id integer,
    sync_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sync_applicant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sync_applicant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sync_applicant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sync_applicant_id_seq OWNED BY public.sync_applicant.id;


--
-- Name: system_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_configurations (
    id bigint NOT NULL,
    name character varying,
    value integer DEFAULT 0
);


--
-- Name: system_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_configurations_id_seq OWNED BY public.system_configurations.id;


--
-- Name: tag_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_relationships (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    rightentityid character varying,
    rightentityid_type character varying,
    rightentitytagcategoryid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tag_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_relationships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_relationships_id_seq OWNED BY public.tag_relationships.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    tagcategoryid character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: task_list_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_list_items (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    attributeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    rightentityid character varying,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_list_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_list_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_list_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_list_items_id_seq OWNED BY public.task_list_items.id;


--
-- Name: timeline_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timeline_items (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    targetentityid character varying,
    targetentityid_type character varying,
    isprimary boolean,
    attributeid character varying,
    whenstart timestamp without time zone,
    whenend timestamp without time zone,
    whatid character varying,
    whatid_type character varying,
    whereid character varying,
    whereid_type character varying,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    whatvalue character varying,
    createdonsystem timestamp without time zone
);


--
-- Name: timeline_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timeline_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timeline_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timeline_items_id_seq OWNED BY public.timeline_items.id;


--
-- Name: unsubscribers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unsubscribers (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unsubscribers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unsubscribers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unsubscribers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unsubscribers_id_seq OWNED BY public.unsubscribers.id;


--
-- Name: unsubscribes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unsubscribes (
    id bigint NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: unsubscribes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unsubscribes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unsubscribes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unsubscribes_id_seq OWNED BY public.unsubscribes.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.uploads (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    document_file_name character varying,
    document_content_type character varying,
    document_file_size integer,
    document_updated_at timestamp without time zone,
    person_id integer,
    user_id integer
);


--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;


--
-- Name: urls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.urls (
    id integer NOT NULL,
    crelate_id character varying,
    createdon timestamp without time zone,
    categorytypeid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    value character varying,
    isprimary boolean,
    createdonsystem timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.urls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.urls_id_seq OWNED BY public.urls.id;


--
-- Name: usabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usabilities (
    id bigint NOT NULL,
    f1 character varying,
    f2 integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: usabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usabilities_id_seq OWNED BY public.usabilities.id;


--
-- Name: user_contact_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_contact_preferences (
    id integer NOT NULL,
    user_id integer,
    followup_date date,
    subscribe_candidate_matches boolean,
    subscribe_reminders boolean,
    subscribe_all boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_contact_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_contact_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_contact_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_contact_preferences_id_seq OWNED BY public.user_contact_preferences.id;


--
-- Name: user_education_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_education_jobs (
    id bigint NOT NULL,
    user_education_id integer,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_education_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_education_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_education_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_education_jobs_id_seq OWNED BY public.user_education_jobs.id;


--
-- Name: user_educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_educations (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rank integer,
    name character varying,
    town character varying
);


--
-- Name: user_educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_educations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_educations_id_seq OWNED BY public.user_educations.id;


--
-- Name: user_experiences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_experiences (
    id integer NOT NULL,
    company_name character varying,
    title character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    user_profile_id integer
);


--
-- Name: user_experiences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_experiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_experiences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_experiences_id_seq OWNED BY public.user_experiences.id;


--
-- Name: user_mailing_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_mailing_addresses (
    id integer NOT NULL,
    user_id integer,
    address_line_1 character varying,
    address_line_2 character varying,
    city character varying,
    state character varying,
    zip integer,
    country character varying,
    legal_age boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    time_zone character varying
);


--
-- Name: user_mailing_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_mailing_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_mailing_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_mailing_addresses_id_seq OWNED BY public.user_mailing_addresses.id;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_profiles (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_profiles_id_seq OWNED BY public.user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    provider character varying,
    uid character varying,
    role integer,
    name character varying,
    full_name character varying,
    person_id integer,
    username character varying,
    notes_id integer,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id integer,
    invitations_count integer DEFAULT 0,
    identity_id integer,
    first_name character varying,
    last_name character varying,
    date_of_birth date,
    location character varying,
    signuprole character varying,
    phone_number character varying,
    job_title character varying,
    company_name character varying,
    company_url character varying,
    remote_interest character varying,
    skills text[] DEFAULT '{}'::text[],
    location_interest_bh boolean,
    position_interest character varying,
    experience_years character varying,
    supervising_num integer,
    salary_expectations character varying,
    work_authorization_status boolean,
    visa_status boolean,
    linkedin_profile_url character varying,
    github_url character varying,
    personal_site character varying,
    stack_overflow_url character varying,
    position_desc text,
    employment_sought character varying,
    resume_file_name character varying,
    resume_content_type character varying,
    resume_file_size integer,
    resume_updated_at timestamp without time zone,
    accepts boolean,
    employer_hiring_location character varying,
    employer_roles character varying,
    employer_roles_type character varying,
    employer_remoteness boolean,
    employer_timeframe character varying,
    employer_pricing_authorization boolean,
    company_size character varying,
    document_content_type character varying,
    crelate_id character varying,
    userstateid character varying,
    accepts_date timestamp without time zone,
    job_search_stage character varying,
    account_manager_id integer,
    utf8 character varying,
    _method character varying,
    authenticity_token character varying,
    commit character varying,
    current_position character varying,
    current_employer character varying,
    public_profile_url json,
    api_standard_profile_request json,
    industry json,
    current_share json,
    num_connections json,
    num_connections_capped json,
    summary json,
    specialties json,
    positions json,
    picture_url json,
    site_standard_profile_request json,
    "user" character varying,
    roles_held text[],
    address_line_1 character varying,
    address_line_2 character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    location_interest_usa text[] DEFAULT '{}'::text[],
    user_approved boolean,
    referred_from character varying,
    employer_hiring_roles character varying,
    bulk_message_count integer DEFAULT 0 NOT NULL,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    google_token character varying,
    google_refresh_token character varying,
    calendly_link text DEFAULT ''::text,
    password_digest character varying,
    email_confirmed boolean DEFAULT false,
    confirm_token character varying,
    title character varying,
    active_job_seeker character varying,
    address character varying,
    sync_job boolean DEFAULT false,
    auto_scroll boolean DEFAULT false,
    send_email_request boolean DEFAULT false,
    user_verification_status character varying,
    discarded_at timestamp without time zone,
    organization_id bigint
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: villagers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.villagers (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    villagerable_id integer,
    villagerable_type character varying
);


--
-- Name: villagers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.villagers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: villagers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.villagers_id_seq OWNED BY public.villagers.id;


--
-- Name: vip_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vip_resources (
    id bigint NOT NULL,
    email character varying,
    name character varying
);


--
-- Name: vip_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vip_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vip_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vip_resources_id_seq OWNED BY public.vip_resources.id;


--
-- Name: vip_scheduler_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vip_scheduler_tables (
    id bigint NOT NULL,
    vip_resource_id integer,
    executed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vip_scheduler_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vip_scheduler_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vip_scheduler_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vip_scheduler_tables_id_seq OWNED BY public.vip_scheduler_tables.id;


--
-- Name: workflow_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_items (
    id integer NOT NULL,
    crelate_id character varying,
    label character varying,
    modifiedon timestamp without time zone,
    createdon timestamp without time zone,
    createdbyid character varying,
    updatedbyid character varying,
    targetid character varying,
    targetid_type character varying,
    workflowitemstatusid character varying,
    workflowid character varying,
    applicationid character varying,
    createdonsystem timestamp without time zone,
    target2id character varying,
    target2id_type character varying,
    name character varying,
    workflowtargetentityid character varying,
    workflowtargetentityid_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: workflow_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflow_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflow_items_id_seq OWNED BY public.workflow_items.id;


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows (
    id integer NOT NULL,
    crelate_id character varying,
    name character varying,
    createdon timestamp without time zone,
    modifiedon timestamp without time zone,
    updatedbyid character varying,
    createdbyid character varying,
    targetentityid character varying,
    targetentityid_type character varying,
    workflowtypeid character varying,
    statusid character varying,
    createdonsystem timestamp without time zone,
    namepart2 character varying,
    namepart1 character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- Name: academic_honors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_honors ALTER COLUMN id SET DEFAULT nextval('public.academic_honors_id_seq'::regclass);


--
-- Name: account_managers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_managers ALTER COLUMN id SET DEFAULT nextval('public.account_managers_id_seq'::regclass);


--
-- Name: account_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_sources ALTER COLUMN id SET DEFAULT nextval('public.account_sources_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: accreditations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accreditations ALTER COLUMN id SET DEFAULT nextval('public.accreditations_id_seq'::regclass);


--
-- Name: accrediting_institutions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accrediting_institutions ALTER COLUMN id SET DEFAULT nextval('public.accrediting_institutions_id_seq'::regclass);


--
-- Name: active_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_candidates ALTER COLUMN id SET DEFAULT nextval('public.active_candidates_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: acts_as_bookable_bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts_as_bookable_bookings ALTER COLUMN id SET DEFAULT nextval('public.acts_as_bookable_bookings_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: ahoy_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_messages ALTER COLUMN id SET DEFAULT nextval('public.ahoy_messages_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: applicant_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicant_batches ALTER COLUMN id SET DEFAULT nextval('public.applicant_batches_id_seq'::regclass);


--
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants ALTER COLUMN id SET DEFAULT nextval('public.applicants_id_seq'::regclass);


--
-- Name: applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications ALTER COLUMN id SET DEFAULT nextval('public.applications_id_seq'::regclass);


--
-- Name: archive_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archive_states ALTER COLUMN id SET DEFAULT nextval('public.archive_states_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments ALTER COLUMN id SET DEFAULT nextval('public.attachments_id_seq'::regclass);


--
-- Name: avatars id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avatars ALTER COLUMN id SET DEFAULT nextval('public.avatars_id_seq'::regclass);


--
-- Name: blacklists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blacklists ALTER COLUMN id SET DEFAULT nextval('public.blacklists_id_seq1'::regclass);


--
-- Name: call_sheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.call_sheets ALTER COLUMN id SET DEFAULT nextval('public.call_sheets_id_seq'::regclass);


--
-- Name: calls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calls ALTER COLUMN id SET DEFAULT nextval('public.calls_id_seq'::regclass);


--
-- Name: campaign_recipients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaign_recipients ALTER COLUMN id SET DEFAULT nextval('public.campaign_recipients_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: candidate_company_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_company_searches ALTER COLUMN id SET DEFAULT nextval('public.candidate_company_searches_id_seq'::regclass);


--
-- Name: candidate_location_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_location_searches ALTER COLUMN id SET DEFAULT nextval('public.candidate_location_searches_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: client_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_accounts ALTER COLUMN id SET DEFAULT nextval('public.client_accounts_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: company_positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_positions ALTER COLUMN id SET DEFAULT nextval('public.company_positions_id_seq'::regclass);


--
-- Name: company_profile_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_profile_jobs ALTER COLUMN id SET DEFAULT nextval('public.company_profile_jobs_id_seq'::regclass);


--
-- Name: company_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_profiles ALTER COLUMN id SET DEFAULT nextval('public.company_profiles_id_seq'::regclass);


--
-- Name: company_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_resources ALTER COLUMN id SET DEFAULT nextval('public.company_resources_id_seq'::regclass);


--
-- Name: contact_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_sources ALTER COLUMN id SET DEFAULT nextval('public.contact_sources_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: crelate_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crelate_users ALTER COLUMN id SET DEFAULT nextval('public.crelate_users_id_seq'::regclass);


--
-- Name: date_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.date_items ALTER COLUMN id SET DEFAULT nextval('public.date_items_id_seq'::regclass);


--
-- Name: dynamic_page_contents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dynamic_page_contents ALTER COLUMN id SET DEFAULT nextval('public.dynamic_page_contents_id_seq'::regclass);


--
-- Name: education_experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_experiences ALTER COLUMN id SET DEFAULT nextval('public.education_experiences_id_seq'::regclass);


--
-- Name: eeo_others id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eeo_others ALTER COLUMN id SET DEFAULT nextval('public.eeo_others_id_seq'::regclass);


--
-- Name: email_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses ALTER COLUMN id SET DEFAULT nextval('public.email_addresses_id_seq'::regclass);


--
-- Name: email_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_credentials ALTER COLUMN id SET DEFAULT nextval('public.email_credentials_id_seq'::regclass);


--
-- Name: email_lookups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_lookups ALTER COLUMN id SET DEFAULT nextval('public.email_lookups_id_seq'::regclass);


--
-- Name: email_sequences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_sequences ALTER COLUMN id SET DEFAULT nextval('public.email_sequences_id_seq'::regclass);


--
-- Name: employer_company_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_company_profiles ALTER COLUMN id SET DEFAULT nextval('public.employer_company_profiles_id_seq'::regclass);


--
-- Name: employer_dashboard id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_dashboard ALTER COLUMN id SET DEFAULT nextval('public.employer_dashboard_id_seq'::regclass);


--
-- Name: employer_sequence_to_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_sequence_to_people ALTER COLUMN id SET DEFAULT nextval('public.employer_sequence_to_people_id_seq'::regclass);


--
-- Name: entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- Name: experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences ALTER COLUMN id SET DEFAULT nextval('public.experiences_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: file_uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_uploads ALTER COLUMN id SET DEFAULT nextval('public.file_uploads_id_seq'::regclass);


--
-- Name: flagged_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flagged_candidates ALTER COLUMN id SET DEFAULT nextval('public.flagged_candidates_id_seq'::regclass);


--
-- Name: followed_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followed_candidates ALTER COLUMN id SET DEFAULT nextval('public.followed_candidates_id_seq'::regclass);


--
-- Name: follows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows ALTER COLUMN id SET DEFAULT nextval('public.follows_id_seq'::regclass);


--
-- Name: form_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_fields ALTER COLUMN id SET DEFAULT nextval('public.form_fields_id_seq'::regclass);


--
-- Name: form_responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_responses ALTER COLUMN id SET DEFAULT nextval('public.form_responses_id_seq'::regclass);


--
-- Name: forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forms ALTER COLUMN id SET DEFAULT nextval('public.forms_id_seq'::regclass);


--
-- Name: group_conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_conversations ALTER COLUMN id SET DEFAULT nextval('public.group_conversations_id_seq'::regclass);


--
-- Name: group_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages ALTER COLUMN id SET DEFAULT nextval('public.group_messages_id_seq'::regclass);


--
-- Name: hiring_managers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiring_managers ALTER COLUMN id SET DEFAULT nextval('public.hiring_managers_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: import_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_jobs ALTER COLUMN id SET DEFAULT nextval('public.import_jobs_id_seq'::regclass);


--
-- Name: incoming_mails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_mails ALTER COLUMN id SET DEFAULT nextval('public.incoming_mails_id_seq'::regclass);


--
-- Name: instant_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instant_addresses ALTER COLUMN id SET DEFAULT nextval('public.instant_addresses_id_seq'::regclass);


--
-- Name: intake_batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intake_batches ALTER COLUMN id SET DEFAULT nextval('public.intake_batches_id_seq'::regclass);


--
-- Name: interview_feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_feedbacks ALTER COLUMN id SET DEFAULT nextval('public.interview_feedbacks_id_seq'::regclass);


--
-- Name: interview_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_schedules ALTER COLUMN id SET DEFAULT nextval('public.interview_schedules_id_seq'::regclass);


--
-- Name: interviewees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviewees ALTER COLUMN id SET DEFAULT nextval('public.interviewees_id_seq'::regclass);


--
-- Name: interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews ALTER COLUMN id SET DEFAULT nextval('public.interviews_id_seq'::regclass);


--
-- Name: invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations ALTER COLUMN id SET DEFAULT nextval('public.invitations_id_seq'::regclass);


--
-- Name: invited_bies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invited_bies ALTER COLUMN id SET DEFAULT nextval('public.invited_bies_id_seq'::regclass);


--
-- Name: job_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_categories ALTER COLUMN id SET DEFAULT nextval('public.job_categories_id_seq'::regclass);


--
-- Name: job_companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_companies ALTER COLUMN id SET DEFAULT nextval('public.job_companies_id_seq'::regclass);


--
-- Name: job_experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_experiences ALTER COLUMN id SET DEFAULT nextval('public.job_experiences_id_seq'::regclass);


--
-- Name: job_locatables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_locatables ALTER COLUMN id SET DEFAULT nextval('public.job_locatables_id_seq'::regclass);


--
-- Name: job_location_interests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_location_interests ALTER COLUMN id SET DEFAULT nextval('public.job_location_interests_id_seq'::regclass);


--
-- Name: job_location_interests_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_location_interests_users ALTER COLUMN id SET DEFAULT nextval('public.job_location_interests_users_id_seq'::regclass);


--
-- Name: job_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_locations ALTER COLUMN id SET DEFAULT nextval('public.job_locations_id_seq'::regclass);


--
-- Name: job_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_posts ALTER COLUMN id SET DEFAULT nextval('public.job_posts_id_seq'::regclass);


--
-- Name: job_searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_searches ALTER COLUMN id SET DEFAULT nextval('public.job_searches_id_seq'::regclass);


--
-- Name: job_stage_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_stage_statuses ALTER COLUMN id SET DEFAULT nextval('public.job_stage_statuses_id_seq'::regclass);


--
-- Name: job_titles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_titles ALTER COLUMN id SET DEFAULT nextval('public.job_titles_id_seq'::regclass);


--
-- Name: job_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_types ALTER COLUMN id SET DEFAULT nextval('public.job_types_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: jobs_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_locations ALTER COLUMN id SET DEFAULT nextval('public.jobs_locations_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: lever_payload_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lever_payload_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.lever_payload_subscriptions_id_seq'::regclass);


--
-- Name: linked_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linked_accounts ALTER COLUMN id SET DEFAULT nextval('public.linked_accounts_id_seq'::regclass);


--
-- Name: linkedin_allow_import_profile id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_allow_import_profile ALTER COLUMN id SET DEFAULT nextval('public.linkedin_allow_import_profile_id_seq'::regclass);


--
-- Name: linkedin_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_data ALTER COLUMN id SET DEFAULT nextval('public.linkedin_data_id_seq'::regclass);


--
-- Name: linkedin_field_of_studies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_field_of_studies ALTER COLUMN id SET DEFAULT nextval('public.linkedin_field_of_studies_id_seq'::regclass);


--
-- Name: linkedin_industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_industries ALTER COLUMN id SET DEFAULT nextval('public.linkedin_industries_id_seq'::regclass);


--
-- Name: linkedin_profile_educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_educations ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profile_educations_id_seq'::regclass);


--
-- Name: linkedin_profile_positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_positions ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profile_positions_id_seq'::regclass);


--
-- Name: linkedin_profile_publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_publications ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profile_publications_id_seq'::regclass);


--
-- Name: linkedin_profile_recommendations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_recommendations ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profile_recommendations_id_seq'::regclass);


--
-- Name: linkedin_profile_url_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_url_resources ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profile_url_resources_id_seq'::regclass);


--
-- Name: linkedin_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profiles ALTER COLUMN id SET DEFAULT nextval('public.linkedin_profiles_id_seq'::regclass);


--
-- Name: linkedin_resumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_resumes ALTER COLUMN id SET DEFAULT nextval('public.linkedin_resumes_id_seq'::regclass);


--
-- Name: linkedin_schools id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_schools ALTER COLUMN id SET DEFAULT nextval('public.linkedin_schools_id_seq'::regclass);


--
-- Name: linkedinprofiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedinprofiles ALTER COLUMN id SET DEFAULT nextval('public.linkedinprofiles_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: lookups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lookups ALTER COLUMN id SET DEFAULT nextval('public.lookups_id_seq'::regclass);


--
-- Name: mailboxer_conversation_opt_outs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_conversation_opt_outs ALTER COLUMN id SET DEFAULT nextval('public.mailboxer_conversation_opt_outs_id_seq'::regclass);


--
-- Name: mailboxer_conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_conversations ALTER COLUMN id SET DEFAULT nextval('public.mailboxer_conversations_id_seq'::regclass);


--
-- Name: mailboxer_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_notifications ALTER COLUMN id SET DEFAULT nextval('public.mailboxer_notifications_id_seq'::regclass);


--
-- Name: mailboxer_receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_receipts ALTER COLUMN id SET DEFAULT nextval('public.mailboxer_receipts_id_seq'::regclass);


--
-- Name: managed_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_accounts ALTER COLUMN id SET DEFAULT nextval('public.managed_accounts_id_seq'::regclass);


--
-- Name: match_score_histograms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_score_histograms ALTER COLUMN id SET DEFAULT nextval('public.match_score_histograms_id_seq'::regclass);


--
-- Name: match_score_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_score_statuses ALTER COLUMN id SET DEFAULT nextval('public.match_score_statuses_id_seq'::regclass);


--
-- Name: match_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_scores ALTER COLUMN id SET DEFAULT nextval('public.match_scores_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: multi_lookups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_lookups ALTER COLUMN id SET DEFAULT nextval('public.multi_lookups_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: notified_objects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notified_objects ALTER COLUMN id SET DEFAULT nextval('public.notified_objects_id_seq'::regclass);


--
-- Name: onsite_interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onsite_interviews ALTER COLUMN id SET DEFAULT nextval('public.onsite_interviews_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: outgoing_mails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_mails ALTER COLUMN id SET DEFAULT nextval('public.outgoing_mails_id_seq'::regclass);


--
-- Name: outgoing_service_blacklists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_service_blacklists ALTER COLUMN id SET DEFAULT nextval('public.outgoing_service_blacklists_id_seq'::regclass);


--
-- Name: ownerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships ALTER COLUMN id SET DEFAULT nextval('public.ownerships_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: phone_interviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_interviews ALTER COLUMN id SET DEFAULT nextval('public.phone_interviews_id_seq'::regclass);


--
-- Name: phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.phone_numbers_id_seq'::regclass);


--
-- Name: placements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.placements ALTER COLUMN id SET DEFAULT nextval('public.placements_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: private_conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_conversations ALTER COLUMN id SET DEFAULT nextval('public.private_conversations_id_seq'::regclass);


--
-- Name: private_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_messages ALTER COLUMN id SET DEFAULT nextval('public.private_messages_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: recruiter_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_organizations ALTER COLUMN id SET DEFAULT nextval('public.recruiter_organizations_id_seq'::regclass);


--
-- Name: recruiter_updates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates ALTER COLUMN id SET DEFAULT nextval('public.recruiter_updates_id_seq'::regclass);


--
-- Name: referrals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals ALTER COLUMN id SET DEFAULT nextval('public.referrals_id_seq'::regclass);


--
-- Name: resume_grades id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resume_grades ALTER COLUMN id SET DEFAULT nextval('public.resume_grades_id_seq'::regclass);


--
-- Name: saved_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_candidates ALTER COLUMN id SET DEFAULT nextval('public.saved_candidates_id_seq'::regclass);


--
-- Name: searched_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searched_candidates ALTER COLUMN id SET DEFAULT nextval('public.searched_candidates_id_seq'::regclass);


--
-- Name: searches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searches ALTER COLUMN id SET DEFAULT nextval('public.searches_id_seq'::regclass);


--
-- Name: sign_up_contracts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sign_up_contracts ALTER COLUMN id SET DEFAULT nextval('public.sign_up_contracts_id_seq'::regclass);


--
-- Name: stage_transitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stage_transitions ALTER COLUMN id SET DEFAULT nextval('public.stage_transitions_id_seq'::regclass);


--
-- Name: static_list_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_list_items ALTER COLUMN id SET DEFAULT nextval('public.static_list_items_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions ALTER COLUMN id SET DEFAULT nextval('public.submissions_id_seq'::regclass);


--
-- Name: submittals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submittals ALTER COLUMN id SET DEFAULT nextval('public.submittals_id_seq'::regclass);


--
-- Name: submitted_candidates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates ALTER COLUMN id SET DEFAULT nextval('public.submitted_candidates_id_seq'::regclass);


--
-- Name: submitted_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests ALTER COLUMN id SET DEFAULT nextval('public.submitted_requests_id_seq'::regclass);


--
-- Name: sync_applicant id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_applicant ALTER COLUMN id SET DEFAULT nextval('public.sync_applicant_id_seq'::regclass);


--
-- Name: system_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_configurations ALTER COLUMN id SET DEFAULT nextval('public.system_configurations_id_seq'::regclass);


--
-- Name: tag_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_relationships ALTER COLUMN id SET DEFAULT nextval('public.tag_relationships_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: task_list_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_list_items ALTER COLUMN id SET DEFAULT nextval('public.task_list_items_id_seq'::regclass);


--
-- Name: timeline_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timeline_items ALTER COLUMN id SET DEFAULT nextval('public.timeline_items_id_seq'::regclass);


--
-- Name: unsubscribers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribers ALTER COLUMN id SET DEFAULT nextval('public.unsubscribers_id_seq'::regclass);


--
-- Name: unsubscribes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribes ALTER COLUMN id SET DEFAULT nextval('public.unsubscribes_id_seq'::regclass);


--
-- Name: uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads ALTER COLUMN id SET DEFAULT nextval('public.uploads_id_seq'::regclass);


--
-- Name: urls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls ALTER COLUMN id SET DEFAULT nextval('public.urls_id_seq'::regclass);


--
-- Name: usabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usabilities ALTER COLUMN id SET DEFAULT nextval('public.usabilities_id_seq'::regclass);


--
-- Name: user_contact_preferences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contact_preferences ALTER COLUMN id SET DEFAULT nextval('public.user_contact_preferences_id_seq'::regclass);


--
-- Name: user_education_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_education_jobs ALTER COLUMN id SET DEFAULT nextval('public.user_education_jobs_id_seq'::regclass);


--
-- Name: user_educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_educations ALTER COLUMN id SET DEFAULT nextval('public.user_educations_id_seq'::regclass);


--
-- Name: user_experiences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences ALTER COLUMN id SET DEFAULT nextval('public.user_experiences_id_seq'::regclass);


--
-- Name: user_mailing_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mailing_addresses ALTER COLUMN id SET DEFAULT nextval('public.user_mailing_addresses_id_seq'::regclass);


--
-- Name: user_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles ALTER COLUMN id SET DEFAULT nextval('public.user_profiles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: villagers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.villagers ALTER COLUMN id SET DEFAULT nextval('public.villagers_id_seq'::regclass);


--
-- Name: vip_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vip_resources ALTER COLUMN id SET DEFAULT nextval('public.vip_resources_id_seq'::regclass);


--
-- Name: vip_scheduler_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vip_scheduler_tables ALTER COLUMN id SET DEFAULT nextval('public.vip_scheduler_tables_id_seq'::regclass);


--
-- Name: workflow_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_items ALTER COLUMN id SET DEFAULT nextval('public.workflow_items_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Name: academic_honors academic_honors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.academic_honors
    ADD CONSTRAINT academic_honors_pkey PRIMARY KEY (id);


--
-- Name: account_managers account_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_managers
    ADD CONSTRAINT account_managers_pkey PRIMARY KEY (id);


--
-- Name: account_sources account_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_sources
    ADD CONSTRAINT account_sources_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: accreditations accreditations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accreditations
    ADD CONSTRAINT accreditations_pkey PRIMARY KEY (id);


--
-- Name: accrediting_institutions accrediting_institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accrediting_institutions
    ADD CONSTRAINT accrediting_institutions_pkey PRIMARY KEY (id);


--
-- Name: active_candidates active_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_candidates
    ADD CONSTRAINT active_candidates_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: acts_as_bookable_bookings acts_as_bookable_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts_as_bookable_bookings
    ADD CONSTRAINT acts_as_bookable_bookings_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ahoy_messages ahoy_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_messages
    ADD CONSTRAINT ahoy_messages_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: applicant_batches applicant_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicant_batches
    ADD CONSTRAINT applicant_batches_pkey PRIMARY KEY (id);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: archive_states archive_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archive_states
    ADD CONSTRAINT archive_states_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: attachments attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: avatars avatars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.avatars
    ADD CONSTRAINT avatars_pkey PRIMARY KEY (id);


--
-- Name: blacklists blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blacklists
    ADD CONSTRAINT blacklists_pkey PRIMARY KEY (id);


--
-- Name: call_sheets call_sheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.call_sheets
    ADD CONSTRAINT call_sheets_pkey PRIMARY KEY (id);


--
-- Name: calls calls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calls
    ADD CONSTRAINT calls_pkey PRIMARY KEY (id);


--
-- Name: campaign_recipients campaign_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaign_recipients
    ADD CONSTRAINT campaign_recipients_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: candidate_company_searches candidate_company_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_company_searches
    ADD CONSTRAINT candidate_company_searches_pkey PRIMARY KEY (id);


--
-- Name: candidate_location_searches candidate_location_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_location_searches
    ADD CONSTRAINT candidate_location_searches_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: client_accounts client_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_accounts
    ADD CONSTRAINT client_accounts_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: company_positions company_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_positions
    ADD CONSTRAINT company_positions_pkey PRIMARY KEY (id);


--
-- Name: company_profile_jobs company_profile_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_profile_jobs
    ADD CONSTRAINT company_profile_jobs_pkey PRIMARY KEY (id);


--
-- Name: company_profiles company_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_profiles
    ADD CONSTRAINT company_profiles_pkey PRIMARY KEY (id);


--
-- Name: company_resources company_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_resources
    ADD CONSTRAINT company_resources_pkey PRIMARY KEY (id);


--
-- Name: contact_sources contact_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_sources
    ADD CONSTRAINT contact_sources_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: crelate_users crelate_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crelate_users
    ADD CONSTRAINT crelate_users_pkey PRIMARY KEY (id);


--
-- Name: date_items date_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.date_items
    ADD CONSTRAINT date_items_pkey PRIMARY KEY (id);


--
-- Name: dynamic_page_contents dynamic_page_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dynamic_page_contents
    ADD CONSTRAINT dynamic_page_contents_pkey PRIMARY KEY (id);


--
-- Name: education_experiences education_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_experiences
    ADD CONSTRAINT education_experiences_pkey PRIMARY KEY (id);


--
-- Name: eeo_others eeo_others_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eeo_others
    ADD CONSTRAINT eeo_others_pkey PRIMARY KEY (id);


--
-- Name: email_addresses email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: email_credentials email_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_credentials
    ADD CONSTRAINT email_credentials_pkey PRIMARY KEY (id);


--
-- Name: email_lookups email_lookups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_lookups
    ADD CONSTRAINT email_lookups_pkey PRIMARY KEY (id);


--
-- Name: email_sequences email_sequences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_sequences
    ADD CONSTRAINT email_sequences_pkey PRIMARY KEY (id);


--
-- Name: employer_company_profiles employer_company_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_company_profiles
    ADD CONSTRAINT employer_company_profiles_pkey PRIMARY KEY (id);


--
-- Name: employer_dashboard employer_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_dashboard
    ADD CONSTRAINT employer_dashboard_pkey PRIMARY KEY (id);


--
-- Name: employer_sequence_to_people employer_sequence_to_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_sequence_to_people
    ADD CONSTRAINT employer_sequence_to_people_pkey PRIMARY KEY (id);


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: file_uploads file_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_uploads
    ADD CONSTRAINT file_uploads_pkey PRIMARY KEY (id);


--
-- Name: flagged_candidates flagged_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flagged_candidates
    ADD CONSTRAINT flagged_candidates_pkey PRIMARY KEY (id);


--
-- Name: followed_candidates followed_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followed_candidates
    ADD CONSTRAINT followed_candidates_pkey PRIMARY KEY (id);


--
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: form_fields form_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_fields
    ADD CONSTRAINT form_fields_pkey PRIMARY KEY (id);


--
-- Name: form_responses form_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.form_responses
    ADD CONSTRAINT form_responses_pkey PRIMARY KEY (id);


--
-- Name: forms forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (id);


--
-- Name: group_conversations group_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_conversations
    ADD CONSTRAINT group_conversations_pkey PRIMARY KEY (id);


--
-- Name: group_messages group_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages
    ADD CONSTRAINT group_messages_pkey PRIMARY KEY (id);


--
-- Name: hiring_managers hiring_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.hiring_managers
    ADD CONSTRAINT hiring_managers_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: import_jobs import_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_jobs
    ADD CONSTRAINT import_jobs_pkey PRIMARY KEY (id);


--
-- Name: incoming_mails incoming_mails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incoming_mails
    ADD CONSTRAINT incoming_mails_pkey PRIMARY KEY (id);


--
-- Name: instant_addresses instant_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.instant_addresses
    ADD CONSTRAINT instant_addresses_pkey PRIMARY KEY (id);


--
-- Name: intake_batches intake_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intake_batches
    ADD CONSTRAINT intake_batches_pkey PRIMARY KEY (id);


--
-- Name: interview_feedbacks interview_feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_feedbacks
    ADD CONSTRAINT interview_feedbacks_pkey PRIMARY KEY (id);


--
-- Name: interview_schedules interview_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_schedules
    ADD CONSTRAINT interview_schedules_pkey PRIMARY KEY (id);


--
-- Name: interviewees interviewees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviewees
    ADD CONSTRAINT interviewees_pkey PRIMARY KEY (id);


--
-- Name: interviews interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT interviews_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: invited_bies invited_bies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invited_bies
    ADD CONSTRAINT invited_bies_pkey PRIMARY KEY (id);


--
-- Name: job_categories job_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_categories
    ADD CONSTRAINT job_categories_pkey PRIMARY KEY (id);


--
-- Name: job_companies job_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_companies
    ADD CONSTRAINT job_companies_pkey PRIMARY KEY (id);


--
-- Name: job_experiences job_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_experiences
    ADD CONSTRAINT job_experiences_pkey PRIMARY KEY (id);


--
-- Name: job_locatables job_locatables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_locatables
    ADD CONSTRAINT job_locatables_pkey PRIMARY KEY (id);


--
-- Name: job_location_interests job_location_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_location_interests
    ADD CONSTRAINT job_location_interests_pkey PRIMARY KEY (id);


--
-- Name: job_location_interests_users job_location_interests_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_location_interests_users
    ADD CONSTRAINT job_location_interests_users_pkey PRIMARY KEY (id);


--
-- Name: job_locations job_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_locations
    ADD CONSTRAINT job_locations_pkey PRIMARY KEY (id);


--
-- Name: job_posts job_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_posts
    ADD CONSTRAINT job_posts_pkey PRIMARY KEY (id);


--
-- Name: job_searches job_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_searches
    ADD CONSTRAINT job_searches_pkey PRIMARY KEY (id);


--
-- Name: job_stage_statuses job_stage_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_stage_statuses
    ADD CONSTRAINT job_stage_statuses_pkey PRIMARY KEY (id);


--
-- Name: job_titles job_titles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_titles
    ADD CONSTRAINT job_titles_pkey PRIMARY KEY (id);


--
-- Name: job_types job_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_types
    ADD CONSTRAINT job_types_pkey PRIMARY KEY (id);


--
-- Name: jobs_locations jobs_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs_locations
    ADD CONSTRAINT jobs_locations_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: lever_payload_subscriptions lever_payload_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lever_payload_subscriptions
    ADD CONSTRAINT lever_payload_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: linked_accounts linked_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linked_accounts
    ADD CONSTRAINT linked_accounts_pkey PRIMARY KEY (id);


--
-- Name: linkedin_allow_import_profile linkedin_allow_import_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_allow_import_profile
    ADD CONSTRAINT linkedin_allow_import_profile_pkey PRIMARY KEY (id);


--
-- Name: linkedin_data linkedin_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_data
    ADD CONSTRAINT linkedin_data_pkey PRIMARY KEY (id);


--
-- Name: linkedin_field_of_studies linkedin_field_of_studies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_field_of_studies
    ADD CONSTRAINT linkedin_field_of_studies_pkey PRIMARY KEY (id);


--
-- Name: linkedin_industries linkedin_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_industries
    ADD CONSTRAINT linkedin_industries_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profile_educations linkedin_profile_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_educations
    ADD CONSTRAINT linkedin_profile_educations_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profile_positions linkedin_profile_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_positions
    ADD CONSTRAINT linkedin_profile_positions_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profile_publications linkedin_profile_publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_publications
    ADD CONSTRAINT linkedin_profile_publications_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profile_recommendations linkedin_profile_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_recommendations
    ADD CONSTRAINT linkedin_profile_recommendations_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profile_url_resources linkedin_profile_url_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_url_resources
    ADD CONSTRAINT linkedin_profile_url_resources_pkey PRIMARY KEY (id);


--
-- Name: linkedin_profiles linkedin_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_pkey PRIMARY KEY (id);


--
-- Name: linkedin_resumes linkedin_resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_resumes
    ADD CONSTRAINT linkedin_resumes_pkey PRIMARY KEY (id);


--
-- Name: linkedin_schools linkedin_schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_schools
    ADD CONSTRAINT linkedin_schools_pkey PRIMARY KEY (id);


--
-- Name: linkedinprofiles linkedinprofiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedinprofiles
    ADD CONSTRAINT linkedinprofiles_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: lookups lookups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lookups
    ADD CONSTRAINT lookups_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversation_opt_outs mailboxer_conversation_opt_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_conversation_opt_outs
    ADD CONSTRAINT mailboxer_conversation_opt_outs_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversations mailboxer_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_conversations
    ADD CONSTRAINT mailboxer_conversations_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_notifications mailboxer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_notifications
    ADD CONSTRAINT mailboxer_notifications_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_receipts mailboxer_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_receipts
    ADD CONSTRAINT mailboxer_receipts_pkey PRIMARY KEY (id);


--
-- Name: managed_accounts managed_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_accounts
    ADD CONSTRAINT managed_accounts_pkey PRIMARY KEY (id);


--
-- Name: match_score_histograms match_score_histograms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_score_histograms
    ADD CONSTRAINT match_score_histograms_pkey PRIMARY KEY (id);


--
-- Name: match_score_statuses match_score_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_score_statuses
    ADD CONSTRAINT match_score_statuses_pkey PRIMARY KEY (id);


--
-- Name: match_scores match_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_scores
    ADD CONSTRAINT match_scores_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: multi_lookups multi_lookups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_lookups
    ADD CONSTRAINT multi_lookups_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notified_objects notified_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notified_objects
    ADD CONSTRAINT notified_objects_pkey PRIMARY KEY (id);


--
-- Name: onsite_interviews onsite_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onsite_interviews
    ADD CONSTRAINT onsite_interviews_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: outgoing_mails outgoing_mails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_mails
    ADD CONSTRAINT outgoing_mails_pkey PRIMARY KEY (id);


--
-- Name: outgoing_service_blacklists outgoing_service_blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_service_blacklists
    ADD CONSTRAINT outgoing_service_blacklists_pkey PRIMARY KEY (id);


--
-- Name: ownerships ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ownerships
    ADD CONSTRAINT ownerships_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: phone_interviews phone_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_interviews
    ADD CONSTRAINT phone_interviews_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: placements placements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: private_conversations private_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_conversations
    ADD CONSTRAINT private_conversations_pkey PRIMARY KEY (id);


--
-- Name: private_messages private_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_messages
    ADD CONSTRAINT private_messages_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: recruiter_organizations recruiter_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_organizations
    ADD CONSTRAINT recruiter_organizations_pkey PRIMARY KEY (id);


--
-- Name: recruiter_updates recruiter_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT recruiter_updates_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (id);


--
-- Name: resume_grades resume_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resume_grades
    ADD CONSTRAINT resume_grades_pkey PRIMARY KEY (id);


--
-- Name: saved_candidates saved_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_candidates
    ADD CONSTRAINT saved_candidates_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: searched_candidates searched_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searched_candidates
    ADD CONSTRAINT searched_candidates_pkey PRIMARY KEY (id);


--
-- Name: searches searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: sign_up_contracts sign_up_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sign_up_contracts
    ADD CONSTRAINT sign_up_contracts_pkey PRIMARY KEY (id);


--
-- Name: stage_transitions stage_transitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stage_transitions
    ADD CONSTRAINT stage_transitions_pkey PRIMARY KEY (id);


--
-- Name: static_list_items static_list_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_list_items
    ADD CONSTRAINT static_list_items_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: submissions submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: submittals submittals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submittals
    ADD CONSTRAINT submittals_pkey PRIMARY KEY (id);


--
-- Name: submitted_candidates submitted_candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates
    ADD CONSTRAINT submitted_candidates_pkey PRIMARY KEY (id);


--
-- Name: submitted_requests submitted_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests
    ADD CONSTRAINT submitted_requests_pkey PRIMARY KEY (id);


--
-- Name: sync_applicant sync_applicant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_applicant
    ADD CONSTRAINT sync_applicant_pkey PRIMARY KEY (id);


--
-- Name: system_configurations system_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_configurations
    ADD CONSTRAINT system_configurations_pkey PRIMARY KEY (id);


--
-- Name: tag_relationships tag_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_relationships
    ADD CONSTRAINT tag_relationships_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_list_items task_list_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_list_items
    ADD CONSTRAINT task_list_items_pkey PRIMARY KEY (id);


--
-- Name: timeline_items timeline_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timeline_items
    ADD CONSTRAINT timeline_items_pkey PRIMARY KEY (id);


--
-- Name: unsubscribers unsubscribers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribers
    ADD CONSTRAINT unsubscribers_pkey PRIMARY KEY (id);


--
-- Name: unsubscribes unsubscribes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unsubscribes
    ADD CONSTRAINT unsubscribes_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: urls urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.urls
    ADD CONSTRAINT urls_pkey PRIMARY KEY (id);


--
-- Name: usabilities usabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usabilities
    ADD CONSTRAINT usabilities_pkey PRIMARY KEY (id);


--
-- Name: user_contact_preferences user_contact_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contact_preferences
    ADD CONSTRAINT user_contact_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_education_jobs user_education_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_education_jobs
    ADD CONSTRAINT user_education_jobs_pkey PRIMARY KEY (id);


--
-- Name: user_educations user_educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_educations
    ADD CONSTRAINT user_educations_pkey PRIMARY KEY (id);


--
-- Name: user_experiences user_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences
    ADD CONSTRAINT user_experiences_pkey PRIMARY KEY (id);


--
-- Name: user_mailing_addresses user_mailing_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mailing_addresses
    ADD CONSTRAINT user_mailing_addresses_pkey PRIMARY KEY (id);


--
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: villagers villagers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.villagers
    ADD CONSTRAINT villagers_pkey PRIMARY KEY (id);


--
-- Name: vip_resources vip_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vip_resources
    ADD CONSTRAINT vip_resources_pkey PRIMARY KEY (id);


--
-- Name: vip_scheduler_tables vip_scheduler_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vip_scheduler_tables
    ADD CONSTRAINT vip_scheduler_tables_pkey PRIMARY KEY (id);


--
-- Name: workflow_items workflow_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_items
    ADD CONSTRAINT workflow_items_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: fk_followables; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_followables ON public.follows USING btree (followable_id, followable_type);


--
-- Name: fk_follows; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_follows ON public.follows USING btree (follower_id, follower_type);


--
-- Name: for_edu_upsert; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX for_edu_upsert ON public.education_experiences USING btree (school_name, person_id, "from", "to");


--
-- Name: index_academic_honors_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_academic_honors_on_crelate_id ON public.academic_honors USING btree (crelate_id);


--
-- Name: index_account_sources_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_account_sources_on_crelate_id ON public.account_sources USING btree (crelate_id);


--
-- Name: index_accounts_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_crelate_id ON public.accounts USING btree (crelate_id);


--
-- Name: index_accounts_on_recruiter_update_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_recruiter_update_id ON public.accounts USING btree (recruiter_update_id);


--
-- Name: index_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_user_id ON public.accounts USING btree (user_id);


--
-- Name: index_accreditations_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accreditations_on_crelate_id ON public.accreditations USING btree (crelate_id);


--
-- Name: index_accrediting_institutions_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accrediting_institutions_on_crelate_id ON public.accrediting_institutions USING btree (crelate_id);


--
-- Name: index_active_candidates_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_candidates_on_job_id ON public.active_candidates USING btree (job_id);


--
-- Name: index_active_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_candidates_on_person_id ON public.active_candidates USING btree (person_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_acts_as_bookable_bookings_bookable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_acts_as_bookable_bookings_bookable ON public.acts_as_bookable_bookings USING btree (bookable_type, bookable_id);


--
-- Name: index_acts_as_bookable_bookings_booker; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_acts_as_bookable_bookings_booker ON public.acts_as_bookable_bookings USING btree (booker_type, booker_id);


--
-- Name: index_addresses_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_crelate_id ON public.addresses USING btree (crelate_id);


--
-- Name: index_addresses_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_person_id ON public.addresses USING btree (person_id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_user_id ON public.admins USING btree (user_id);


--
-- Name: index_ahoy_messages_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_messages_on_token ON public.ahoy_messages USING btree (token);


--
-- Name: index_ahoy_messages_on_user_type_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_messages_on_user_type_and_user_id ON public.ahoy_messages USING btree (user_type, user_id);


--
-- Name: index_answers_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_person_id ON public.answers USING btree (person_id);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_question_id ON public.answers USING btree (question_id);


--
-- Name: index_applicants_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applicants_on_organization_id ON public.applicants USING btree (organization_id);


--
-- Name: index_applications_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_crelate_id ON public.applications USING btree (crelate_id);


--
-- Name: index_archive_states_on_lever_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_archive_states_on_lever_id ON public.archive_states USING btree (lever_id);


--
-- Name: index_archive_states_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_archive_states_on_person_id ON public.archive_states USING btree (person_id);


--
-- Name: index_attachments_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_attachments_on_crelate_id ON public.attachments USING btree (crelate_id);


--
-- Name: index_blacklists_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blacklists_on_person_id ON public.blacklists USING btree (person_id);


--
-- Name: index_blacklists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blacklists_on_user_id ON public.blacklists USING btree (user_id);


--
-- Name: index_by_links; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_by_links ON public.people USING btree (links);


--
-- Name: index_by_referral; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_by_referral ON public.referrals USING btree (invitee_code, invitee_email);


--
-- Name: index_call_sheets_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_call_sheets_on_person_id ON public.call_sheets USING btree (person_id);


--
-- Name: index_call_sheets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_call_sheets_on_user_id ON public.call_sheets USING btree (user_id);


--
-- Name: index_calls_on_call_sheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calls_on_call_sheet_id ON public.calls USING btree (call_sheet_id);


--
-- Name: index_calls_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calls_on_person_id ON public.calls USING btree (person_id);


--
-- Name: index_calls_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_calls_on_user_id ON public.calls USING btree (user_id);


--
-- Name: index_campaign_recipients_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_campaign_recipients_on_organization_id ON public.campaign_recipients USING btree (organization_id);


--
-- Name: index_comments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_person_id ON public.comments USING btree (person_id);


--
-- Name: index_comments_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_post_id ON public.comments USING btree (post_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_company_positions_on_email_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_email_address_id ON public.company_positions USING btree (email_address_id);


--
-- Name: index_company_positions_on_email_address_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_email_address_id_id ON public.company_positions USING btree (email_address_id_id);


--
-- Name: index_company_positions_on_linkedin_profile_position_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_linkedin_profile_position_id ON public.company_positions USING btree (linkedin_profile_position_id);


--
-- Name: index_company_positions_on_linkedin_profile_position_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_linkedin_profile_position_id_id ON public.company_positions USING btree (linkedin_profile_position_id_id);


--
-- Name: index_company_positions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_person_id ON public.company_positions USING btree (person_id);


--
-- Name: index_company_positions_on_person_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_person_id_id ON public.company_positions USING btree (person_id_id);


--
-- Name: index_company_positions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_positions_on_user_id ON public.company_positions USING btree (user_id);


--
-- Name: index_contact_sources_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contact_sources_on_crelate_id ON public.contact_sources USING btree (crelate_id);


--
-- Name: index_contacts_on_email_and_phone_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_email_and_phone_number ON public.contacts USING btree (email, phone_number);


--
-- Name: index_contacts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_contacts_on_user_id ON public.contacts USING btree (user_id);


--
-- Name: index_conversations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_conversations_on_user_id ON public.conversations USING btree (user_id);


--
-- Name: index_crelate_users_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_crelate_users_on_crelate_id ON public.crelate_users USING btree (crelate_id);


--
-- Name: index_date_items_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_date_items_on_crelate_id ON public.date_items USING btree (crelate_id);


--
-- Name: index_education_experiences_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_education_experiences_on_person_id ON public.education_experiences USING btree (person_id);


--
-- Name: index_eeo_others_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_eeo_others_on_crelate_id ON public.eeo_others USING btree (crelate_id);


--
-- Name: index_email_addresses_on_email_and_email_type_and_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_email_addresses_on_email_and_email_type_and_person_id ON public.email_addresses USING btree (email, email_type, person_id);


--
-- Name: index_email_addresses_on_linkedin_profile_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_addresses_on_linkedin_profile_id_id ON public.email_addresses USING btree (linkedin_profile_id_id);


--
-- Name: index_email_lookups_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_lookups_on_crelate_id ON public.email_lookups USING btree (crelate_id);


--
-- Name: index_email_sequences_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_sequences_on_job_id ON public.email_sequences USING btree (job_id);


--
-- Name: index_employer_company_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_company_profiles_on_user_id ON public.employer_company_profiles USING btree (user_id);


--
-- Name: index_employer_dashboard_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_dashboard_on_job_id ON public.employer_dashboard USING btree (job_id);


--
-- Name: index_employer_dashboard_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_dashboard_on_organization_id ON public.employer_dashboard USING btree (organization_id);


--
-- Name: index_employer_dashboard_on_organization_id_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_dashboard_on_organization_id_and_job_id ON public.employer_dashboard USING btree (organization_id, job_id);


--
-- Name: index_employer_sequence_to_people_on_email_sequence_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_sequence_to_people_on_email_sequence_id ON public.employer_sequence_to_people USING btree (email_sequence_id);


--
-- Name: index_employer_sequence_to_people_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employer_sequence_to_people_on_person_id ON public.employer_sequence_to_people USING btree (person_id);


--
-- Name: index_entries_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_user_id ON public.entries USING btree (user_id);


--
-- Name: index_experiences_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiences_on_crelate_id ON public.experiences USING btree (crelate_id);


--
-- Name: index_feedbacks_on_interview_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feedbacks_on_interview_schedule_id ON public.feedbacks USING btree (interview_schedule_id);


--
-- Name: index_flagged_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flagged_candidates_on_person_id ON public.flagged_candidates USING btree (person_id);


--
-- Name: index_flagged_candidates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flagged_candidates_on_user_id ON public.flagged_candidates USING btree (user_id);


--
-- Name: index_followed_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followed_candidates_on_person_id ON public.followed_candidates USING btree (person_id);


--
-- Name: index_followed_candidates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followed_candidates_on_user_id ON public.followed_candidates USING btree (user_id);


--
-- Name: index_follows_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_follows_on_user_id ON public.follows USING btree (user_id);


--
-- Name: index_form_fields_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_fields_on_crelate_id ON public.form_fields USING btree (crelate_id);


--
-- Name: index_form_responses_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_form_responses_on_crelate_id ON public.form_responses USING btree (crelate_id);


--
-- Name: index_forms_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_forms_on_crelate_id ON public.forms USING btree (crelate_id);


--
-- Name: index_group_conversations_users_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_conversations_users_on_conversation_id ON public.group_conversations_users USING btree (conversation_id);


--
-- Name: index_group_conversations_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_conversations_users_on_user_id ON public.group_conversations_users USING btree (user_id);


--
-- Name: index_group_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_messages_on_conversation_id ON public.group_messages USING btree (conversation_id);


--
-- Name: index_group_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_messages_on_user_id ON public.group_messages USING btree (user_id);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_user_id ON public.identities USING btree (user_id);


--
-- Name: index_instant_addresses_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_instant_addresses_on_crelate_id ON public.instant_addresses USING btree (crelate_id);


--
-- Name: index_intake_batches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_intake_batches_on_user_id ON public.intake_batches USING btree (user_id);


--
-- Name: index_interview_feedbacks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_interview_feedbacks_on_user_id ON public.interview_feedbacks USING btree (user_id);


--
-- Name: index_interview_schedules_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_interview_schedules_on_job_id ON public.interview_schedules USING btree (job_id);


--
-- Name: index_interviews_on_interviewee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_interviews_on_interviewee_id ON public.interviews USING btree (interviewee_id);


--
-- Name: index_interviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_interviews_on_user_id ON public.interviews USING btree (user_id);


--
-- Name: index_invitations_on_invited_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_invited_user_id ON public.invitations USING btree (invited_user_id);


--
-- Name: index_invitations_on_inviting_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_inviting_user_id ON public.invitations USING btree (inviting_user_id);


--
-- Name: index_invitations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invitations_on_organization_id ON public.invitations USING btree (organization_id);


--
-- Name: index_job_experiences_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_experiences_on_person_id ON public.job_experiences USING btree (person_id);


--
-- Name: index_job_location_interests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_location_interests_on_user_id ON public.job_location_interests USING btree (user_id);


--
-- Name: index_job_locations_on_job_locatable_id_and_job_locatable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_locations_on_job_locatable_id_and_job_locatable_type ON public.job_locations USING btree (job_locatable_id, job_locatable_type);


--
-- Name: index_job_posts_on_hiring_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_posts_on_hiring_manager_id ON public.job_posts USING btree (hiring_manager_id);


--
-- Name: index_job_posts_on_job_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_posts_on_job_category_id ON public.job_posts USING btree (job_category_id);


--
-- Name: index_job_posts_on_job_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_posts_on_job_company_id ON public.job_posts USING btree (job_company_id);


--
-- Name: index_job_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_posts_on_user_id ON public.job_posts USING btree (user_id);


--
-- Name: index_job_searches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_searches_on_user_id ON public.job_searches USING btree (user_id);


--
-- Name: index_job_stage_statuses_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_stage_statuses_on_job_id ON public.job_stage_statuses USING btree (job_id);


--
-- Name: index_job_stage_statuses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_stage_statuses_on_user_id ON public.job_stage_statuses USING btree (user_id);


--
-- Name: index_job_titles_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_titles_on_crelate_id ON public.job_titles USING btree (crelate_id);


--
-- Name: index_job_types_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_types_on_crelate_id ON public.job_types USING btree (crelate_id);


--
-- Name: index_jobs_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_creator_id ON public.jobs USING btree (creator_id);


--
-- Name: index_jobs_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_discarded_at ON public.jobs USING btree (discarded_at);


--
-- Name: index_jobs_on_managed_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_managed_account_id ON public.jobs USING btree (managed_account_id);


--
-- Name: index_jobs_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_organization_id ON public.jobs USING btree (organization_id);


--
-- Name: index_jobs_on_recruiter_update_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_recruiter_update_id ON public.jobs USING btree (recruiter_update_id);


--
-- Name: index_linked_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_accounts_on_user_id ON public.linked_accounts USING btree (user_id);


--
-- Name: index_linkedin_industries_on_linkedin_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_industries_on_linkedin_profile_id ON public.linkedin_industries USING btree (linkedin_profile_id);


--
-- Name: index_linkedin_industries_on_linkedin_profiles_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_industries_on_linkedin_profiles_id ON public.linkedin_industries USING btree (linkedin_profiles_id);


--
-- Name: index_linkedin_profile_educations_on_linkedin_field_of_study_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_educations_on_linkedin_field_of_study_id ON public.linkedin_profile_educations USING btree (linkedin_field_of_study_id);


--
-- Name: index_linkedin_profile_educations_on_linkedin_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_educations_on_linkedin_profile_id ON public.linkedin_profile_educations USING btree (linkedin_profile_id);


--
-- Name: index_linkedin_profile_educations_on_linkedin_school_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_educations_on_linkedin_school_id ON public.linkedin_profile_educations USING btree (linkedin_school_id);


--
-- Name: index_linkedin_profile_educations_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_educations_on_person_id ON public.linkedin_profile_educations USING btree (person_id);


--
-- Name: index_linkedin_profile_educations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_educations_on_user_id ON public.linkedin_profile_educations USING btree (user_id);


--
-- Name: index_linkedin_profile_positions_on_linkedin_profile_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_positions_on_linkedin_profile_id_id ON public.linkedin_profile_positions USING btree (linkedin_profile_id_id);


--
-- Name: index_linkedin_profile_positions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_positions_on_person_id ON public.linkedin_profile_positions USING btree (person_id);


--
-- Name: index_linkedin_profile_positions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_positions_on_user_id ON public.linkedin_profile_positions USING btree (user_id);


--
-- Name: index_linkedin_profile_publications_on_linkedin_profile_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_publications_on_linkedin_profile_id_id ON public.linkedin_profile_publications USING btree (linkedin_profile_id_id);


--
-- Name: index_linkedin_profile_publications_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_publications_on_person_id ON public.linkedin_profile_publications USING btree (person_id);


--
-- Name: index_linkedin_profile_recommendations_on_linkedin_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_recommendations_on_linkedin_profile_id ON public.linkedin_profile_recommendations USING btree (linkedin_profile_id);


--
-- Name: index_linkedin_profile_recommendations_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_recommendations_on_person_id ON public.linkedin_profile_recommendations USING btree (person_id);


--
-- Name: index_linkedin_profile_recommendations_on_recommender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_recommendations_on_recommender_id ON public.linkedin_profile_recommendations USING btree (recommender_id);


--
-- Name: index_linkedin_profile_url_resources_on_linkedin_profile_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_url_resources_on_linkedin_profile_id_id ON public.linkedin_profile_url_resources USING btree (linkedin_profile_id_id);


--
-- Name: index_linkedin_profile_url_resources_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profile_url_resources_on_person_id ON public.linkedin_profile_url_resources USING btree (person_id);


--
-- Name: index_linkedin_profiles_on_linkedin_industry_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profiles_on_linkedin_industry_id_id ON public.linkedin_profiles USING btree (linkedin_industry_id_id);


--
-- Name: index_linkedin_profiles_on_linkedin_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_profiles_on_linkedin_profile_id ON public.linkedin_profiles USING btree (linkedin_profile_id);


--
-- Name: index_linkedin_resumes_on_incoming_mail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_resumes_on_incoming_mail_id ON public.linkedin_resumes USING btree (incoming_mail_id);


--
-- Name: index_linkedin_schools_on_LinkedinProfileEducation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "index_linkedin_schools_on_LinkedinProfileEducation_id" ON public.linkedin_schools USING btree ("LinkedinProfileEducation_id");


--
-- Name: index_linkedin_schools_on_linkedin_profile_education_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linkedin_schools_on_linkedin_profile_education_id ON public.linkedin_schools USING btree (linkedin_profile_education_id);


--
-- Name: index_lookups_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lookups_on_name ON public.lookups USING btree (name);


--
-- Name: index_mailboxer_conversation_opt_outs_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_conversation_id ON public.mailboxer_conversation_opt_outs USING btree (conversation_id);


--
-- Name: index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type ON public.mailboxer_conversation_opt_outs USING btree (unsubscriber_id, unsubscriber_type);


--
-- Name: index_mailboxer_notifications_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_notifications_on_conversation_id ON public.mailboxer_notifications USING btree (conversation_id);


--
-- Name: index_mailboxer_notifications_on_notified_object_id_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_notifications_on_notified_object_id_and_type ON public.mailboxer_notifications USING btree (notified_object_id, notified_object_type);


--
-- Name: index_mailboxer_notifications_on_sender_id_and_sender_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_notifications_on_sender_id_and_sender_type ON public.mailboxer_notifications USING btree (sender_id, sender_type);


--
-- Name: index_mailboxer_notifications_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_notifications_on_type ON public.mailboxer_notifications USING btree (type);


--
-- Name: index_mailboxer_receipts_on_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_receipts_on_message_id ON public.mailboxer_receipts USING btree (message_id);


--
-- Name: index_mailboxer_receipts_on_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_receipts_on_notification_id ON public.mailboxer_receipts USING btree (notification_id);


--
-- Name: index_mailboxer_receipts_on_receiver_id_and_receiver_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailboxer_receipts_on_receiver_id_and_receiver_type ON public.mailboxer_receipts USING btree (receiver_id, receiver_type);


--
-- Name: index_managed_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managed_accounts_on_user_id ON public.managed_accounts USING btree (user_id);


--
-- Name: index_match_score_statuses_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_score_statuses_on_person_id ON public.match_score_statuses USING btree (person_id);


--
-- Name: index_match_scores_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_scores_on_job_id ON public.match_scores USING btree (job_id);


--
-- Name: index_match_scores_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_scores_on_person_id ON public.match_scores USING btree (person_id);


--
-- Name: index_messages_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_person_id ON public.messages USING btree (person_id);


--
-- Name: index_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_user_id ON public.messages USING btree (user_id);


--
-- Name: index_multi_lookups_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_multi_lookups_on_crelate_id ON public.multi_lookups USING btree (crelate_id);


--
-- Name: index_notes_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_person_id ON public.notes USING btree (person_id);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_user_id ON public.notes USING btree (user_id);


--
-- Name: index_onsite_interviews_on_call_sheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_onsite_interviews_on_call_sheet_id ON public.onsite_interviews USING btree (call_sheet_id);


--
-- Name: index_onsite_interviews_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_onsite_interviews_on_person_id ON public.onsite_interviews USING btree (person_id);


--
-- Name: index_onsite_interviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_onsite_interviews_on_user_id ON public.onsite_interviews USING btree (user_id);


--
-- Name: index_organizations_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_discarded_at ON public.organizations USING btree (discarded_at);


--
-- Name: index_organizations_on_image_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_image_url ON public.organizations USING btree (image_url);


--
-- Name: index_organizations_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_owner_id ON public.organizations USING btree (owner_id);


--
-- Name: index_outgoing_service_blacklists_on_company_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_service_blacklists_on_company_resource_id ON public.outgoing_service_blacklists USING btree (company_resource_id);


--
-- Name: index_outgoing_service_blacklists_on_vip_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_outgoing_service_blacklists_on_vip_resource_id ON public.outgoing_service_blacklists USING btree (vip_resource_id);


--
-- Name: index_ownerships_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ownerships_on_crelate_id ON public.ownerships USING btree (crelate_id);


--
-- Name: index_participants_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_conversation_id ON public.participants USING btree (conversation_id);


--
-- Name: index_people_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_account_id ON public.people USING btree (account_id);


--
-- Name: index_people_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_active ON public.people USING btree (active) WHERE (active IS TRUE);


--
-- Name: index_people_on_active_set_by_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_active_set_by_user_id ON public.people USING btree (active_set_by_user_id);


--
-- Name: index_people_on_approve_for_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_approve_for_job_id ON public.people USING btree (approve_for_job_id);


--
-- Name: index_people_on_contact_merge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_contact_merge_id ON public.people USING btree (contact_merge_id);


--
-- Name: index_people_on_contact_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_contact_source_id ON public.people USING btree (contact_source_id);


--
-- Name: index_people_on_contact_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_contact_status_id ON public.people USING btree (contact_status_id);


--
-- Name: index_people_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_created_by_id ON public.people USING btree (created_by_id);


--
-- Name: index_people_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_crelate_id ON public.people USING btree (crelate_id);


--
-- Name: index_people_on_email_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_email_address ON public.people USING btree (email_address);


--
-- Name: index_people_on_email_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_email_available ON public.people USING btree (email_available) WHERE (email_available IS TRUE);


--
-- Name: index_people_on_ethnicity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_ethnicity_id ON public.people USING btree (ethnicity_id);


--
-- Name: index_people_on_gender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_gender_id ON public.people USING btree (gender_id);


--
-- Name: index_people_on_github_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_github_available ON public.people USING btree (github_available) WHERE (github_available IS TRUE);


--
-- Name: index_people_on_icon_attachment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_icon_attachment_id ON public.people USING btree (icon_attachment_id);


--
-- Name: index_people_on_inbound_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_inbound_user_id ON public.people USING btree (inbound_user_id);


--
-- Name: index_people_on_last_activity_regarding_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_last_activity_regarding_id ON public.people USING btree (last_activity_regarding_id);


--
-- Name: index_people_on_lever_candidate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_lever_candidate_id ON public.people USING btree (lever_candidate_id);


--
-- Name: index_people_on_linkedin_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_linkedin_available ON public.people USING btree (linkedin_available) WHERE (linkedin_available IS TRUE);


--
-- Name: index_people_on_linkedin_profile_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_linkedin_profile_id_id ON public.people USING btree (linkedin_profile_id_id);


--
-- Name: index_people_on_note_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_note_id ON public.people USING btree (note_id);


--
-- Name: index_people_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_organization_id ON public.people USING btree (organization_id);


--
-- Name: index_people_on_organization_id_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_organization_id_id ON public.people USING btree (organization_id_id);


--
-- Name: index_people_on_phone_number_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_phone_number_available ON public.people USING btree (phone_number_available) WHERE (phone_number_available IS TRUE);


--
-- Name: index_people_on_recently_added; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_recently_added ON public.people USING btree (recently_added) WHERE (recently_added IS TRUE);


--
-- Name: index_people_on_top_five_percent_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_top_five_percent_status ON public.people USING btree (top_five_percent_status) WHERE (top_five_percent_status IS TRUE);


--
-- Name: index_people_on_top_one_percent_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_top_one_percent_status ON public.people USING btree (top_one_percent_status) WHERE (top_one_percent_status IS TRUE);


--
-- Name: index_people_on_top_ten_percent_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_top_ten_percent_status ON public.people USING btree (top_ten_percent_status) WHERE (top_ten_percent_status IS TRUE);


--
-- Name: index_people_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_user_id ON public.people USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_phone_interviews_on_call_sheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phone_interviews_on_call_sheet_id ON public.phone_interviews USING btree (call_sheet_id);


--
-- Name: index_phone_interviews_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phone_interviews_on_person_id ON public.phone_interviews USING btree (person_id);


--
-- Name: index_phone_interviews_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phone_interviews_on_user_id ON public.phone_interviews USING btree (user_id);


--
-- Name: index_phone_numbers_on_people_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phone_numbers_on_people_id ON public.phone_numbers USING btree (people_id);


--
-- Name: index_phone_numbers_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_phone_numbers_on_person_id ON public.phone_numbers USING btree (person_id);


--
-- Name: index_phone_numbers_on_value_and_phone_type_and_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_phone_numbers_on_value_and_phone_type_and_person_id ON public.phone_numbers USING btree (value, phone_type, person_id);


--
-- Name: index_placements_on_call_sheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_call_sheet_id ON public.placements USING btree (call_sheet_id);


--
-- Name: index_placements_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_person_id ON public.placements USING btree (person_id);


--
-- Name: index_placements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_user_id ON public.placements USING btree (user_id);


--
-- Name: index_posts_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_person_id ON public.posts USING btree (person_id);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON public.posts USING btree (user_id);


--
-- Name: index_private_conversations_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_private_conversations_on_recipient_id ON public.private_conversations USING btree (recipient_id);


--
-- Name: index_private_conversations_on_recipient_id_and_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_private_conversations_on_recipient_id_and_sender_id ON public.private_conversations USING btree (recipient_id, sender_id);


--
-- Name: index_private_conversations_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_private_conversations_on_sender_id ON public.private_conversations USING btree (sender_id);


--
-- Name: index_private_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_private_messages_on_conversation_id ON public.private_messages USING btree (conversation_id);


--
-- Name: index_private_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_private_messages_on_user_id ON public.private_messages USING btree (user_id);


--
-- Name: index_questions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_person_id ON public.questions USING btree (person_id);


--
-- Name: index_recruiter_organizations_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_organizations_on_discarded_at ON public.recruiter_organizations USING btree (discarded_at);


--
-- Name: index_recruiter_organizations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_organizations_on_organization_id ON public.recruiter_organizations USING btree (organization_id);


--
-- Name: index_recruiter_organizations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_organizations_on_user_id ON public.recruiter_organizations USING btree (user_id);


--
-- Name: index_recruiter_updates_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_account_id ON public.recruiter_updates USING btree (account_id);


--
-- Name: index_recruiter_updates_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_category_id ON public.recruiter_updates USING btree (category_id);


--
-- Name: index_recruiter_updates_on_inbound_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_inbound_user_id ON public.recruiter_updates USING btree (inbound_user_id);


--
-- Name: index_recruiter_updates_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_job_id ON public.recruiter_updates USING btree (job_id);


--
-- Name: index_recruiter_updates_on_managed_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_managed_account_id ON public.recruiter_updates USING btree (managed_account_id);


--
-- Name: index_recruiter_updates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_person_id ON public.recruiter_updates USING btree (person_id);


--
-- Name: index_recruiter_updates_on_status_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_status_id ON public.recruiter_updates USING btree (status_id);


--
-- Name: index_recruiter_updates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recruiter_updates_on_user_id ON public.recruiter_updates USING btree (user_id);


--
-- Name: index_saved_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_candidates_on_person_id ON public.saved_candidates USING btree (person_id);


--
-- Name: index_saved_candidates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saved_candidates_on_user_id ON public.saved_candidates USING btree (user_id);


--
-- Name: index_searched_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searched_candidates_on_person_id ON public.searched_candidates USING btree (person_id);


--
-- Name: index_searched_candidates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searched_candidates_on_user_id ON public.searched_candidates USING btree (user_id);


--
-- Name: index_searches_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_searches_on_user_id ON public.searches USING btree (user_id);


--
-- Name: index_sign_up_contracts_on_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sign_up_contracts_on_role ON public.sign_up_contracts USING btree (role);


--
-- Name: index_stage_transitions_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stage_transitions_on_submission_id ON public.stage_transitions USING btree (submission_id);


--
-- Name: index_static_list_items_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_static_list_items_on_crelate_id ON public.static_list_items USING btree (crelate_id);


--
-- Name: index_statuses_on_lever_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statuses_on_lever_id ON public.statuses USING btree (lever_id);


--
-- Name: index_statuses_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statuses_on_person_id ON public.statuses USING btree (person_id);


--
-- Name: index_statuses_on_recruiter_update_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_statuses_on_recruiter_update_id ON public.statuses USING btree (recruiter_update_id);


--
-- Name: index_submissions_on_incoming_mail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_incoming_mail_id ON public.submissions USING btree (incoming_mail_id);


--
-- Name: index_submissions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_job_id ON public.submissions USING btree (job_id);


--
-- Name: index_submissions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_person_id ON public.submissions USING btree (person_id);


--
-- Name: index_submissions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submissions_on_user_id ON public.submissions USING btree (user_id);


--
-- Name: index_submittals_on_call_sheet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submittals_on_call_sheet_id ON public.submittals USING btree (call_sheet_id);


--
-- Name: index_submittals_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submittals_on_crelate_id ON public.submittals USING btree (crelate_id);


--
-- Name: index_submittals_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submittals_on_person_id ON public.submittals USING btree (person_id);


--
-- Name: index_submittals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submittals_on_user_id ON public.submittals USING btree (user_id);


--
-- Name: index_submitted_candidates_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_candidates_on_account_id ON public.submitted_candidates USING btree (account_id);


--
-- Name: index_submitted_candidates_on_employer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_candidates_on_employer_id ON public.submitted_candidates USING btree (employer_id);


--
-- Name: index_submitted_candidates_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_candidates_on_job_id ON public.submitted_candidates USING btree (job_id);


--
-- Name: index_submitted_candidates_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_candidates_on_person_id ON public.submitted_candidates USING btree (person_id);


--
-- Name: index_submitted_candidates_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_candidates_on_user_id ON public.submitted_candidates USING btree (user_id);


--
-- Name: index_submitted_requests_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_account_id ON public.submitted_requests USING btree (account_id);


--
-- Name: index_submitted_requests_on_candidate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_candidate_id ON public.submitted_requests USING btree (candidate_id);


--
-- Name: index_submitted_requests_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_job_id ON public.submitted_requests USING btree (job_id);


--
-- Name: index_submitted_requests_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_person_id ON public.submitted_requests USING btree (person_id);


--
-- Name: index_submitted_requests_on_recruiter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_recruiter_id ON public.submitted_requests USING btree (recruiter_id);


--
-- Name: index_submitted_requests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_submitted_requests_on_user_id ON public.submitted_requests USING btree (user_id);


--
-- Name: index_tag_relationships_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_relationships_on_crelate_id ON public.tag_relationships USING btree (crelate_id);


--
-- Name: index_tags_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_crelate_id ON public.tags USING btree (crelate_id);


--
-- Name: index_tags_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_user_id ON public.tags USING btree (user_id);


--
-- Name: index_task_list_items_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_task_list_items_on_crelate_id ON public.task_list_items USING btree (crelate_id);


--
-- Name: index_timeline_items_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timeline_items_on_crelate_id ON public.timeline_items USING btree (crelate_id);


--
-- Name: index_uploads_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_person_id ON public.uploads USING btree (person_id);


--
-- Name: index_urls_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_urls_on_crelate_id ON public.urls USING btree (crelate_id);


--
-- Name: index_user_contact_preferences_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_contact_preferences_on_user_id ON public.user_contact_preferences USING btree (user_id);


--
-- Name: index_user_experiences_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_experiences_on_user_id ON public.user_experiences USING btree (user_id);


--
-- Name: index_user_experiences_on_user_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_experiences_on_user_profile_id ON public.user_experiences USING btree (user_profile_id);


--
-- Name: index_user_mailing_addresses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_mailing_addresses_on_user_id ON public.user_mailing_addresses USING btree (user_id);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_profiles_on_user_id ON public.user_profiles USING btree (user_id);


--
-- Name: index_users_on_account_manager_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_account_manager_id ON public.users USING btree (account_manager_id);


--
-- Name: index_users_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_crelate_id ON public.users USING btree (crelate_id);


--
-- Name: index_users_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_discarded_at ON public.users USING btree (discarded_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_identity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_identity_id ON public.users USING btree (identity_id);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON public.users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invitations_count ON public.users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invited_by_id ON public.users USING btree (invited_by_id);


--
-- Name: index_users_on_notes_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_notes_id ON public.users USING btree (notes_id);


--
-- Name: index_users_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_organization_id ON public.users USING btree (organization_id);


--
-- Name: index_users_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_person_id ON public.users USING btree (person_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_villagers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_villagers_on_email ON public.villagers USING btree (email);


--
-- Name: index_villagers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_villagers_on_reset_password_token ON public.villagers USING btree (reset_password_token);


--
-- Name: index_villagers_on_villagerable_type_and_villagerable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_villagers_on_villagerable_type_and_villagerable_id ON public.villagers USING btree (villagerable_type, villagerable_id);


--
-- Name: index_workflow_items_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workflow_items_on_crelate_id ON public.workflow_items USING btree (crelate_id);


--
-- Name: index_workflows_on_crelate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workflows_on_crelate_id ON public.workflows USING btree (crelate_id);


--
-- Name: mailboxer_notifications_notified_object; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX mailboxer_notifications_notified_object ON public.mailboxer_notifications USING btree (notified_object_type, notified_object_id);


--
-- Name: people_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_idx ON public.people USING gin (to_tsvector('english'::regconfig, (((formatted_name)::text || ' '::text) || (name)::text)));


--
-- Name: people_search_text; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_search_text ON public.people USING gin (to_tsvector('english'::regconfig, (search_text)::text));


--
-- Name: company_positions company_positions_email_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_positions
    ADD CONSTRAINT company_positions_email_address_id_fk FOREIGN KEY (email_address_id) REFERENCES public.email_addresses(id);


--
-- Name: email_addresses email_addresses_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses
    ADD CONSTRAINT email_addresses_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: linkedin_resumes fk_rails_00818f4bd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_resumes
    ADD CONSTRAINT fk_rails_00818f4bd0 FOREIGN KEY (incoming_mail_id) REFERENCES public.incoming_mails(id);


--
-- Name: submittals fk_rails_0364a3597f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submittals
    ADD CONSTRAINT fk_rails_0364a3597f FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: interviews fk_rails_046f157800; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interviews
    ADD CONSTRAINT fk_rails_046f157800 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submitted_candidates fk_rails_090c4a3c5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates
    ADD CONSTRAINT fk_rails_090c4a3c5b FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: comments fk_rails_0ababf4328; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_0ababf4328 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: calls fk_rails_0b239d9e9b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calls
    ADD CONSTRAINT fk_rails_0b239d9e9b FOREIGN KEY (call_sheet_id) REFERENCES public.call_sheets(id);


--
-- Name: submitted_candidates fk_rails_0c02437a81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates
    ADD CONSTRAINT fk_rails_0c02437a81 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: invitations fk_rails_0fe4c14f0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_0fe4c14f0e FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: saved_candidates fk_rails_1035a4c076; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_candidates
    ADD CONSTRAINT fk_rails_1035a4c076 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: blacklists fk_rails_10d333a1dc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blacklists
    ADD CONSTRAINT fk_rails_10d333a1dc FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: statuses fk_rails_1324eb4066; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT fk_rails_1324eb4066 FOREIGN KEY (recruiter_update_id) REFERENCES public.recruiter_updates(id);


--
-- Name: private_messages fk_rails_1367835d70; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_messages
    ADD CONSTRAINT fk_rails_1367835d70 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: linkedin_industries fk_rails_13be6a49f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_industries
    ADD CONSTRAINT fk_rails_13be6a49f0 FOREIGN KEY (linkedin_profiles_id) REFERENCES public.linkedin_profiles(id);


--
-- Name: linkedin_profile_publications fk_rails_1dde11f9c9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_publications
    ADD CONSTRAINT fk_rails_1dde11f9c9 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: linkedin_profile_url_resources fk_rails_21a05df79d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_url_resources
    ADD CONSTRAINT fk_rails_21a05df79d FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: phone_interviews fk_rails_222b7b9f73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_interviews
    ADD CONSTRAINT fk_rails_222b7b9f73 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: submittals fk_rails_22a62c0078; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submittals
    ADD CONSTRAINT fk_rails_22a62c0078 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: blacklists fk_rails_23fa4463b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blacklists
    ADD CONSTRAINT fk_rails_23fa4463b8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: posts fk_rails_2504a6d6f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_2504a6d6f3 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: submitted_candidates fk_rails_267696e45b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates
    ADD CONSTRAINT fk_rails_267696e45b FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: participants fk_rails_26c9fe9cce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_26c9fe9cce FOREIGN KEY (conversation_id) REFERENCES public.conversations(id);


--
-- Name: messages fk_rails_273a25a7a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_273a25a7a6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submissions fk_rails_2b681b3209; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_2b681b3209 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: users fk_rails_2f296ee649; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_2f296ee649 FOREIGN KEY (identity_id) REFERENCES public.identities(id);


--
-- Name: comments fk_rails_2fd19c0db7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_2fd19c0db7 FOREIGN KEY (post_id) REFERENCES public.posts(id);


--
-- Name: email_sequences fk_rails_301cc8a025; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_sequences
    ADD CONSTRAINT fk_rails_301cc8a025 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: follows fk_rails_32479bd030; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT fk_rails_32479bd030 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submissions fk_rails_366fd2634b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_366fd2634b FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: submissions fk_rails_36a28152ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_36a28152ed FOREIGN KEY (incoming_mail_id) REFERENCES public.incoming_mails(id);


--
-- Name: recruiter_updates fk_rails_3c81ba993d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_3c81ba993d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_experiences fk_rails_3d2d7033d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences
    ADD CONSTRAINT fk_rails_3d2d7033d6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: interview_schedules fk_rails_3d4f25f60f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interview_schedules
    ADD CONSTRAINT fk_rails_3d4f25f60f FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: answers fk_rails_3d5ed4418f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_rails_3d5ed4418f FOREIGN KEY (question_id) REFERENCES public.questions(id);


--
-- Name: submitted_requests fk_rails_40f2d42fe4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests
    ADD CONSTRAINT fk_rails_40f2d42fe4 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: employer_sequence_to_people fk_rails_438893f8da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_sequence_to_people
    ADD CONSTRAINT fk_rails_438893f8da FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: recruiter_updates fk_rails_458f374328; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_458f374328 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: call_sheets fk_rails_4c79439a59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.call_sheets
    ADD CONSTRAINT fk_rails_4c79439a59 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: archive_states fk_rails_4d1573e6da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archive_states
    ADD CONSTRAINT fk_rails_4d1573e6da FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: answers fk_rails_4f93456086; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_rails_4f93456086 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: submittals fk_rails_505b7a2954; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submittals
    ADD CONSTRAINT fk_rails_505b7a2954 FOREIGN KEY (call_sheet_id) REFERENCES public.call_sheets(id);


--
-- Name: submitted_requests fk_rails_505e2c1173; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests
    ADD CONSTRAINT fk_rails_505e2c1173 FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: identities fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: phone_interviews fk_rails_538859ac41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_interviews
    ADD CONSTRAINT fk_rails_538859ac41 FOREIGN KEY (call_sheet_id) REFERENCES public.call_sheets(id);


--
-- Name: user_contact_preferences fk_rails_577f1ea35a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_contact_preferences
    ADD CONSTRAINT fk_rails_577f1ea35a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: phone_numbers fk_rails_5ac3c3b4fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT fk_rails_5ac3c3b4fd FOREIGN KEY (people_id) REFERENCES public.people(id);


--
-- Name: linkedin_profile_recommendations fk_rails_5c09649152; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_recommendations
    ADD CONSTRAINT fk_rails_5c09649152 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: user_mailing_addresses fk_rails_66a6cb35b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_mailing_addresses
    ADD CONSTRAINT fk_rails_66a6cb35b8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: phone_interviews fk_rails_6d757c88c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_interviews
    ADD CONSTRAINT fk_rails_6d757c88c7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: job_experiences fk_rails_716e310802; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_experiences
    ADD CONSTRAINT fk_rails_716e310802 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: uploads fk_rails_747279a58a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT fk_rails_747279a58a FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: invitations fk_rails_74f77b0f82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_74f77b0f82 FOREIGN KEY (invited_user_id) REFERENCES public.users(id);


--
-- Name: recruiter_updates fk_rails_757c77e46e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_757c77e46e FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: conversations fk_rails_7c15d62a0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT fk_rails_7c15d62a0a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: recruiter_updates fk_rails_7cb3cf486c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_7cb3cf486c FOREIGN KEY (managed_account_id) REFERENCES public.managed_accounts(id);


--
-- Name: saved_candidates fk_rails_7d6beba243; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saved_candidates
    ADD CONSTRAINT fk_rails_7d6beba243 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: messages fk_rails_835d3e2df6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_835d3e2df6 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: user_profiles fk_rails_87a6352e58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT fk_rails_87a6352e58 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: job_location_interests fk_rails_87e3472896; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_location_interests
    ADD CONSTRAINT fk_rails_87e3472896 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: call_sheets fk_rails_892410bd8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.call_sheets
    ADD CONSTRAINT fk_rails_892410bd8d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submissions fk_rails_8d85741475; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submissions
    ADD CONSTRAINT fk_rails_8d85741475 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: onsite_interviews fk_rails_8e9124edcb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onsite_interviews
    ADD CONSTRAINT fk_rails_8e9124edcb FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: employer_sequence_to_people fk_rails_8ed51c84c0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_sequence_to_people
    ADD CONSTRAINT fk_rails_8ed51c84c0 FOREIGN KEY (email_sequence_id) REFERENCES public.email_sequences(id);


--
-- Name: recruiter_updates fk_rails_91d86bbc2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_91d86bbc2a FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: calls fk_rails_94ba5213ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.calls
    ADD CONSTRAINT fk_rails_94ba5213ce FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: user_experiences fk_rails_973b18bc4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_experiences
    ADD CONSTRAINT fk_rails_973b18bc4d FOREIGN KEY (user_profile_id) REFERENCES public.user_profiles(id);


--
-- Name: entries fk_rails_99dc12d4fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_rails_99dc12d4fd FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: phone_numbers fk_rails_9cca78dca2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT fk_rails_9cca78dca2 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: linkedin_schools fk_rails_9e90119639; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_schools
    ADD CONSTRAINT fk_rails_9e90119639 FOREIGN KEY (linkedin_profile_education_id) REFERENCES public.linkedin_profile_educations(id);


--
-- Name: linkedin_profile_educations fk_rails_a0936026a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_educations
    ADD CONSTRAINT fk_rails_a0936026a4 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: job_searches fk_rails_a53082865a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_searches
    ADD CONSTRAINT fk_rails_a53082865a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: outgoing_service_blacklists fk_rails_a54302b251; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_service_blacklists
    ADD CONSTRAINT fk_rails_a54302b251 FOREIGN KEY (vip_resource_id) REFERENCES public.vip_resources(id);


--
-- Name: questions fk_rails_ab269456db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT fk_rails_ab269456db FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: organizations fk_rails_ab574863f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_ab574863f6 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: linkedin_industries fk_rails_b05a71dadd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_industries
    ADD CONSTRAINT fk_rails_b05a71dadd FOREIGN KEY (linkedin_profile_id) REFERENCES public.linkedin_profiles(id);


--
-- Name: followed_candidates fk_rails_b146fcea7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followed_candidates
    ADD CONSTRAINT fk_rails_b146fcea7b FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: accounts fk_rails_b1e30bebc8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_rails_b1e30bebc8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: outgoing_service_blacklists fk_rails_bb728e04e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.outgoing_service_blacklists
    ADD CONSTRAINT fk_rails_bb728e04e8 FOREIGN KEY (company_resource_id) REFERENCES public.company_resources(id);


--
-- Name: company_positions fk_rails_bc07ee142e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.company_positions
    ADD CONSTRAINT fk_rails_bc07ee142e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: jobs fk_rails_bf70b05740; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_bf70b05740 FOREIGN KEY (managed_account_id) REFERENCES public.managed_accounts(id);


--
-- Name: education_experiences fk_rails_bfc9e0c3fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_experiences
    ADD CONSTRAINT fk_rails_bfc9e0c3fb FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: placements fk_rails_c28c8e1c5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT fk_rails_c28c8e1c5d FOREIGN KEY (call_sheet_id) REFERENCES public.call_sheets(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: submitted_candidates fk_rails_c5eb06597a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_candidates
    ADD CONSTRAINT fk_rails_c5eb06597a FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: onsite_interviews fk_rails_c84c72f0d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onsite_interviews
    ADD CONSTRAINT fk_rails_c84c72f0d3 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: employer_company_profiles fk_rails_ccde7da00f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employer_company_profiles
    ADD CONSTRAINT fk_rails_ccde7da00f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: followed_candidates fk_rails_d2bafc2477; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followed_candidates
    ADD CONSTRAINT fk_rails_d2bafc2477 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: placements fk_rails_d416d5a60e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT fk_rails_d416d5a60e FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: onsite_interviews fk_rails_d48532432b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onsite_interviews
    ADD CONSTRAINT fk_rails_d48532432b FOREIGN KEY (call_sheet_id) REFERENCES public.call_sheets(id);


--
-- Name: linkedin_profiles fk_rails_d5d2a02b8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profiles
    ADD CONSTRAINT fk_rails_d5d2a02b8d FOREIGN KEY (linkedin_profile_id) REFERENCES public.linkedin_profiles(id);


--
-- Name: linked_accounts fk_rails_d68dcf73fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linked_accounts
    ADD CONSTRAINT fk_rails_d68dcf73fa FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submitted_requests fk_rails_d914d5f5f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests
    ADD CONSTRAINT fk_rails_d914d5f5f7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: submitted_requests fk_rails_d91bf448a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.submitted_requests
    ADD CONSTRAINT fk_rails_d91bf448a2 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: statuses fk_rails_da8047cc22; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT fk_rails_da8047cc22 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: jobs fk_rails_df6238c8a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_df6238c8a6 FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: searches fk_rails_e192b86393; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searches
    ADD CONSTRAINT fk_rails_e192b86393 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users fk_rails_e44627cd5c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_e44627cd5c FOREIGN KEY (notes_id) REFERENCES public.notes(id);


--
-- Name: tags fk_rails_e689f6d0cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_e689f6d0cc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: recruiter_updates fk_rails_e745eb6ba7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT fk_rails_e745eb6ba7 FOREIGN KEY (job_id) REFERENCES public.jobs(id);


--
-- Name: addresses fk_rails_e760e37e14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fk_rails_e760e37e14 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: invitations fk_rails_ef283eb59a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_ef283eb59a FOREIGN KEY (inviting_user_id) REFERENCES public.users(id);


--
-- Name: flagged_candidates fk_rails_ef73f88dbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flagged_candidates
    ADD CONSTRAINT fk_rails_ef73f88dbc FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: flagged_candidates fk_rails_f5e4fb05ba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flagged_candidates
    ADD CONSTRAINT fk_rails_f5e4fb05ba FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: users fk_rails_fa67535741; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_fa67535741 FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: placements fk_rails_fe81c39da1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.placements
    ADD CONSTRAINT fk_rails_fe81c39da1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: linkedin_profile_educations linkedin_profile_educations_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_educations
    ADD CONSTRAINT linkedin_profile_educations_person_id_fk FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- Name: linkedin_profile_positions linkedin_profile_positions_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_positions
    ADD CONSTRAINT linkedin_profile_positions_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: linkedin_profile_recommendations linkedin_profile_recommendations_linkedin_profile_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profile_recommendations
    ADD CONSTRAINT linkedin_profile_recommendations_linkedin_profile_id_fk FOREIGN KEY (linkedin_profile_id) REFERENCES public.linkedin_profiles(id);


--
-- Name: linkedin_profiles linkedin_profiles_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.linkedin_profiles
    ADD CONSTRAINT linkedin_profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: managed_accounts managed_accounts_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_accounts
    ADD CONSTRAINT managed_accounts_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: mailboxer_conversation_opt_outs mb_opt_outs_on_conversations_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_conversation_opt_outs
    ADD CONSTRAINT mb_opt_outs_on_conversations_id FOREIGN KEY (conversation_id) REFERENCES public.mailboxer_conversations(id);


--
-- Name: mailboxer_notifications notifications_on_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_notifications
    ADD CONSTRAINT notifications_on_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.mailboxer_conversations(id);


--
-- Name: posts posts_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: mailboxer_receipts receipts_on_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailboxer_receipts
    ADD CONSTRAINT receipts_on_notification_id FOREIGN KEY (notification_id) REFERENCES public.mailboxer_notifications(id);


--
-- Name: recruiter_updates recruiter_updates_status_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recruiter_updates
    ADD CONSTRAINT recruiter_updates_status_id_fk FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: uploads uploads_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200511012218'),
('20200707001041'),
('20200713002251'),
('20200721072248'),
('20200721173613'),
('20200721174303'),
('20200729102718'),
('20200731160457'),
('20200805065341'),
('20200806153048'),
('20201006060104'),
('20201006161254'),
('20201007025005'),
('20201007031932'),
('20201008220341'),
('20201008224552'),
('20201008225637'),
('20201009051653'),
('20201012120847'),
('20201012154850'),
('20201013041122'),
('20201013041139'),
('20201014110110'),
('20201019095848'),
('20201026080801'),
('20201026082327'),
('20201026082403'),
('20201028180036'),
('20201030174426'),
('20201102050445'),
('20201102145911'),
('20201104160331'),
('20201104164715'),
('20201109123004'),
('20201111140116'),
('20201123234022'),
('20201124120937'),
('20201125141400'),
('20201125142256'),
('20201125142738'),
('20201203225559'),
('20201204124730'),
('20201204130423'),
('20201204142732'),
('20201204142826'),
('20201204143607'),
('20201207104012'),
('20201207173611'),
('20201211192825'),
('20201214235803'),
('20201218154247'),
('20201223000147'),
('20201230170853'),
('20201231123840'),
('20210102081753'),
('20210108174130'),
('20210111172842'),
('20210112125624'),
('20210127001949'),
('20210201154925'),
('20210203105025'),
('20210211124539'),
('20210215180545'),
('20210219184846'),
('20210225131101'),
('20210301062049'),
('20210302061540'),
('20210302101035'),
('20210305081017'),
('20210310101140'),
('20210311093519'),
('20210312131539'),
('20210315073923'),
('20210315081312'),
('20210316081253'),
('20210317151054'),
('20210318075342'),
('20210325064911'),
('20210326131616'),
('20210330153332'),
('20210331163223'),
('20210401065527'),
('20210401094144'),
('20210407171012'),
('20210408034858'),
('20210413100754'),
('20210420080817'),
('20210420164252'),
('20210422082025'),
('20210425222251'),
('20210427194351'),
('20210429203855'),
('20210503091222'),
('20210506210028'),
('20210507104050'),
('20210507112345'),
('20210511135427'),
('20210519132237'),
('20210521142102'),
('20210521142739'),
('202105221314'),
('20210522131415'),
('20210523120230'),
('20210524092357'),
('20210524154347'),
('20210525170604'),
('20210526112233'),
('20210601091206'),
('20210601093453'),
('20210601094649'),
('20210601133211'),
('20210601133253'),
('20210602053248'),
('20210602081105'),
('20210604092552'),
('20210604132413'),
('20210607090825'),
('20210610041013'),
('20210611105236'),
('20210614104709'),
('20210617072759'),
('20210617081000'),
('20210617150148'),
('20210617183724'),
('20210617212542'),
('20210618164600'),
('20210621141608'),
('20210623064819'),
('20210623065633'),
('20210624092717'),
('20210627192024'),
('20210628055209'),
('20210628055227'),
('20210629045256'),
('20210629090821'),
('20210629142418'),
('20210629142814'),
('20210701103445'),
('20210701103800'),
('20210702052947'),
('20210702173817'),
('20210707081240'),
('20210713062514'),
('20210713072939'),
('20210714040327'),
('20210715082320'),
('20210716024628'),
('20210716125418'),
('20210716125538'),
('20210722092951'),
('20210723073434'),
('20210723101156'),
('20210728054937'),
('20210729045434'),
('20210729075743'),
('20210729154444'),
('20210802100235'),
('20210804123102'),
('20210804125928'),
('20210806090907'),
('20210806142328'),
('20210806142530'),
('20210809135219'),
('20210812055209'),
('20210812061032'),
('20210814032446'),
('20210818124314'),
('20210818131556'),
('20210819103446'),
('20210820053725'),
('20210820111637'),
('20210823062800'),
('20210823092208'),
('20210823105839'),
('20210824062653'),
('20210824065125'),
('20210824183515'),
('20210824190835'),
('20210825184657'),
('20210902052502'),
('20210906084218'),
('20210920044633'),
('20210920113949'),
('20210921052320'),
('20210921081617'),
('20210921094233'),
('20210922060946'),
('20210922110505');


