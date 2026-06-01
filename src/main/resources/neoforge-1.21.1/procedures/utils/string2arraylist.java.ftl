private static ArrayList<Object> string2ArrayList(String text, String separator) {
    return new ArrayList<>(Arrays.asList(text.split(separator)));
}