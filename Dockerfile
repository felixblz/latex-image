FROM debian:12

WORKDIR /tex

RUN apt-get update && apt-get install -y \
    gnupg \
    curl \
    openjdk-17-jre \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://miktex.org/download/key | gpg --dearmor -o /usr/share/keyrings/miktex.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/miktex.gpg] https://miktex.org/download/debian bookworm universe" | tee /etc/apt/sources.list.d/miktex.list

RUN apt-get update && apt-get install -y \
    miktex \
    && rm -rf /var/lib/apt/lists/*

RUN miktexsetup \
    --shared=yes \
    finish

RUN initexmf \
    --admin \
    --set-config-value \
    [MPM]AutoInstall=1

WORKDIR /kotlin

ADD https://github.com/JetBrains/kotlin/releases/download/v2.1.21/kotlin-compiler-2.1.21.zip kotlin-compiler.zip

RUN unzip kotlin-compiler.zip  \
    && rm kotlin-compiler.zip

ENV PATH="/kotlin/kotlinc/bin:$PATH"

WORKDIR /app