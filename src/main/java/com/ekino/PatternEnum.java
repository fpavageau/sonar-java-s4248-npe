package com.ekino;

import java.util.regex.Pattern;

public enum PatternEnum {
    INSTANCE(Pattern.compile(".*"));

    private final Pattern pattern;

    private PatternEnum(Pattern pattern) {
        this.pattern = pattern;
    }
}
