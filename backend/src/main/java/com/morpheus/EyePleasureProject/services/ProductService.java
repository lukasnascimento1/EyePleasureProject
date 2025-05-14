package com.morpheus.EyePleasureProject.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.morpheus.EyePleasureProject.model.product.Artefato;
import com.morpheus.EyePleasureProject.repositories.ProductRepository;

@Service
public class ProductService {
    
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Artefato> listAllProducts() {
        return productRepository.findAll();
    }

    

}
