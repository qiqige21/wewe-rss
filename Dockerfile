FROM node:22-alpine

WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install

# 复制所有文件（包括 prisma 目录）
COPY . .

# 设置 Prisma Schema 路径（关键修复！）
ENV PRISMA_SCHEMA_PATH=/app/prisma/schema.prisma

# 生成 Prisma Client
RUN npx prisma generate

# 构建前端和后端
RUN pnpm run build:web && pnpm run build:server

# 暴露端口
EXPOSE $PORT

# 启动命令（使用环境变量指定 schema）
CMD ["sh", "-c", "npx prisma db push --schema=/app/prisma/schema.prisma && node dist/server/index.js"]
