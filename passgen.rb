#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'random-word'
end


MIN_WORD_SIZE       = 6
MAX_WORD_SIZE       = 12
OVERALL_MIN_SIZE    = 12
OVERALL_MAX_SIZE    = 18
CAPITALIZATION_ODDS = 0.10
LEET_ODDS           = 0.10
NUMERAL_ODDS        = 0.10
SPECIAL_CHAR_ODDS   = 0.025
SPECIAL_CHARS       = %q{
  !@#$%^&*()+_<>?:"';/.,[]\\\{\}|=-
}.strip.chars

LEET_CHARS = {
  'a' => '4',
  'b' => '8',
  'e' => '3',
  'g' => '9',
  'i' => '1',
  'o' => '0',
  's' => '5',
  't' => '7',
  'z' => '2'
}

def random_special
  SPECIAL_CHARS[ Random.rand(0 .. SPECIAL_CHARS.length-1) ]
end

def random_numeral
  Random.rand(0..9).to_s
end

def randomize_chars(word)
  word.chars.reduce('') do |memo, c|
    c = LEET_CHARS[c] if Random.rand <= LEET_ODDS && LEET_CHARS.has_key?(c)
    c = c.upcase if Random.rand <= CAPITALIZATION_ODDS
    memo << random_special if Random.rand <= SPECIAL_CHAR_ODDS
    memo << random_numeral if Random.rand <= NUMERAL_ODDS
    memo << c
  end
end


word_list = RandomWord.nouns.lazy
  .flat_map {|w| w.split('_') }
  .reject {|w| w.length < MIN_WORD_SIZE || w.length > MAX_WORD_SIZE }
  .map {|w| randomize_chars(w) }


compound_words = Enumerator.new do |y|
  loop do
    w = word_list.next + random_special + word_list.next

    if (w.length <= OVERALL_MAX_SIZE) &&
       (w.length >= OVERALL_MIN_SIZE) &&
       (SPECIAL_CHARS.any? {|f| w.include?(f)}) &&
       (/\d/ =~ w)

      y << w
    end
  end
end

puts compound_words.first(25)
