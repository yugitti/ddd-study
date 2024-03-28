package com.example.dddstudy.repository;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.repository.IUserRepository;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.repository.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.util.Optional;

@Repository
public class UserRepositoryJBDC implements IUserRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    UserRepositoryJBDC(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }
    @Override
    public void save(User user) {

        Integer addressId = getAddressIdByUserId(user.getId());
        if (addressId != null) {
            // 存在する場合、updateメソッドを呼び出し
            update(user, addressId);
        } else {
            // 存在しない場合、insertメソッドを呼び出し
            insert(user);
        }
    }


    private void insert(User user){
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
    }

    private void update(User user, Integer address_id){

        String sqlForAddress = "UPDATE Addresses SET prefectures = ?, city = ?, line1 = ?, line2 = ? WHERE address_id = ?";

        jdbcTemplate.update(sqlForAddress,
                user.getAddress().prefectures().toString(),
                user.getAddress().city(),
                user.getAddress().line1(),
                user.getAddress().line2(),
                address_id);

        String sqlForUser = "UPDATE Users SET first_name = ?, second_name = ?, birthday = ?, gender = ?, address_id = ? WHERE user_id = ?";

        jdbcTemplate.update(sqlForUser,
                user.getName().firstName(),
                user.getName().secondName(),
                user.getBirthday().getBirthdayAsLocalDate(),
                user.getGender().toString(),
                address_id,
                user.getId().asBytes());

    }

    @Override
    public Optional<User> findById(UserId userId) {
        String query = """
                SELECT *
                FROM Users as u
                JOIN Addresses as a
                On u.address_id=a.address_id
                WHERE u.user_id= ?
                LIMIT 1
                ;
                """;

        return jdbcTemplate.query(query, rs -> {
            if(!rs.next()) return Optional.empty();
            return Optional.of(UserMapper.mapToUser(rs));
        }, userId.getId());
    }
    // user_idに対応するaddress_idを取得するメソッド
    public Integer getAddressIdByUserId(UserId userId) {
        String sql = "SELECT address_id FROM USERS WHERE user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, Integer.class, userId.getId());
        } catch (EmptyResultDataAccessException e) {
            // レコードが見つからない場合はnullを返す
            return null;
        }
    }

    @Override
    public void delete(UserId userId){
        String sql = """
                DELETE
                FROM Users as u
                WHERE u.user_id= ?
                ;
                """;
        jdbcTemplate.update(sql, userId);
        return;
    }
    @Override
    public boolean exists(User user){
        return true;
    }

}
