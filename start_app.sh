#!/bin/bash

# DEBUG
echo "DEBUG: start_app.sh"
echo "DEBUG: DB_USER: $DB_USER"
echo "DEBUG: DB_PASS: $DB_PASS"
echo "DEBUG: DB_URL: $DB_URL"
echo "DEBUG: DB_PORT: $DB_PORT"
echo "DEBUG: DB_TABLE: $DB_TABLE"


# Javaアプリケーションの起動コマンド（jarファイル名は適宜変更してください）
java -jar target/ddd-study.jar
