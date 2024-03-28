package com.example.dddstudy.usecase;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.usecase.dto.input.UpdateUserParams;
import com.example.dddstudy.usecase.dto.output.UserRes;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UpdateUserUsecase {
    private final IUserRepository userRepository;

    @Autowired
    UpdateUserUsecase(IUserRepository userRepository){
        this.userRepository = userRepository;
    }

    public UserRes run(UpdateUserParams params){
        User userFromDb = userRepository
                .findById(params.getId())
                .orElseThrow(() -> new IllegalArgumentException("user id not found"));

        params.ifNamePresent(userFromDb::changeName);
        params.ifBirthdayPresent(userFromDb::changeBirthday);
        params.ifGenderPresent(userFromDb::changeGender);
        params.ifAddressPresent(userFromDb::changeAddress);

        userRepository.save(userFromDb);

        return new UserRes(
                userFromDb.getId(),
                userFromDb.getName(),
                userFromDb.getBirthday(),
                userFromDb.getGender(),
                userFromDb.getAddress());

    }


}
