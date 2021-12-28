
#Search and Replace
#string(FIND <string> <substring> <out-var> [...])
#string(REPLACE <match-string> <replace-string> <out-var> <input>...)
#string(REGEX MATCH <match-regex> <out-var> <input>...)
#string(REGEX MATCHALL <match-regex> <out-var> <input>...)
#string(REGEX REPLACE <match-regex> <replace-expr> <out-var> <input>...)


#宏定义
#获取当前的工作目录的名称
#参数 outvariablename 将对应的${outvariablename} 变量设置为字符串匹配的值
#使用的规则为 ${CMAKE_CURRENT_SOURCE_DIR} CMAKE当前工作的源文件目录, 通过后端匹配正则字符串的形式来进行匹配
macro(CMAKELIB_GET_DIR_NAME outvariablename)
    string(REGEX MATCH "([^/]*)$" TMP ${CMAKE_CURRENT_SOURCE_DIR})
    set(${outvariablename} ${TMP})
endmacro(ADD_ALL_SUBDIR)
