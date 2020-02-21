
require 'octokit'
require 'open-uri'

class RepoDef
  attr_accessor :obj_class, :app_name, :alias, :desc, :repo, :depends

  def initialize(obj_class, app_name, c_alias, desc, repo, depends = nil)
    @obj_class = obj_class
    @app_name = app_name
    @alias = c_alias
    @desc = desc
    @repo = repo
    @depends = depends
  end

  def latest_release
    client = Octokit::Client.new
    release = client.latest_release @repo
    hash = nil

    unless release.assets[1]&.browser_download_url.nil?
      hash = open(release.assets[1].browser_download_url).read.match(/sha384sum ([a-f0-9]+)/)[1]
    end

    ReleaseFile.new(release.assets[0].name, release.assets[0].browser_download_url, release.tag_name, hash)
  end

  def map
    file = latest_release

    map = {
        '__CLASS__' => @obj_class,
        '__TITLE__' => @app_name,
        '__DESC__' => @desc,
        '__REPO__' => @repo,
        '__ALIAS__' => @alias,
        '__DEPENDS__' => if @depends.nil? then '' else @depends end,

        # from the latest release file info
        '__URL__' => file.link,
        '__SHA__' => file.hash,
        '__VERSION__' => file.version,
        '__FILE__' => file.name,
    }
  end
end

class ReleaseFile
  attr_accessor :name, :link, :version, :hash

  def initialize(name, link, version, hash)
    @name = name
    @link = link
    @version = version
    @hash = hash
  end
end

template = <<-'TMP'
#
# Dockerfile for a minimal PHP-PPM run time
#

FROM somnambulist/php-base:7.3-latest

RUN apk --update add ca-certificates \
    && apk update \
    && apk upgrade \
    && apk --no-cache add -U \
    # Packages
    php7-cgi \
    php7-pcntl \
    php7-posix \
    php7-shmop \
    php7-sysvshm \
    php7-sysvshm \
    php7-sysvshm \
    # Clean up
    && rm -rf /var/cache/apk/* /tmp/*

# setup php-pm -- shamelessly borrowed from the above composer code :)
RUN curl --silent --fail --location --retry 3 --output /tmp/ppm.phar --url https://github.com/somnambulist-tech/phppm-phar/releases/download/__VERSION__/ppm.phar \
  && php -r " \
  \$signature = '__SHA__'; \
  \$hash = hash_file('sha384', '/tmp/ppm.phar'); \
  if (!hash_equals(\$signature, \$hash)) { \
    unlink('/tmp/ppm.phar'); \
    echo 'Integrity check failed, the ppm.phar archive is either corrupt or worse.' . PHP_EOL; \
    exit(1); \
  }" \
  && mv /tmp/ppm.phar /usr/bin/ppm.phar \
  && ln -s /usr/bin/ppm.phar /usr/bin/ppm \
  && chmod 755 /usr/bin/ppm \
  && ppm --ansi --version --no-interaction
TMP

d  = RepoDef.new('Ppm', 'PHP-PM', 'ppm', 'PHP-PM Process Manager for PHP as a Phar archive', 'somnambulist-tech/phppm-phar')
re = Regexp.new(d.map.keys.map { |x| Regexp.escape(x) }.join('|'))

puts 'Updating Dockerfile for ' + d.app_name + "\n"
File.write('7.3/Dockerfile', template.gsub(re, d.map))
