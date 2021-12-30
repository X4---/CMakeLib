
#包含文件目录对应的入口Entry.cmake文件

#Log
message(STATUS "\[CMAKELIB\]LoadCMakeLibBegin")

#record
set(totalcmakefiles "")

include(CMakeLib_CommonTools)
list(APPEND totalcmakefiles "CMakeLib_CommonTools")

include(CMakeLib_FileOperation)
list(APPEND totalcmakefiles "CMakeLib_FileOperation")


#Log
foreach(child ${totalcmakefiles})
    CMAKELIB_COMMON_LOG("Load:${child}")
endforeach()


message(STATUS "\[CMAKELIB\]LoadCMakeLibEnd")