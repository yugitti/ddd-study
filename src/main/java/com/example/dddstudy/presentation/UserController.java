package com.example.dddstudy.presentation;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.presentation.dto.CreateUserBody;
import com.example.dddstudy.presentation.mapper.CreateUserMapper;
import com.example.dddstudy.usecase.CreateUserUsecase;
import com.example.dddstudy.usecase.FindByIdUserUsecase;
import com.example.dddstudy.usecase.dto.input.CreateUserParams;
import com.example.dddstudy.usecase.dto.input.FindByIdUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    private final CreateUserUsecase createUserUsecase;
    private final CreateUserMapper userCreateMapper;
    private final FindByIdUserUsecase findByUserUsecase;
    @Autowired
    UserController(CreateUserUsecase userUsecase, CreateUserMapper userCreateMapper, FindByIdUserUsecase findByUserUsecase){
        this.createUserUsecase = userUsecase;
        this.userCreateMapper = userCreateMapper;
        this.findByUserUsecase = findByUserUsecase;
    }

    @GetMapping(value = "/user/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public UserRes userFindByIdController(@PathVariable("id") String id) throws Exception {
        UserId userId = new UserId(id);
        FindByIdUserParams params = new FindByIdUserParams(userId);
        return this.findByUserUsecase.run(params);
    }

    @PutMapping(value = "/user/create",produces = MediaType.APPLICATION_JSON_VALUE )
    @ResponseStatus(HttpStatus.CREATED)
    public User userCreateController(@Valid @RequestBody CreateUserBody body){
        CreateUserParams params = this.userCreateMapper.toCreateUserParams(body);
        return createUserUsecase.run(params);

    }
}
