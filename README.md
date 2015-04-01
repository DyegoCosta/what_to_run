# What To Run

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
gem install what_to_run
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

Run your tests on a clean git branch

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

:warning: A `run_log.json` file will be created in the current directory, you might want to include it in your `.gitignore`.

## Contributing

Open an [issue](https://github.com/DyegoCosta/what_to_run/issues) or fork it and submit a [pull-request](https://help.github.com/articles/using-pull-requests/).

## License

What To Run is released under the [MIT License](http://www.opensource.org/licenses/MIT).
