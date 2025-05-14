package com.morpheus.EyePleasureProject.model.product;

import java.util.ArrayList;


public interface IProduct {
    
    public String getDescription();

    public String getName();
    
    public String getPrice();

    public Integer getSize();
    
    /**
     * Get main image path of the Product
     * @return
     */
    public String getImagePath();
    
    /**
     * Get path to Product 3D model data
     * @return
     */
    public String getModelPath();

    /**
     * Get basic info to info into arraylist to controller validate
     */
    public ArrayList<String> getInfo();

    public void setDescription(String description);

    public void setName(String name);

    public void setImagePath(String path);

    public void setModelPath(String path);
    
}
