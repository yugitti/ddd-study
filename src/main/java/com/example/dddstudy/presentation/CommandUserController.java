package com.example.dddstudy.presentation;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.UserId;
import com.example.dddstudy.presentation.dto.CreateUserBody;
import com.example.dddstudy.presentation.dto.UpdateUserBody;
import com.example.dddstudy.presentation.mapper.CreateUserMapper;
import com.example.dddstudy.usecase.CreateUserUsecase;
import com.example.dddstudy.usecase.DeleteUserUsecase;
import com.example.dddstudy.usecase.UpdateUserUsecase;
import com.example.dddstudy.usecase.dto.input.CreateUserParams;
import com.example.dddstudy.usecase.dto.input.DeleteUserParams;
import com.example.dddstudy.usecase.dto.input.UpdateUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
public class CommandUserController {

    private final CreateUserUsecase createUserUsecase;
    private final CreateUserMapper userCreateMapper;
    private final UpdateUserUsecase updateUserUsecase;
    private final DeleteUserUsecase deleteUserUsecase;

    @Autowired
    CommandUserController(CreateUserUsecase userUsecase, CreateUserMapper userCreateMapper, UpdateUserUsecase updateUserUsecase, DeleteUserUsecase deleteUserUsecase){
        this.createUserUsecase = userUsecase;
        this.userCreateMapper = userCreateMapper;
        this.updateUserUsecase = updateUserUsecase;
        this.deleteUserUsecase = deleteUserUsecase;
    }


    @PutMapping(value = "/user/create",produces = MediaType.APPLICATION_JSON_VALUE )
    @ResponseStatus(HttpStatus.CREATED)
    public UserRes userCreateController(@Valid @RequestBody CreateUserBody body){
        CreateUserParams params = this.userCreateMapper.toCreateUserParams(body);
        return createUserUsecase.run(params);

    }

    @PostMapping(value = "/user/update",produces = MediaType.APPLICATION_JSON_VALUE )
    @ResponseStatus(HttpStatus.CREATED)
    public UserRes userUpdateController(@Valid @RequestBody UpdateUserBody body){
        UpdateUserParams params = this.userCreateMapper.toUpdateUserParams(body);
        return updateUserUsecase.run(params);
    }

    @DeleteMapping(value = "/user/delete/{id}",produces = MediaType.APPLICATION_JSON_VALUE )
    @ResponseStatus(HttpStatus.CREATED)
    public void userUpdateController(@PathVariable("id") String id){
        UserId userId = new UserId(id);
        DeleteUserParams params = new DeleteUserParams(userId);
        deleteUserUsecase.run(params);
        return;
    }
}
