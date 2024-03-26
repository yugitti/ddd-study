package com.example.dddstudy.presentation.mapper;

import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.presentation.dto.CreateUserBody;
import com.example.dddstudy.usecase.dto.input.CreateUserParams;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class CreateUserMapper {
    public CreateUserParams toCreateUserParams(CreateUserBody body){
        return new CreateUserParams(
                mapFullName(body.getName()),
                mapBirthday(body.getBirthday()),
                mapGender(body.getGender()),
                mapAddress(body.getAddress()));
    }

    private Gender mapGender(int i){
        return Gender.fromInt(i);
    }

    private FullName mapFullName(String name) {
        // 仮にフルネームがスペースで区切られていると仮定
        String[] parts = name.split(" ");
        return new FullName(parts[0], parts[1]);
    }

    // Birthdayマッピング用のヘルパーメソッド
    private Birthday mapBirthday(String birthday) {
        String[] parts = birthday.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        int day = Integer.parseInt(parts[2]);
        return new Birthday(year, month, day);
    }

    // Addressマッピング用のヘルパーメソッド
    private Address mapAddress(Map<String, Object> address) {
        int code = (int)address.get("prefecture");
        String city = (String)address.get("city");
        String line1 = (String)address.get("address1");
        String line2 = (String)address.get("address2");
        return new Address(Prefectures.fromCode(code), city, line1, line2);
    }
}
