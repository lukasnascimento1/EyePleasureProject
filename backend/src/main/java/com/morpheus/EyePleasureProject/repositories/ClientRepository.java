package com.morpheus.EyePleasureProject.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import com.morpheus.EyePleasureProject.model.user.Client;

import java.util.Optional;

public interface ClientRepository extends JpaRepository<Client, Long> {
    Optional<Client> findByNicknameAndPsswd(String nickname, String psswd);
    Optional<Client> findByNickname(String nickname);
}