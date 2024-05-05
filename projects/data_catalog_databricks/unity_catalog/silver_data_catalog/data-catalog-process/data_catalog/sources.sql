-- Databricks notebook source
-- MAGIC %python
-- MAGIC dbutils.widgets.removeAll()

-- COMMAND ----------

CREATE WIDGET DROPDOWN data_owner DEFAULT "dev_uc_catalogs_owners"  CHOICES (VALUES 'dev_uc_catalogs_owners', 'test_uc_catalogs_owners', 'prod_uc_catalogs_owners');
CREATE WIDGET DROPDOWN data_catalog DEFAULT "dev_data_catalog"  CHOICES (VALUES 'dev_data_catalog', 'test_data_catalog', 'data_catalog');
CREATE WIDGET TEXT database_name DEFAULT "silver_data_catalog";
CREATE WIDGET DROPDOWN storage_account DEFAULT "magellanadlsdev"  CHOICES (VALUES 'magellanadlsdev', 'magellanadlstest', 'magellanadlsprod');

-- COMMAND ----------

SELECT "${data_owner}", "${data_catalog}",  "${database_name}", "${storage_account}"

-- COMMAND ----------

USE CATALOG ${data_catalog};
USE DATABASE ${database_name};

-- COMMAND ----------

DROP TABLE IF EXISTS sources;

CREATE TABLE sources (
  `source` STRING NOT NULL COMMENT 'A source refers to the origin or location from which data is obtained. It can be one or more database, a file, an application, or any other system that generates or stores data.',
  `source_description` STRING COMMENT 'Provides a concise explanation of the data source, including its context, significance, and any relevant additional details.',
  `source_created_in_uc_at` TIMESTAMP COMMENT 'The date when the object was created in Unity Catalog.',
  `source_last_updated_at` TIMESTAMP COMMENT 'The last update data or schema of the database.',
  `tag_source_active_system` STRING COMMENT 'It indicates if it is an active system.',
  `tag_source_csl_internal_system` STRING COMMENT 'It indicates if it is an internal CSL system.'
  )
USING delta
COMMENT 'Table populated with metadata by business users and data stewards, used for filling in descriptions and tags.'
LOCATION 'abfss://silver@${storage_account}.dfs.core.windows.net/data_catalog/sources';

-- COMMAND ----------

ALTER TABLE sources OWNER TO ${data_owner};

-- COMMAND ----------

ALTER TABLE sources ADD CONSTRAINT `silver_sources_source` PRIMARY KEY(`source`);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ---