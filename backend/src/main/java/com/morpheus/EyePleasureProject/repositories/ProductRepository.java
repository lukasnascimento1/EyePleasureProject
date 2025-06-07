package com.morpheus.EyePleasureProject.repositories;

import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.morpheus.EyePleasureProject.model.product.Artefato;

@Repository
public interface ProductRepository extends JpaRepository<Artefato, Long>{
    
    Set<Artefato> findByUsername(String username);
    Set<Artefato> findByCategory(String category);

    
}
