# SkypeArchive

skype archive for gii hackathon

## Installation

    curl -L http://bit.ly/ONcFkw | ruby

## Usage

    skype_archive search account_name [options] search_text
    skype_archive sync

          --author AUTHOR              who sent the message
          --conversation CONVERSATION  search which channel
          --from TIME                  search the message from when
      -h, --help                       Show this message

## Example

    skype_archive search gii.richard.huang ruby
    skype_archive search gii.richard.huang --conversation Operations
ruby
    skype_archive search gii.richard.huang --conversation Operations
--from "1 month ago" ruby
    skype_archive search gii.richard.huang --conversation Operations
--from "1 month ago" ruby
    skype_archive search gii.richard.huang --conversation Operations
--from "1 month ago" --author Jason ruby
