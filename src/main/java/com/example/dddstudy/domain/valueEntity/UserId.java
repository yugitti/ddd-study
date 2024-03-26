package com.example.dddstudy.domain.valueEntity;
import lombok.Getter;

import java.util.UUID;

@Getter
public class UserId {
    final UUID id;
    public UserId(){
        this.id = UUID.randomUUID();
    }
    public UserId(String id){
        this.id = UUID.fromString(id);
    }

    public byte[] asBytes() {
        long msb = id.getMostSignificantBits();
        long lsb = id.getLeastSignificantBits();
        byte[] buffer = new byte[16];

        for (int i = 0; i < 8; i++) {
            buffer[i] = (byte) (msb >>> 8 * (7 - i));
        }
        for (int i = 8; i < 16; i++) {
            buffer[i] = (byte) (lsb >>> 8 * (7 - i));
        }

        return buffer;
    }

}
