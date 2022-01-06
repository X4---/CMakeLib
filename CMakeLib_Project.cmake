include(CMakeLib_FileOperation)






#将当前对应的路径中的所有目录进行添加
function(CMAKELIB_PROJECT_ADDALLSUBDIR)
    set(local "")
    CMAKELIB_FILE_GET_ALL_SUBDIR("local")
    foreach(child ${local})
        add_subdirectory( ${child} )
    endforeach()
endfunction()

#将当前的处理目录设置为代码的根目录
macro(CMAKELIB_PROJECT_SETCODEROOT)
    set(ENV{CMAKELIB_ROOT_CODE} ${CMAKE_CURRENT_SOURCE_DIR})
endmacro()

#获取当前目录对应的代码根目录的相对路径
macro(CMAKELIB_PROJECT_GETRELEATEPATH outvariablename)
    string(REPLACE "$ENV{CMAKELIB_ROOT_CODE}/" "" TMP ${CMAKE_CURRENT_SOURCE_DIR})
    set(${outvariablename} ${TMP})
endmacro()

#获取当前工程对应的工程Folder名称
macro(CMAKELIB_PROJECT_GETPROJECTFOLERPATH outvariablename)
    set(localvar "")
    set(localname "")
    CMAKELIB_PROJECT_GETRELEATEPATH(localvar)
    CMAKELIB_FILE_GET_DIR_NAME(localname)

    string(REPLACE "/${localname}" "" TMP ${localvar})
    set(${outvariablename} ${TMP})
endmacro()



#项目通用设置
macro(CMAKELIB_PROJECT projectname)

    set(PROJECT_NAME ${projectname})    
    set_property(GLOBAL PROPERTY USE_FOLDERS ON)

endmacro()



#生成对应的工程
macro(CMAKELIB_PROJECT_SETUPPROJECT mode targetname targetsourcesname targetlibname)

#0.Process Input

	#string(REPLACE " " ";" listtargetsources {${targetsourcesname} )
	#string(REPLACE " " ";" listtargetlibs ${targetlibname} )
    set(listtargetsources ${${targetsourcesname}})
    set(listtargetlibs ${${targetlibname}})


   # message(STATUS ${listtargetlibs})

#1.First Gen Target
    if(${mode} STREQUAL "exe")
        add_executable( ${targetname} ${listtargetsources} )
    elseif(${mode} STREQUAL "bin")
        add_library( ${targetname} STATIC ${listtargetsources} )
    elseif(${mode} STREQUAL "dll")
        add_library( ${targetname} SHARED ${listtargetsources} )
    else()
        CMAKELIB_COMMON_LOG("mode : ${mode} not support")
        set(NOTCONTINUE " ")
    endif()

#2.Second Set TargetProperty

    if(NOT DEFINED NOTCONTINUE)
        #2.1设置对应的文件Folder目录
        CMAKELIB_PROJECT_GETPROJECTFOLERPATH(localfolder)
        set_target_properties(${targetname} PROPERTIES FOLDER ${localfolder})
    endif()

#3.TargetLib

    if(NOT DEFINED NOTCONTINUE)
        if(NOT listtargetlibs STREQUAL " ")
            target_link_libraries( ${targetname} ${listtargetlibs} )
        endif()
    endif()


endmacro(CMAKELIB_PROJECT_SETUPPROJECT)










