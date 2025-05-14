package com.morpheus.EyePleasureProject.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.morpheus.EyePleasureProject.model.user.Client;
import com.morpheus.EyePleasureProject.repositories.ClientRepository;

@RestController
@RequestMapping("/usuarios")
public class ClientController {

    private final ClientRepository clientRepository;

    public ClientController(ClientRepository userRepository) {
        this.clientRepository = userRepository;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> dados) {
        String login = dados.get("nickname");
        String senha = dados.get("psswd");
        
        if (login == null || senha == null)
            return ResponseEntity.badRequest().body("Login e senha são obrigatórios");
        
        if (login.isEmpty() || senha.isEmpty())
            return ResponseEntity.badRequest().body("Login e senha não podem ser vazios");
        System.out.println("Login recebido: " + login + " / " + senha);
        Optional<Client> usuario = clientRepository.findByNicknameAndPsswd(login, senha);
        if (usuario.isPresent()) {
            System.out.println("Usuário encontrado: " + usuario.isPresent());
            return ResponseEntity.ok().build(); // Sucesso
        } else {
            return ResponseEntity.status(401).body("Usuário ou senha inválidos");
        }
    }

    @PostMapping("/criar")
    public ResponseEntity<Client> criarUsuario(@RequestBody Client novo) {
        return ResponseEntity.ok(clientRepository.save(novo));
    }

    @GetMapping
    public ResponseEntity<List<Client>> listarTodosUsuarios() {
        return ResponseEntity.ok(clientRepository.findAll());
    }
}