#!/bin/sh

while sleep 0.1; do
  find scripts test/unit -name '*.gd' | entr -s 'godot --headless --debug-collisions --path $(pwd) -d -s addons/gut/gut_cmdln.gd -gconfig=.gut_editor_config.json'
done