package com.example.dddstudy.repository;
import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.domain.valueEntity.FullName;
import com.example.dddstudy.domain.valueEntity.UserId;
import org.springframework.stereotype.Repository;

import java.util.Optional;


public class UserRepository implements IUserRepository {
    @Override
    public void save(User user){
        return;
    }

    @Override
    public Optional<User> findById(UserId id) {
        return Optional.empty();
    }

    @Override
    public boolean exists(User user){
        return true;
    }
}
