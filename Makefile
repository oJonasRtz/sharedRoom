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
	@mkdir -p .dotnet
	@DOTNET_CLI_HOME=.dotnet DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet dev-certs https --export-path server/certs/server.cert --format Pem --no-password

env:
	@if [ "$${OS:-}" = "Windows_NT" ] && command -v powershell.exe >/dev/null 2>&1; then \
		powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./scripts/envs.ps1; \
	else \
		missing=0; \
		for dir in MusicRooms.Api MusicRooms.Web; do \
			if [ ! -f "$$dir/.env" ]; then \
				echo "Error: Missing .env file in $$dir"; \
				missing=1; \
			fi; \
		done; \
		if [ $$missing -eq 1 ]; then \
			bash ./scripts/envs.sh; \
		fi; \
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