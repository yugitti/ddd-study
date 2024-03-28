package com.example.dddstudy.usecase;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.usecase.dto.input.DeleteUserParams;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DeleteUserUsecase {

    IUserRepository userRepository;

    @Autowired
    DeleteUserUsecase(IUserRepository userRepository){
        this.userRepository = userRepository;
    }

    public void run(DeleteUserParams params){

        userRepository.delete(params.id());

        return;

    }
}
