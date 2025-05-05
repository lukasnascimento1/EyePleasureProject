package com.morpheus.EyePleasureProject.services;

import org.springframework.stereotype.Service;

import com.morpheus.EyePleasureProject.repositories.ProductRepository;

@Service
public class EyePleasureService {

    private final ProductRepository productRepository;

    public EyePleasureService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }
    
    public String addClient() {
        return "Client added successfully!";
    }
    
    
}
