package com.morpheus.EyePleasureProject.model.product;

import java.util.ArrayList;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "modelPath")
@ToString
@Table(name = "artefatos")
/**
 * Artefato class implements IProduct interface
 * 
 * @author Morpheus
 * @version 1.0
 * @since 2023-10-01
 */
public class Artefato implements IProduct{
    
    @Id
    @GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    private Long id;
    
    private String name, description, category, price;
    private String imagePath, modelPath;
    private Integer size;

    private String username;
    
    @Override
    public ArrayList<String> getInfo(){
        ArrayList<String> info = new ArrayList<>();
        info.add(name); 
        info.add(description);
        info.add(imagePath); 
        info.add(modelPath);
        
        return info;
    }

    
}
