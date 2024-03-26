package com.example.dddstudy.usecase.dto.input;

import com.example.dddstudy.domain.valueEntity.Address;
import com.example.dddstudy.domain.valueEntity.Birthday;
import com.example.dddstudy.domain.valueEntity.FullName;
import com.example.dddstudy.domain.valueEntity.Gender;

import java.util.Map;

public record CreateUserParams(FullName name, Birthday birthday, Gender gender, Address address) {
}
