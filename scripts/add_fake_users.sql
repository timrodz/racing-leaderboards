-- Script to add 10 fake users for testing purposes
-- This script inserts realistic test users into the users table
-- Usage: psql -d racing_leaderboards < scripts/add_fake_users.sql
-- Note: Uses ON CONFLICT to prevent duplicate insertions if run multiple times

INSERT INTO users (name, inserted_at, updated_at)
VALUES 
  ('John Doe', NOW(), NOW()),
  ('Jane Smith', NOW(), NOW()),
  ('Michael Johnson', NOW(), NOW()),
  ('Sarah Wilson', NOW(), NOW()),
  ('David Brown', NOW(), NOW()),
  ('Emily Davis', NOW(), NOW()),
  ('Robert Miller', NOW(), NOW()),
  ('Jessica Garcia', NOW(), NOW()),
  ('William Anderson', NOW(), NOW()),
  ('Ashley Martinez', NOW(), NOW())
ON CONFLICT (name) DO NOTHING;