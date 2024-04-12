CREATE TABLE dataset (
    DATASET_ID INT GENERATED ALWAYS AS IDENTITY,
    REF VARCHAR(512) NOT NULL,
    FULL_NAME VARCHAR(512) NOT NULL,
    ABBREVIATION VARCHAR(512) NOT NULL,
    DESCRIPTION TEXT DEFAULT '',
    PRIMARY KEY (DATASET_ID),
    UNIQUE (REF)
);

CREATE TABLE dataset_meta (
    DATASET_META_ID INT GENERATED ALWAYS AS IDENTITY,
    DATASET_ID INT NOT NULL,
    KEY VARCHAR(256) NOT NULL,
    VALUE TEXT NOT NULL,
    UNIQUE (KEY, DATASET_ID),
    CONSTRAINT fk_study FOREIGN KEY(DATASET_ID) REFERENCES dataset(DATASET_ID),
);

CREATE TABLE consent (
    CONSENT_ID INT GENERATED ALWAYS AS IDENTITY,
    DATASET_ID INT NOT NULL,
    CONSENT_CODE VARCHAR(512) NOT NULL,
    DESCRIPTION VARCHAR(512) NOT NULL,
    AUTHZ VARCHAR(512) NOT NULL,
    PRIMARY KEY (CONSENT_ID),
    UNIQUE (CONSENT_CODE, DATASET_ID)
);

CREATE TABLE concept_node (
    CONCEPT_NODE_ID INT GENERATED ALWAYS AS IDENTITY,
    DATASET_ID INT NOT NULL,
    NAME VARCHAR(512) NOT NULL,
    DISPLAY VARCHAR(512) NOT NULL,
    CONCEPT_PATH VARCHAR(10000) NOT NULL DEFAULT 'INVALID',
    PARENT_ID INT,
    PRIMARY KEY (CONCEPT_NODE_ID),
    CONSTRAINT fk_parent FOREIGN KEY (PARENT_ID) REFERENCES CONCEPT_NODE(CONCEPT_NODE_ID),
    CONSTRAINT fk_study FOREIGN KEY (DATASET_ID) REFERENCES dataset(DATASET_ID)
);
CREATE UNIQUE INDEX concept_node_concept_path_idx ON CONCEPT_NODE (md5(CONCEPT_PATH));

CREATE TABLE concept_node_meta (
    CONCEPT_NODE_META_ID INT GENERATED ALWAYS AS IDENTITY,
    KEY VARCHAR(256) NOT NULL,
    VALUE TEXT NOT NULL,
    PRIMARY KEY (CONCEPT_NODE_META_ID),
    UNIQUE (KEY, CONCEPT_NODE_ID),
    CONSTRAINT fk_CONCEPT_NODE FOREIGN KEY (CONCEPT_NODE_ID) REFERENCES CONCEPT_NODE(CONCEPT_NODE_ID)
);

CREATE TABLE facet_category (
    FACET_CATEGORY_ID INT GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR(512) NOT NULL,
    DISPLAY VARCHAR(512) NOT NULL,
    DESCRIPTION TEXT DEFAULT '',
    PRIMARY KEY (FACET_CATEGORY_ID),
    UNIQUE (NAME)
);

CREATE TABLE facet (
    FACET_ID INT GENERATED ALWAYS AS IDENTITY,
    FACET_CATEGORY_ID INT NOT NULL,
    NAME VARCHAR(512) NOT NULL,
    DISPLAY VARCHAR(512) NOT NULL,
    DESCRIPTION TEXT DEFAULT '',
    PARENT INT,
    PRIMARY KEY (FACET_ID),
    UNIQUE (NAME, FACET_CATEGORY_ID),
    CONSTRAINT fk_parent FOREIGN KEY (PARENT_ID) REFERENCES facet(FACET_ID),
    CONSTRAINT fk_category FOREIGN KEY (FACET_CATEGORY_ID) REFERENCES facet_category(FACET_CATEGORY_ID)
);

CREATE TABLE concept_node_meta__concept_node (
    CONCEPT_NODE_META__CONCEPT_NODE INT GENERATED ALWAYS AS IDENTITY,
    CONCEPT_NODE_META_ID INT NOT NULL,
    CONCEPT_NODE_ID INT NOT NULL,
    PRIMARY KEY (CONCEPT_NODE_META_ID),
    CONSTRAINT fk_CONCEPT_NODE FOREIGN KEY (CONCEPT_NODE_META_ID) REFERENCES CONCEPT_NODE_meta(CONCEPT_NODE_META_ID),
    CONSTRAINT fk_CONCEPT_NODE FOREIGN KEY (CONCEPT_NODE_ID) REFERENCES CONCEPT_NODE(CONCEPT_NODE_ID)
);

CREATE TABLE harmonized_concept_node (
    HARMONIZED_CONCEPT_NODE_ID INT GENERATED ALWAYS AS IDENTITY,
    NAME VARCHAR(512) NOT NULL,
    DISPLAY VARCHAR(512) NOT NULL,
    CONCEPT_PATH VARCHAR(10000) NOT NULL DEFAULT 'INVALID',
    PARENT_ID INT,
    PRIMARY KEY (CONCEPT_NODE_ID),
    CONSTRAINT fk_parent FOREIGN KEY (PARENT_ID) REFERENCES harmonized_CONCEPT_NODE(CONCEPT_NODE_ID),
);
CREATE UNIQUE INDEX harmonized_concept_node_concept_path_idx ON harmonized_concept_node(md5(CONCEPT_PATH));

CREATE TABLE harmonized_concept_node__concept_node (
    HARMONIZED_CONCEPT_NODE__CONCEPT_NODE INT GENERATED ALWAYS AS IDENTITY,
    HARMONIZED_CONCEPT_NODE_ID INT NOT NULL,
    CONCEPT_NODE_ID INT NOT NULL,
    PRIMARY KEY (HARMONIZED_CONCEPT_NODE__CONCEPT_NODE),
    UNIQUE(HARMONIZED_CONCEPT_NODE_ID, CONCEPT_NODE_ID),
    CONSTRAINT fk_harmonized_CONCEPT_NODE FOREIGN KEY (HARMONIZED_CONCEPT_NODE_ID) REFERENCES harmonized_CONCEPT_NODE(HARMONIZED_CONCEPT_NODE_ID),
    CONSTRAINT fk_CONCEPT_NODE FOREIGN KEY (CONCEPT_NODE_ID) REFERENCES CONCEPT_NODE(CONCEPT_NODE_ID),
);
