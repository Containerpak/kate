FROM ghcr.io/containerpak/mesa64-sdk:main AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG KATE_URL=https://download.kde.org/stable/release-service/26.08.1/src/kate-26.08.1.tar.xz
ARG KATE_SHA256=b7d690761e37c29b425375ee42b959b59a9de693789de86e0fb826bace5b3d7f

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake curl extra-cmake-modules gettext libkf6config-dev \
    libkf6coreaddons-dev libkf6crash-dev libkf6dbusaddons-dev \
    libkf6doctools-dev libkf6guiaddons-dev libkf6i18n-dev \
    libkf6iconthemes-dev libkf6newstuff-dev libkf6texteditor-dev \
    libkf6textwidgets-dev libkf6userfeedback-dev libkf6wallet-dev \
    libkf6windowsystem-dev libkf6xmlgui-dev ninja-build pkgconf \
    qt6-base-dev qt6-base-private-dev qt6-declarative-dev \
    qtkeychain-qt6-dev && \
    curl -fL "$KATE_URL" -o /tmp/kate.tar.xz && \
    echo "$KATE_SHA256  /tmp/kate.tar.xz" | sha256sum -c - && \
    mkdir -p /tmp/kate && \
    tar -xJf /tmp/kate.tar.xz -C /tmp/kate --strip-components=1 && \
    cmake -S /tmp/kate -B /tmp/kate/build -G Ninja \
    -DBUILD_TESTING=OFF -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr && \
    cmake --build /tmp/kate/build && \
    DESTDIR=/out cmake --install /tmp/kate/build

FROM ghcr.io/containerpak/mesa64:main

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    kate konsole-kpart markdownpart sonnet6-plugins && \
    cpak-clean-junk

COPY --from=build /out/usr/ /usr/
