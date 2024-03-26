package com.example.dddstudy.repository;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.repository.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

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
                .addValue("prefectures", user.getAddress().prefectures())
                .addValue("city", user.getAddress().city())
                .addValue("line1", user.getAddress().line1())
                .addValue("line2", user.getAddress().line2());
        Number addressId = insertAddress.executeAndReturnKey((addressParams));

        SimpleJdbcInsert insertUsers = new SimpleJdbcInsert(jdbcTemplate)
                .withTableName("Users");
        SqlParameterSource userParams = new MapSqlParameterSource()
                .addValue("user_id", user.getId().asBytes())
                .addValue("first_name", user.getName().firstName())
                .addValue("second_name", user.getName().secondName())
                .addValue("birthday", user.getBirthday().getBirthdayAsLocalDate())
                .addValue("gender", user.getGender().toString())
                .addValue("address_id", addressId);

        insertUsers.execute(userParams);
        return;

    }

    @Override
    public Optional<User> findById(UserId userId) {
        String query = """
                SELECT *
                FROM Users as u
                JOIN Addresses as a
                On u.address_id=a.address_id
                HAVING u.user_id= ?
                LIMIT 1
                ;
                """;

        return jdbcTemplate.query(query, rs -> {
            if(!rs.next()) return Optional.empty();
            return Optional.of(UserMapper.mapToUser(rs));
        }, userId.getId());
    }

    @Override
    public boolean exists(User user){
        return true;
    }

}
