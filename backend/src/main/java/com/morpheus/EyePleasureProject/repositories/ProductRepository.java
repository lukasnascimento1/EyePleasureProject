package com.morpheus.EyePleasureProject.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.morpheus.EyePleasureProject.model.product.Artefato;

@Repository
public interface ProductRepository extends JpaRepository<Artefato, Long>{
    
    List<Artefato> findByUsername(String username);
}
