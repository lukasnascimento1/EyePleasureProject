package com.morpheus.EyePleasureProject;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.morpheus.EyePleasureProject.model.product.Artefato;
import com.morpheus.EyePleasureProject.repositories.ProductRepository;

@SpringBootApplication
public class EyePleasureProjectApplication {

	public static void main(String[] args) {
		SpringApplication.run(EyePleasureProjectApplication.class, args);
	}

	@Bean
    public CommandLineRunner carregarProdutos(ProductRepository produtoRepository) {
        return args -> {
            if (produtoRepository.count() == 0) {
                produtoRepository.save(new Artefato(
                    null,
                    "Hambúrguer 3D",
                    "Modelo realista de hambúrguer para visualização",
                    "Comida",
                    "29.90",
                    "/uploads/images/hamburger.png",
                    "/uploads/models/lukas/VidaNintendo.usdz",
                    1,
					"@lukasnascimentos"

                ));

                produtoRepository.save(new Artefato(
                    null,
                    "Pizza 3D",
                    "Modelo de pizza artesanal",
                    "Comida",
                    "34.90",
                    "/uploads/images/pizza.png",
                    "/uploads/models/lukas/VidaNintendo.usdz",
                    1,
					"@lukasnascimentos"
                ));
            }
        };
    }

}
