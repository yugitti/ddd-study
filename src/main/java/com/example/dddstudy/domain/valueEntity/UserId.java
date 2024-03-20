package com.example.dddstudy.domain.valueEntity;
import lombok.Getter;

import java.util.UUID;

@Getter
public class UserId {
    final UUID id;
    public UserId(){
        this.id = UUID.randomUUID();
    }
}
