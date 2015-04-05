# What To Run

[![Join the chat at https://gitter.im/DyegoCosta/what_to_run](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/DyegoCosta/what_to_run?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/DyegoCosta/what_to_run.svg?branch=master)](https://travis-ci.org/DyegoCosta/what_to_run)

What To Run is a lib for regression test selection, use it to predict which tests you should run when you make any modification on your codebase.

This lib is based on [@tenderlove](https://github.com/tenderlove) idea and guidance, make sure to read his [blog post](http://tenderlovemaking.com/2015/02/13/predicting-test-failues.html) on the subject.

## Requirements

- Project must be inside a Git repository

## Installation

Add this line to your application's Gemfile:

```
gem 'what_to_run'
```

And then execute

```
$ bundle
```

Or install it yourself as:

```
$ gem install what_to_run
```

## Usage

Require the lib with:

Minitest

```
require 'what_to_run/minitest'
```

RSpec

```
require 'what_to_run/rspec'
```

Run your tests with COLLECTION=1 on a clean git branch

Minitest

```
$ COLLECTION=1 bundle exec rake test
```

RSpec

```
$ COLLECTION=1 bundle exec rspec
```

This will create the initial coverage information. Then make your desired modifications on your code.

Now to predict which tests is likely fail, run this:

```
$ what_to_run
```

## Contributing

Open an [issue](https://github.com/DyegoCosta/what_to_run/issues) or fork it and submit a [pull-request](https://help.github.com/articles/using-pull-requests/).

## License

What To Run is released under the [MIT License](http://www.opensource.org/licenses/MIT).
