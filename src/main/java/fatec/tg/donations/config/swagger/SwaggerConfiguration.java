package fatec.tg.donations.config.swagger;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfiguration {

    @Value("${info.app.version}")
    private String version;

    @Value("${springdoc.info.description}")
    private String description;

    @Value("${springdoc.info.title}")
    private String title;

    @Bean
    public OpenAPI infoApi() {

        Info info = new Info();
        info.setTitle(title);

        return new OpenAPI()
                .info(info.description(description).version(version));
    }

}
