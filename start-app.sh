#!/bin/bash

# 1. Start containers in detached mode
echo "Starting containers..."
docker compose up -d

# 2. Wait until Postgres service is healthy
echo "Waiting for Postgres to be ready..."
while true; do
  STATUS=$(docker compose ps -q db | xargs docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}nohealth{{end}}')
  if [ "$STATUS" = "healthy" ] || [ "$STATUS" = "nohealth" ]; then
    break
  fi
  sleep 1
done

# 3. Run Prisma migration (only if schema changed)
echo "Running Prisma migrations..."
docker compose exec app bunx prisma migrate deploy

# 4. Optional: Open Prisma Studio in default browser
# echo "Opening Prisma Studio..."
# docker compose exec -d app bunx prisma studio

echo "✅ App is ready! Server running on port 3000"


# cd /path/to/express-prisma-app
# ./start-app.sh