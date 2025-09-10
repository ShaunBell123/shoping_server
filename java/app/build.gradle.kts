plugins {
    id("java")
    id("application")
    id("org.springframework.boot") version "3.5.5"
    id("io.spring.dependency-management") version "1.1.7"
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation("org.springframework.boot:spring-boot-starter-web")

    // Guava
    implementation("com.google.guava:guava:32.1.1-jre")

    // Testing
    testImplementation("org.junit.jupiter:junit-jupiter:5.9.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

springBoot {
    mainClass.set("com.java_server.shop.App")
}

// JUnit test configuration
tasks.named<Test>("test") {
    useJUnitPlatform()
}
