#!/usr/bin/env ruby
require 'bundler'
Bundler.setup
Bundler.require

keypieces = Dir['keypieces/*.keypiece']

if keypieces.empty?
  puts "\nNo keypieces detected, so I'm assuming you want to split a key. Answer these questions:\n"

  puts "\nHow many keypieces do you want?"
  num_pieces = gets.chomp.to_i

  puts "\nHow many pieces are needed to reconstruct the key?"
  quorum = gets.chomp.to_i

  puts "\nPlease paste in your key:"
  key = gets.chomp

  shares = ShamirSecretSharing::Base58.split key, num_pieces, quorum

  holders = []
  num_pieces.times do |n|
    puts "\nName of piece holder ##{n + 1}:"
    holders << gets.chomp.downcase.gsub(/\s/, '_')
  end

  shares.each_with_index do |piece, i|
    File.open("keypieces/#{holders[i]}.keypiece", 'w') do |handle|
      handle.write piece
    end
  end

  puts "\nDone! The keypieces have been written to the directory of the same name. Be sure to run this script again to test that they can reconstruct the key."

else
  puts "\nKeypieces detected, so going to attempt to reconstruct the key. What is the size of the quorum?"
  quorum = gets.chomp.to_i

  keypieces.map! do |piece_filename|
    File.open(piece_filename, 'r') do |handle|
      handle.read
    end
  end

  key = ShamirSecretSharing::Base58.combine keypieces

  if key
    puts "\nSuccessfully reconstructed your key:"
    puts key
    puts
  else
    puts "\nUnable to reconstruct your key. Check that all necessary pieces are present."
  end
end
