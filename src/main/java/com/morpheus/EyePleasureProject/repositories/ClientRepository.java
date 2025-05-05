package com.morpheus.EyePleasureProject.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.morpheus.EyePleasureProject.model.user.Client;

public interface ClientRepository extends JpaRepository<Client, Long> {
    
    private List<Client> findByEmail(String email);
}