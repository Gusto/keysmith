# KeySmith

Split a secret using Shamir's Secret Sharing, and encrypt / decrypt files with it.

See: https://en.wikipedia.org/wiki/Shamir's_Secret_Sharing


## Managing Keys

Run ./generate_keys to generate the key pieces. The script will prompt you for parameters.

For example, to generate 7 key pieces and require 3 in order to reconstruct the secret, you would enter 7, then 3,
and then paste your secret key, or leave blank to generate a secure key.

Test that the secret key can be reconstructed by running `./reconstruct_key`

Now copy each of the keypieces onto separate USB drives, and keep them safe / isolated.


## Encrypting Files

### Encrypt

After you have generated your keypieces, create a new `./encrypted` directory that contains your sensitive files,
then run `./encrypt`

The contents of `./encrypted` will be encrypted and saved at `encrypted.tar.gz.enc`.

After encrypting the files, make sure to run `./cleanup` to securely wipe the `./encrypted` directory, and the contents of `./keypieces`.


### Decrypt

You need a `encrypted.tar.gz.enc` file, and enough keypieces in the `./keypieces` directory to reconstruct the secret.
If these requirements are met, run `./decrypt`, which will extract the encrypted tarball to `./encrypted`.
If the `./encrypted` directory already exists, you must press 'y' to overwrite.
