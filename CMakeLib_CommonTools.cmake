
#输出对应的Log
macro(CMAKELIB_COMMON_LOG loginfo)
    message(STATUS "\[CMAKELIB\]${loginfo}")
endmacro(CMAKELIB_COMMON_LOG)

#输出遍历的字符串
macro(CMAKELIB_COMMON_LOG_LIST variablename)
    foreach(child ${${variablename}})
        CMAKELIB_COMMON_LOG(${child})
    endforeach()
endmacro(CMAKELIB_COMMON_LOG_LIST)