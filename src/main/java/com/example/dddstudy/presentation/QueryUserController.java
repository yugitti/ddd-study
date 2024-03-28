package com.example.dddstudy.presentation;

import com.example.dddstudy.domain.valueEntity.UserId;
import com.example.dddstudy.usecase.FindByIdUserUsecase;
import com.example.dddstudy.usecase.dto.input.FindByIdUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class QueryUserController {
    private final FindByIdUserUsecase findByUserUsecase;

    @Autowired
    QueryUserController(FindByIdUserUsecase findByUserUsecase){
        this.findByUserUsecase = findByUserUsecase;
    }

    @GetMapping(value = "/user/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public UserRes userFindByIdController(@PathVariable("id") String id) throws Exception {
        UserId userId = new UserId(id);
        FindByIdUserParams params = new FindByIdUserParams(userId);
        return this.findByUserUsecase.run(params);
    }

}
