package com.example.dddstudy.domain.valueEntity;

public enum Gender {
    Male(0),
    Female(1),
    Other(2);

    private final int value;

    Gender(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }

    public static Gender fromInt(int value) {
        for (Gender gender : Gender.values()) {
            if (gender.getValue() == value) {
                return gender;
            }
        }
        throw new IllegalArgumentException("Unknown value: " + value);
    }
}
