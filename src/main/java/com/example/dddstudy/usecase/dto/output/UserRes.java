package com.example.dddstudy.usecase.dto.output;

import com.example.dddstudy.domain.valueEntity.*;

public record UserRes(
        UserId id,
        FullName name,
        Birthday birthday,
        Gender gender,
        Address address
) {
}
