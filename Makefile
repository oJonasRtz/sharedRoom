all: up

up: build show-url
	@echo "Starting the application..."
	@docker compose up -d

down:
	@echo "Stopping the application..."
	@docker compose down

show-url:
	@echo "Tunnel URL:"
	@docker compose logs cloudflared | grep -o 'https://[-a-zA-Z0-9]*\.trycloudflare\.com' | tail -1
	@echo "Note: It may take a few seconds for the tunnel URL to appear. If you don't see it, try running 'make show-url' again after a moment."

build: certs env
	@echo "Building the application..."
	@docker compose build --no-cache

certs:
	@echo "Generating SSL certificates..."
	@if [ "$${OS:-}" = "Windows_NT" ] && command -v powershell.exe >/dev/null 2>&1; then \
		powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./scripts/cert.ps1; \
	else \
		mkdir -p .dotnet; \
		DOTNET_CLI_HOME=.dotnet DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet dev-certs https --export-path server/certs/server.cert --format Pem --no-password; \
	fi

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

remake:
	@echo "Recreating the application..."
	@docker compose down -v
	@rm -f server/certs/server.cert server/certs/server.key
	@rm -f MusicRooms.Api/.env MusicRooms.Web/.env
	@$(MAKE) up

re: remake

.PHONY: all up down re remake certs env build clean fclean show-url