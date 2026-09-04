if (NOT APP_WAKELOCK_IMPLEMENTED)
    target_sources(ultimate-gaming-client-lib PRIVATE app_wakelock_common.c)
endif ()