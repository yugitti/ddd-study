package com.example.dddstudy.domain.valueEntity;

public record Birthday(int year, int month, int day) {
    public String getBirthday(){
        return "%s-%s-%s".formatted(year(), month(), day());
    }
}
