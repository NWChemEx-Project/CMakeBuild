include(UtilityMacros.cmake)
include(AssertMacros.cmake)

is_valid(test1 not_defined)
assert(NOT test1)

set(blank_string "")
is_valid(test2 blank_string)
assert(NOT test2)

set(valid_string "this_is_valid")
is_valid(test3 valid_string)
assert(test3)

set(valid_list item1 item2)
is_valid(test4 valid_list)
assert(test4)
