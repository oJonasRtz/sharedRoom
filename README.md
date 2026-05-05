# 🎬 SharedRoom

Experience synchronized entertainment with friends in real-time. Watch YouTube videos together, chat, and manage your viewing experience seamlessly.

## 📑 Table of Contents

### Project Overview
1. [About](#-about)
2. [Key Features](#-key-features)
3. [Room Management Commands](#-room-management-commands)
4. [Tech Stack](#-tech-stack)

### How to Run
5. [Dependencies](#-dependencies)
6. [Quick Start](#-quick-start)
7. [Available Commands](#-available-commands)

### Other
8. [License](#-license)

## 🎯 About

**SharedRoom** is a collaborative media streaming platform that brings people together in virtual rooms. Whether you're planning a movie night or hosting a music session, SharedRoom lets you synchronize YouTube content across all participants in real-time. It's built as a modern web application using **C# and ASP.NET**, combining a **Blazor** frontend with a robust **Web API** backend.

## ✨ Key Features

### 📺 Public Room Dashboard
- Discover and browse public rooms created by other users
- Join any existing room instantly
- Create your own private or public room with a single click

### 🎪 Interactive Room Experience
- **Real-time Video Synchronization**: All participants watch the same YouTube content at the same time
- **Integrated Chat**: Communicate with other room members in real-time
- **Command System**: Control room functions via chat commands or intuitive UI

## 🎪 Room Management Commands

| Command | Purpose |
|---------|---------|
| `add <URL>` | Add a YouTube link to the queue |
| `remove <index>` | Remove a link from the queue |
| `invite <username>` | Generate an invite link for a specific user |
| `kick <username>` | Remove a user from the room |

All commands are available through both the chat interface and the graphical UI for maximum flexibility.

## 🛠️ Tech Stack

- **Backend**: ASP.NET Core Web API (C#)
- **Frontend**: Blazor WebAssembly
- **Real-time Communication**: SignalR (for synchronization)
- **.NET Version**: 8.0+

---

## 📋 Dependencies

### ⚠️ IMPORTANT: Docker is Required

This project **requires Docker and Docker Compose** to run. You cannot run this project without them.

### System Requirements

- **Docker**: Version 20.10 or higher ([Install Docker](https://docs.docker.com/get-docker/))
- **Docker Compose**: Version 1.29 or higher ([Install Docker Compose](https://docs.docker.com/compose/install/))
- **Operating System**: Linux, macOS, or Windows (with WSL 2 recommended)

### Verify Installation

Before running the project, verify that Docker and Docker Compose are installed:

```bash
docker --version
docker compose version
```

Both commands should return version information. If either command is not found, please install the missing tools.

## 🚀 Quick Start

### Prerequisites Checklist
- ✅ Docker installed and running
- ✅ Docker Compose installed
- ✅ No other dependencies needed!

### Running the Project

Simply run:
```bash
make
```

This will automatically build and start the application. Your project will be available shortly after!

## 📦 Available Commands

All commands are managed through `make`. Here's a complete reference:

| Command | Description |
|---------|-------------|
| `make` or `make all` | Build and start the application (default) |
| `make up` | Start the application containers |
| `make down` | Stop the application containers |
| `make build` | Build Docker images without starting |
| `make re` | Restart the application (down + up) |
| `make clean` | Remove containers, volumes, and prune unused data |
| `make fclean` | Complete cleanup including all images (full reset) |

### Usage Examples

**Start the application for the first time:**
```bash
make
```

**Stop the application:**
```bash
make down
```

**Restart the application:**
```bash
make re
```

**Clean up everything (be careful - this removes volumes):**
```bash
make clean
```

**Full system reset (removes all Docker artifacts):**
```bash
make fclean
```

## 📝 License

This project is built for learning and practice purposes. See LICENSE for details.

---

**Made with ❤️ to learn C# and ASP.NET**