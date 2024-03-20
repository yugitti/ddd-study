package com.example.dddstudy.domain.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import com.example.dddstudy.domain.valueEntity.Address;
import com.example.dddstudy.domain.valueEntity.Birthday;
import com.example.dddstudy.domain.valueEntity.FullName;
import com.example.dddstudy.domain.valueEntity.Gender;

import java.util.UUID;

@Getter
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class User {
    @EqualsAndHashCode.Include
    final UUID id;
    FullName name;
    final Birthday birthday;
    final Gender gender;
    Address address;

    public void changeName(FullName name){
        this.name = name;
    }

    public void changeAddress(Address address){
        this.address = address;
    }

}
