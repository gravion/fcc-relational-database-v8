#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -c"

# create table
$PSQL "DROP TABLE IF EXISTS customers, services, appointments CASCADE;"

# create table services
$PSQL "CREATE TABLE services(
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(20) UNIQUE NOT NULL
  );"
# create table customers
$PSQL "CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(12) UNIQUE NOT NULL,
  name VARCHAR(20) NOT NULL
  );"
# create table appointments
$PSQL "CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(20) NOT NULL
  );"

$PSQL "INSERT INTO services(name) VALUES ('cut'), ('color'), ('perm'), ('style'), ('trim'), ('brazilian'), ('bob'), ('afro') ;"