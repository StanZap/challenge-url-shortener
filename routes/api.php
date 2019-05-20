<?php

Route::post('/links', 'LinksController@create');
Route::get('/top-100-links', 'LinksController@getTop100');
