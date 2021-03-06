# Travis Client

The `travis` [gem](https://rubygems.org/) includes both a command line client and a Ruby library to interface with a Travis CI service.

## Command Line Client

Command line usage is pretty simple:

```
$ cd my_awesome_project
$ travis encrypt FOO=BAR
```

The client will try its best at figuring out which API endpoint to talk to. But you can always explicitly state which one it is by adding `--pro` or `--org` (or `-e URL` if you run your own).

### Available commands

Currently the following commands are available:

* `endpoint` - displays the API endpoint used
* `encrypt` - encrypts data with a repos public key (useful for secure env vars etc)
* `help` - displays general or command specific help
* `login` - authenticates for subsequent commands
* `whoami` - displays the user name you are logged in with

### Unix friendly

All the commands are written with Unix in mind:

```
$ curl "$(travis endpoint)/docs" > docs.html
$ cat secret.txt | travis encrypt
```

### Windows friendly

It should work on Windows. However, we do not yet run our CI on Windows and only tried on Windows 7 so far.

### Invoking from Ruby

You can also invoke the commands from within Ruby:

``` ruby
require 'travis/cli'
Travis::CLI.run(:encrypt, "my secret")
```

Note that you should probably use `Travis::Client` instead.

## Ruby Library

### Basic Example

``` ruby
require 'travis'

rails = Travis::Repository.find('rails/rails')
puts "The last Rails build #{rails.last_build_state}."
```

Output:

```
The last Rails build passed.
```

Field names correspond to field names in JSON payload returned from [Travis API](https://api.travis-ci.org).

### Reloading Entities

You can reload a single entity by calling `reload` on it:

``` ruby
loop do
  sleep 1
  repo.reload
  puts "Current Status: #{repo.last_build_state}"
end
```

You can also reload *all* entities by calling:

``` ruby
Travis.session.clear_cache
```

### Using Pro

``` ruby
require 'travis/pro'

Travis::Pro.access_token = '...'
Travis::Pro::Repository.find('secret/repo')
```

### No global state

If you use the library in a long running process, like a daemon, it is recommended to create a new session for every piece of work, as every session uses its own cache and is not guaranteed to be thread-safe.

``` ruby
require 'travis/client'

session = Travis::Client.new(uri: 'http://localhost:3000', access_token: 'foobar')
session.repo('foo/bar')
```

You can also create a namespace to get the look and feel of `Travis` and `Travis::Pro`:

``` ruby
MyTravis = Travis::Namespace.new('http://localhost:3000')
MyTravis::Repository.find('foo/bar')
```

## Installation

Make sure you have Ruby installed (duh!), it should work with any Ruby starting from version 1.8.7, including 2.0, Rubinius and JRuby:

```
$ gem install travis --no-rdoc --no-ri
```

### Upgrading from travis-cli (now travis-deploy)

If you have the old `travis-cli` gem installed, you should `gem uninstall travis-cli`, just to be sure, as it ships with an executable that is also named `travis`.

## Version History

**v1.0.3** (January 15, 2013)

* Fix `-r slug` for repository commands. (#3)

**v1.0.2** (January 14, 2013)

* Only bundle CA certs needed to verify Travis CI and GitHub domains.
* Make tests pass on Windows.

**v1.0.1** (January 14, 2013)

* Improve `encrypt --add` behavior.

**v1.0.0** (January 14, 2013)

* Fist public release.
* Improved documentation.

**v1.0.0pre2**  (January 14, 2013)

* Added Windows support.
* Suggestion to run `travis login` will add `--org` if needed.

**v1.0.0pre** (January 13, 2013)

* Initial public prerelease.

## TODO

### Command Line Client

* Enabling/disabling projects
* Build status inspection
* Log streaming
* Rebuild builds/jobs
* Requeue projects
* List projects, maybe
* Broadcasts
* Events?
* Workers?
* Artifacts?
* Integrate travis-lint?
* What about deploy/config?

### Ruby Client

* Artifacts
* Branches
* Broadcasts
* Builds
* Commits
* Events
* Hooks
* Jobs
* Requests
* Workers