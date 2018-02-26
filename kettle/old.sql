/*
 Navicat Premium Data Transfer

 Source Server         : localhost_5432
 Source Server Type    : PostgreSQL
 Source Server Version : 90403
 Source Host           : localhost:5432
 Source Catalog        : old
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 90403
 File Encoding         : 65001

 Date: 26/02/2018 10:52:27
*/


-- ----------------------------
-- Table structure for company
-- ----------------------------
DROP TABLE IF EXISTS "public"."company";
CREATE TABLE "public"."company" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "address" varchar(100) COLLATE "pg_catalog"."default",
  "tel" varchar(100) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."company" OWNER TO "postgres";
COMMENT ON COLUMN "public"."company"."name" IS '名称';
COMMENT ON COLUMN "public"."company"."address" IS '地址';
COMMENT ON COLUMN "public"."company"."tel" IS '电话';

-- ----------------------------
-- Records of company
-- ----------------------------
BEGIN;
INSERT INTO "public"."company" VALUES ('2018022410181019879', '合肥xx集团', '合肥市xx路xx号', '055162311111');
INSERT INTO "public"."company" VALUES ('2018022410181019878', '合肥xx科技有限公司', '合肥市xx路xx号', '055163452211');
COMMIT;

-- ----------------------------
-- Table structure for company_district
-- ----------------------------
DROP TABLE IF EXISTS "public"."company_district";
CREATE TABLE "public"."company_district" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "company_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "district_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."company_district" OWNER TO "postgres";

-- ----------------------------
-- Records of company_district
-- ----------------------------
BEGIN;
INSERT INTO "public"."company_district" VALUES ('2018022410181030000', '2018022410181019879', '2018022410181020002');
INSERT INTO "public"."company_district" VALUES ('2018022410181030001', '2018022410181019878', '2018022410181020003');
COMMIT;

-- ----------------------------
-- Table structure for district
-- ----------------------------
DROP TABLE IF EXISTS "public"."district";
CREATE TABLE "public"."district" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "code" varchar(100) COLLATE "pg_catalog"."default",
  "level" int8,
  "parent_id" varchar(32) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."district" OWNER TO "postgres";
COMMENT ON COLUMN "public"."district"."name" IS '名称';
COMMENT ON COLUMN "public"."district"."code" IS '编码';
COMMENT ON COLUMN "public"."district"."level" IS '级别 1为省，2为市，3为区';
COMMENT ON COLUMN "public"."district"."parent_id" IS '父级id';

-- ----------------------------
-- Records of district
-- ----------------------------
BEGIN;
INSERT INTO "public"."district" VALUES ('2018022410181020000', '安徽省', '340000', 1, NULL);
INSERT INTO "public"."district" VALUES ('2018022410181020002', '瑶海区', '340102', 3, '2018022410181020001');
INSERT INTO "public"."district" VALUES ('2018022410181020001', '合肥市', '340100', 2, '2018022410181020000');
INSERT INTO "public"."district" VALUES ('2018022410181020003', '庐阳区', '340103', 3, '2018022410181020001');
COMMIT;

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee";
CREATE TABLE "public"."employee" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "age" int8,
  "sex" int8
)
;
ALTER TABLE "public"."employee" OWNER TO "postgres";
COMMENT ON COLUMN "public"."employee"."name" IS '姓名';
COMMENT ON COLUMN "public"."employee"."age" IS '年龄';
COMMENT ON COLUMN "public"."employee"."sex" IS '性别 1男 2女';

-- ----------------------------
-- Records of employee
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee" VALUES ('2018022410181040000', '张三', 26, 1);
INSERT INTO "public"."employee" VALUES ('2018022410181040001', '李四', 23, 2);
COMMIT;

-- ----------------------------
-- Table structure for employee_company
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee_company";
CREATE TABLE "public"."employee_company" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "employee_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "company_id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."employee_company" OWNER TO "postgres";
COMMENT ON COLUMN "public"."employee_company"."employee_id" IS '员工id';
COMMENT ON COLUMN "public"."employee_company"."company_id" IS '公司id';

-- ----------------------------
-- Records of employee_company
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee_company" VALUES ('2018022410181050000', '2018022410181040000', '2018022410181019879');
INSERT INTO "public"."employee_company" VALUES ('2018022410181050001', '2018022410181040001', '2018022410181019878');
COMMIT;

-- ----------------------------
-- Primary Key structure for table company
-- ----------------------------
ALTER TABLE "public"."company" ADD CONSTRAINT "company_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table company_district
-- ----------------------------
ALTER TABLE "public"."company_district" ADD CONSTRAINT "company_district_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table district
-- ----------------------------
ALTER TABLE "public"."district" ADD CONSTRAINT "district_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table employee
-- ----------------------------
ALTER TABLE "public"."employee" ADD CONSTRAINT "employee_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table employee_company
-- ----------------------------
ALTER TABLE "public"."employee_company" ADD CONSTRAINT "employee_company_pkey" PRIMARY KEY ("id");
