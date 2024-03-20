package com.example.dddstudy.usecase;

import com.example.dddstudy.domain.mapper.UserMapper;
import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.presentation.UserCreateBody;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserUsecase {
    private final IUserRepository userRepository;

    @Autowired
    UserUsecase(IUserRepository userRepository){
        this.userRepository = userRepository;
    }

    public void createUser(User user){
        userRepository.save(user);
        return;
    }
}
