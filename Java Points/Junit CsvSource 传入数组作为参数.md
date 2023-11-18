```java
@Log
class PermutationsIiTest {

    @ParameterizedTest
    @CsvSource({
            "'1, 1, 2'"
    })
    void permuteUnique(@ConvertWith(StringArrayConverter.class) int[] arr) {
        log.info(new PermutationsIi().permuteUnique(arr).toString());
    }
}

class StringArrayConverter extends SimpleArgumentConverter {

    @Override
    protected Object convert(Object source, Class<?> targetType) throws ArgumentConversionException {
        return Arrays.stream(((String) source).split("\\s*,\\s*")).mapToInt(Integer::parseInt).toArray();
    }
}
```

https://doczhcn.gitbook.io/junit5/index/index-2/parameterized-tests#xian-shi-zhuan-huan