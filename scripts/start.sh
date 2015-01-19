#!/bin/bash
kill all apache2
sleep 2s
supervisord -n
