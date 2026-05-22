#!/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'

echo -e "${GREEN}Setting up environment variables...${RESET}"

JWT_SECRET=$(openssl rand -hex 32)
EXP_TIME_HOURS=20

#API
cat > MusicRooms.Api/.env << EOL
JWT_SECRET=${JWT_SECRET}
EXP_TIME_HOURS=${EXP_TIME_HOURS}
EOL

#WEB
cat > MusicRooms.Web/.env << EOL
EXP_TIME_HOURS=${EXP_TIME_HOURS}
EOL

echo -e "${GREEN}Environment variables set up successfully!${RESET}"