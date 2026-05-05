
all: up

up: build
	@echo "Starting the application..."
	@docker compose up -d

down:
	@echo "Stopping the application..."
	@docker compose down

build:
	@echo "Building the application..."
	@docker compose build

clean:
	@echo "Clearing the application data..."
	@docker compose down -v
	@docker containers prune -f
	@docker images prune -f
	@docker networks prune -f

fclean: clean
	@echo "Removing all Docker images..."
	@docker system prune -a -f --volumes

re: down up

.PHONY: all up down re