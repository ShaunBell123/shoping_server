FROM eclipse-temurin:17-jdk

ENV GRADLE_HOME=/opt/gradle
ENV GRADLE_VERSION=9.0.0
ARG GRADLE_DOWNLOAD_SHA256=8fad3d78296ca518113f3d29016617c7f9367dc005f932bd9d93bf45ba46072b

# Create gradle user and home
RUN groupadd gradle \
    && useradd -m -g gradle gradle \
    && mkdir -p /home/gradle/.gradle \
    && chown -R gradle:gradle /home/gradle \
    && ln -s /home/gradle/.gradle /root/.gradle

WORKDIR /home/gradle
VOLUME /home/gradle/.gradle

# Install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip git bash python3 python3-pip wget \
    && rm -rf /var/lib/apt/lists/*

# Download and install Gradle
RUN wget --no-verbose -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln -s "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

USER gradle
WORKDIR /home/gradle/project

# Copy project into container
COPY --chown=gradle:gradle . .

# Build the Spring Boot jar
RUN gradle bootJar --no-daemon

EXPOSE 8080

# Run Spring Boot
CMD ["java", "-jar", "build/libs/app.jar"]
