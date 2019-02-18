# Getting a working development environment

## Ipfs

This library uses an ipfs instance inside a Docker container.

### Getting the Docker image

```bash
docker pull ipfs/go-ipfs
```

Then to initialize it, execute the following

```bash
docker run --name ipfsd -p 5001:5001 -d ipfs/go-ipfs
```

or,

```bash
var/bin/ipfsd
```

These commands also start the container.


### Manage the Ipfs daemon lifecycle through Docker

To start it:

```bash
docker start ipfsd
```

To stop it:

```bash
docker stop ipfsd
```

## Ruby

### Rbenv

If you don't have rbenv (or another ruby version manager) already.

To install it:

```bash
git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
```

Add the following lines in your shell .rc file

```bash
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

Reload your shell!


### ruby-build

`ruby-build` is an `rbenv` plugin that makes the installation of rubies easier

```bash
mkdir ${HOME}/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
```

### Ruby

Go to the root of the project.

You can find the currently used ruby version inside the `.ruby-version` file.

```bash
rbenv install `cat .ruby-version`
rbenv local `cat .ruby-version`
```

This will install and set the correct ruby version to use with the project
without messing up the one that you use in your system.


### The project's dependencies

We go through bundler to install the project dependencies

```sh
gem install bundler
bundle install
```

## Testing the setup

What a better way than running the specs to test if the setup is
complete and working.

So, still at the root of the project:

```bash
bundle exec rspec
```

or,

```bash
bundle exec rake test
```

# Library Design

The library mostly revolves around one entity: the **CLIENT**.

It is the one that will route **REQUESTS** to Ipfs. Those **REQUESTS**
are built by low-level entities known as **COMMANDS**.

But, none of the above objects are intended to be used directly (by
the library's user). The low-level mechanism is hidden to the user and
instead, objects such as **File** and **Directory** are exposed.

We tend to follow the following [implementation](https://github.com/ipfs/interface-ipfs-core/tree/master/SPEC), given by
the Ipfs' team.

## Client

The two main purposes of the **CLIENT** are:

- maintaining a connection with Ipfs through the program execution
- to route all the **REQUESTS** and their corresponding responses.

It's worth knowing that, in the entire library, it's the only object
that is allowed to communicate with the outside world, in our case,
Ipfs.

One of the main advantages of its implementation is to concentrate all
the side-effects and the dependencies of external libraries, such as
[`HTTP.rb`](https://github.com/httprb/http) to a single entity.

His implementation, as a singleton class, allows us to use it the
same way we would use a Database Connector.
 
For example, it is absolutely mandatory that at the runtime, an Ipfs
daemon is present, otherwise the execution stops.

### Using the client

To use the **CLIENT** in the project, simply pass a **COMMAND** and
its arguments to the `execute` method.

Example from `ruby-ipfs-api/lib/file.rb:19`

```ruby
Ipfs::Client.execute(Command::Add, @path).tap { |response|
	...
}
```

In this example, we ask the **CLIENT** to execute the Ipfs **ADD**
command with a path to a file. Then, we handle the response according
to our needs.

## Commands

**COMMANDS** are entities that are used to create requests and
handle their responses at a low-level.

They tend to be as close as possible to the Ipfs implementation and
to be used in the same way. However, even, if their design allow it,
they are not intended to be used directly.

Their implementation mostly depends of the needs given by their
execution context.

For example, the **ADD** method should allow us to be called either on
a file and either on a directory. The main difference between the two
is to pass a `recursive` option.

The manipulation of **COMMANDS** are done exclusively by the
**CLIENT**. For that reason, **COMMANDS** MUST implement two methods
`build_request` and `parse_response`.

### Execution steps

A **COMMAND**, in order to be executed, is sent to the **CLIENT**.

As an orchestrator, the **CLIENT** will ask the **COMMAND** to prepare
its **REQUEST**. Right after, the **CLIENT** will use the **REQUEST**
to call Ipfs and sends back the response to the **COMMAND**.

### Requests

**REQUESTS** objects are here to encapsulate information that will be
given to Ipfs. They are built by the commands (and only by them) and
are passed to client.

All **REQUESTS** objects inherits from an interface named `Ipfs::Request`.

## API

In this section, we'll talk about interfaces which the user will
interact with.

### File

**FILE** allows to `add` and `cat` content to Ipfs. Those two methods
make a call to the API with the help of **COMMANDS** and the **CLIENT**.

The `add` method has side-effects. Upon call, it completes information
about the file.

### Directory

[not implemented yet]

**DIRECTORY** allows to `ls` directories to Ipfs.


The `ls` method has side-effects. Upon call, the object creates as many
as necessary **FILE** and/or **DIRECTORY** objects that are saved as
attributes. This method is recursive.
