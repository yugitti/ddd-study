package com.example.dddstudy.usecase;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.usecase.dto.input.CreateUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CreateUserUsecase {
    private final IUserRepository userRepository;

    @Autowired
    CreateUserUsecase(IUserRepository userRepository){
        this.userRepository = userRepository;
    }

    public UserRes run(CreateUserParams params){
        User user = createUser(params);
        userRepository.save(user);
        return new UserRes(
                user.getId(),
                user.getName(),
                user.getBirthday(),
                user.getGender(),
                user.getAddress());
    }

    private User createUser(CreateUserParams params){

        return new User(new UserId(),  params.name(), params.birthday(), params.gender(), params.address());

    }

}
