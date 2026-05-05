FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /workspace

RUN apt-get update && apt-get install -y \
	git \
	curl \
	wget \
	vim \
	time \
	make \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*