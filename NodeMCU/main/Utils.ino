bool stringContains(String content, String sfind)
{
    return content.indexOf(sfind) != -1;
}

String getParameter(String content, String delimiter) {
    int index = content.indexOf(delimiter) + 1;

    if (index == 0) {
        return "";
    }

     return content.substring(index);
}
