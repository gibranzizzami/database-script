#!/bin/bash

NAME="nama-database"
TABS="nama-table"
COLM="nama-kolom"
INST="nama-isian"

sudo mysql <<EOF
CREATE DATABASE $NAME;
USE $NAME;
CREATE TABLE $TABS;
