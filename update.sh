#!/bin/bash

echo "Updating..."
git pull
docker compose up --build --detach
echo "Update done"