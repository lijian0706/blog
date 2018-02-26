/*
 Navicat Premium Data Transfer

 Source Server         : localhost_5432
 Source Server Type    : PostgreSQL
 Source Server Version : 90403
 Source Host           : localhost:5432
 Source Catalog        : new
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90403
 File Encoding         : 65001

 Date: 26/02/2018 10:51:54
*/


-- ----------------------------
-- Sequence structure for company_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."company_seq";
CREATE SEQUENCE "public"."company_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for employee_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."employee_seq";
CREATE SEQUENCE "public"."employee_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS "public"."company";
CREATE TABLE "public"."company" (
  "id" int8 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "district" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "city" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "province" varchar(100) COLLATE "pg_catalog"."default",
  "contact" varchar(100) COLLATE "pg_catalog"."default",
  "addr" varchar(100) COLLATE "pg_catalog"."default",
  "old_id" varchar(32) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."company" OWNER TO "postgres";
COMMENT ON COLUMN "public"."company"."name" IS '名称';
COMMENT ON COLUMN "public"."company"."district" IS '区';
COMMENT ON COLUMN "public"."company"."city" IS '市';
COMMENT ON COLUMN "public"."company"."province" IS '省';
COMMENT ON COLUMN "public"."company"."contact" IS '联系方式';
COMMENT ON COLUMN "public"."company"."addr" IS '地址';
COMMENT ON COLUMN "public"."company"."old_id" IS '老company_id';

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee";
CREATE TABLE "public"."employee" (
  "id" int8 NOT NULL,
  "name" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "sex" varchar(10) COLLATE "pg_catalog"."default",
  "age" int8,
  "company_id" int8 NOT NULL
)
;
ALTER TABLE "public"."employee" OWNER TO "postgres";
COMMENT ON COLUMN "public"."employee"."name" IS '姓名';
COMMENT ON COLUMN "public"."employee"."sex" IS '性别';
COMMENT ON COLUMN "public"."employee"."age" IS '年龄';
COMMENT ON COLUMN "public"."employee"."company_id" IS '公司id';

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."company_seq"
OWNED BY "public"."company"."id";
SELECT setval('"public"."company_seq"', 7, true);
ALTER SEQUENCE "public"."employee_seq"
OWNED BY "public"."employee"."id";
SELECT setval('"public"."employee_seq"', 3, true);

-- ----------------------------
-- Primary Key structure for table company
-- ----------------------------
ALTER TABLE "public"."company" ADD CONSTRAINT "company_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table employee
-- ----------------------------
ALTER TABLE "public"."employee" ADD CONSTRAINT "employee_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table employee
-- ----------------------------
ALTER TABLE "public"."employee" ADD CONSTRAINT "fk_company_id" FOREIGN KEY ("company_id") REFERENCES "public"."company" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
