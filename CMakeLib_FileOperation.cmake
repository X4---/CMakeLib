
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
function(CMAKELIB_FILE_GET_DIR_NAME outvariablename)
    string(REGEX MATCH "([^/]*)$" TMP ${CMAKE_CURRENT_SOURCE_DIR})
    set(${outvariablename} ${TMP} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_DIR_NAME)



# Reading
#   file(READ <filename> <out-var> [...])
#   file(STRINGS <filename> <out-var> [...])
#   file(<HASH> <filename> <out-var>)
#   file(TIMESTAMP <filename> <out-var> [...])
#   file(GET_RUNTIME_DEPENDENCIES [...])

# Writing
#   file({WRITE | APPEND} <filename> <content>...)
#   file({TOUCH | TOUCH_NOCREATE} [<file>...])
#   file(GENERATE OUTPUT <output-file> [...])
#   file(CONFIGURE OUTPUT <output-file> CONTENT <content> [...])

# Filesystem
#   file({GLOB | GLOB_RECURSE} <out-var> [...] [<globbing-expr>...])
#   file(MAKE_DIRECTORY [<dir>...])
#   file({REMOVE | REMOVE_RECURSE } [<files>...])
#   file(RENAME <oldname> <newname> [...])
#   file(COPY_FILE <oldname> <newname> [...])
#   file({COPY | INSTALL} <file>... DESTINATION <dir> [...])
#   file(SIZE <filename> <out-var>)
#   file(READ_SYMLINK <linkname> <out-var>)
#   file(CREATE_LINK <original> <linkname> [...])
#   file(CHMOD <files>... <directories>... PERMISSIONS <permissions>... [...])
#   file(CHMOD_RECURSE <files>... <directories>... PERMISSIONS <permissions>... [...])

# Path Conversion
#   file(REAL_PATH <path> <out-var> [BASE_DIRECTORY <dir>] [EXPAND_TILDE])
#   file(RELATIVE_PATH <out-var> <directory> <file>)
#   file({TO_CMAKE_PATH | TO_NATIVE_PATH} <path> <out-var>)

# Transfer
#   file(DOWNLOAD <url> [<file>] [...])
#   file(UPLOAD <file> <url> [...])

# Locking
#   file(LOCK <path> [...])

# Archiving
#   file(ARCHIVE_CREATE OUTPUT <archive> PATHS <paths>... [...])
#   file(ARCHIVE_EXTRACT INPUT <archive> [...])


#宏定义
#获取当前工作目录下所有的子目录的名称
#参数 outvariablename 将对应的${outvariablename} 变量设置为字符串

function(CMAKELIB_FILE_GET_ALL_SUBDIR outvariablename)
    file(GLOB _children RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)
	set(${outvariablename} "")
	foreach(_child ${_children})
		if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_child})
			list(APPEND ${outvariablename} ${_child})
		endif()
	endforeach()
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_ALL_SUBDIR)


#获取当前目录下所有的文件
function(CMAKELIB_FILE_GET_ALL_SUBFILE outvariablename)
	file(GLOB _children RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)
	set(${outvariablename} "" PARENT_SCOPE)
	foreach(_child ${_children})
		if(NOT IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_child})
			list(APPEND ${outvariablename} ${_child} PARENT_SCOPE)
		endif()
	endforeach()
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_ALL_SUBFILE)


#获取当前文件下以对应.filter 对应的文件
function(CMAKELIB_FILE_GET_ALL_SUBFILE_FILTER outvariablename filter)
	file(GLOB _children RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)
	set(${outvariablename} "")
	foreach(_child ${_children})
		if(NOT IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_child})
			list(APPEND ${outvariablename} ${_child})
			#message(STATUS ${_child})
		endif()
	endforeach()
	list(FILTER ${outvariablename} INCLUDE REGEX ${filter})
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)

endfunction(CMAKELIB_FILE_GET_ALL_SUBFILE_FILTER)

#获取当前文件下所有目录 循环
function(CMAKELIB_FILE_GET_ALL_SUBDIR_RECURSE outvariablename)
    file(GLOB_RECURSE _children LIST_DIRECTORIES true RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)
	set(${outvariablename} "")
	foreach(_child ${_children})
		if(IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_child})
			list(APPEND ${outvariablename} ${_child})
		endif()
	endforeach()
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_ALL_SUBDIR_RECURSE)

#获取当前目录下所有文件 循环
function(CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE outvariablename)
	file(GLOB_RECURSE  _children LIST_DIRECTORIES true RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*)
	set(${outvariablename} "")
	foreach(_child ${_children})
		if(NOT IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${_child})
			list(APPEND ${outvariablename} ${_child})
		endif()
	endforeach()
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE)


#获取当前目录下所有文件 循环 filter
function(CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER outvariablename subfolder filter)
	file(GLOB_RECURSE  _children LIST_DIRECTORIES true RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/${subfolder} ${CMAKE_CURRENT_SOURCE_DIR}/${subfolder}/*)
	set(${outvariablename} "")
	foreach(_child ${_children})
		#message(STATUS ${_child})
		if(NOT IS_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${subfolder}/${_child})
			list(APPEND ${outvariablename} ${subfolder}/${_child})
			#message(STATUS ${subfolder}/${_child})
		endif()
	endforeach()

	list(FILTER ${outvariablename} INCLUDE REGEX ${filter})
	set(${outvariablename} ${${outvariablename}} PARENT_SCOPE)
endfunction(CMAKELIB_FILE_GET_ALL_SUBFILE_RECURSE_FILTER)

