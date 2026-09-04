target_sources(ultimate-gaming-client-lib PRIVATE session.c
        session_events.c
        session_worker.c
        session_priv.c)

if (FEATURE_EMBEDDED_SHELL)
    target_sources(ultimate-gaming-client-lib PRIVATE embed_wrapper.c session_worker_embedded.c)
endif ()

add_subdirectory(input)
add_subdirectory(connection)
add_subdirectory(audio)
add_subdirectory(video)
