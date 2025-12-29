# FROM node:20-alpine
FROM oven/bun:latest

WORKDIR /app

# COPY package*.json ./
COPY bun.lock package.json ./

RUN bun install

# Copy prisma schema first to cache the generation step
COPY prisma ./prisma
RUN bunx prisma generate

COPY . .


EXPOSE 3000

CMD ["bun", "run", "dev"]
