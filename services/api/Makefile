# Math App API - Makefile

.PHONY: help install dev build test migrate db-up db-down prisma-generate prisma-studio lint format

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	npm install

dev: ## Start development server with hot reload
	npm run start:dev

build: ## Build for production
	npm run build

test: ## Run all tests
	npm run test

test:watch: ## Run tests in watch mode
	npm run test:watch

test:e2e: ## Run end-to-end tests
	npm run test:e2e

coverage: ## Generate test coverage report
	npm run test:cov

migrate: ## Run database migrations
	npx prisma migrate dev

migrate-deploy: ## Deploy migrations in production
	npx prisma migrate deploy

db-up: ## Start database with Docker
	docker-compose up -d db

db-down: ## Stop database
	docker-compose down

dev-full: ## Start full development environment with Docker
	docker-compose up -d

prisma-generate: ## Generate Prisma client
	npx prisma generate

prisma-studio: ## Open Prisma Studio
	npx prisma studio

lint: ## Run ESLint
	npm run lint

format: ## Format code with Prettier
	npm run format

clean: ## Clean build artifacts and node_modules
	rm -rf dist node_modules

docker-build: ## Build Docker image
	docker build -t mathapp-api .

seed: ## Seed database with sample data
	npx ts-node prisma/seed.ts
