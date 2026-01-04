#!/bin/bash

echo "=== DATABASE ==="
echo "Gunakan huruf kecil & underscore (_), TANPA spasi"
echo

mysql_cmd="sudo mysql"

# Database
read -p "Nama database: " dbname
dbname=${dbname// /_}

# Jumlah tabel
read -p "Jumlah tabel: " table_count

# Buat database dulu
$mysql_cmd -e "CREATE DATABASE IF NOT EXISTS \`$dbname\`;" \
  || { echo "❌ Gagal membuat database"; exit 1; }

for (( t=1; t<=table_count; t++ ))
do
  echo
  echo "=== TABEL KE-$t ==="

  read -p "Nama tabel: " tablename
  tablename=${tablename// /_}

  read -p "Jumlah kolom (tidak termasuk id): " col_count

  columns=""
  col_names=()

  for (( i=1; i<=col_count; i++ ))
  do
    echo
    read -p "Nama kolom ke-$i: " col
    col=${col// /_}

    read -p "Tipe data kolom $col (INT, VARCHAR(100), TEXT, dll): " type

    col_names+=("$col")

    if [ $i -eq $col_count ]; then
      columns+="\`$col\` $type"
    else
      columns+="\`$col\` $type, "
    fi
  done

  # CREATE TABLE
  sql_create_table="
  USE \`$dbname\`;
  CREATE TABLE IF NOT EXISTS \`$tablename\` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    $columns
  );
  "

  echo "⏳ Membuat tabel $tablename..."
  $mysql_cmd -e "$sql_create_table" || { echo "❌ Gagal create tabel"; exit 1; }

  # Insert data?
  echo
  read -p "Isi data untuk tabel $tablename? (y/n): " insert_choice

  if [[ "$insert_choice" == "y" ]]; then
    echo
    echo "=== INPUT DATA 1 BARIS ==="
    values=""

    for col in "${col_names[@]}"
    do
      read -p "Isi data untuk $col: " val
      val=${val//\'/\\\'}
      values+="'$val', "
    done

    values=${values%, }
    column_list=$(IFS=, ; echo "${col_names[*]}")

    sql_insert="
    USE \`$dbname\`;
    INSERT INTO \`$tablename\` ($column_list)
    VALUES ($values);
    "

    echo "⏳ Menyimpan data..."
    $mysql_cmd -e "$sql_insert" || { echo "❌ Gagal insert data"; exit 1; }
  fi

done

echo
echo "✅ SEMUA TABEL BERHASIL DIBUAT"

