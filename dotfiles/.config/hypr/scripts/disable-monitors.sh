#!/usr/bin/env bash

hyprctl eval ' for _, m in ipairs(hl.get_monitors()) do     if m.name ~= "vnc" then         hl.monitor({ output = m.name, disabled = true })     end end '