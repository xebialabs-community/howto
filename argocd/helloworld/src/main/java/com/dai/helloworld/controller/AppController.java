package com.dai.helloworld.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AppController {

	@RequestMapping("/")
	String hello1() {
		return "Hello World, Spring Boot Change1!";
	}
}
