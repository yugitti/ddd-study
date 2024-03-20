package com.example.dddstudy.domain.entity;

import com.example.dddstudy.domain.valueEntity.*;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import java.util.UUID;

@Getter
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class User {
    @EqualsAndHashCode.Include
    final UserId id;
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
