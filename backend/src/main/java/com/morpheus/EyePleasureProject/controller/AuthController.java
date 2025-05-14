package com.morpheus.EyePleasureProject.controller;

import com.morpheus.EyePleasureProject.model.user.Client;
import com.morpheus.EyePleasureProject.repositories.ClientRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final ClientRepository clientRepository;

    public AuthController(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody Client cliente) {
        Optional<Client> encontrado = clientRepository.findByNicknameAndPsswd(
            cliente.getNickname(), cliente.getPsswd()
        );

        if (encontrado.isPresent()) {
            return ResponseEntity.ok("Login realizado com sucesso");
        } else {
            return ResponseEntity.status(401).body("Credenciais inválidas");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody Client novo) {
        if (clientRepository.findByNickname(novo.getNickname()).isPresent()) {
            return ResponseEntity.status(409).body("⚠️ Nickname já está em uso.");
        }

        clientRepository.save(novo);
        return ResponseEntity.ok("✅ Usuário registrado com sucesso.");
    }
}