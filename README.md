# Mhtml
A ruby gem for parsing MHTML.

Uses the NodeJS C HTTP Parser under the hood (thanks to @cotag for the gem).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mhtml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mhtml

## Usage
Two interfaces are provided - all at once, or chunked.

### All at once
For when you have all of the data in memory.

```ruby
source = File.open('/file/path.mht').read
doc = Mhtml::RootDocument.new(source)

doc.headers.each { |h| puts h }

# body is decoded from printed quotable, and encoded according to charset header
puts doc.body 

doc.sub_docs.each { |s| puts subdoc }
```

### Chunked
For when source data is being streamed, or when concerned about memory usage.

```ruby
doc = Mhtml::RootDocument.new

doc.on_header { |h| handle_header(h) } # yields each header

# yields body, possibly in parts
doc.on_body do |b|
  encoding = doc.encoding
  handle_body(b)
end

doc.on_subdoc_begin { handle_subdoc_begin } # yields nil on each subdoc begin
doc.on_subdoc_header { |h| handle_subdoc_header(h) } # yields each subdoc header
doc.on_subdoc_body { |b| handle_subdoc_body(b) } # yields each subdoc's body, possibly in parts
doc.on_subdoc_complete { handle_subdoc_begin } # yields nil on each subdoc complete

File.open('/file/path.mht').read.scan(/.{128}/).each do |chunk|
  doc << chunk
end
```

### Headers
The header class looks like this (portayed as a hash):

```ruby
# Content-Type: multipart/related; charset="windows-1252"; boundary="----=_NextPart_01C74319.B7EA56A0"
{
  key: 'Content-Type',
  values: [
    { key: nil, value: 'multipart/related' },
    { key: 'charset', value: 'windows-1252' },
    { key: 'boundary', value: '----=_NextPart_01C74319.B7EA56A0' }
  ]
}
```

## TODO
- Revisit spec fixtures - either use existing solution or break out to separate
  gem
- Build up body of fixtures using MHTML from various sources

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).


## Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/benjineering/mhtml_rb.
