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



#设CMAKELIB_PROJECT_SET置对应的Target CMakeLib 依赖

macro(CMAKELIB_PROJECT_ADD_LINKTARGET_PUBLIC linkname)
    
    set(LocalDirName "")
    if(DEFINED CUSTOMTARGETNAME)
        set(LocalTargetName ${CUSTOMTARGETNAME})
    else()
        CMAKELIB_FILE_GET_DIR_NAME(LocalDirName)
        set(LocalTargetName ${LocalDirName})
    endif()
    set(CMAKELIB_LINK_PUBLIC_${LocalTargetName} "${CMAKELIB_LINK_PUBLIC_${LocalTargetName}};${linkname}")

    if(NOT DEFINED CMAKELIB_LINK_PUBLIC_${LocalTargetName})
        set(CMAKELIB_LINK_PUBLIC_${LocalTargetName} "${linkname}")
    else()
        set(CMAKELIB_LINK_PUBLIC_${LocalTargetName} "${CMAKELIB_LINK_PUBLIC_${LocalTargetName}};${linkname}")
    endif()

endmacro()


macro(CMAKELIB_PROJECT_ADD_LINKTARGET_PRIVATE linkname)

    set(LocalDirName "")
    if(DEFINED CUSTOMTARGETNAME)
        set(LocalTargetName ${CUSTOMTARGETNAME})
    else()
        CMAKELIB_FILE_GET_DIR_NAME(LocalDirName)
        set(LocalTargetName ${LocalDirName})
    endif()

    if(NOT DEFINED CMAKELIB_LINK_PRIVATE_${LocalTargetName})
        set(CMAKELIB_LINK_PRIVATE_${LocalTargetName} "${linkname}")
    else()
        set(CMAKELIB_LINK_PRIVATE_${LocalTargetName} "${CMAKELIB_LINK_PRIVATE_${LocalTargetName}};${linkname}")
    endif()

    

endmacro()


macro(CMAKELIB_PROJECT_ADD_LINKTARGET_INTERFACE linkname)

    set(LocalDirName "")
    if(DEFINED CUSTOMTARGETNAME)
        set(LocalTargetName ${CUSTOMTARGETNAME})
    else()
        CMAKELIB_FILE_GET_DIR_NAME(LocalDirName)
        set(LocalTargetName ${LocalDirName})
    endif()

    if(NOT DEFINED CMAKELIB_LINK_INTERFACE_${LocalTargetName})
        set(CMAKELIB_LINK_INTERFACE_${LocalTargetName} "${linkname}")
    else()
        set(CMAKELIB_LINK_INTERFACE_${LocalTargetName} "${CMAKELIB_LINK_INTERFACE_${LocalTargetName}};${linkname}")
    endif()

endmacro()

#设置对应的跟输出目录
macro(CMAKELIB_PROJECT_SET_OUTPUT_DIR outputdir)    
    set(CUSTOM_OUT_BINARY ${outputdir})
endmacro()

#生成对应的工程
macro(CMAKELIB_PROJECT_SETUPPROJECT mode targetname targetsourcesname)

#0.Process Input

	#string(REPLACE " " ";" listtargetsources {${targetsourcesname} )
	#string(REPLACE " " ";" listtargetlibs ${targetlibname} )
    set(listtargetsources ${${targetsourcesname}})


#0.将当前的目录设置为对应的Project组织的根目录
    source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${listtargetsources})
#1.First Gen Target
    if(${mode} STREQUAL "exe")
        add_executable( ${targetname} ${listtargetsources} )
    elseif(${mode} STREQUAL "bin")
        add_library( ${targetname} STATIC ${listtargetsources} )
    elseif(${mode} STREQUAL "dll")
        add_library( ${targetname} SHARED ${listtargetsources} )
    elseif(${mode} STREQUAL "source")

        set(NOTCONTINUE " ")
    else()
        CMAKELIB_COMMON_LOG("mode : ${mode} not support")
        set(NOTCONTINUE " ")
    endif()

#2.Second Set TargetProperty
    if(NOT DEFINED NOTCONTINUE)
        #2.1设置对应的文件Folder目录
        CMAKELIB_PROJECT_GETPROJECTFOLERPATH(localfolder)
        CMAKELIB_COMMON_LOG("${targetname} in folder :${localfolder}")
        set_target_properties(${targetname} PROPERTIES FOLDER ${localfolder})
    endif()

    if(DEFINED CUSTOM_OUT_BINARY)
        #2.2设置对应的输出目录
        CMAKELIB_COMMON_LOG("${targetname} in Output :${CUSTOM_OUT_BINARY}")
        set_target_properties(${targetname} PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY "${CUSTOM_OUT_BINARY}"
            LIBRARY_OUTPUT_DIRECTORY "${CUSTOM_OUT_BINARY}"
            RUNTIME_OUTPUT_DIRECTORY "${CUSTOM_OUT_BINARY}")
    endif()

#3.TargetInclude

    if(NOT DEFINED NOTCONTINUE)
        set(LocalFetchPublicTargetIncludevarname CMAKELIB_INCLUDE_PUBLIC_${targetname})
        if(DEFINED ${LocalFetchPublicTargetIncludevarname})
            foreach( folder ${${LocalFetchPublicTargetIncludevarname}})

                #message(STATUS publicfolder  " " ${folder})
                target_include_directories(${targetname} PUBLIC ${folder})

            endforeach()
        endif()

        set(LocalFetchPrivateTargetIncludevarname CMAKELIB_INCLUDE_PRIVATE_${targetname})
        if(DEFINED ${LocalFetchPrivateTargetIncludevarname})
            foreach( folder ${${LocalFetchPrivateTargetIncludevarname}})

                #message(STATUS privatefolder  " " ${folder})
                target_include_directories(${targetname} PRIVATE ${folder})
            endforeach()
        endif()

        set(LocalFetchInterfaceTargetIncludevarname CMAKELIB_INCLUDE_INTERFACE_${targetname})
        if(DEFINED ${LocalFetchInterfaceTargetIncludevarname})
            foreach( folder ${${LocalFetchInterfaceTargetIncludevarname}})
                #message(STATUS interfacefolder  " " ${folder})
                target_include_directories(${targetname} INTERFACE ${folder})
            endforeach()
        endif()

    endif()


#4.TargetLib
    if(NOT DEFINED NOTCONTINUE)
    set(LocalFetchPublicTargetLinkvarname CMAKELIB_LINK_PUBLIC_${targetname})
    if(DEFINED ${LocalFetchPublicTargetLinkvarname})
        foreach( target ${${LocalFetchPublicTargetLinkvarname}})

            #message(STATUS publiclink  " " ${target})
            target_link_libraries(${targetname} PUBLIC ${target})

        endforeach()
    endif()

    set(LocalFetchPrivateTargetLinkvarname CMAKELIB_LINK_PRIVATE_${targetname})
    if(DEFINED ${LocalFetchPrivateTargetLinkvarname})
        foreach( target ${${LocalFetchPrivateTargetLinkvarname}})

            #message(STATUS publiclink  " " ${target})
            target_link_libraries(${targetname} PRIVATE ${target})


        endforeach()
    endif()

    set(LocalFetchInterfaceTargetLinkvarname CMAKELIB_LINK_INTERFACE_${targetname})
    if(DEFINED ${LocalFetchInterfaceTargetLinkvarname})
        foreach( target ${${LocalFetchInterfaceTargetLinkvarname}})

            #message(STATUS interfacelink  " " ${target})
            target_link_libraries(${targetname} INTERFACE ${target})

        endforeach()
    endif()

    endif()
#5.TargetCompileDefine

    if(${mode} STREQUAL "exe")
        
    elseif(${mode} STREQUAL "bin")
       
    elseif(${mode} STREQUAL "dll")
        target_compile_definitions( ${targetname} INTERFACE ${targetname}_IMPORT )
        target_compile_definitions( ${targetname} PRIVATE ${targetname}_EXPORT )
    elseif(${mode} STREQUAL "source")

    else()

    endif()

endmacro(CMAKELIB_PROJECT_SETUPPROJECT)



macro(CMAKE_PROJECT_DEFAULT_SETUP_EXE)

#0.Get FolderName And Set it to LocalTargetName

    set(LocalDirName "")
    if(DEFINED CUSTOMTARGETNAME)
        set(LocalTargetName ${CUSTOMTARGETNAME})
    else()
        CMAKELIB_FILE_GET_DIR_NAME(LocalDirName)
        set(LocalTargetName ${LocalDirName})
    endif()


#1.Get FileFilter And Set it to Local
    set(LocalFileFilter ".*h|.*cpp")
    if(DEFINED CUSTOMFILEFILTER)
        set(LocalFileFilter ${CUSTOMFILEFILTER})
    else()
        set(LocalFileFilter ".*h|.*cpp")
    endif()
#2.GetPublicFiles
    set(LocalPublicFiles "")    
    CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER( LocalPublicFiles Public ${LocalFileFilter})
#3.GetPrivateFiles
    set(LocalPrivateFiles "")
    CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER( LocalPrivateFiles Private ${LocalFileFilter})
#4.GetCurDir
    set(LocalFiles "")
    CMAKELIB_FILE_GET_ALL_SUBFILE_FILTER( LocalFiles ${LocalFileFilter})
#4.GetInterfaceFiles


#5.SetAllFiles
    set(LocalSrcFiles ${LocalFiles} ${LocalPublicFiles} ${LocalPrivateFiles})

#6.Set CMakeLibVariable
    set(CMAKELIB_INCLUDE_PUBLIC_${LocalTargetName} Public)
    set(CMAKELIB_INCLUDE_PRIVATE_${LocalTargetName} Private)
    set(CMAKELIB_INCLUDE_INTERFACE_${LocalTargetName} Interface)
#6.SetUPProject
    CMAKELIB_PROJECT_SETUPPROJECT( exe ${LocalTargetName} LocalSrcFiles )
endmacro(CMAKE_PROJECT_DEFAULT_SETUP_EXE)


macro(CMAKE_PROJECT_DEFAULT_SETUP_SHARED_LIB)

#0.Get FolderName And Set it to LocalTargetName
    set(LocalDirName "")
    if(DEFINED CUSTOMTARGETNAME)
        set(LocalTargetName ${CUSTOMTARGETNAME})
    else()
        CMAKELIB_FILE_GET_DIR_NAME(LocalDirName)
        set(LocalTargetName ${LocalDirName})
    endif()
#1.Get FileFilter And Set it to Local
    set(LocalFileFilter ".*h|.*cpp")
    if(DEFINED CUSTOMFILEFILTER)
        set(LocalFileFilter ${CUSTOMFILEFILTER})
    else()
        set(LocalFileFilter ".*h|.*cpp")
    endif()
#2.GetPublicFiles
    set(LocalPublicFiles "")    
    CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER( LocalPublicFiles Public ${LocalFileFilter})
#3.GetPrivateFiles
    set(LocalPrivateFiles "")
    CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER( LocalPrivateFiles Private ${LocalFileFilter})
#4.GetCurDir
    set(LocalFiles "")
    CMAKELIB_FILE_GET_ALL_SUBFILE_FILTER( LocalFiles ${LocalFileFilter})
#4.GetInterfaceFiles

#5.SetAllFiles
    set(LocalSrcFiles ${LocalFiles} ${LocalPublicFiles} ${LocalPrivateFiles})
#6.Set CMakeLibVariable
    set(CMAKELIB_INCLUDE_PUBLIC_${LocalTargetName} Public)
    set(CMAKELIB_INCLUDE_PRIVATE_${LocalTargetName} Private)
    set(CMAKELIB_INCLUDE_INTERFACE_${LocalTargetName} Interface)
#6.SetUPproject
    CMAKELIB_PROJECT_SETUPPROJECT( dll ${LocalTargetName} LocalSrcFiles )
    

endmacro(CMAKE_PROJECT_DEFAULT_SETUP_SHARED_LIB)





