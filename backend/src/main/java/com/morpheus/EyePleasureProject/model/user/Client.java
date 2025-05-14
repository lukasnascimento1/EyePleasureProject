package com.morpheus.EyePleasureProject.model.user;

import java.util.ArrayList;
import java.util.List;

import com.morpheus.EyePleasureProject.model.product.Artefato;

import jakarta.persistence.CascadeType;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Client class implements IUser interface
 * 
 * @author Morpheus
 * @version 1.0
 * @since 2023-10-01
 */

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = {"cpf", "nickname", "email"})
@ToString
public class Client implements IUser {  

    @Id
    @GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    private Long id;

    private String name, cpf, email, psswd, nickname;
    //private String endereco, telefone, dataDeNascimento;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Artefato> produtos;

    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Artefato> pizzas;

    @ElementCollection
    private List<String> informacoesPessoais;

    @ElementCollection
    private List<String> informacoesDePagamento;

    //  @ElementCollection
    //  private List<String> informacoesDeEntrega;
 
    //  @ElementCollection
    //  private List<String> informacoesDeContato;
 
    @Override
    public ArrayList<String> getInfo() {
    ArrayList<String> info = new ArrayList<>();
    info.add(name);
    info.add(cpf);
    info.add(email);
    info.add(psswd);
    info.add(nickname);
    //  info.add(endereco);
    //  info.add(telefone);
    //  info.add(dataDeNascimento);
        return info;
    }

    @Override
    public ArrayList<Artefato> getCart() {
        return new ArrayList<>(produtos != null ? produtos : List.of());
    }
 }