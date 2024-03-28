package com.example.dddstudy.usecase.dto.input;

import com.example.dddstudy.domain.valueEntity.*;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Optional;
import java.util.function.Consumer;

@Getter
@AllArgsConstructor
public class UpdateUserParams {
    private UserId id;
    private FullName name;
    private Birthday birthday;
    private Gender gender;
    private Address address;

    public void ifNamePresent(Consumer<FullName> consumer) {
        if(name != null){
            consumer.accept(name);
        }
    }
    public void ifBirthdayPresent(Consumer<Birthday> consumer) {
        if(birthday != null){
            consumer.accept(birthday);
        }
    }
    public void ifGenderPresent(Consumer<Gender> consumer) {
        if(gender != null){
            consumer.accept(gender);
        }
    }



    public void ifAddressPresent(Consumer<Address> consumer) {
        if(address != null){
            consumer.accept(address);
        }
    }




}
