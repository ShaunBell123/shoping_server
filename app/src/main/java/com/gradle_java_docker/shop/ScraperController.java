package com.gradle_java_docker.shop;

// import java.io.File;
// import java.io.IOException;

// import org.graalvm.polyglot.Context;
// import org.graalvm.polyglot.Source;
// import org.graalvm.polyglot.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ScraperController {

    @PostMapping("/scrape")
    public String scrape(@RequestParam String shopName) {

        return "Scraping not available in Docker";

        // try (Context context = Context.newBuilder("python")
        //         .allowAllAccess(true)
        //         .option("python.PythonPath", "app/src/python_resources")
        //         .build()) {

        //     Source src = Source.newBuilder("python", new File("app/src/python_resources/" + shopName + ".py")).build();
        //     context.eval(src);

        //     Value pyClass = context.getBindings("python").getMember(shopName);
        //     Value instance = pyClass.newInstance();
        //     Value result = instance.invokeMember("scrape");

        //     return result.asString();

        // } catch (IOException e) {
        //     e.printStackTrace();
        //     return "Error reading Python file: " + e.getMessage();
        // } catch (Exception e) {
        //     e.printStackTrace();
        //     return "Python execution error: " + e.getMessage();
        // }

    }
    
}
