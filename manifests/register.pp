# used by other modules to register themselves in the motd
define motd::register($content='', $order=10) {
  include ::motd

  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }

  concat::fragment{"motd_fragment_${name}":
    target  => '/etc/motd',
    content => inline_template('<% puts @character + "    - #{@body}".ljust(@length-2,' ') + @character %>'),
  }
}
