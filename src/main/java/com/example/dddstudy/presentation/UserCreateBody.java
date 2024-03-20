package com.example.dddstudy.presentation;
import jakarta.validation.constraints.NotBlank;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Map;

@Getter
@AllArgsConstructor
public class UserCreateBody {
    @NotBlank(message = "Name is mandatory")
    final private String name;
    @NotBlank
    private String birthday;
    @NotNull
    private int gender;
    @NotEmpty
    private Map<String, Object> address;
}
