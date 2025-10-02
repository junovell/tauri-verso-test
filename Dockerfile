FROM debian:12

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install unzip curl

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

# install tauri and bun
RUN apt-get -y install libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev xdg-utils fuse
RUN curl -fsSL https://bun.sh/install | bash

# Prepare Android directories and system variables

ENV ANDROID_HOME="/Android/sdk"
ENV NDK_VERSION="28.2.13676358"
ENV NDK_HOME="$ANDROID_HOME/ndk/$NDK_VERSION"
ENV PATH="$PATH:$ANDROID_HOME/platform-tools"
ENV PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"

RUN mkdir -p $ANDROID_HOME
RUN mkdir -p .android && touch .android/repositories.cfg

# install rust android target
RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

# Set up Android SDK
RUN apt-get install -y default-jdk
RUN curl -fsSL -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mkdir $ANDROID_HOME/cmdline-tools && mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest


# RUN yes | sdkmanager --licenses && sdkmanager "build-tools;36.0.0" "ndk;$NDK_VERSION" "platform-tools" "platforms;android-36" "sources;android-36"
RUN yes | sdkmanager --licenses && sdkmanager "ndk;$NDK_VERSION" "platform-tools"
# RUN echo 'export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"' >> /etc/bash.bashrc
