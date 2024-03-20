package com.example.dddstudy.repository;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.domain.valueEntity.FullName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Repository
public class UserRepositoryJBDC implements IUserRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    UserRepositoryJBDC(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }
    @Override
    public void save(User user){
        SimpleJdbcInsert insertAddress = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("Addresses")
                .usingGeneratedKeyColumns("address_id");
        SqlParameterSource addressParams = new MapSqlParameterSource()
                .addValue("prefecture", user.getAddress().prefectures())
                .addValue("city", user.getAddress().city())
                .addValue("line1", user.getAddress().line1())
                .addValue("line2", user.getAddress().line2());
        Number addressId = insertAddress.executeAndReturnKey((addressParams));

        SimpleJdbcInsert insertUsers = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("Users")
                .usingGeneratedKeyColumns("address_id");
        SqlParameterSource userParams = new MapSqlParameterSource()
                .addValue("user_id", user.getId().toString())
                .addValue("first_name", user.getName().firstName())
                .addValue("second_name", user.getName().secondName())
                .addValue("birthday", user.getBirthday().getBirthday())
                .addValue("gender", user.getGender().toString())
                .addValue("address_id", addressId);

        insertUsers.execute(userParams);
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