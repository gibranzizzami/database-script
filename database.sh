#!/bin/bash

NAME=$(arsip)
COLM=$('nama-kolom')
INST=$('nama-isian')

sudo mysql -u root -p <<EOF
CREATE DATABASE $NAME;
USE $NAME;
