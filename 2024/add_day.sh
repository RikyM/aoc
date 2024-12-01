#!/usr/bin/env bash

day=$1
printf -v day_s "%02d" $day

skeleton_path='.skeleton/'
src_path='src/stars/'
test_path='test/spec/'
input_path='input/'
example_path='test/input/'

function add_star() {
  star=$1

  echo "Adding day $day - star $star"

  star_src="${skeleton_path}/star_day_star.rb"
  star_target="${src_path}/star_${day_s}_${star}.rb"

  spec_src="${skeleton_path}/star_day_star_spec.rb"
  spec_target="${test_path}/star_${day_s}_${star}_spec.rb"

  sed -e "s/'DAY_PLACEHOLDER'/$day/" -e "s/'STAR_PLACEHOLDER'/$star/" $star_src > $star_target
  sed -e "s/'DAY_PLACEHOLDER'/$day/" -e "s/'STAR_PLACEHOLDER'/$star/" $spec_src > $spec_target

  touch "$input_path/input_${day_s}.txt"
  touch "$example_path/example_${day_s}_${star}.txt"
}

add_star 1
add_star 2
