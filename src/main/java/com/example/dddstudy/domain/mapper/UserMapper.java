package com.example.dddstudy.domain.mapper;

import com.example.dddstudy.domain.entity.User;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.presentation.UserCreateBody;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.Map;

@Mapper
public interface UserMapper {

    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    @Mapping(target = "id", expression = "java(new UserId())")
    @Mapping(target = "name", expression = "java(mapFullName(userCreateBody.getName()))")
    @Mapping(target = "birthday", expression = "java(mapBirthday(userCreateBody.getBirthday()))")
    @Mapping(target = "gender", expression = "java(mapGender(userCreateBody.getGender()))")
    @Mapping(target = "address", expression = "java(mapAddress(userCreateBody.getAddress()))")
    User userCreateBodyToUser(UserCreateBody userCreateBody);
    default Gender mapGender(int i){
        return Gender.fromInt(i);
    }

    // FullNameマッピング用のヘルパーメソッド
    default FullName mapFullName(String name) {
        // 仮にフルネームがスペースで区切られていると仮定
        String[] parts = name.split(" ");
        return new FullName(parts[0], parts[1]);
    }

    // Birthdayマッピング用のヘルパーメソッド
    default Birthday mapBirthday(String birthday) {
        String[] parts = birthday.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        int day = Integer.parseInt(parts[2]);
        return new Birthday(year, month, day);
    }

    // Addressマッピング用のヘルパーメソッド
    default Address mapAddress(Map<String, Object> address) {
        int code = (int)address.get("prefecture");
        String city = (String)address.get("city");
        String line1 = (String)address.get("address1");
        String line2 = (String)address.get("address2");
        return new Address(Prefectures.fromCode(code), city, line1, line2);
    }
}
