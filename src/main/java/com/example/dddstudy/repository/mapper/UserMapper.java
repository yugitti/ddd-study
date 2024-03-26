package com.example.dddstudy.repository.mapper;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.*;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public class UserMapper {

    public static User mapToUser(ResultSet rs) throws SQLException {
        UserId userId = new UserId(rs.getString("user_id"));
        FullName fullName = new FullName(rs.getString("first_name"), rs.getString("second_name"));
        LocalDate birthdayDate = rs.getDate("birthday").toLocalDate();
        Birthday birthday = new Birthday(
                birthdayDate.getYear(),
                birthdayDate.getMonthValue(),
                birthdayDate.getDayOfMonth());
        Gender gender = Gender.valueOf(rs.getString("gender"));
        Address address = new Address(
                Prefectures.valueOf(rs.getString("prefectures")),
                rs.getString("city"),
                rs.getString("line1"),
                rs.getString("line2")
        );

        return new User(userId, fullName, birthday, gender, address);
    }

}
