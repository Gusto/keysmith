require File.expand_path('../shamir-secret-sharing', __FILE__)
require 'securerandom'

class KeySmith
  class << self
    def generate(options)
      options.key = SecureRandom.hex(128) if options.key.nil? || options.key == ""

      shares = ShamirSecretSharing::Base58.split options.key, options.pieces, options.quorum

      shares.each_with_index do |piece, i|
        name = options.piece_names[i]
        File.open("#{options.keypiece_dir}/#{name}.keypiece", 'w') {|f| f.write piece }
      end

      puts <<-EOS
Done! The keypieces have been written to '#{options.keypiece_dir}/*.keypiece'
Be sure to run 'ks reconstruct --keypiece-dir #{options.keypiece_dir}' to test that the key can be reconstructed.
      EOS
    end

    def reconstruct(options)
      keypieces = Dir["#{options.keypiece_dir}/*.keypiece"]

      if keypieces.empty?
        puts "No keypieces detected! Please copy the required number of keypieces into #{options.keypiece_dir}"
        return false
      end

      keypieces.map! do |piece_filename|
        File.open(piece_filename, 'r') {|f| f.read.chomp }
      end

      key = ShamirSecretSharing::Base58.combine keypieces
      return key if key

      puts "Unable to reconstruct your key. Check that all necessary pieces are present."
      return false
    end

    def encrypt(options)
      unless File.exists?(options.input_dir)
        puts "#{options.input_dir} does not exist. Please create the #{options.input_dir} folder and add the files you want to encrypt."
        exit 1
      end

      reconstruct_key_unless_given!(options) or return false

      `srm -fm "#{options.output}"; (cd "#{options.input_dir}"; tar cz .) | openssl enc -aes-256-cbc -pass "pass:#{options.key}" -e > "#{options.output}"`

      puts "Saved encrypted file to #{options.output}"
    end

    def decrypt(options)
      unless File.exists?(options.input)
        puts "#{options.input} does not exist!"
        exit 1
      end

      reconstruct_key_unless_given!(options) or return false

      if File.exists?(options.output_dir)
        response = ask("'#{options.output_dir}' directory already exists. Overwrite? (y/n) ").strip
        exit unless response.downcase == 'y'
        # Remove existing encrypted folder
        `srm -rfm "#{options.output_dir}"`
      end

      `mkdir -p #{options.output_dir}; openssl aes-256-cbc -d -pass "pass:#{options.key}" -in "#{options.input}" | tar zxf - -C #{options.output_dir}`
      puts "Extracted encrypted files to #{options.output_dir}"
    end

    def clean(options)
      puts "Securely deleting #{options.keypiece_dir}/*.keypiece..."
      `srm -rfm "#{options.keypiece_dir}"/*.keypiece`
    end


    private

    def reconstruct_key_unless_given!(options)
      unless options.key
        options.key = reconstruct(options)
      end
      options.key
    end
  end
end
