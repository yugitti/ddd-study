package com.example.dddstudy.domain.repository;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.FullName;

import java.util.Optional;

public interface IUserRepository {
    void save(User user);
    Optional<User> find(FullName name);
    boolean exists(User user);
}
