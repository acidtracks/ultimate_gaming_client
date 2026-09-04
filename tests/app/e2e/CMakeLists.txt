add_library(ultimate-gaming-client-test-e2e STATIC base_impl.c e2e_lv_cursor_img.c)
target_include_directories(ultimate-gaming-client-test-e2e PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(ultimate-gaming-client-test-e2e PRIVATE unity ultimate-gaming-client-lib)