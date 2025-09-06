plugins {
    id("java")
    id("application")
    id("org.graalvm.python") version "24.2.2"
    id("org.springframework.boot") version "3.5.5"
    id("io.spring.dependency-management") version "1.1.7"
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation("org.springframework.boot:spring-boot-starter-web")

    // GraalVM SDK
    implementation("org.graalvm.sdk:graal-sdk:24.2.2")

    // Guava
    implementation("com.google.guava:guava:32.1.1-jre")

    // Testing
    testImplementation("org.junit.jupiter:junit-jupiter:5.9.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(24))
    }
}

application {
    mainClass.set("gradle_java_docker.App")
}

// GraalPy plugin configuration
graalPy {
    packages = setOf("beautifulsoup4==4.12.3", "selenium==4.35.0")
    externalDirectory = file("${project.projectDir}/app/python-resources")
}

// JUnit test configuration
tasks.named<Test>("test") {
    useJUnitPlatform()
}
