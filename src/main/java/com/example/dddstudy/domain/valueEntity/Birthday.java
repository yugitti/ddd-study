package com.example.dddstudy.domain.valueEntity;

import java.time.LocalDate;

public record Birthday(int year, int month, int day) {
    public String getBirthdayAsString(){
        return "%s-%s-%s".formatted(year(), month(), day());
    }
    public LocalDate getBirthdayAsLocalDate(){
        return LocalDate.of(year(), month(), day());
    }
}
