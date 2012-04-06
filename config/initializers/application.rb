# -*- encoding : utf-8 -*-
#
# Load iBoard Modules
#

require "redcloth"

require "string_extensions"
String.send(:extend, StringExtensions::ClassMethods)
String.send(:include, StringExtensions::InstanceMethods)

require "special_characters"
include SpecialCharacters

