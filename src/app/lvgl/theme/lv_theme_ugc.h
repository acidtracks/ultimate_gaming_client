#pragma once

#include "lvgl.h"

typedef struct app_t app_t;

void lv_theme_ugc_init(lv_theme_t *theme, const app_fonts_t *fonts, app_t *app);

void lv_theme_ugc_deinit(lv_theme_t *theme);

const lv_font_t *lv_theme_ugc_get_iconfont_large(lv_obj_t *obj);

const lv_font_t *lv_theme_ugc_get_iconfont_normal(lv_obj_t *obj);

const lv_font_t *lv_theme_ugc_get_iconfont_small(lv_obj_t *obj);