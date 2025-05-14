package com.morpheus.EyePleasureProject.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.morpheus.EyePleasureProject.model.product.Artefato;
import com.morpheus.EyePleasureProject.repositories.ProductRepository;


@RestController
@RequestMapping("/products")
public class ProductController {

    private final ProductRepository produtoRepository;
    
    public ProductController(ProductRepository produtoRepository) {
        this.produtoRepository = produtoRepository;
    }
    
    @PostMapping("/uploadModel")
    public ResponseEntity<String> uploadModel(@RequestParam("file") MultipartFile file) {
        try {
            String fileName = UUID.randomUUID() + ".usdz";
            Path filePath = Paths.get("uploads/models/", fileName);
            Files.createDirectories(filePath.getParent());
            file.transferTo(filePath.toFile());
            return ResponseEntity.ok("/uploads/models/" + fileName);
            
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erro: " + e.getMessage());
        }
    }

    // Exibir o modelo 3D
    @GetMapping("/modelos/{fileName}")
    public ResponseEntity<Resource> getModel(@PathVariable String fileName) throws IOException {
        Path baseDir = Paths.get("uploads/models");
        Path filePath = Files.walk(baseDir)
            .filter(path -> path.getFileName().toString().equals(fileName))
            .findFirst()
            .orElse(null);
    
        if (filePath == null || !Files.exists(filePath)) {
            return ResponseEntity.notFound().build();
        }
    
        Resource resource = new UrlResource(filePath.toUri());
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
            .contentType(MediaType.parseMediaType("model/vnd.usdz+zip"))
            .body(resource);
    }

    @GetMapping("/imagens/{fileName}")
    public ResponseEntity<Resource> getImage(@PathVariable String fileName) throws IOException {
        Path baseDir = Paths.get("uploads/models");
        Path filePath = Files.walk(baseDir)
            .filter(path -> path.getFileName().toString().equals(fileName))
            .findFirst()
            .orElse(null);

        if (filePath == null || !Files.exists(filePath)) {
            return ResponseEntity.notFound().build();
        }

        Resource resource = new UrlResource(filePath.toUri());
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
            .contentType(MediaType.IMAGE_JPEG)
            .body(resource);
    }

    @PostMapping
    public ResponseEntity<Artefato> criarProduto(@RequestBody Artefato produto) {
        Artefato novo = produtoRepository.save(produto);
        return ResponseEntity.ok(novo);
    }

    @GetMapping("/modelos")
    public ResponseEntity<List<String>> listarTodosOsModelos() {
        List<Artefato> produtos = produtoRepository.findAll();
        List<String> caminhosDosModelos = produtos.stream()
                .map(Artefato::getModelPath)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        return ResponseEntity.ok(caminhosDosModelos);
    }

    @GetMapping
    public ResponseEntity<List<Artefato>> listarTodosProdutos() {
        return ResponseEntity.ok(produtoRepository.findAll());
    }

    @PostMapping("/criarComArquivo")
    public ResponseEntity<?> criarComArquivo(
        @RequestParam("file") MultipartFile modelFile,
        @RequestParam("image") MultipartFile imageFile,
        @RequestParam("name") String name,
        @RequestParam("description") String description,
        @RequestParam("category") String category,
        @RequestParam("price") String price,
        @RequestParam("size") String size,
        @RequestParam("username") String username) {

    try {
        // Criar subdiretórios do usuário
        Path userBaseDir = Paths.get("uploads/", username);
        Path modelosDir = userBaseDir.resolve("Modelos");
        Path imagensDir = userBaseDir.resolve("Imagens");
        Path produtosDir = userBaseDir.resolve("Produtos");

        Files.createDirectories(modelosDir);
        Files.createDirectories(imagensDir);
        Files.createDirectories(produtosDir);

        // Salvar arquivos
        String modelFilename = UUID.randomUUID() + "." + getExtension(modelFile.getOriginalFilename());
        String imageFilename = UUID.randomUUID() + "." + getExtension(imageFile.getOriginalFilename());

        Path modelPath = modelosDir.resolve(modelFilename);
        Path imagePath = imagensDir.resolve(imageFilename);

        try (InputStream in = modelFile.getInputStream()) {
            Files.copy(in, modelPath, StandardCopyOption.REPLACE_EXISTING);
        }

        try (InputStream in = imageFile.getInputStream()) {
            Files.copy(in, imagePath, StandardCopyOption.REPLACE_EXISTING);
        }

        // Criar e salvar artefato no banco
        Artefato artefato = new Artefato();
        artefato.setName(name);
        artefato.setDescription(description);
        artefato.setCategory(category);
        artefato.setPrice(price);
        artefato.setSize(Integer.parseInt(size));
        artefato.setModelPath("/" + modelPath.toString().replace("\\", "/"));
        artefato.setImagePath("/" + imagePath.toString().replace("\\", "/"));
        artefato.setUsername(username);

        produtoRepository.save(artefato);

        // Salvar como JSON
        Path jsonPath = produtosDir.resolve(UUID.randomUUID() + ".json");
        new ObjectMapper().writerWithDefaultPrettyPrinter().writeValue(jsonPath.toFile(), artefato);
        
        /*
         * 
         // Novo: salvar os metadados do produto em JSON
         Path produtoDir = userBaseDir.resolve("Produtos");
         Files.createDirectories(produtoDir);
         
         String jsonFilename = UUID.randomUUID() + ".json";
         Path jsonPath = produtoDir.resolve(jsonFilename);
         
         // Criar um objeto com os dados do produto
         Map<String, Object> produtoMap = new LinkedHashMap<>();
         produtoMap.put("name", name);
         produtoMap.put("description", description);
         produtoMap.put("category", category);
         produtoMap.put("price", price);
         produtoMap.put("size", size);
         produtoMap.put("modelPath", artefato.getModelPath());
         produtoMap.put("imagePath", artefato.getImagePath());
         produtoMap.put("username", username);
         
         // Escrever o JSON
         ObjectMapper mapper = new ObjectMapper();
         mapper.writerWithDefaultPrettyPrinter().writeValue(jsonPath.toFile(), produtoMap);
         */
         
         return ResponseEntity.ok("Produto salvo com sucesso!");

    } catch (IOException e) {
        e.printStackTrace();
        return ResponseEntity.status(500).body("Erro ao salvar arquivos");
    }
}

private String getExtension(String filename) {
    return filename.substring(filename.lastIndexOf('.') + 1);
}
    
    @PostMapping("/testUpload")
    public ResponseEntity<String> testUpload(@RequestParam("file") MultipartFile file) {
        System.out.println("📩 Arquivo recebido: " + file.getOriginalFilename());
        System.out.println("📦 Tamanho: " + file.getSize() + " bytes");

        try {
            // Path path = Paths.get("uploads/models/", file.getOriginalFilename());
            Path path = Paths.get(System.getProperty("user.dir"), "uploads", "models", file.getOriginalFilename());
            Files.createDirectories(path.getParent());
            file.transferTo(path.toFile());
            return ResponseEntity.ok("Arquivo salvo com sucesso!");
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erro ao salvar: " + e.getMessage());
        }
    }

    @GetMapping("/usuario/{username}")
    public ResponseEntity<List<Artefato>> listarProdutosDoUsuario(@PathVariable String username) {
        List<Artefato> doUsuario = produtoRepository.findAll().stream()
                .filter(p -> username.equals(p.getUsername()))
                .collect(Collectors.toList());
    
        return ResponseEntity.ok(doUsuario);
    }
    
}
