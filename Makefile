
all: up

up: build
	@echo "Starting the application..."
	@docker compose up -d

down:
	@echo "Stopping the application..."
	@docker compose down

build: certs env
	@echo "Building the application..."
	@docker compose build --no-cache

certs:
	@echo "Generating SSL certificates..."
	@bash ./scripts/cert.sh

env:
	@missing=0; \
	for dir in MusicRooms.Api MusicRooms.Web; do \
		if [ ! -f "$$dir/.env" ]; then \
			echo "Error: Missing .env file in $$dir"; \
			missing=1; \
		fi; \
	done; \
	if [ $$missing -eq 1 ]; then \
		bash ./scripts/envs.sh; \
	fi

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

.PHONY: all up down re certs env build clean fclean