package com.example.dddstudy.usecase;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.usecase.dto.input.FindByIdUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FindByIdUserUsecase {
    private final IUserRepository userRepository;

    @Autowired
    FindByIdUserUsecase(IUserRepository userRepository){
        this.userRepository = userRepository;
    }

    public UserRes run(FindByIdUserParams params) throws Exception {
        User user = userRepository
                .findById(params.id())
                .orElseThrow(() -> new IllegalArgumentException("user id not found"));

        return new UserRes(
                user.getId(),
                user.getName(),
                user.getBirthday(),
                user.getGender(),
                user.getAddress());
    }
}
