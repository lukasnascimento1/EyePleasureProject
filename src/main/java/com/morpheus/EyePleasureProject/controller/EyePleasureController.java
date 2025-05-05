package com.morpheus.EyePleasureProject.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.morpheus.EyePleasureProject.services.EyePleasureService;



@RestController
@RequestMapping("/eyepleasure")
public class EyePleasureController {
    
    private final EyePleasureService eyePleasureService;

    public EyePleasureController(EyePleasureService eyePleasureService) {
        this.eyePleasureService = eyePleasureService;
    }

    @GetMapping("/addClient")
    public String addClient() {
        return eyePleasureService.addClient();
    }
    

    
    
}
