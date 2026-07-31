#!/bin/bash

set -e

echo "Cleaning Lightek recursive backup corruption..."

echo "Removing recursive scaffold backups..."

rm -rf lib/generators/lightek/scaffold/backups


echo "Removing migrated backup copy..."

rm -rf .lightek/backups


echo "Recreating clean backup locations..."

mkdir -p lib/generators/lightek/scaffold/backups
mkdir -p .lightek/backups


echo "Creating backup ignore rules..."

touch lib/generators/lightek/scaffold/backups/.keep
touch .lightek/backups/.keep


echo "Backup cleanup complete."