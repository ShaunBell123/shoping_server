package gradle_java_docker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class App {

    public static void main(String[] args) {
        System.out.println("Shopping Java Server is running!");
        SpringApplication.run(App.class, args);
    }

}
