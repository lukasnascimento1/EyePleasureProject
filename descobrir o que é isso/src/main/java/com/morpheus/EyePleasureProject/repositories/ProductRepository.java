package com.morpheus.EyePleasureProject.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.morpheus.EyePleasureProject.model.product.Artefato;

@Repository
public interface ProductRepository extends JpaRepository<Artefato, Long>{
    
}
