package com.morpheus.EyePleasureProject.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/helloworld")
public class helloworldController {

    @GetMapping
	public String index() {
		return "Welcome to EyePleasure Project!";
	}
}
