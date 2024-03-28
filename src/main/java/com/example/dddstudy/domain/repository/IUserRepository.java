package com.example.dddstudy.domain.repository;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.UserId;

import java.util.Optional;

public interface IUserRepository {
    void save(User user);
    Optional<User> findById(UserId id);
    boolean exists(User user);
    void delete(UserId id);
}
