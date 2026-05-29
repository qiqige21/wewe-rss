FROM node:22-alpine

WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install

# 复制所有文件
COPY . .

# 生成 Prisma Client
RUN npx prisma generate

# 构建前端和后端
RUN pnpm run build:web && pnpm run build:server

# 暴露端口（Railway 会用 $PORT 环境变量）
EXPOSE $PORT

# 启动命令
CMD ["sh", "-c", "npx prisma db push && node dist/server/index.js"]
