# copy_if_exists.cmake
if(EXISTS "${INPUT}")
  file(COPY "${INPUT}" DESTINATION "${OUTPUT}")
  message(STATUS "Copied: ${INPUT} → ${OUTPUT}")
else()
  message(WARNING "Skip copy: ${INPUT} does not exist yet.")
endif()
