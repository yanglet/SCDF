create table if not exists hibernate_sequence
(
    next_val bigint
);

insert into hibernate_sequence (next_val)
select *
from (select 1 as next_val) as temp
where not exists(select * from hibernate_sequence);

create table app_registration
(
    id              bigint not null,
    object_version  bigint,
    default_version bit,
    metadata_uri    longtext,
    name            varchar(255),
    type            integer,
    uri             longtext,
    version         varchar(255),
    primary key (id)
);

create table task_deployment
(
    id                   bigint       not null,
    object_version       bigint,
    task_deployment_id   varchar(255) not null,
    task_definition_name varchar(255) not null,
    platform_name        varchar(255) not null,
    created_on           datetime,
    primary key (id)
);

create table audit_records
(
    id              bigint not null,
    audit_action    bigint,
    audit_data      longtext,
    audit_operation bigint,
    correlation_id  varchar(255),
    created_by      varchar(255),
    created_on      datetime,
    primary key (id)
);

create table stream_definitions
(
    definition_name varchar(255) not null,
    definition      longtext,
    primary key (definition_name)
);

create table task_definitions
(
    definition_name varchar(255) not null,
    definition      longtext,
    primary key (definition_name)
);

CREATE TABLE TASK_EXECUTION
(
    TASK_EXECUTION_ID     BIGINT NOT NULL PRIMARY KEY,
    START_TIME            DATETIME DEFAULT NULL,
    END_TIME              DATETIME DEFAULT NULL,
    TASK_NAME             VARCHAR(100),
    EXIT_CODE             INTEGER,
    EXIT_MESSAGE          VARCHAR(2500),
    ERROR_MESSAGE         VARCHAR(2500),
    LAST_UPDATED          TIMESTAMP,
    EXTERNAL_EXECUTION_ID VARCHAR(255),
    PARENT_EXECUTION_ID   BIGINT
);

CREATE TABLE TASK_EXECUTION_PARAMS
(
    TASK_EXECUTION_ID BIGINT NOT NULL,
    TASK_PARAM        VARCHAR(2500),
    constraint TASK_EXEC_PARAMS_FK foreign key (TASK_EXECUTION_ID)
        references TASK_EXECUTION (TASK_EXECUTION_ID)
);

CREATE TABLE TASK_TASK_BATCH
(
    TASK_EXECUTION_ID BIGINT NOT NULL,
    JOB_EXECUTION_ID  BIGINT NOT NULL,
    constraint TASK_EXEC_BATCH_FK foreign key (TASK_EXECUTION_ID)
        references TASK_EXECUTION (TASK_EXECUTION_ID)
);

CREATE TABLE TASK_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
);

INSERT INTO TASK_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp;

CREATE TABLE TASK_LOCK
(
    LOCK_KEY     CHAR(36)     NOT NULL,
    REGION       VARCHAR(100) NOT NULL,
    CLIENT_ID    CHAR(36),
    CREATED_DATE DATETIME(6)  NOT NULL,
    constraint LOCK_PK primary key (LOCK_KEY, REGION)
);

CREATE TABLE BATCH_JOB_INSTANCE
(
    JOB_INSTANCE_ID BIGINT       NOT NULL PRIMARY KEY,
    VERSION         BIGINT,
    JOB_NAME        VARCHAR(100) NOT NULL,
    JOB_KEY         VARCHAR(32)  NOT NULL,
    constraint JOB_INST_UN unique (JOB_NAME, JOB_KEY)
);

CREATE TABLE BATCH_JOB_EXECUTION
(
    JOB_EXECUTION_ID           BIGINT        NOT NULL PRIMARY KEY,
    VERSION                    BIGINT,
    JOB_INSTANCE_ID            BIGINT        NOT NULL,
    CREATE_TIME                DATETIME      NOT NULL,
    START_TIME                 DATETIME DEFAULT NULL,
    END_TIME                   DATETIME DEFAULT NULL,
    STATUS                     VARCHAR(10),
    EXIT_CODE                  VARCHAR(2500),
    EXIT_MESSAGE               VARCHAR(2500),
    LAST_UPDATED               DATETIME,
    JOB_CONFIGURATION_LOCATION VARCHAR(2500) NULL,
    constraint JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
        references BATCH_JOB_INSTANCE (JOB_INSTANCE_ID)
);

CREATE TABLE BATCH_JOB_EXECUTION_PARAMS
(
    JOB_EXECUTION_ID BIGINT       NOT NULL,
    TYPE_CD          VARCHAR(6)   NOT NULL,
    KEY_NAME         VARCHAR(100) NOT NULL,
    STRING_VAL       VARCHAR(250),
    DATE_VAL         DATETIME DEFAULT NULL,
    LONG_VAL         BIGINT,
    DOUBLE_VAL       DOUBLE PRECISION,
    IDENTIFYING      CHAR(1)      NOT NULL,
    constraint JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
);

CREATE TABLE BATCH_STEP_EXECUTION
(
    STEP_EXECUTION_ID  BIGINT       NOT NULL PRIMARY KEY,
    VERSION            BIGINT       NOT NULL,
    STEP_NAME          VARCHAR(100) NOT NULL,
    JOB_EXECUTION_ID   BIGINT       NOT NULL,
    START_TIME         DATETIME     NOT NULL,
    END_TIME           DATETIME DEFAULT NULL,
    STATUS             VARCHAR(10),
    COMMIT_COUNT       BIGINT,
    READ_COUNT         BIGINT,
    FILTER_COUNT       BIGINT,
    WRITE_COUNT        BIGINT,
    READ_SKIP_COUNT    BIGINT,
    WRITE_SKIP_COUNT   BIGINT,
    PROCESS_SKIP_COUNT BIGINT,
    ROLLBACK_COUNT     BIGINT,
    EXIT_CODE          VARCHAR(2500),
    EXIT_MESSAGE       VARCHAR(2500),
    LAST_UPDATED       DATETIME,
    constraint JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
);

CREATE TABLE BATCH_STEP_EXECUTION_CONTEXT
(
    STEP_EXECUTION_ID  BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
        references BATCH_STEP_EXECUTION (STEP_EXECUTION_ID)
);

CREATE TABLE BATCH_JOB_EXECUTION_CONTEXT
(
    JOB_EXECUTION_ID   BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
        references BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
);

CREATE TABLE BATCH_STEP_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
);

INSERT INTO BATCH_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_STEP_EXECUTION_SEQ);

CREATE TABLE BATCH_JOB_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
);

INSERT INTO BATCH_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_JOB_EXECUTION_SEQ);

CREATE TABLE BATCH_JOB_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
);

INSERT INTO BATCH_JOB_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BATCH_JOB_SEQ);

-- V1-skipper.sql
create table if not exists hibernate_sequence
(
    next_val bigint
);

insert into hibernate_sequence (next_val)
select *
from (select 1 as next_val) as temp
where not exists(select * from hibernate_sequence);

create table skipper_app_deployer_data
(
    id              bigint not null,
    object_version  bigint,
    deployment_data longtext,
    release_name    varchar(255),
    release_version integer,
    primary key (id)
);

create table skipper_info
(
    id             bigint not null,
    object_version bigint,
    deleted        datetime,
    description    varchar(255),
    first_deployed datetime,
    last_deployed  datetime,
    status_id      bigint,
    primary key (id)
);

create table skipper_manifest
(
    id             bigint not null,
    object_version bigint,
    data           longtext,
    primary key (id)
);

create table skipper_package_file
(
    id            bigint not null,
    package_bytes longblob,
    primary key (id)
);

create table skipper_package_metadata
(
    id                 bigint not null,
    object_version     bigint,
    api_version        varchar(255),
    description        longtext,
    display_name       varchar(255),
    icon_url           longtext,
    kind               varchar(255),
    maintainer         varchar(255),
    name               varchar(255),
    origin             varchar(255),
    package_home_url   longtext,
    package_source_url longtext,
    repository_id      bigint,
    repository_name    varchar(255),
    sha256             varchar(255),
    tags               longtext,
    version            varchar(255),
    packagefile_id     bigint,
    primary key (id)
);

create table skipper_release
(
    id                   bigint  not null,
    object_version       bigint,
    config_values_string longtext,
    name                 varchar(255),
    package_metadata_id  bigint,
    pkg_json_string      longtext,
    platform_name        varchar(255),
    repository_id        bigint,
    version              integer not null,
    info_id              bigint,
    manifest_id          bigint,
    primary key (id)
);

create table skipper_repository
(
    id             bigint not null,
    object_version bigint,
    description    varchar(255),
    local          bit,
    name           varchar(255),
    repo_order     integer,
    source_url     longtext,
    url            longtext,
    primary key (id)
);

create table skipper_status
(
    id              bigint not null,
    platform_status longtext,
    status_code     varchar(255),
    primary key (id)
);

create table action
(
    id   bigint not null,
    name varchar(255),
    spel varchar(255),
    primary key (id)
);

create table deferred_events
(
    jpa_repository_state_id bigint not null,
    deferred_events         varchar(255)
);

create table guard
(
    id   bigint not null,
    name varchar(255),
    spel varchar(255),
    primary key (id)
);

create table state
(
    id                bigint not null,
    initial_state     bit    not null,
    kind              integer,
    machine_id        varchar(255),
    region            varchar(255),
    state             varchar(255),
    submachine_id     varchar(255),
    initial_action_id bigint,
    parent_state_id   bigint,
    primary key (id)
);

create table state_entry_actions
(
    jpa_repository_state_id bigint not null,
    entry_actions_id        bigint not null,
    primary key (jpa_repository_state_id, entry_actions_id)
);

create table state_exit_actions
(
    jpa_repository_state_id bigint not null,
    exit_actions_id         bigint not null,
    primary key (jpa_repository_state_id, exit_actions_id)
);

create table state_state_actions
(
    jpa_repository_state_id bigint not null,
    state_actions_id        bigint not null,
    primary key (jpa_repository_state_id, state_actions_id)
);

create table state_machine
(
    machine_id            varchar(255) not null,
    state                 varchar(255),
    state_machine_context longblob,
    primary key (machine_id)
);

create table transition
(
    id         bigint not null,
    event      varchar(255),
    kind       integer,
    machine_id varchar(255),
    guard_id   bigint,
    source_id  bigint,
    target_id  bigint,
    primary key (id)
);

create table transition_actions
(
    jpa_repository_transition_id bigint not null,
    actions_id                   bigint not null,
    primary key (jpa_repository_transition_id, actions_id)
);

create index idx_pkg_name on skipper_package_metadata (name);

create index idx_rel_name on skipper_release (name);

create index idx_repo_name on skipper_repository (name);

alter table skipper_repository
    add constraint uk_repository unique (name);

alter table deferred_events
    add constraint fk_state_deferred_events
        foreign key (jpa_repository_state_id)
            references state (id);

alter table skipper_info
    add constraint fk_info_status
        foreign key (status_id)
            references skipper_status (id);

alter table skipper_package_metadata
    add constraint fk_package_metadata_pfile
        foreign key (packagefile_id)
            references skipper_package_file (id);

alter table skipper_release
    add constraint fk_release_info
        foreign key (info_id)
            references skipper_info (id);

alter table skipper_release
    add constraint fk_release_manifest
        foreign key (manifest_id)
            references skipper_manifest (id);

alter table state
    add constraint fk_state_initial_action
        foreign key (initial_action_id)
            references action (id);

alter table state
    add constraint fk_state_parent_state
        foreign key (parent_state_id)
            references state (id);

alter table state_entry_actions
    add constraint fk_state_entry_actions_a
        foreign key (entry_actions_id)
            references action (id);

alter table state_entry_actions
    add constraint fk_state_entry_actions_s
        foreign key (jpa_repository_state_id)
            references state (id);

alter table state_exit_actions
    add constraint fk_state_exit_actions_a
        foreign key (exit_actions_id)
            references action (id);

alter table state_exit_actions
    add constraint fk_state_exit_actions_s
        foreign key (jpa_repository_state_id)
            references state (id);

alter table state_state_actions
    add constraint fk_state_state_actions_a
        foreign key (state_actions_id)
            references action (id);

alter table state_state_actions
    add constraint fk_state_state_actions_s
        foreign key (jpa_repository_state_id)
            references state (id);

alter table transition
    add constraint fk_transition_guard
        foreign key (guard_id)
            references guard (id);

alter table transition
    add constraint fk_transition_source
        foreign key (source_id)
            references state (id);

alter table transition
    add constraint fk_transition_target
        foreign key (target_id)
            references state (id);

alter table transition_actions
    add constraint fk_transition_actions_a
        foreign key (actions_id)
            references action (id);

alter table transition_actions
    add constraint fk_transition_actions_t
        foreign key (jpa_repository_transition_id)
            references transition (id);


-- V2-dataflow.sql
alter table stream_definitions
    add description varchar(255);

alter table stream_definitions
    add original_definition longtext;

alter table task_definitions
    add description varchar(255);

CREATE TABLE task_execution_metadata
(
    id                      BIGINT NOT NULL,
    task_execution_id       BIGINT NOT NULL,
    task_execution_manifest LONGTEXT,
    primary key (id),
    CONSTRAINT TASK_METADATA_FK FOREIGN KEY (task_execution_id)
        REFERENCES TASK_EXECUTION (TASK_EXECUTION_ID)
);

CREATE TABLE task_execution_metadata_seq
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
);

INSERT INTO task_execution_metadata_seq (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from task_execution_metadata_seq);

-- V2-dataflow-after.sql
update stream_definitions
set original_definition=definition;

-- V3-dataflow.sql
alter table audit_records
    add platform_name varchar(255);

-- V4-dataflow.sql
create index STEP_NAME_IDX on BATCH_STEP_EXECUTION (STEP_NAME);

-- V5-dataflow.sql
create index TASK_EXECUTION_ID_IDX on TASK_EXECUTION_PARAMS (TASK_EXECUTION_ID);

-- V6-dataflow.sql
alter table app_registration
    add boot_version varchar(16);

-- V7-dataflow.sql
create table if not exists BOOT3_TASK_EXECUTION
(
    TASK_EXECUTION_ID     BIGINT NOT NULL PRIMARY KEY,
    START_TIME            DATETIME(6) DEFAULT NULL,
    END_TIME              DATETIME(6) DEFAULT NULL,
    TASK_NAME             VARCHAR(100),
    EXIT_CODE             INTEGER,
    EXIT_MESSAGE          VARCHAR(2500),
    ERROR_MESSAGE         VARCHAR(2500),
    LAST_UPDATED          TIMESTAMP,
    EXTERNAL_EXECUTION_ID VARCHAR(255),
    PARENT_EXECUTION_ID   BIGINT
) ENGINE = InnoDB;

create table if not exists BOOT3_TASK_EXECUTION_PARAMS
(
    TASK_EXECUTION_ID BIGINT NOT NULL,
    TASK_PARAM        VARCHAR(2500),
    constraint BOOT3_TASK_EXEC_PARAMS_FK foreign key (TASK_EXECUTION_ID)
        references BOOT3_TASK_EXECUTION (TASK_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_TASK_TASK_BATCH
(
    TASK_EXECUTION_ID BIGINT NOT NULL,
    JOB_EXECUTION_ID  BIGINT NOT NULL,
    constraint BOOT3_TASK_EXEC_BATCH_FK foreign key (TASK_EXECUTION_ID)
        references BOOT3_TASK_EXECUTION (TASK_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_TASK_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE = InnoDB;

INSERT INTO BOOT3_TASK_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp;

create table if not exists BOOT3_TASK_LOCK
(
    LOCK_KEY     CHAR(36)     NOT NULL,
    REGION       VARCHAR(100) NOT NULL,
    CLIENT_ID    CHAR(36),
    CREATED_DATE DATETIME(6)  NOT NULL,
    constraint BOOT3_LOCK_PK primary key (LOCK_KEY, REGION)
) ENGINE = InnoDB;

create table if not exists BOOT3_TASK_EXECUTION_METADATA
(
    ID                      BIGINT NOT NULL,
    TASK_EXECUTION_ID       BIGINT NOT NULL,
    TASK_EXECUTION_MANIFEST TEXT,
    primary key (ID),
    CONSTRAINT BOOT3_TASK_METADATA_FK FOREIGN KEY (TASK_EXECUTION_ID) REFERENCES BOOT3_TASK_EXECUTION (TASK_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_TASK_EXECUTION_METADATA_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE = InnoDB;
INSERT INTO BOOT3_TASK_EXECUTION_METADATA_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BOOT3_TASK_EXECUTION_METADATA_SEQ);

create table if not exists BOOT3_BATCH_JOB_INSTANCE
(
    JOB_INSTANCE_ID BIGINT       NOT NULL PRIMARY KEY,
    VERSION         BIGINT,
    JOB_NAME        VARCHAR(100) NOT NULL,
    JOB_KEY         VARCHAR(32)  NOT NULL,
    constraint BOOT3_JOB_INST_UN unique (JOB_NAME, JOB_KEY)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_JOB_EXECUTION
(
    JOB_EXECUTION_ID BIGINT      NOT NULL PRIMARY KEY,
    VERSION          BIGINT,
    JOB_INSTANCE_ID  BIGINT      NOT NULL,
    CREATE_TIME      DATETIME(6) NOT NULL,
    START_TIME       DATETIME(6) DEFAULT NULL,
    END_TIME         DATETIME(6) DEFAULT NULL,
    STATUS           VARCHAR(10),
    EXIT_CODE        VARCHAR(2500),
    EXIT_MESSAGE     VARCHAR(2500),
    LAST_UPDATED     DATETIME(6),
    constraint BOOT3_JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
        references BOOT3_BATCH_JOB_INSTANCE (JOB_INSTANCE_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_JOB_EXECUTION_PARAMS
(
    JOB_EXECUTION_ID BIGINT       NOT NULL,
    PARAMETER_NAME   VARCHAR(100) NOT NULL,
    PARAMETER_TYPE   VARCHAR(100) NOT NULL,
    PARAMETER_VALUE  VARCHAR(2500),
    IDENTIFYING      CHAR(1)      NOT NULL,
    constraint BOOT3_JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_STEP_EXECUTION
(
    STEP_EXECUTION_ID  BIGINT       NOT NULL PRIMARY KEY,
    VERSION            BIGINT       NOT NULL,
    STEP_NAME          VARCHAR(100) NOT NULL,
    JOB_EXECUTION_ID   BIGINT       NOT NULL,
    CREATE_TIME        DATETIME(6)  NOT NULL,
    START_TIME         DATETIME(6) DEFAULT NULL,
    END_TIME           DATETIME(6) DEFAULT NULL,
    STATUS             VARCHAR(10),
    COMMIT_COUNT       BIGINT,
    READ_COUNT         BIGINT,
    FILTER_COUNT       BIGINT,
    WRITE_COUNT        BIGINT,
    READ_SKIP_COUNT    BIGINT,
    WRITE_SKIP_COUNT   BIGINT,
    PROCESS_SKIP_COUNT BIGINT,
    ROLLBACK_COUNT     BIGINT,
    EXIT_CODE          VARCHAR(2500),
    EXIT_MESSAGE       VARCHAR(2500),
    LAST_UPDATED       DATETIME(6),
    constraint BOOT3_JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_STEP_EXECUTION_CONTEXT
(
    STEP_EXECUTION_ID  BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint BOOT3_STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
        references BOOT3_BATCH_STEP_EXECUTION (STEP_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_JOB_EXECUTION_CONTEXT
(
    JOB_EXECUTION_ID   BIGINT        NOT NULL PRIMARY KEY,
    SHORT_CONTEXT      VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint BOOT3_JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION (JOB_EXECUTION_ID)
) ENGINE = InnoDB;

create table if not exists BOOT3_BATCH_STEP_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint BOOT3_UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE = InnoDB;

INSERT INTO BOOT3_BATCH_STEP_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BOOT3_BATCH_STEP_EXECUTION_SEQ);

create table if not exists BOOT3_BATCH_JOB_EXECUTION_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint BOOT3_UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE = InnoDB;

INSERT INTO BOOT3_BATCH_JOB_EXECUTION_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BOOT3_BATCH_JOB_EXECUTION_SEQ);

create table if not exists BOOT3_BATCH_JOB_SEQ
(
    ID         BIGINT  NOT NULL,
    UNIQUE_KEY CHAR(1) NOT NULL,
    constraint UNIQUE_KEY_UN unique (UNIQUE_KEY)
) ENGINE = InnoDB;

INSERT INTO BOOT3_BATCH_JOB_SEQ (ID, UNIQUE_KEY)
select *
from (select 0 as ID, '0' as UNIQUE_KEY) as tmp
where not exists(select * from BOOT3_BATCH_JOB_SEQ);

-- V9-dataflow.sql
CREATE VIEW AGGREGATE_TASK_EXECUTION AS
SELECT TASK_EXECUTION_ID,
       START_TIME,
       END_TIME,
       TASK_NAME,
       EXIT_CODE,
       EXIT_MESSAGE,
       ERROR_MESSAGE,
       LAST_UPDATED,
       EXTERNAL_EXECUTION_ID,
       PARENT_EXECUTION_ID,
       'boot2' AS SCHEMA_TARGET
FROM TASK_EXECUTION
UNION ALL
SELECT TASK_EXECUTION_ID,
       START_TIME,
       END_TIME,
       TASK_NAME,
       EXIT_CODE,
       EXIT_MESSAGE,
       ERROR_MESSAGE,
       LAST_UPDATED,
       EXTERNAL_EXECUTION_ID,
       PARENT_EXECUTION_ID,
       'boot3' AS SCHEMA_TARGET
FROM BOOT3_TASK_EXECUTION;

CREATE VIEW AGGREGATE_TASK_EXECUTION_PARAMS AS
SELECT TASK_EXECUTION_ID, TASK_PARAM, 'boot2' AS SCHEMA_TARGET
FROM TASK_EXECUTION_PARAMS
UNION ALL
SELECT TASK_EXECUTION_ID, TASK_PARAM, 'boot3' AS SCHEMA_TARGET
FROM BOOT3_TASK_EXECUTION_PARAMS;

CREATE VIEW AGGREGATE_JOB_EXECUTION AS
SELECT JOB_EXECUTION_ID,
       VERSION,
       JOB_INSTANCE_ID,
       CREATE_TIME,
       START_TIME,
       END_TIME,
       STATUS,
       EXIT_CODE,
       EXIT_MESSAGE,
       LAST_UPDATED,
       'boot2' AS SCHEMA_TARGET
FROM BATCH_JOB_EXECUTION
UNION ALL
SELECT JOB_EXECUTION_ID,
       VERSION,
       JOB_INSTANCE_ID,
       CREATE_TIME,
       START_TIME,
       END_TIME,
       STATUS,
       EXIT_CODE,
       EXIT_MESSAGE,
       LAST_UPDATED,
       'boot3' AS SCHEMA_TARGET
FROM BOOT3_BATCH_JOB_EXECUTION;

CREATE VIEW AGGREGATE_JOB_INSTANCE AS
SELECT JOB_INSTANCE_ID, VERSION, JOB_NAME, JOB_KEY, 'boot2' AS SCHEMA_TARGET
FROM BATCH_JOB_INSTANCE
UNION ALL
SELECT JOB_INSTANCE_ID, VERSION, JOB_NAME, JOB_KEY, 'boot3' AS SCHEMA_TARGET
FROM BOOT3_BATCH_JOB_INSTANCE;

CREATE VIEW AGGREGATE_TASK_BATCH AS
SELECT TASK_EXECUTION_ID, JOB_EXECUTION_ID, 'boot2' AS SCHEMA_TARGET
FROM TASK_TASK_BATCH
UNION ALL
SELECT TASK_EXECUTION_ID, JOB_EXECUTION_ID, 'boot3' AS SCHEMA_TARGET
FROM BOOT3_TASK_TASK_BATCH;

CREATE VIEW AGGREGATE_STEP_EXECUTION AS
SELECT STEP_EXECUTION_ID,
       VERSION,
       STEP_NAME,
       JOB_EXECUTION_ID,
       START_TIME,
       END_TIME,
       STATUS,
       COMMIT_COUNT,
       READ_COUNT,
       FILTER_COUNT,
       WRITE_COUNT,
       READ_SKIP_COUNT,
       WRITE_SKIP_COUNT,
       PROCESS_SKIP_COUNT,
       ROLLBACK_COUNT,
       EXIT_CODE,
       EXIT_MESSAGE,
       LAST_UPDATED,
       'boot2' AS SCHEMA_TARGET
FROM BATCH_STEP_EXECUTION
UNION ALL
SELECT STEP_EXECUTION_ID,
       VERSION,
       STEP_NAME,
       JOB_EXECUTION_ID,
       START_TIME,
       END_TIME,
       STATUS,
       COMMIT_COUNT,
       READ_COUNT,
       FILTER_COUNT,
       WRITE_COUNT,
       READ_SKIP_COUNT,
       WRITE_SKIP_COUNT,
       PROCESS_SKIP_COUNT,
       ROLLBACK_COUNT,
       EXIT_CODE,
       EXIT_MESSAGE,
       LAST_UPDATED,
       'boot3' AS SCHEMA_TARGET
FROM BOOT3_BATCH_STEP_EXECUTION;

-- V8-dataflow.sql
RENAME TABLE task_execution_metadata TO task_execution_metadata_lc;
RENAME TABLE task_execution_metadata_lc TO TASK_EXECUTION_METADATA;
RENAME TABLE task_execution_metadata_seq TO task_execution_metadata_seq_lc;
RENAME TABLE task_execution_metadata_seq_lc TO TASK_EXECUTION_METADATA_SEQ;

-- V10-dataflow.sql
create index BATCH_STEP_EXECUTION_JOB_EXECUTION_ID_IX on BATCH_STEP_EXECUTION (JOB_EXECUTION_ID);
create index BOOT3_BATCH_STEP_EXECUTION_JOB_EXECUTION_ID_IX on BOOT3_BATCH_STEP_EXECUTION (JOB_EXECUTION_ID);
create index BOOT3_TASK_TASK_BATCH_JOB_EXECUTION_ID_IX on BOOT3_TASK_TASK_BATCH (JOB_EXECUTION_ID);
create index TASK_TASK_BATCH_JOB_EXECUTION_ID_IX on TASK_TASK_BATCH (JOB_EXECUTION_ID);
create index BATCH_JOB_EXECUTION_START_TIME_IX on BATCH_JOB_EXECUTION (START_TIME);
create index BOOT3_BATCH_JOB_EXECUTION_START_TIME_IX on BOOT3_BATCH_JOB_EXECUTION (START_TIME);

-- V11-dataflow.sql
create index TASK_EXECUTION_PARENT_IX on TASK_EXECUTION (PARENT_EXECUTION_ID);
create index BOOT3_TASK_EXECUTION_PARENT_IX on BOOT3_TASK_EXECUTION (PARENT_EXECUTION_ID);