# Docker for RubyMine

Rails development using docker for rubymine.

![rubymine](https://raw.githubusercontent.com/zchee/docker-library/master/rubymine/rubymine.png)

# Supported tags and respective `Dockerfile` links

- [`2.0.0`, `2.0`, `2.0.0-p598`](/rubymine/2.0.0/Dockerfile)
- [`2.1.5`, `2.1`](/rubymine/2.1.5/Dockerfile)
- [`2.2.0`, `2.2`, `latest`](/rubymine/2.2.0/Dockerfile)

# How to use this image

## Create a `Dockerfile` in your Ruby app project

    FROM zchee/rubymine:latest(or you want version)
    CMD ["./your-daemon-or-script.rb"]

Put this file in the root of your app, next to the `Gemfile`.

This image includes multiple `ONBUILD` triggers which should be all you need to
bootstrap most applications.  
If you using boot2docker on VirtualBox in Mac, folder share specified in the -v option.

You can then build and run the Ruby image:

    docker build -t yourname/my-ruby-app .
    docker run -t --name my-running-script yourname/my-ruby-app
    docker run -d -p 2222:22 -p 3000:3000 -v "$PWD":/usr/src/app --name my-running-script yourname/my-ruby-app

### Generate a `Gemfile.lock`

The `onbuid` tag expects a `Gemfile.lock` in your app directory.  
This `docker run` will help you generate one. Run it in the root of your app, next to the
`Gemfile`:

e.g. ruby 2.0

    docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.0 bundle install

and, set up [port forwarding](#port-forwarding).

# Environment

## SSHd ready

This Dockerfile is SSHd ready.
Installed openssh-server, and Set `root` user's password is `root`.

## Port forwarding

This Dockerfile is set port forwarding to

    EXPOSE 22
    EXPOSE 3000

When you build the image, please put this option to the docker run command.

    -d -p 2222:22 -p 3000:3000

e.g.) sample command

    docker run -d -p 2222:22 -p 3000:3000 --name railstutorial zchee/rubymine:2.0.0

If you using boot2docker on VirtualBox in Mac, `docker run` command after this command.

    VBoxManage controlvm "boot2docker-vm" natpf1 "sshd,tcp,127.0.0.1,2222,,2222"
    VBoxManage controlvm "boot2docker-vm" natpf1 "rails_server,tcp,127.0.0.1,3000,,3000"

## `ruby-debug-ide` and `debase` ready
Installed `ruby-debug-ide` and `debase` gem.  
for RubyMine debugging.

# License

View [license information](https://www.ruby-lang.org/en/about/license.txt)
for the software contained in this image.

# Supported Docker versions

This image is officially supported on Docker version 1.4.1.

Support for older versions (down to 1.0) is provided on a best-effort basis.


# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us
 through a [GitHub issue](https://github.com/zchee/docker-library/issues).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small;
we are always thrilled to receive pull requests, and do our best to process them
as fast as we can.

Before you start to code, we recommend discussing your plans
through a [GitHub issue](https://github.com/docker-library/ruby/issues), especially for more ambitious
contributions. This gives other contributors a chance to point you in the right
direction, give you feedback on your design, and help you find out if someone
else is working on the same thing.
