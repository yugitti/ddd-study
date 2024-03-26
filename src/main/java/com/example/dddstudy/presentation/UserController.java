package com.example.dddstudy.presentation;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.presentation.dto.CreateUserBody;
import com.example.dddstudy.presentation.mapper.CreateUserMapper;
import com.example.dddstudy.usecase.CreateUserUsecase;
import com.example.dddstudy.usecase.dto.CreateUserParams;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    private final CreateUserUsecase userUsecase;
    private final CreateUserMapper userCreateMapper;
    @Autowired
    UserController(CreateUserUsecase userUsecase, CreateUserMapper userCreateMapper){
        this.userUsecase = userUsecase;
        this.userCreateMapper = userCreateMapper;
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
    @ResponseStatus(HttpStatus.CREATED)
    public User userCreateController(@Valid @RequestBody CreateUserBody body){
        CreateUserParams params = this.userCreateMapper.toCreateUserParams(body);
        return userUsecase.run(params);

    }
}
