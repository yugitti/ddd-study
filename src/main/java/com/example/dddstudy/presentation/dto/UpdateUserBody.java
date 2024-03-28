package com.example.dddstudy.presentation.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Map;

@Getter
@AllArgsConstructor
public class UpdateUserBody {
    @NotBlank
    final private String id;

    final private String name;

    private String birthday;

    private Integer gender;

    private Map<String, Object> address;

}
