package com.example.dddstudy.presentation;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.mapper.UserMapper;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.usecase.UserUsecase;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    private final UserUsecase userUsecase;
    @Autowired
    UserController(UserUsecase userUsecase){
        this.userUsecase = userUsecase;
    }

    @GetMapping(value = "/user", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public User userController(){
        UserId id = new UserId();
        FullName name = new FullName("Yugi", "Tsutomu");
        Birthday birthday = new Birthday(1980, 8, 15);
        Gender gender = Gender.Male;
        Address address = new Address(Prefectures.TOKYO, "XXX", "YYY", "3");

        return new User(id, name, birthday, gender, address);
    }

    @PutMapping(value = "/user/create",produces = MediaType.APPLICATION_JSON_VALUE )
    public void userCreateController(@Valid @RequestBody UserCreateBody body){
        User user = UserMapper.INSTANCE.userCreateBodyToUser(body);
        userUsecase.createUser(user);
        System.out.println("hello");

    }
}
