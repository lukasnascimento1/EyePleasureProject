package com.morpheus.EyePleasureProject.model.user;

import java.util.ArrayList;

import com.morpheus.EyePleasureProject.model.product.Artefato;

public interface IUser {
    
    public String getName();
    
    public String getCpf();
    
    public String getEmail();
    
    public String getPsswd();
    
    public String getNickname();
    
    public void setName(String name);
    
    public void setCpf(String cpf);
    
    public void setEmail(String email);
    
    public void setPsswd(String psswd);
    
    public void setNickname(String nickname);
    
    public ArrayList<Artefato> getCart();
    
    public ArrayList<String> getInfo();
}
