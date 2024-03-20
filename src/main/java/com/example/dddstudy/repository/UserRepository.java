package com.example.dddstudy.repository;
import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.domain.valueEntity.FullName;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class UserRepository implements IUserRepository {
    @Override
    public void save(User user){
        return;
    }

    @Override
    public Optional<User> find(FullName name) {
        return Optional.empty();
    }

    @Override
    public boolean exists(User user){
        return true;
    }
}
