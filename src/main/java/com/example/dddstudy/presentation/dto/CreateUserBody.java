package com.example.dddstudy.presentation.dto;
import com.example.dddstudy.domain.valueEntity.*;
import com.example.dddstudy.usecase.dto.CreateUserParams;
import jakarta.validation.constraints.NotBlank;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Map;

@Getter
@AllArgsConstructor
public class CreateUserBody {
    @NotBlank(message = "Name is mandatory")
    final private String name;
    @NotBlank
    private String birthday;
    @NotNull
    private int gender;
    @NotEmpty
    private Map<String, Object> address;
}
