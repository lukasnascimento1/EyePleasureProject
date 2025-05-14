package com.morpheus.EyePleasureProject.model.user;

import java.util.ArrayList;

import com.morpheus.EyePleasureProject.model.product.Artefato;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@AllArgsConstructor
@EqualsAndHashCode(of = {"cnpj", "nickname", "email"})
@ToString
public class Enterprise implements IUser{
    
    @Id
    @GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    private Long id;

    private String name, cnpj, email, psswd, nickname, cpf;

    @Override
    public ArrayList<Artefato> getCart() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getCart'");
    }

    @Override
    public ArrayList<String> getInfo() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getInfo'");
    }

}